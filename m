Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE62693FD
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404556AbfGOOsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404456AbfGOOs2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:48:28 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ABFF21530;
        Mon, 15 Jul 2019 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563202107;
        bh=/1Dfhf2LlvlJfQWd1+qiSURUlxVSOx/QRmLrdfFzWh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVc2eztva17zZ2U1ziZ3fo+D+FLr6ipUPzMu8dkT1lCUYf9KlaG59llVSu+PDAgRP
         NYeW1odVdnywLf2pJ3wFFFArC2M1k/g8qU0bTJr6AQ/tYUquUpSCB+RAPDj/zGxvPF
         ZPaliO8BZV0bX+SQsCKEjwL0dPdlyv3P498tAbJ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 47/53] ixgbe: Check DDM existence in transceiver before access
Date:   Mon, 15 Jul 2019 10:45:29 -0400
Message-Id: <20190715144535.11636-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>

[ Upstream commit 655c91414579d7bb115a4f7898ee726fc18e0984 ]

Some transceivers may comply with SFF-8472 but not implement the Digital
Diagnostic Monitoring (DDM) interface described in it. The existence of
such area is specified by bit 6 of byte 92, set to 1 if implemented.

Currently, due to not checking this bit ixgbe fails trying to read SFP
module's eeprom with the follow message:

ethtool -m enP51p1s0f0
Cannot get Module EEPROM data: Input/output error

Because it fails to read the additional 256 bytes in which it was assumed
to exist the DDM data.

This issue was noticed using a Mellanox Passive DAC PN 01FT738. The eeprom
data was confirmed by Mellanox as correct and present in other Passive
DACs in from other manufacturers.

Signed-off-by: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index d681273bd39d..9d38634071a4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -3133,7 +3133,8 @@ static int ixgbe_get_module_info(struct net_device *dev,
 		page_swap = true;
 	}
 
-	if (sff8472_rev == IXGBE_SFF_SFF_8472_UNSUP || page_swap) {
+	if (sff8472_rev == IXGBE_SFF_SFF_8472_UNSUP || page_swap ||
+	    !(addr_mode & IXGBE_SFF_DDM_IMPLEMENTED)) {
 		/* We have a SFP, but it does not support SFF-8472 */
 		modinfo->type = ETH_MODULE_SFF_8079;
 		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
index 5abd66c84d00..7b7dc6d7d159 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
@@ -70,6 +70,7 @@
 #define IXGBE_SFF_SOFT_RS_SELECT_10G		0x8
 #define IXGBE_SFF_SOFT_RS_SELECT_1G		0x0
 #define IXGBE_SFF_ADDRESSING_MODE		0x4
+#define IXGBE_SFF_DDM_IMPLEMENTED		0x40
 #define IXGBE_SFF_QSFP_DA_ACTIVE_CABLE		0x1
 #define IXGBE_SFF_QSFP_DA_PASSIVE_CABLE		0x8
 #define IXGBE_SFF_QSFP_CONNECTOR_NOT_SEPARABLE	0x23
-- 
2.20.1

