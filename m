Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78613333C61
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhCJMQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbhCJMPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:33 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CA9C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:33 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id h10so27722000edl.6
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uBMyfeZGBYssApetTOvkLJjBUDN0aQlVeMEhwcHcv4A=;
        b=AgDnfXoSLbGKXvuInQNFE8piKckgLznhlQPu9swpMbnKDQ8GVdkavhiGVj+eIXBzKh
         DhNrx0e5RCea24322c60cMMG/o7VWyYwXANP+uSlrA5Bj8jhi3NplqCHMxyhoqy7wwMZ
         xY+KoLCsERP1C3J2QSTpf3AfBoXz9HYU5qqp0M+8i4bgdVqpizCJbrPryA9gNDkE70dt
         xMeg+n5ztu/PU+YhBfnsvWBJb5FQumSgXtJxIGtnMn9jIBzy+LxX/IV3tN5l4p3qKtrj
         rzuRef3nazv0iy8/OoaZieiOLQLvFPyLmYVTKDn1Ii4tuTOPZhDwD0wDNDV13ikbCVjx
         hQKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uBMyfeZGBYssApetTOvkLJjBUDN0aQlVeMEhwcHcv4A=;
        b=eJ8J8ren9RUdzM7WNTJfDKg06UDgTNRvh92OKHkXvQc0ubna3x9/pM/Y5Gkbt00dvj
         HUSoDl4Xn0Z+oNis2PMf50gkUhEuNhmSlUMu71dKbwEe1KZRSOoT4O3yNjUAEky0TKH2
         lB+4Ra/vhTB8weKHqVr7HNJhEyjC4hTo1hJJpigpLA1odNRhqrl71JwN/n0KePHi2dnC
         NXejbBiy5wEi8WRqV/XmPJ+x+4mu5YCGlvO48LbeOEThOsroiYEwO2Pk90JS99LbFVT6
         Cbgu74nmHiU7G+Zzug4MxC8P2r7IfN8FAHmtx7ZXz63dPgM4TzibngSiQ25MWHTZMd6H
         lWwg==
X-Gm-Message-State: AOAM531gypRnvFScliLD0I16RxHqdzVmtJuoFc+TQMdvS+/2YSBRAAo5
        iCnIaaxQY/FUGCzOLzVvSBo=
X-Google-Smtp-Source: ABdhPJytjv4WTwyJp+8B/0fWl5KXZGKKCCiMgeZjY5MQUZtHQ60cXPGu5aacGCfUM4hfIjWSnT7FoA==
X-Received: by 2002:a50:fa92:: with SMTP id w18mr2913203edr.172.1615378531062;
        Wed, 10 Mar 2021 04:15:31 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:29 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 02/15] staging: dpaa2-switch: fix up initial forwarding configuration done by firmware
Date:   Wed, 10 Mar 2021 14:14:39 +0200
Message-Id: <20210310121452.552070-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

By default, the DPSW object is configured with VLAN ID 1 in the VLAN
table, which all ports are member of. This entry in the VLAN table
selects the same FDB ID for all ports, meaning that forwarding between
ports is permitted. This is unlike the switchdev model, where each port
should operate as standalone by default.

To make the switch operate in standalone ports mode, we need the VLAN
table to select a unique FDB ID for each port. In order to do that, we
need to simply delete the VLAN 1 created automatically by firmware, and
let dpaa2_switch_port_init take over, by readding VLAN ID 1, but
pointing towards a unique FDB ID.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 80 ++++++++++++++++---------
 1 file changed, 51 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index edcaf99c24fc..fa0ec54b49fa 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -3,7 +3,7 @@
  * DPAA2 Ethernet Switch driver
  *
  * Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2017-2018 NXP
+ * Copyright 2017-2021 NXP
  *
  */
 
@@ -1365,6 +1365,8 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 {
 	struct device *dev = &sw_dev->dev;
 	struct ethsw_core *ethsw = dev_get_drvdata(dev);
+	struct dpsw_vlan_if_cfg vcfg = {0};
+	struct dpsw_tci_cfg tci_cfg = {0};
 	struct dpsw_stp_cfg stp_cfg;
 	int err;
 	u16 i;
@@ -1416,6 +1418,12 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 	stp_cfg.state = DPSW_STP_STATE_FORWARDING;
 
 	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
+		err = dpsw_if_disable(ethsw->mc_io, 0, ethsw->dpsw_handle, i);
+		if (err) {
+			dev_err(dev, "dpsw_if_disable err %d\n", err);
+			goto err_close;
+		}
+
 		err = dpsw_if_set_stp(ethsw->mc_io, 0, ethsw->dpsw_handle, i,
 				      &stp_cfg);
 		if (err) {
@@ -1423,6 +1431,39 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 				err, i);
 			goto err_close;
 		}
