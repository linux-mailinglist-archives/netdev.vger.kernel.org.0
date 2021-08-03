Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D7F3DF35F
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbhHCQ6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237530AbhHCQ4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:56:09 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C41C0613D5
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:55:56 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y12so29856520edo.6
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EacamUE2d3pNQji3i01hsIr9Xh5RtDwmJAOVG/8Hf2Q=;
        b=kquZS0CeVDrTb9Sv82xW/rdVsketMOIB9HXtlNtej4MMjpxP5Y1U9WzyX4qpwBMU/X
         OdhqXt4hpwBfOSEluNscoryCGGUb5O3GWUHCi92X1Z5bYSle78OLeP3J21i8+fzOgPAx
         2lb1fkxaCTMPWn6w1aPquJrA/gRElEZdZpxcMIMwNTKy1LMtLe09r/17XkwUgRx+CGRR
         xG6kBz178eOB6ONMWnTrX5OhrBaPCROPLx5UHJ7wsy3IsIXidO1Hkt1YfZLEbwjsCnlv
         rOI7LJNYj7nCem9pUgkKMsvea1iHqvfZ78MtTosDR2lmaKVBSxsak1T7g24sHidSo/Cb
         tmdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EacamUE2d3pNQji3i01hsIr9Xh5RtDwmJAOVG/8Hf2Q=;
        b=pzn0HMaYzqTidwuqJ+k2JDGzXOSk7Kgr5C17H9AiDTYSjemZuxO027qaH6ydnu3EjA
         YAoVRzSkV3+OzVJKvRJFWLHOiyVOuS4pE7u9LFbDUjse6F5nz/D/SX49xAHYagiXI9Xu
         ovgpd2CehYEei/tCnfE/bWVrr820G1Jhpur7Fp+urnwKaZAxGW30QLfnVO0R3d57018K
         TUmQXsGsn+Adl4wtYYTzpx3xzqJdNRJEMlVPlGIsnroOv6ahNHy8km8ER48xe6zy8A1W
         uOsjVriLJCWWbLUVDtNjSJ/9xYMEPyA/5FGtg7nLp7LmI/p4EOMiLufUvkDJZfzPE1MU
         xLUQ==
X-Gm-Message-State: AOAM530lePOI3uY/bIe2BtMykTxMjGBUSXuUCiQRnjKwScb1get1RBKP
        XahmmESFqH3/MteF36rhpsc=
X-Google-Smtp-Source: ABdhPJzIqMY7TzcOZsL3xub0RWXP+6k1oggvEinqXSX+PFTW1gOkdXq0zrOHXZi4YlQfMEozbvW09g==
X-Received: by 2002:a05:6402:60b:: with SMTP id n11mr27663232edv.235.1628009754690;
        Tue, 03 Aug 2021 09:55:54 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e7sm8754630edk.3.2021.08.03.09.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:55:54 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/8] dpaa2-switch: use the port index in the IRQ handler
Date:   Tue,  3 Aug 2021 19:57:39 +0300
Message-Id: <20210803165745.138175-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165745.138175-1-ciorneiioana@gmail.com>
References: <20210803165745.138175-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The MC firmware supplies us the switch interface index for which an
interrupt was triggered. Use this to our advantage instead of looping
through all the switch ports and doing unnecessary work.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 27 ++++++++-----------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 42d31a4a7da6..f8b7601dc9e4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -594,7 +594,7 @@ static int dpaa2_switch_port_change_mtu(struct net_device *netdev, int mtu)
 	return 0;
 }
 
-static int dpaa2_switch_port_carrier_state_sync(struct net_device *netdev)
+static int dpaa2_switch_port_link_state_update(struct net_device *netdev)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct dpsw_link_state state;
@@ -693,10 +693,10 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 	}
 
 	/* sync carrier state */
-	err = dpaa2_switch_port_carrier_state_sync(netdev);
+	err = dpaa2_switch_port_link_state_update(netdev);
 	if (err) {
 		netdev_err(netdev,
-			   "dpaa2_switch_port_carrier_state_sync err %d\n", err);
+			   "dpaa2_switch_port_link_state_update err %d\n", err);
 		goto err_carrier_sync;
 	}
 
@@ -1419,22 +1419,13 @@ bool dpaa2_switch_port_dev_check(const struct net_device *netdev)
 	return netdev->netdev_ops == &dpaa2_switch_port_ops;
 }
 
-static void dpaa2_switch_links_state_update(struct ethsw_core *ethsw)
-{
-	int i;
-
-	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
-		dpaa2_switch_port_carrier_state_sync(ethsw->ports[i]->netdev);
-		dpaa2_switch_port_set_mac_addr(ethsw->ports[i]);
-	}
-}
-
 static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 {
 	struct device *dev = (struct device *)arg;
 	struct ethsw_core *ethsw = dev_get_drvdata(dev);
+	struct ethsw_port_priv *port_priv;
 	u32 status = ~0;
-	int err;
+	int err, if_id;
 
 	err = dpsw_get_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				  DPSW_IRQ_INDEX_IF, &status);
@@ -1443,9 +1434,13 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 		goto out;
 	}
 
-	if (status & DPSW_IRQ_EVENT_LINK_CHANGED)
-		dpaa2_switch_links_state_update(ethsw);
+	if_id = (status & 0xFFFF0000) >> 16;
+	port_priv = ethsw->ports[if_id];
 
+	if (status & DPSW_IRQ_EVENT_LINK_CHANGED) {
+		dpaa2_switch_port_link_state_update(port_priv->netdev);
+		dpaa2_switch_port_set_mac_addr(port_priv);
+	}
 out:
 	err = dpsw_clear_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				    DPSW_IRQ_INDEX_IF, status);
-- 
2.31.1

