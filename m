Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551E4126252
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 13:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfLSMjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 07:39:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:27930 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbfLSMjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 07:39:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 04:39:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,331,1571727600"; 
   d="scan'208";a="366062500"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.49.245])
  by orsmga004.jf.intel.com with ESMTP; 19 Dec 2019 04:39:40 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next v2 02/12] xsk: simplify detection of empty and full rings
Date:   Thu, 19 Dec 2019 13:39:21 +0100
Message-Id: <1576759171-28550-3-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576759171-28550-1-git-send-email-magnus.karlsson@intel.com>
References: <1576759171-28550-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to set the correct return flags for poll, the xsk code has to
check if the Rx queue is empty and if the Tx queue is full. This code
was unnecessarily large and complex as it used the functions that are
used to update the local state from the global state (xskq_nb_free and
xskq_nb_avail). Since we are not doing this nor updating any data
dependent on this state, we can simplify the functions. Another
benefit from this is that we can also simplify the xskq_nb_free and
xskq_nb_avail functions in a later commit.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_queue.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index a2f0ba6..b28f9da 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -362,12 +362,15 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)
 
 static inline bool xskq_full_desc(struct xsk_queue *q)
 {
-	return xskq_nb_avail(q, q->nentries) == q->nentries;
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer) ==
+		q->nentries;
 }
 
 static inline bool xskq_empty_desc(struct xsk_queue *q)
 {
-	return xskq_nb_free(q, q->prod_tail, q->nentries) == q->nentries;
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->consumer) == READ_ONCE(q->ring->producer);
 }
 
 void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask);
-- 
2.7.4

