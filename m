Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFB33F6C30
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhHXX1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:27:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:39250 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232824AbhHXX1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 19:27:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="217448927"
X-IronPort-AV: E=Sophos;i="5.84,348,1620716400"; 
   d="scan'208";a="217448927"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 16:26:32 -0700
X-IronPort-AV: E=Sophos;i="5.84,348,1620716400"; 
   d="scan'208";a="515847896"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.40.105])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 16:26:31 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, geliangtang@xiaomi.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/7] mptcp: optimize out option generation
Date:   Tue, 24 Aug 2021 16:26:13 -0700
Message-Id: <20210824232619.136912-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210824232619.136912-1-mathew.j.martineau@linux.intel.com>
References: <20210824232619.136912-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently we have several protocol constraints on MPTCP options
generation (e.g. MPC and MPJ subopt are mutually exclusive)
and some additional ones required by our implementation
(e.g. almost all ADD_ADDR variant are mutually exclusive with
everything else).

We can leverage the above to optimize the out option generation:
we check DSS/MPC/MPJ presence in a mutually exclusive way,
avoiding many unneeded conditionals in the common cases.

Additionally extend the existing constraints on ADD_ADDR opt on
all subvariants, so that it becomes fully mutually exclusive with
the above and we can skip another conditional statement for the
common case.

This change is also needed by the next patch.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 229 +++++++++++++++++++++++--------------------
 net/mptcp/protocol.h |   1 +
 2 files changed, 121 insertions(+), 109 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 4c37f4b215ee..1a59b3045a33 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -592,6 +592,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		dss_size = map_size;
 		if (skb && snd_data_fin_enable)
 			mptcp_write_data_fin(subflow, skb, &opts->ext_copy);
+		opts->suboptions = OPTION_MPTCP_DSS;
 		ret = true;
 	}
 
@@ -615,6 +616,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		opts->ext_copy.ack64 = 0;
 	}
 	opts->ext_copy.use_ack = 1;
+	opts->suboptions = OPTION_MPTCP_DSS;
 	WRITE_ONCE(msk->old_wspace, __mptcp_space((struct sock *)msk));
 
 	/* Add kind/length/subtype/flag overhead if mapping is not populated */
@@ -686,8 +688,13 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	if (drop_other_suboptions) {
 		pr_debug("drop other suboptions");
 		opts->suboptions = 0;
-		opts->ext_copy.use_ack = 0;
-		opts->ext_copy.use_map = 0;
+
+		/* note that e.g. DSS could have written into the memory
+		 * aliased by ahmac, we must reset the field here
+		 * to avoid appending the hmac even for ADD_ADDR echo
+		 * options
+		 */
+		opts->ahmac = 0;
 		*size -= opt_size;
 	}
 	opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
