Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457D23ABFB7
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhFQXsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:13490 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233083AbhFQXsm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:42 -0400
IronPort-SDR: NUvVC3c2yr48f4+yJ86JRt6hGVlumwj1E5M62FAd8hwRNYFHacwPIsWnZ/XtZ/L0TW2iAg6+1r
 Ti7UASTLBORQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506654"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506654"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:32 -0700
IronPort-SDR: 8wsbw6faFAhYgs4SVMRrLFN4tZL/XZb8Z48WuBUv8yf7UIuPV3g+ptuaRRMeT9Rt0Xwyz5ACom
 SEdctVZC58sA==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943915"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:32 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, geliangtang@gmail.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/16] mptcp: validate the data checksum
Date:   Thu, 17 Jun 2021 16:46:16 -0700
Message-Id: <20210617234622.472030-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This patch added three new members named data_csum, csum_len and
map_csum in struct mptcp_subflow_context, implemented a new function
named mptcp_validate_data_checksum().

If the current mapping is valid and csum is enabled traverse the later
pending skbs and compute csum incrementally till the whole mapping has
been covered. If not enough data is available in the rx queue, return
MAPPING_EMPTY - that is, no data.

Next subflow_data_ready invocation will trigger again csum computation.

When the full DSS is available, validate the csum and return to the
caller an appropriate error code, to trigger subflow reset of fallback
as required by the RFC.

Additionally:
- if the csum prevence in the DSS don't match the negotiated value e.g.
  csum present, but not requested, return invalid mapping to trigger
  subflow reset.
- keep some csum state, to avoid re-compute the csum on the same data
  when multiple rx queue traversal are required.
- clean-up the uncompleted mapping from the receive queue on close, to
  allow proper subflow disposal

