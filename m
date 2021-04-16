Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB846362B28
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhDPWiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:38:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:38335 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234699AbhDPWiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:38:50 -0400
IronPort-SDR: FwKEqZlX3/6HwUxZDRu5e4umkNaVS1y21FV6DSMzfp/HjIFdw9joJVVroF9D0bfQAWrDrHqZdY
 TGdsCsfYmxTQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="215670612"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="215670612"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 15:38:18 -0700
IronPort-SDR: hNFfAQ+Tl/pu7xW22Vr4WvDpJ2JnMmBx7D3LRTxpj8NM3tRo7SG03lwLRmEn0QLb/QILh7k2t8
 2Y5XnZkCV4uw==
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="462107399"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.43.70])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 15:38:18 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/8] mptcp: add tracepoint in subflow_check_data_avail
Date:   Fri, 16 Apr 2021 15:38:07 -0700
Message-Id: <20210416223808.298842-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
References: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a tracepoint in subflow_check_data_avail() to show the
mapping status.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/trace/events/mptcp.h | 29 +++++++++++++++++++++++++++++
 net/mptcp/subflow.c          |  4 +---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/mptcp.h b/include/trace/events/mptcp.h
index b90bfe45d995..775a46d0b0f0 100644
--- a/include/trace/events/mptcp.h
+++ b/include/trace/events/mptcp.h
@@ -7,6 +7,14 @@
 
 #include <linux/tracepoint.h>
 
+#define show_mapping_status(status)					\
+	__print_symbolic(status,					\
+		{ 0, "MAPPING_OK" },					\
+		{ 1, "MAPPING_INVALID" },				\
+		{ 2, "MAPPING_EMPTY" },					\
+		{ 3, "MAPPING_DATA_FIN" },				\
+		{ 4, "MAPPING_DUMMY" })
+
 TRACE_EVENT(mptcp_subflow_get_send,
 
 	TP_PROTO(struct mptcp_subflow_context *subflow),
@@ -138,6 +146,27 @@ TRACE_EVENT(ack_update_msk,
 		  __entry->msk_wnd_end)
 );
 
+TRACE_EVENT(subflow_check_data_avail,
+
+	TP_PROTO(__u8 status, struct sk_buff *skb),
+
+	TP_ARGS(status, skb),
+
+	TP_STRUCT__entry(
+		__field(u8, status)
+		__field(const void *, skb)
+	),
+
+	TP_fast_assign(
+		__entry->status = status;
+		__entry->skb = skb;
+	),
+
+	TP_printk("mapping_status=%s, skb=%p",
+		  show_mapping_status(__entry->status),
+		  __entry->skb)
+);
+
 #endif /* _TRACE_MPTCP_H */
 
 /* This part must be outside protection */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index d8a2a55ae916..82e91b00ad39 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1002,8 +1002,6 @@ static bool subflow_check_data_avail(struct sock *ssk)
 	struct mptcp_sock *msk;
 	struct sk_buff *skb;
 
-	pr_debug("msk=%p ssk=%p data_avail=%d skb=%p", subflow->conn, ssk,
-		 subflow->data_avail, skb_peek(&ssk->sk_receive_queue));
 	if (!skb_peek(&ssk->sk_receive_queue))
 		subflow->data_avail = 0;
 	if (subflow->data_avail)
@@ -1015,7 +1013,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		u64 old_ack;
 
 		status = get_mapping_status(ssk, msk);
-		pr_debug("msk=%p ssk=%p status=%d", msk, ssk, status);
+		trace_subflow_check_data_avail(status, skb_peek(&ssk->sk_receive_queue));
 		if (status == MAPPING_INVALID) {
 			ssk->sk_err = EBADMSG;
 			goto fatal;
-- 
2.31.1

