Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2A126C6A8
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 19:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgIPR6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 13:58:43 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:12601 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbgIPR4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:56:51 -0400
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08GGL3LB006473;
        Wed, 16 Sep 2020 09:21:03 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com, dt@chelsio.com,
        rajur@chelsio.com
Subject: [PATCH net] cxgb4: fix memory leak during module unload
Date:   Wed, 16 Sep 2020 21:50:39 +0530
Message-Id: <20200916162039.26369-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the memory leak in mps during module unload
path by freeing mps reference entries if the list
adpter->mps_ref is not already empty

Fixes: 28b3870578ef ("cxgb4: Re-work the logic for mps refcounting")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
index b1a073eea60b..a020e8490681 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
@@ -229,7 +229,7 @@ void cxgb4_free_mps_ref_entries(struct adapter *adap)
 {
 	struct mps_entries_ref *mps_entry, *tmp;
 
-	if (!list_empty(&adap->mps_ref))
+	if (list_empty(&adap->mps_ref))
 		return;
 
 	spin_lock(&adap->mps_ref_lock);
-- 
2.9.5

