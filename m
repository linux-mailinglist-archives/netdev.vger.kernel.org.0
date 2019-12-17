Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988E41224E8
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfLQGnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:43:06 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:4911 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfLQGnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 01:43:06 -0500
Received: from fcoe-test9.blr.asicdesigners.com (fcoe-test9.blr.asicdesigners.com [10.193.185.176])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBH6grfs026325;
        Mon, 16 Dec 2019 22:43:01 -0800
From:   Shahjada Abul Husain <shahjada@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com, Shahjada Abul Husain <shahjada@chelsio.com>
Subject: [PATCH net-next 1/2] cxgb4: fix missed high priority region calculation
Date:   Tue, 17 Dec 2019 12:12:08 +0530
Message-Id: <20191217064209.8526-2-shahjada@chelsio.com>
X-Mailer: git-send-email 2.23.0.256.g4c86140
In-Reply-To: <20191217064209.8526-1-shahjada@chelsio.com>
References: <20191217064209.8526-1-shahjada@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit c21939998802 ("cxgb4: add support for high priority filters")
has missed considering high priority region calculation in some code
paths. This patch fixes them.

Fixes: c21939998802 ("cxgb4: add support for high priority filters")
Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 21 +++++++++++++------
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  3 ++-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |  2 +-
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 6a5b0346dad9..44deabfa32b5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -369,12 +369,16 @@ static int get_filter_count(struct adapter *adapter, unsigned int fidx,
 			return -E2BIG;
 		}
 	} else {
-		if ((fidx != (adapter->tids.nftids +
-			      adapter->tids.nsftids - 1)) &&
-		    fidx >= adapter->tids.nftids)
+		if ((fidx != (adapter->tids.nftids + adapter->tids.nsftids +
+			      adapter->tids.nhpftids - 1)) &&
+		    fidx >= (adapter->tids.nftids + adapter->tids.nhpftids))
 			return -E2BIG;
 
-		f = &adapter->tids.ftid_tab[fidx];
+		if (fidx < adapter->tids.nhpftids)
+			f = &adapter->tids.hpftid_tab[fidx];
+		else
+			f = &adapter->tids.ftid_tab[fidx -
+						    adapter->tids.nhpftids];
 		if (!f->valid)
 			return -EINVAL;
 	}
@@ -480,6 +484,7 @@ int cxgb4_get_free_ftid(struct net_device *dev, int family)
 		ftid -= n;
 	}
 	spin_unlock_bh(&t->ftid_lock);
+	ftid += t->nhpftids;
 
 	return found ? ftid : -ENOMEM;
 }
@@ -815,10 +820,14 @@ int delete_filter(struct adapter *adapter, unsigned int fidx)
 	struct filter_entry *f;
 	int ret;
 
-	if (fidx >= adapter->tids.nftids + adapter->tids.nsftids)
+	if (fidx >= adapter->tids.nftids + adapter->tids.nsftids +
+		    adapter->tids.nhpftids)
 		return -EINVAL;
 
-	f = &adapter->tids.ftid_tab[fidx];
+	if (fidx < adapter->tids.nhpftids)
+		f = &adapter->tids.hpftid_tab[fidx];
+	else
+		f = &adapter->tids.ftid_tab[fidx - adapter->tids.nhpftids];
 	ret = writable_filter(f);
 	if (ret)
 		return ret;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 706b71e1b6c1..bb5513bdd293 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -672,7 +672,8 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 		 * 0 to driver. However, the hardware TCAM index
 		 * starts from 0. Hence, the -1 here.
 		 */
-		if (cls->common.prio <= adap->tids.nftids) {
+		if (cls->common.prio <= (adap->tids.nftids +
+					 adap->tids.nhpftids)) {
 			fidx = cls->common.prio - 1;
 			if (fidx < adap->tids.nhpftids)
 				fs->prio = 1;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 53e8db8b2546..24c3c2dc7171 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -137,7 +137,7 @@ static int cxgb4_matchall_alloc_filter(struct net_device *dev,
 	 * -1 here. 1 slot is enough to create a wildcard matchall
 	 * VIID rule.
 	 */
-	if (cls->common.prio <= adap->tids.nftids)
+	if (cls->common.prio <= (adap->tids.nftids + adap->tids.nhpftids))
 		fidx = cls->common.prio - 1;
 	else
 		fidx = cxgb4_get_free_ftid(dev, PF_INET);
-- 
2.23.0.256.g4c86140

