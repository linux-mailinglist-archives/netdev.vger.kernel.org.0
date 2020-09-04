Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D1025D62E
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 12:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgIDK3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 06:29:05 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:56675 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730066AbgIDK3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 06:29:00 -0400
Received: from localhost (fedora32ganji.blr.asicdesigners.com [10.193.80.135])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 084ASvOS022506;
        Fri, 4 Sep 2020 03:28:57 -0700
From:   Ganji Aravind <ganji.aravind@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: [PATCH net] cxgb4: Fix offset when clearing filter byte counters
Date:   Fri,  4 Sep 2020 15:58:18 +0530
Message-Id: <20200904102818.2001982-1-ganji.aravind@chelsio.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the correct offset to clear the stale filter hit
bytes counter. Otherwise, the counter starts incrementing
from the stale information, instead of 0.

Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
Signed-off-by: Ganji Aravind <ganji.aravind@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 650db92cb11c..481498585ead 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -1911,13 +1911,16 @@ int cxgb4_del_filter(struct net_device *dev, int filter_id,
 static int configure_filter_tcb(struct adapter *adap, unsigned int tid,
 				struct filter_entry *f)
 {
-	if (f->fs.hitcnts)
+	if (f->fs.hitcnts) {
 		set_tcb_field(adap, f, tid, TCB_TIMESTAMP_W,
-			      TCB_TIMESTAMP_V(TCB_TIMESTAMP_M) |
+			      TCB_TIMESTAMP_V(TCB_TIMESTAMP_M),
+			      TCB_TIMESTAMP_V(0ULL),
+			      1);
+		set_tcb_field(adap, f, tid, TCB_RTT_TS_RECENT_AGE_W,
 			      TCB_RTT_TS_RECENT_AGE_V(TCB_RTT_TS_RECENT_AGE_M),
-			      TCB_TIMESTAMP_V(0ULL) |
 			      TCB_RTT_TS_RECENT_AGE_V(0ULL),
 			      1);
+	}
 
 	if (f->fs.newdmac)
 		set_tcb_tflag(adap, f, tid, TF_CCTRL_ECE_S, 1,
-- 
2.26.2