@@ -739,7 +746,12 @@ static bool mptcp_established_options_mp_prio(struct sock *sk,
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
-	if (!subflow->send_mp_prio)
+	/* can't send MP_PRIO with MPC, as they share the same option space:
+	 * 'backup'. Also it makes no sense at all
+	 */
+	if (!subflow->send_mp_prio ||
+	    ((OPTION_MPTCP_MPC_SYN | OPTION_MPTCP_MPC_SYNACK |
+	      OPTION_MPTCP_MPC_ACK) & opts->suboptions))
 		return false;
 
 	/* account for the trailing 'nop' option */
@@ -1198,8 +1210,74 @@ static u16 mptcp_make_csum(const struct mptcp_ext *mpext)
 void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			 struct mptcp_out_options *opts)
 {
-	if ((OPTION_MPTCP_MPC_SYN | OPTION_MPTCP_MPC_SYNACK |
-	     OPTION_MPTCP_MPC_ACK) & opts->suboptions) {
+	/* RST is mutually exclusive with everything else */
+	if (unlikely(OPTION_MPTCP_RST & opts->suboptions)) {
+		*ptr++ = mptcp_option(MPTCPOPT_RST,
+				      TCPOLEN_MPTCP_RST,
+				      opts->reset_transient,
+				      opts->reset_reason);
+		return;
+	}
+
+	/* DSS, MPC, MPJ and ADD_ADDR are mutually exclusive, see
+	 * mptcp_established_options*()
+	 */
+	if (likely(OPTION_MPTCP_DSS & opts->suboptions)) {
+		struct mptcp_ext *mpext = &opts->ext_copy;
+		u8 len = TCPOLEN_MPTCP_DSS_BASE;
+		u8 flags = 0;
+
+		if (mpext->use_ack) {
+			flags = MPTCP_DSS_HAS_ACK;
+			if (mpext->ack64) {
+				len += TCPOLEN_MPTCP_DSS_ACK64;
+				flags |= MPTCP_DSS_ACK64;
+			} else {
+				len += TCPOLEN_MPTCP_DSS_ACK32;
+			}
+		}
+
+		if (mpext->use_map) {
+			len += TCPOLEN_MPTCP_DSS_MAP64;
+
+			/* Use only 64-bit mapping flags for now, add
+			 * support for optional 32-bit mappings later.
+			 */
+			flags |= MPTCP_DSS_HAS_MAP | MPTCP_DSS_DSN64;
+			if (mpext->data_fin)
+				flags |= MPTCP_DSS_DATA_FIN;
+
+			if (opts->csum_reqd)
+				len += TCPOLEN_MPTCP_DSS_CHECKSUM;
+		}
+
+		*ptr++ = mptcp_option(MPTCPOPT_DSS, len, 0, flags);
+
+		if (mpext->use_ack) {
+			if (mpext->ack64) {
+				put_unaligned_be64(mpext->data_ack, ptr);
+				ptr += 2;
+			} else {
+				put_unaligned_be32(mpext->data_ack32, ptr);
+				ptr += 1;
+			}
+		}
+
+		if (mpext->use_map) {
+			put_unaligned_be64(mpext->data_seq, ptr);
+			ptr += 2;
+			put_unaligned_be32(mpext->subflow_seq, ptr);
+			ptr += 1;
+			if (opts->csum_reqd) {
+				put_unaligned_be32(mpext->data_len << 16 |
+						   mptcp_make_csum(mpext), ptr);
+			} else {
+				put_unaligned_be32(mpext->data_len << 16 |
+						   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
+			}
+		}
+	} else if ((OPTION_MPTCP_MPC_SYN | OPTION_MPTCP_MPC_SYNACK |
+		    OPTION_MPTCP_MPC_ACK) & opts->suboptions) {
 		u8 len, flag = MPTCP_CAP_HMAC_SHA256;
 
 		if (OPTION_MPTCP_MPC_SYN & opts->suboptions) {
@@ -1246,10 +1324,31 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 					   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
 		}
 		ptr += 1;
-	}
 
-mp_capable_done:
-	if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
+		/* MPC is additionally mutually exclusive with MP_PRIO */
+		goto mp_capable_done;
+	} else if (OPTION_MPTCP_MPJ_SYN & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
+				      TCPOLEN_MPTCP_MPJ_SYN,
+				      opts->backup, opts->join_id);
+		put_unaligned_be32(opts->token, ptr);
+		ptr += 1;
+		put_unaligned_be32(opts->nonce, ptr);
+		ptr += 1;
+	} else if (OPTION_MPTCP_MPJ_SYNACK & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
+				      TCPOLEN_MPTCP_MPJ_SYNACK,
+				      opts->backup, opts->join_id);
+		put_unaligned_be64(opts->thmac, ptr);
+		ptr += 2;
+		put_unaligned_be32(opts->nonce, ptr);
+		ptr += 1;
+	} else if (OPTION_MPTCP_MPJ_ACK & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
+				      TCPOLEN_MPTCP_MPJ_ACK, 0, 0);
+		memcpy(ptr, opts->hmac, MPTCPOPT_HMAC_LEN);
+		ptr += 5;
+	} else if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
 		u8 len = TCPOLEN_MPTCP_ADD_ADDR_BASE;
 		u8 echo = MPTCP_ADDR_ECHO;
 
@@ -1307,6 +1406,19 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 		}
 	}
 
+	if (OPTION_MPTCP_PRIO & opts->suboptions) {
+		const struct sock *ssk = (const struct sock *)tp;
+		struct mptcp_subflow_context *subflow;
+
+		subflow = mptcp_subflow_ctx(ssk);
+		subflow->send_mp_prio = 0;
+
+		*ptr++ = mptcp_option(MPTCPOPT_MP_PRIO,
+				      TCPOLEN_MPTCP_PRIO,
+				      opts->backup, TCPOPT_NOP);
+	}
+
+mp_capable_done:
 	if (OPTION_MPTCP_RM_ADDR & opts->suboptions) {
 		u8 i = 1;
 
@@ -1327,107 +1439,6 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 		}
 	}
 
