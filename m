Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CE84D4076
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbiCJE4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiCJE4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:56:41 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BDF4129BA3;
        Wed,  9 Mar 2022 20:55:40 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 283C21691;
        Wed,  9 Mar 2022 20:55:40 -0800 (PST)
Received: from u200865.usa.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D14323FA27;
        Wed,  9 Mar 2022 20:55:39 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, pbrobinson@gmail.com,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH] net: bcmgenet: Don't claim WOL when its not available
Date:   Wed,  9 Mar 2022 22:55:35 -0600
Message-Id: <20220310045535.224450-1-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the bcmgenet platforms don't correctly support WOL, yet
ethtool returns:

"Supports Wake-on: gsf"

which is false.

Ideally if there isn't a wol_irq, or there is something else that
keeps the device from being able to wakeup it should display:

"Supports Wake-on: d"

This patch checks whether the device can wakup, before using the
hard-coded supported flags. This corrects the ethtool reporting, as
well as the WOL configuration because ethtool verifies that the mode
is supported before attempting it.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index e31a5a397f11..f55d9d9c01a8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -40,6 +40,13 @@
 void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct device *kdev = &priv->pdev->dev;
+
+	if (!device_can_wakeup(kdev)) {
+		wol->supported = 0;
+		wol->wolopts = 0;
+		return;
+	}
 
 	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
 	wol->wolopts = priv->wolopts;
-- 
2.35.1

