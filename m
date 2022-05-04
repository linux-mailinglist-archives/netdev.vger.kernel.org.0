Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409D951B16B
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243437AbiEDV6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239578AbiEDV55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:57:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F3B50E15
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 14:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651701260; x=1683237260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UHrBSVM6h23pOzib57ZIg1rDyJtjxy4O5aLuYMcgO5I=;
  b=Nm51RJIMPqtVv5BFJNxRFbimBEV3hhWfoKwTW8DKUjEFWZlE6I+RfGv/
   PZvSlzI6PViuFdx1wiP23EHVpxWgR9Oe8PBuZx75QFZ0MhHkN+7EcWU/4
   S6k/qsvOyl/+IK1deVgG7xuDo9b4wkyxeSkNuo0VsDU1ofiEE5OY2owaG
   kjMV/FkaLp0+7vauQTZVvscKmWsqGbWzWszTjBpeCT7A8oKDJwVRcRm5z
   vFmEK70O5yUiLzZ95NjSfVTEQj6dy6dEU+r4D3A4OM9v9XkaHSeO273Td
   ztlqiwPqlpkG3knnVolRK88q8GRFRSSr037sXzzeuTv+1gADlcIkmA+Wh
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="248445427"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="248445427"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 14:54:20 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="621000378"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.251.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 14:54:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/5] tcp: allow MPTCP to update the announced window
Date:   Wed,  4 May 2022 14:54:06 -0700
Message-Id: <20220504215408.349318-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504215408.349318-1-mathew.j.martineau@linux.intel.com>
References: <20220504215408.349318-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The MPTCP RFC requires that the MPTCP-level receive window's
right edge never moves backward. Currently the MPTCP code
enforces such constraint while tracking the right edge, but it
does not reflects it on the wire, as MPTCP lacks a suitable hook
to update accordingly the TCP header.

This change modifies the existing mptcp_write_options() hook,
providing the current packet's TCP header to the MPTCP protocol,
so that the next patch could implement the above mentioned
constraint.

No functional changes intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h   |  2 +-
 net/ipv4/tcp_output.c | 14 ++++++++------
 net/mptcp/options.c   |  2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 8b1afd6f5cc4..d4ec894ce67b 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -125,7 +125,7 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       struct mptcp_out_options *opts);
 bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb);
 
-void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
+void mptcp_write_options(struct tcphdr *th, __be32 *ptr, struct tcp_sock *tp,
 			 struct mptcp_out_options *opts);
 
 void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5f91a9536e00..b092228e4342 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -445,12 +445,13 @@ struct tcp_out_options {
 	struct mptcp_out_options mptcp;
 };
 
-static void mptcp_options_write(__be32 *ptr, const struct tcp_sock *tp,
+static void mptcp_options_write(struct tcphdr *th, __be32 *ptr,
+				struct tcp_sock *tp,
 				struct tcp_out_options *opts)
 {
 #if IS_ENABLED(CONFIG_MPTCP)
 	if (unlikely(OPTION_MPTCP & opts->options))
-		mptcp_write_options(ptr, tp, &opts->mptcp);
+		mptcp_write_options(th, ptr, tp, &opts->mptcp);
 #endif
 }
 
@@ -606,9 +607,10 @@ static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb,
  * At least SACK_PERM as the first option is known to lead to a disaster
  * (but it may well be that other scenarios fail similarly).
  */
-static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
+static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
 			      struct tcp_out_options *opts)
 {
+	__be32 *ptr = (__be32 *)(th + 1);
 	u16 options = opts->options;	/* mungable copy */
 
 	if (unlikely(OPTION_MD5 & options)) {
@@ -702,7 +704,7 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 
 	smc_options_write(ptr, &options);
 
-	mptcp_options_write(ptr, tp, opts);
+	mptcp_options_write(th, ptr, tp, opts);
 }
 
 static void smc_set_option(const struct tcp_sock *tp,
@@ -1355,7 +1357,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		th->window	= htons(min(tp->rcv_wnd, 65535U));
 	}
 
-	tcp_options_write((__be32 *)(th + 1), tp, &opts);
+	tcp_options_write(th, tp, &opts);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Calculate the MD5 hash, as we have all we need now */
@@ -3591,7 +3593,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
-	tcp_options_write((__be32 *)(th + 1), NULL, &opts);
+	tcp_options_write(th, NULL, &opts);
 	th->doff = (tcp_header_size >> 2);
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index e05d9458a025..2570911735ab 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1265,7 +1265,7 @@ static u16 mptcp_make_csum(const struct mptcp_ext *mpext)
 				 ~csum_unfold(mpext->csum));
 }
 
-void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
+void mptcp_write_options(struct tcphdr *th, __be32 *ptr, struct tcp_sock *tp,
 			 struct mptcp_out_options *opts)
 {
 	const struct sock *ssk = (const struct sock *)tp;
-- 
2.36.0