Co-developed-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.h |   4 ++
 net/mptcp/subflow.c  | 105 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 103 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 76194babc754..12637299b42e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -400,6 +400,8 @@ struct mptcp_subflow_context {
 	u32	map_subflow_seq;
 	u32	ssn_offset;
 	u32	map_data_len;
+	__wsum	map_data_csum;
+	u32	map_csum_len;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
 		request_join : 1,   /* send MP_JOIN */
 		request_bkup : 1,
@@ -409,6 +411,8 @@ struct mptcp_subflow_context {
 		pm_notified : 1,    /* PM hook called for established status */
 		conn_finished : 1,
 		map_valid : 1,
+		map_csum_reqd : 1,
+		map_data_fin : 1,
 		mpc_map : 1,
 		backup : 1,
 		send_mp_prio : 1,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 9b82ce635c6e..9ccc4686d0d4 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -827,10 +827,90 @@ static bool validate_mapping(struct sock *ssk, struct sk_buff *skb)
 	return true;
 }
 
+static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *skb,
+					      bool csum_reqd)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct csum_pseudo_header header;
+	u32 offset, seq, delta;
+	__wsum csum;
+	int len;
+
+	if (!csum_reqd)
+		return MAPPING_OK;
+
+	/* mapping already validated on previous traversal */
+	if (subflow->map_csum_len == subflow->map_data_len)
+		return MAPPING_OK;
+
+	/* traverse the receive queue, ensuring it contains a full
+	 * DSS mapping and accumulating the related csum.
+	 * Preserve the accoumlate csum across multiple calls, to compute
+	 * the csum only once
+	 */
+	delta = subflow->map_data_len - subflow->map_csum_len;
+	for (;;) {
+		seq = tcp_sk(ssk)->copied_seq + subflow->map_csum_len;
+		offset = seq - TCP_SKB_CB(skb)->seq;
+
+		/* if the current skb has not been accounted yet, csum its contents
+		 * up to the amount covered by the current DSS
+		 */
+		if (offset < skb->len) {
+			__wsum csum;
+
+			len = min(skb->len - offset, delta);
+			csum = skb_checksum(skb, offset, len, 0);
+			subflow->map_data_csum = csum_block_add(subflow->map_data_csum, csum,
+								subflow->map_csum_len);
+
+			delta -= len;
+			subflow->map_csum_len += len;
+		}
+		if (delta == 0)
+			break;
+
+		if (skb_queue_is_last(&ssk->sk_receive_queue, skb)) {
+			/* if this subflow is closed, the partial mapping
+			 * will be never completed; flush the pending skbs, so
+			 * that subflow_sched_work_if_closed() can kick in
+			 */
+			if (unlikely(ssk->sk_state == TCP_CLOSE))
+				while ((skb = skb_peek(&ssk->sk_receive_queue)))
+					sk_eat_skb(ssk, skb);
+
+			/* not enough data to validate the csum */
+			return MAPPING_EMPTY;
+		}
+
+		/* the DSS mapping for next skbs will be validated later,
+		 * when a get_mapping_status call will process such skb
+		 */
+		skb = skb->next;
+	}
+
+	/* note that 'map_data_len' accounts only for the carried data, does
+	 * not include the eventual seq increment due to the data fin,
+	 * while the pseudo header requires the original DSS data len,
+	 * including that
+	 */
+	header.data_seq = cpu_to_be64(subflow->map_seq);
+	header.subflow_seq = htonl(subflow->map_subflow_seq);
+	header.data_len = htons(subflow->map_data_len + subflow->map_data_fin);
+	header.csum = 0;
+
+	csum = csum_partial(&header, sizeof(header), subflow->map_data_csum);
+	if (unlikely(csum_fold(csum)))
+		return subflow->mp_join ? MAPPING_INVALID : MAPPING_DUMMY;
+
+	return MAPPING_OK;
+}
+
 static enum mapping_status get_mapping_status(struct sock *ssk,
 					      struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	bool csum_reqd = READ_ONCE(msk->csum_enabled);
 	struct mptcp_ext *mpext;
 	struct sk_buff *skb;
 	u16 data_len;
@@ -923,9 +1003,10 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 		/* Allow replacing only with an identical map */
 		if (subflow->map_seq == map_seq &&
 		    subflow->map_subflow_seq == mpext->subflow_seq &&
-		    subflow->map_data_len == data_len) {
+		    subflow->map_data_len == data_len &&
+		    subflow->map_csum_reqd == mpext->csum_reqd) {
 			skb_ext_del(skb, SKB_EXT_MPTCP);
-			return MAPPING_OK;
+			goto validate_csum;
 		}
 
 		/* If this skb data are fully covered by the current mapping,
@@ -937,17 +1018,27 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 		}
 
 		/* will validate the next map after consuming the current one */
-		return MAPPING_OK;
+		goto validate_csum;
 	}
 
 	subflow->map_seq = map_seq;
 	subflow->map_subflow_seq = mpext->subflow_seq;
 	subflow->map_data_len = data_len;
 	subflow->map_valid = 1;
+	subflow->map_data_fin = mpext->data_fin;
 	subflow->mpc_map = mpext->mpc_map;
-	pr_debug("new map seq=%llu subflow_seq=%u data_len=%u",
+	subflow->map_csum_reqd = mpext->csum_reqd;
+	subflow->map_csum_len = 0;
+	subflow->map_data_csum = csum_unfold(mpext->csum);
+
+	/* Cfr RFC 8684 Section 3.3.0 */
+	if (unlikely(subflow->map_csum_reqd != csum_reqd))
+		return MAPPING_INVALID;
+
+	pr_debug("new map seq=%llu subflow_seq=%u data_len=%u csum=%d:%u",
 		 subflow->map_seq, subflow->map_subflow_seq,
-		 subflow->map_data_len);
+		 subflow->map_data_len, subflow->map_csum_reqd,
+		 subflow->map_data_csum);
 
 validate_seq:
 	/* we revalidate valid mapping on new skb, because we must ensure
@@ -957,7 +1048,9 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 		return MAPPING_INVALID;
 
 	skb_ext_del(skb, SKB_EXT_MPTCP);
-	return MAPPING_OK;
+
+validate_csum:
+	return validate_data_csum(ssk, skb, csum_reqd);
 }
 
 static void mptcp_subflow_discard_data(struct sock *ssk, struct sk_buff *skb,
-- 
2.32.0

