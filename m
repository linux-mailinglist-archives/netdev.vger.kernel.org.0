Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEA35092AC
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 00:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355788AbiDTW2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 18:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237210AbiDTW2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 18:28:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C13403E0;
        Wed, 20 Apr 2022 15:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650493515; x=1682029515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DnWR4bk+hv6VcI7OdulN0bk+Petr2t2+O49LbWUe6JI=;
  b=BUYNBSE1u2zPy5wJ+X2aWdgSaxjnAtOpfj6KG0+q7GKUUTiUJKgcsY9E
   n9fN/RYrmjMQ94skyJlel19GZBVP66SQa+eP92I8+igB4w7ysqciltlGl
   yPgs7Qf9VQwTQShHhpTLyhvmLZxwfGxFycSRacCEDqiM22+eWsq/enJij
   U6vQakbZlrvAWrXpHnCDJuwh6U+DafxLbXnunJIbbUOUe1SREypmSiRbB
   oDWDDPGrKELomocTRv2vt7OkDOAmaQH+8c9ZACmxCbk7rUC+AKEviJBPd
   V4e4vwm+k6kI+Q4F1ooWQXVFZyeSr+FSjBByRNz/yB8ciHNvn86UMTYR1
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="289277577"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="289277577"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:25:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="555422582"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.100.38])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:25:13 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Nicolas Rybowski <nicolas.rybowski@tessares.net>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next 1/7] bpf: expose is_mptcp flag to bpf_tcp_sock
Date:   Wed, 20 Apr 2022 15:24:53 -0700
Message-Id: <20220420222459.307649-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com>
References: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Rybowski <nicolas.rybowski@tessares.net>

is_mptcp is a field from struct tcp_sock used to indicate that the
current tcp_sock is part of the MPTCP protocol.

In this protocol, a first socket (mptcp_sock) is created with
sk_protocol set to IPPROTO_MPTCP (=262) for control purpose but it
isn't directly on the wire. This is the role of the subflow (kernel)
sockets which are classical tcp_sock with sk_protocol set to
IPPROTO_TCP. The only way to differentiate such sockets from plain TCP
sockets is the is_mptcp field from tcp_sock.

Such an exposure in BPF is thus required to be able to differentiate
plain TCP sockets from MPTCP subflow sockets in BPF_PROG_TYPE_SOCK_OPS
programs.

The choice has been made to silently pass the case when CONFIG_MPTCP is
unset by defaulting is_mptcp to 0 in order to make BPF independent of
the MPTCP configuration. Another solution is to make the verifier fail
in 'bpf_tcp_sock_is_valid_ctx_access' but this will add an additional
'#ifdef CONFIG_MPTCP' in the BPF code and a same injected BPF program
will not run if MPTCP is not set.

An example use-case is provided in
https://github.com/multipath-tcp/mptcp_net-next/tree/scripts/bpf/examples

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/bpf.h       | 1 +
 net/core/filter.c              | 9 ++++++++-
 tools/include/uapi/linux/bpf.h | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d14b10b85e51..9ef1f3e1c22f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5694,6 +5694,7 @@ struct bpf_tcp_sock {
 	__u32 delivered;	/* Total data packets delivered incl. rexmits */
 	__u32 delivered_ce;	/* Like the above but only ECE marked packets */
 	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
+	__u32 is_mptcp;		/* Is MPTCP subflow? */
 };
 
 struct bpf_sock_tuple {
diff --git a/net/core/filter.c b/net/core/filter.c
index 143f442a9505..7b1867f1f422 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6754,7 +6754,7 @@ bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 				  struct bpf_insn_access_aux *info)
 {
 	if (off < 0 || off >= offsetofend(struct bpf_tcp_sock,
-					  icsk_retransmits))
+					  is_mptcp))
 		return false;
 
 	if (off % size != 0)
@@ -6888,6 +6888,13 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct bpf_tcp_sock, icsk_retransmits):
 		BPF_INET_SOCK_GET_COMMON(icsk_retransmits);
 		break;
+	case offsetof(struct bpf_tcp_sock, is_mptcp):
+#ifdef CONFIG_MPTCP
+		BPF_TCP_SOCK_GET_COMMON(is_mptcp);
+#else
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+#endif
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d14b10b85e51..9ef1f3e1c22f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5694,6 +5694,7 @@ struct bpf_tcp_sock {
 	__u32 delivered;	/* Total data packets delivered incl. rexmits */
 	__u32 delivered_ce;	/* Like the above but only ECE marked packets */
 	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
+	__u32 is_mptcp;		/* Is MPTCP subflow? */
 };
 
 struct bpf_sock_tuple {
-- 
2.36.0

