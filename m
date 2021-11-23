Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F4E45A6D3
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 16:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhKWPx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 10:53:58 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:31025 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238484AbhKWPx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 10:53:57 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 1ANFogAc011796;
        Tue, 23 Nov 2021 07:50:43 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, manojmalviya@chelsio.com
Subject: [PATCH net-next] cxgb4: allow reading unrecognized port module eeprom
Date:   Tue, 23 Nov 2021 21:17:17 +0530
Message-Id: <1637682437-31407-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even if firmware fails to recognize the plugged-in port module type,
allow reading port module EEPROM anyway. This helps in obtaining
necessary diagnostics information for debugging and analysis.

Signed-off-by: Manoj Malviya <manojmalviya@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 0e4ec4079741..6c790af92170 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1993,6 +1993,15 @@ static int get_dump_data(struct net_device *dev, struct ethtool_dump *eth_dump,
 	return 0;
 }
 
+static bool cxgb4_fw_mod_type_info_available(unsigned int fw_mod_type)
+{
+	/* Read port module EEPROM as long as it is plugged-in and
+	 * safe to read.
+	 */
+	return (fw_mod_type != FW_PORT_MOD_TYPE_NONE &&
+		fw_mod_type != FW_PORT_MOD_TYPE_ERROR);
+}
+
 static int cxgb4_get_module_info(struct net_device *dev,
 				 struct ethtool_modinfo *modinfo)
 {
@@ -2001,7 +2010,7 @@ static int cxgb4_get_module_info(struct net_device *dev,
 	struct adapter *adapter = pi->adapter;
 	int ret;
 
-	if (!t4_is_inserted_mod_type(pi->mod_type))
+	if (!cxgb4_fw_mod_type_info_available(pi->mod_type))
 		return -EINVAL;
 
 	switch (pi->port_type) {
-- 
2.27.0