-	if (OPTION_MPTCP_PRIO & opts->suboptions) {
-		const struct sock *ssk = (const struct sock *)tp;
-		struct mptcp_subflow_context *subflow;
-
-		subflow = mptcp_subflow_ctx(ssk);
-		subflow->send_mp_prio = 0;
-
-		*ptr++ = mptcp_option(MPTCPOPT_MP_PRIO,
-				      TCPOLEN_MPTCP_PRIO,
-				      opts->backup, TCPOPT_NOP);
-	}
-
-	if (OPTION_MPTCP_MPJ_SYN & opts->suboptions) {
-		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
-				      TCPOLEN_MPTCP_MPJ_SYN,
-				      opts->backup, opts->join_id);
-		put_unaligned_be32(opts->token, ptr);
-		ptr += 1;
-		put_unaligned_be32(opts->nonce, ptr);
-		ptr += 1;
-	}
-
-	if (OPTION_MPTCP_MPJ_SYNACK & opts->suboptions) {
-		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
-				      TCPOLEN_MPTCP_MPJ_SYNACK,
-				      opts->backup, opts->join_id);
-		put_unaligned_be64(opts->thmac, ptr);
-		ptr += 2;
-		put_unaligned_be32(opts->nonce, ptr);
-		ptr += 1;
-	}
-
-	if (OPTION_MPTCP_MPJ_ACK & opts->suboptions) {
-		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
-				      TCPOLEN_MPTCP_MPJ_ACK, 0, 0);
-		memcpy(ptr, opts->hmac, MPTCPOPT_HMAC_LEN);
-		ptr += 5;
-	}
-
-	if (OPTION_MPTCP_RST & opts->suboptions)
-		*ptr++ = mptcp_option(MPTCPOPT_RST,
-				      TCPOLEN_MPTCP_RST,
-				      opts->reset_transient,
-				      opts->reset_reason);
-
-	if (opts->ext_copy.use_ack || opts->ext_copy.use_map) {
-		struct mptcp_ext *mpext = &opts->ext_copy;
-		u8 len = TCPOLEN_MPTCP_DSS_BASE;
-		u8 flags = 0;
-
-		if (mpext->use_ack) {
-			flags = MPTCP_DSS_HAS_ACK;
-			if (mpext->ack64) {
-				len += TCPOLEN_MPTCP_DSS_ACK64;
-				flags |= MPTCP_DSS_ACK64;
-			} else {
-				len += TCPOLEN_MPTCP_DSS_ACK32;
-			}
-		}
-
-		if (mpext->use_map) {
-			len += TCPOLEN_MPTCP_DSS_MAP64;
-
-			/* Use only 64-bit mapping flags for now, add
-			 * support for optional 32-bit mappings later.
-			 */
-			flags |= MPTCP_DSS_HAS_MAP | MPTCP_DSS_DSN64;
-			if (mpext->data_fin)
-				flags |= MPTCP_DSS_DATA_FIN;
-
-			if (opts->csum_reqd)
-				len += TCPOLEN_MPTCP_DSS_CHECKSUM;
-		}
-
-		*ptr++ = mptcp_option(MPTCPOPT_DSS, len, 0, flags);
-
-		if (mpext->use_ack) {
-			if (mpext->ack64) {
-				put_unaligned_be64(mpext->data_ack, ptr);
-				ptr += 2;
-			} else {
-				put_unaligned_be32(mpext->data_ack32, ptr);
-				ptr += 1;
-			}
-		}
-
-		if (mpext->use_map) {
-			put_unaligned_be64(mpext->data_seq, ptr);
-			ptr += 2;
-			put_unaligned_be32(mpext->subflow_seq, ptr);
-			ptr += 1;
-			if (opts->csum_reqd) {
-				put_unaligned_be32(mpext->data_len << 16 |
-						   mptcp_make_csum(mpext), ptr);
-			} else {
-				put_unaligned_be32(mpext->data_len << 16 |
-						   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
-			}
-		}
-	}
-
 	if (tp)
 		mptcp_set_rwin(tp);
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 7cd3d5979bcd..d276ce16f126 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -26,6 +26,7 @@
 #define OPTION_MPTCP_FASTCLOSE	BIT(8)
 #define OPTION_MPTCP_PRIO	BIT(9)
 #define OPTION_MPTCP_RST	BIT(10)
+#define OPTION_MPTCP_DSS	BIT(11)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
-- 
2.33.0

