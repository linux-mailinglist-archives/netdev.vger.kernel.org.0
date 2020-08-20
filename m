Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBE624B7AF
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 13:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgHTLCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 07:02:09 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:32686 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbgHTLB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 07:01:57 -0400
Received: from pluto.blr.asicdesigners.com (pluto.asicdesigners.com [10.193.186.16] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 07KB1elE029748;
        Thu, 20 Aug 2020 04:01:41 -0700
From:   Rahul Kundu <rahul.kundu@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vishal@chelsio.com, rahul.lakkireddy@chelsio.com, dt@chelsio.com,
        rahul.kundu@chelsio.com
Subject: [PATCH net-next] cxgb4: insert IPv6 filter rules in next free region
Date:   Thu, 20 Aug 2020 16:31:36 +0530
Message-Id: <0b35dad8bf171816a20ca6b8ba1c38aa96aeeaeb.1597919928.git.rahul.kundu@chelsio.com>
X-Mailer: git-send-email 2.18.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 filters can occupy up to 4 slots and will exhaust HPFILTER
region much sooner. So, continue searching for free slots in the
HASH or NORMAL filter regions, as long as the rule's priority does
not conflict with existing rules in those regions.

Signed-off-by: Rahul Kundu <rahul.kundu@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c   | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 650db92cb11c..f6c1ec140e09 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -604,17 +604,14 @@ int cxgb4_get_free_ftid(struct net_device *dev, u8 family, bool hash_en,
 			/* If the new rule wants to get inserted into
 			 * HPFILTER region, but its prio is greater
 			 * than the rule with the highest prio in HASH
-			 * region, then reject the rule.
-			 */
-			if (t->tc_hash_tids_max_prio &&
-			    tc_prio > t->tc_hash_tids_max_prio)
-				break;
-
-			/* If there's not enough slots available
-			 * in HPFILTER region, then move on to
-			 * normal FILTER region immediately.
+			 * region, or if there's not enough slots
+			 * available in HPFILTER region, then skip
+			 * trying to insert this rule into HPFILTER
+			 * region and directly go to the next region.
 			 */
-			if (ftid + n > t->nhpftids) {
+			if ((t->tc_hash_tids_max_prio &&
+			     tc_prio > t->tc_hash_tids_max_prio) ||
+			     (ftid + n) > t->nhpftids) {
 				ftid = t->nhpftids;
 				continue;
 			}
-- 
2.18.2

