Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FA9486EA6
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344047AbiAGAUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:47984 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344033AbiAGAUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514842; x=1673050842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UtZL9lW6Z7vfWdyQtIYFyHhpXBqpKoVl0bB1B2rjZSc=;
  b=k0h/jxeRpCSL1eMcDffRKv4HbP0Kh3uAvRcbLrhFztdb4LQLckldMSfx
   LvFKl+kHV3a85cIk9XdHkaqznWlAGwLGb0dWEF5cJP8jcTjHDmskqvCra
   qKFiCOxZWMov5hamPBSJ5T7oSsNjQUic7IqFgH7AjriOxIyOQqguM5lvx
   48zaVn8ih24GqPBp1FqsEveiorEf0u1effpA+EtcJoZa0FokPtlqZf6lM
   3/PPZOcGS43O+3fH5pTwe//749KmKrnOkvgiE/kR7ypaHkoJ3ktlFriLg
   K8H+FtUvoYBDZeaEuTB9maAJblZk0CxH6Z0Rg+FkpbOs0Swc2Tu4hLti6
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721302"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721302"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:34 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508494"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:34 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/13] mptcp: implement fastclose xmit path
Date:   Thu,  6 Jan 2022 16:20:15 -0800
Message-Id: <20220107002026.375427-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Allow the MPTCP xmit path to add MP_FASTCLOSE suboption
on RST egress packets.

Additionally reorder related options writing to reduce
the number of conditionals required in the fast path.

Co-developed-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 57 ++++++++++++++++++++++++++++++++++----------
 net/mptcp/protocol.h |  1 +
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index fe98e4f475ba..46d35a235f35 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -768,6 +768,28 @@ static noinline bool mptcp_established_options_rst(struct sock *sk, struct sk_bu
 	return true;
 }
 
+static bool mptcp_established_options_fastclose(struct sock *sk,
+						unsigned int *size,
+						unsigned int remaining,
+						struct mptcp_out_options *opts)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+
+	if (likely(!subflow->send_fastclose))
+		return false;
+
+	if (remaining < TCPOLEN_MPTCP_FASTCLOSE)
+		return false;
+
+	*size = TCPOLEN_MPTCP_FASTCLOSE;
+	opts->suboptions |= OPTION_MPTCP_FASTCLOSE;
+	opts->rcvr_key = msk->remote_key;
+
+	pr_debug("FASTCLOSE key=%llu", opts->rcvr_key);
+	return true;
+}
+
 static bool mptcp_established_options_mp_fail(struct sock *sk,
 					      unsigned int *size,
 					      unsigned int remaining,
@@ -806,10 +828,12 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 		return false;
 
 	if (unlikely(skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_RST)) {
-		if (mptcp_established_options_mp_fail(sk, &opt_size, remaining, opts)) {
+		if (mptcp_established_options_fastclose(sk, &opt_size, remaining, opts) ||
+		    mptcp_established_options_mp_fail(sk, &opt_size, remaining, opts)) {
 			*size += opt_size;
 			remaining -= opt_size;
 		}
+		/* MP_RST can be used with MP_FASTCLOSE and MP_FAIL if there is room */
 		if (mptcp_established_options_rst(sk, skb, &opt_size, remaining, opts)) {
 			*size += opt_size;
 			remaining -= opt_size;
@@ -1251,17 +1275,8 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 		ptr += 2;
 	}
 
-	/* RST is mutually exclusive with everything else */
-	if (unlikely(OPTION_MPTCP_RST & opts->suboptions)) {
-		*ptr++ = mptcp_option(MPTCPOPT_RST,
-				      TCPOLEN_MPTCP_RST,
-				      opts->reset_transient,
-				      opts->reset_reason);
-		return;
-	}
-
-	/* DSS, MPC, MPJ and ADD_ADDR are mutually exclusive, see
-	 * mptcp_established_options*()
+	/* DSS, MPC, MPJ, ADD_ADDR, FASTCLOSE and RST are mutually exclusive,
+	 * see mptcp_established_options*()
 	 */
 	if (likely(OPTION_MPTCP_DSS & opts->suboptions)) {
 		struct mptcp_ext *mpext = &opts->ext_copy;
@@ -1447,6 +1462,24 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 				ptr += 1;
 			}
 		}
+	} else if (unlikely(OPTION_MPTCP_FASTCLOSE & opts->suboptions)) {
+		/* FASTCLOSE is mutually exclusive with others except RST */
+		*ptr++ = mptcp_option(MPTCPOPT_MP_FASTCLOSE,
+				      TCPOLEN_MPTCP_FASTCLOSE,
+				      0, 0);
+		put_unaligned_be64(opts->rcvr_key, ptr);
+		ptr += 2;
+
+		if (OPTION_MPTCP_RST & opts->suboptions)
+			goto mp_rst;
+		return;
+	} else if (unlikely(OPTION_MPTCP_RST & opts->suboptions)) {
+mp_rst:
+		*ptr++ = mptcp_option(MPTCPOPT_RST,
+				      TCPOLEN_MPTCP_RST,
+				      opts->reset_transient,
+				      opts->reset_reason);
+		return;
 	}
 
 	if (OPTION_MPTCP_PRIO & opts->suboptions) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0486c9f5b38b..f177936ff67d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -423,6 +423,7 @@ struct mptcp_subflow_context {
 		backup : 1,
 		send_mp_prio : 1,
 		send_mp_fail : 1,
+		send_fastclose : 1,
 		rx_eof : 1,
 		can_ack : 1,        /* only after processing the remote a key */
 		disposable : 1,	    /* ctx can be free at ulp release time */
-- 
2.34.1