+
+		/* Switch starts with all ports configured to VLAN 1. Need to
+		 * remove this setting to allow configuration at bridge join
+		 */
+		vcfg.num_ifs = 1;
+		vcfg.if_id[0] = i;
+		err = dpsw_vlan_remove_if_untagged(ethsw->mc_io, 0, ethsw->dpsw_handle,
+						   DEFAULT_VLAN_ID, &vcfg);
+		if (err) {
+			dev_err(dev, "dpsw_vlan_remove_if_untagged err %d\n",
+				err);
+			goto err_close;
+		}
+
+		tci_cfg.vlan_id = 4095;
+		err = dpsw_if_set_tci(ethsw->mc_io, 0, ethsw->dpsw_handle, i, &tci_cfg);
+		if (err) {
+			dev_err(dev, "dpsw_if_set_tci err %d\n", err);
+			goto err_close;
+		}
+
+		err = dpsw_vlan_remove_if(ethsw->mc_io, 0, ethsw->dpsw_handle,
+					  DEFAULT_VLAN_ID, &vcfg);
+		if (err) {
+			dev_err(dev, "dpsw_vlan_remove_if err %d\n", err);
+			goto err_close;
+		}
+	}
+
+	err = dpsw_vlan_remove(ethsw->mc_io, 0, ethsw->dpsw_handle, DEFAULT_VLAN_ID);
+	if (err) {
+		dev_err(dev, "dpsw_vlan_remove err %d\n", err);
+		goto err_close;
 	}
 
 	ethsw->workqueue = alloc_ordered_workqueue("%s_%d_ordered",
@@ -1449,34 +1490,22 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 
 static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 {
+	struct switchdev_obj_port_vlan vlan = {
+		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
+		.vid = DEFAULT_VLAN_ID,
+		.flags = BRIDGE_VLAN_INFO_UNTAGGED | BRIDGE_VLAN_INFO_PVID,
+	};
 	struct net_device *netdev = port_priv->netdev;
-	struct ethsw_core *ethsw = port_priv->ethsw_data;
-	struct dpsw_vlan_if_cfg vcfg;
 	int err;
 
-	/* Switch starts with all ports configured to VLAN 1. Need to
-	 * remove this setting to allow configuration at bridge join
+	/* We need to add VLAN 1 as the PVID on this port until it is under a
+	 * bridge since the DPAA2 switch is not able to handle the traffic in a
+	 * VLAN unaware fashion
 	 */
-	vcfg.num_ifs = 1;
-	vcfg.if_id[0] = port_priv->idx;
-
-	err = dpsw_vlan_remove_if_untagged(ethsw->mc_io, 0, ethsw->dpsw_handle,
-					   DEFAULT_VLAN_ID, &vcfg);
-	if (err) {
-		netdev_err(netdev, "dpsw_vlan_remove_if_untagged err %d\n",
-			   err);
-		return err;
-	}
-
-	err = dpaa2_switch_port_set_pvid(port_priv, 0);
+	err = dpaa2_switch_port_vlans_add(netdev, &vlan);
 	if (err)
 		return err;
 
-	err = dpsw_vlan_remove_if(ethsw->mc_io, 0, ethsw->dpsw_handle,
-				  DEFAULT_VLAN_ID, &vcfg);
-	if (err)
-		netdev_err(netdev, "dpsw_vlan_remove_if err %d\n", err);
-
 	return err;
 }
 
@@ -1633,9 +1662,6 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 	if (err)
 		goto err_free_cmdport;
 
-	/* DEFAULT_VLAN_ID is implicitly configured on the switch */
-	ethsw->vlans[DEFAULT_VLAN_ID] = ETHSW_VLAN_MEMBER;
-
 	ethsw->ports = kcalloc(ethsw->sw_attr.num_ifs, sizeof(*ethsw->ports),
 			       GFP_KERNEL);
 	if (!(ethsw->ports)) {
@@ -1655,10 +1681,6 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 		goto err_free_ports;
 	}
 
-	/* Make sure the switch ports are disabled at probe time */
-	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
-		dpsw_if_disable(ethsw->mc_io, 0, ethsw->dpsw_handle, i);
-
 	/* Setup IRQs */
 	err = dpaa2_switch_setup_irqs(sw_dev);
 	if (err)
-- 
2.30.0

