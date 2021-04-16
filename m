Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CF0362B2A
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhDPWi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:38:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:38347 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234681AbhDPWiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:38:50 -0400
IronPort-SDR: 9ho1JqylnzV00YAUFq816Xy4Sg2vuBah1Vb3xOER0uQwQVJz0o2Yw0Uf8OarI2+DtgwX7HwUCY
 uWhgLs+Pcoxg==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="215670610"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="215670610"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 15:38:18 -0700
IronPort-SDR: OOOE8frzYuhahQKQVEgjRdv8UbPgch2BuBoNQC41VExiXi0DijYreTrg4DFH/6FOJJhuioHU3+
 uJBbdVGaUkzg==
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="462107396"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.43.70])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 15:38:17 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/8] mptcp: add tracepoint in ack_update_msk
Date:   Fri, 16 Apr 2021 15:38:06 -0700
Message-Id: <20210416223808.298842-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
References: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a tracepoint in ack_update_msk() to track the
incoming data_ack and window/snd_una updates.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/trace/events/mptcp.h | 32 ++++++++++++++++++++++++++++++++
 net/mptcp/options.c          |  6 ++++++
 2 files changed, 38 insertions(+)

diff --git a/include/trace/events/mptcp.h b/include/trace/events/mptcp.h
index ec20350d82eb..b90bfe45d995 100644
--- a/include/trace/events/mptcp.h
+++ b/include/trace/events/mptcp.h
@@ -106,6 +106,38 @@ DEFINE_EVENT(mptcp_dump_mpext, get_mapping_status,
 	TP_PROTO(struct mptcp_ext *mpext),
 	TP_ARGS(mpext));
 
+TRACE_EVENT(ack_update_msk,
+
+	TP_PROTO(u64 data_ack, u64 old_snd_una,
+		 u64 new_snd_una, u64 new_wnd_end,
+		 u64 msk_wnd_end),
+
+	TP_ARGS(data_ack, old_snd_una,
+		new_snd_una, new_wnd_end,
+		msk_wnd_end),
+
+	TP_STRUCT__entry(
+		__field(u64, data_ack)
+		__field(u64, old_snd_una)
+		__field(u64, new_snd_una)
+		__field(u64, new_wnd_end)
+		__field(u64, msk_wnd_end)
+	),
+
+	TP_fast_assign(
+		__entry->data_ack = data_ack;
+		__entry->old_snd_una = old_snd_una;
+		__entry->new_snd_una = new_snd_una;
+		__entry->new_wnd_end = new_wnd_end;
+		__entry->msk_wnd_end = msk_wnd_end;
+	),
+
+	TP_printk("data_ack=%llu old_snd_una=%llu new_snd_una=%llu new_wnd_end=%llu msk_wnd_end=%llu",
+		  __entry->data_ack, __entry->old_snd_una,
+		  __entry->new_snd_una, __entry->new_wnd_end,
+		  __entry->msk_wnd_end)
+);
+
 #endif /* _TRACE_MPTCP_H */
 
 /* This part must be outside protection */
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index d51c3ad54d9a..99fc21406168 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -13,6 +13,8 @@
 #include "protocol.h"
 #include "mib.h"
 
+#include <trace/events/mptcp.h>
+
 static bool mptcp_cap_flag_sha256(u8 flags)
 {
 	return (flags & MPTCP_CAP_FLAG_MASK) == MPTCP_CAP_HMAC_SHA256;
@@ -943,6 +945,10 @@ static void ack_update_msk(struct mptcp_sock *msk,
 		__mptcp_data_acked(sk);
 	}
 	mptcp_data_unlock(sk);
+
+	trace_ack_update_msk(mp_opt->data_ack,
+			     old_snd_una, new_snd_una,
+			     new_wnd_end, msk->wnd_end);
 }
 
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit)
-- 
2.31.1

