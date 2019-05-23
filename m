Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765F7280B1
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730860AbfEWPL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:11:58 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:26540 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730719AbfEWPL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 11:11:58 -0400
Received: from v4.blr.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x4NFBqkM006803;
        Thu, 23 May 2019 08:11:53 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com, rajur@chelsio.com
Subject: [PATCH net] cxgb4: offload VLAN flows regardless of VLAN ethtype
Date:   Thu, 23 May 2019 20:41:44 +0530
Message-Id: <20190523151144.15587-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VLAN flows never get offloaded unless ivlan_vld is set in filter spec.
It's not compulsory for vlan_ethtype to be set.

So, always enable ivlan_vld bit for offloading VLAN flows regardless of
vlan_ethtype is set or not.

Fixes: ad9af3e09c (cxgb4: add tc flower match support for vlan)
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 6e2d80008a79..cfaf8f618d1f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -197,6 +197,9 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 		fs->val.ivlan = vlan_tci;
 		fs->mask.ivlan = vlan_tci_mask;
 
+		fs->val.ivlan_vld = 1;
+		fs->mask.ivlan_vld = 1;
+
 		/* Chelsio adapters use ivlan_vld bit to match vlan packets
 		 * as 802.1Q. Also, when vlan tag is present in packets,
 		 * ethtype match is used then to match on ethtype of inner
@@ -207,8 +210,6 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 		 * ethtype value with ethtype of inner header.
 		 */
 		if (fs->val.ethtype == ETH_P_8021Q) {
-			fs->val.ivlan_vld = 1;
-			fs->mask.ivlan_vld = 1;
 			fs->val.ethtype = 0;
 			fs->mask.ethtype = 0;
 		}
-- 
2.9.5

