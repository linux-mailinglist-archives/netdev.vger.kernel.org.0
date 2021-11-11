Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A8144D4FE
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 11:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhKKKb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 05:31:28 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:57664 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbhKKKb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 05:31:26 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 1ABASUZG029628;
        Thu, 11 Nov 2021 02:28:31 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, manojmalviya@chelsio.com
Subject: [PATCH net] cxgb4: fix eeprom len when diagnostics not implemented
Date:   Thu, 11 Nov 2021 15:55:16 +0530
Message-Id: <1636626316-27997-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure diagnostics monitoring support is implemented for the SFF 8472
compliant port module and set the correct length for ethtool port
module eeprom read.

Fixes: f56ec6766dcf ("cxgb4: Add support for ethtool i2c dump")
Signed-off-by: Manoj Malviya <manojmalviya@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 7 +++++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h         | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 5903bdb78916..129352bbe114 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -2015,12 +2015,15 @@ static int cxgb4_get_module_info(struct net_device *dev,
 		if (ret)
 			return ret;
 
-		if (!sff8472_comp || (sff_diag_type & 4)) {
+		if (!sff8472_comp || (sff_diag_type & SFP_DIAG_ADDRMODE)) {
 			modinfo->type = ETH_MODULE_SFF_8079;
 			modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
 		} else {
 			modinfo->type = ETH_MODULE_SFF_8472;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+			if (sff_diag_type & SFP_DIAG_IMPLEMENTED)
+				modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+			else
+				modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN / 2;
 		}
 		break;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h
index 002fc62ea726..63bc956d2037 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h
@@ -293,6 +293,8 @@ enum {
 #define I2C_PAGE_SIZE		0x100
 #define SFP_DIAG_TYPE_ADDR	0x5c
 #define SFP_DIAG_TYPE_LEN	0x1
+#define SFP_DIAG_ADDRMODE	BIT(2)
+#define SFP_DIAG_IMPLEMENTED	BIT(6)
 #define SFF_8472_COMP_ADDR	0x5e
 #define SFF_8472_COMP_LEN	0x1
 #define SFF_REV_ADDR		0x1
-- 
2.27.0

