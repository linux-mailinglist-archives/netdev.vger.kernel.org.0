Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84ED43ABFBC
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhFQXtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:49:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:13474 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhFQXst (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:49 -0400
IronPort-SDR: BOoPsoAvBSFZNaEmsnT69BDX2xNZAzcuDKZ1BRPRgCywjmAlL9xjiZ6AugVi+Y9fgRLGzJsK6N
 u1718niRsHXw==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506666"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506666"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:34 -0700
IronPort-SDR: odAlPzAhgu1xw1HyVwp2UwtTNIFW6NV6BjVEi5rEauEK6DuoSU7EECrd10Fn9ua3s78fN+0HGG
 8HOqWFrltcig==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943925"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:33 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 14/16] mptcp: dump csum fields in mptcp_dump_mpext
Date:   Thu, 17 Jun 2021 16:46:20 -0700
Message-Id: <20210617234622.472030-15-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

In mptcp_dump_mpext, dump the csum fields, csum and csum_reqd in struct
mptcp_dump_mpext too.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/trace/events/mptcp.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/mptcp.h b/include/trace/events/mptcp.h
index 775a46d0b0f0..6bf43176f14c 100644
--- a/include/trace/events/mptcp.h
+++ b/include/trace/events/mptcp.h
@@ -73,6 +73,7 @@ DECLARE_EVENT_CLASS(mptcp_dump_mpext,
 		__field(u64, data_seq)
 		__field(u32, subflow_seq)
 		__field(u16, data_len)
+		__field(u16, csum)
 		__field(u8, use_map)
 		__field(u8, dsn64)
 		__field(u8, data_fin)
@@ -82,6 +83,7 @@ DECLARE_EVENT_CLASS(mptcp_dump_mpext,
 		__field(u8, frozen)
 		__field(u8, reset_transient)
 		__field(u8, reset_reason)
+		__field(u8, csum_reqd)
 	),
 
 	TP_fast_assign(
@@ -89,6 +91,7 @@ DECLARE_EVENT_CLASS(mptcp_dump_mpext,
 		__entry->data_seq = mpext->data_seq;
 		__entry->subflow_seq = mpext->subflow_seq;
 		__entry->data_len = mpext->data_len;
+		__entry->csum = (__force u16)mpext->csum;
 		__entry->use_map = mpext->use_map;
 		__entry->dsn64 = mpext->dsn64;
 		__entry->data_fin = mpext->data_fin;
@@ -98,16 +101,18 @@ DECLARE_EVENT_CLASS(mptcp_dump_mpext,
 		__entry->frozen = mpext->frozen;
 		__entry->reset_transient = mpext->reset_transient;
 		__entry->reset_reason = mpext->reset_reason;
+		__entry->csum_reqd = mpext->csum_reqd;
 	),
 
-	TP_printk("data_ack=%llu data_seq=%llu subflow_seq=%u data_len=%u use_map=%u dsn64=%u data_fin=%u use_ack=%u ack64=%u mpc_map=%u frozen=%u reset_transient=%u reset_reason=%u",
+	TP_printk("data_ack=%llu data_seq=%llu subflow_seq=%u data_len=%u csum=%x use_map=%u dsn64=%u data_fin=%u use_ack=%u ack64=%u mpc_map=%u frozen=%u reset_transient=%u reset_reason=%u csum_reqd=%u",
 		  __entry->data_ack, __entry->data_seq,
 		  __entry->subflow_seq, __entry->data_len,
-		  __entry->use_map, __entry->dsn64,
-		  __entry->data_fin, __entry->use_ack,
-		  __entry->ack64, __entry->mpc_map,
-		  __entry->frozen, __entry->reset_transient,
-		  __entry->reset_reason)
+		  __entry->csum, __entry->use_map,
+		  __entry->dsn64, __entry->data_fin,
+		  __entry->use_ack, __entry->ack64,
+		  __entry->mpc_map, __entry->frozen,
+		  __entry->reset_transient, __entry->reset_reason,
+		  __entry->csum_reqd)
 );
 
 DEFINE_EVENT(mptcp_dump_mpext, get_mapping_status,
-- 
2.32.0

