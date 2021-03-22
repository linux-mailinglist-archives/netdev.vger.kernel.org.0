Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1695F3450F1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhCVUhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:37:55 -0400
Received: from mx3.wp.pl ([212.77.101.9]:59175 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231319AbhCVUhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:37:41 -0400
Received: (wp-smtpd smtp.wp.pl 16313 invoked from network); 22 Mar 2021 21:37:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1616445459; bh=4wZEMbi9EMv6IVxl42euvZird0xthBpBO8JfOOptsSA=;
          h=From:To:Cc:Subject;
          b=YsxeazDEbHqkDezfBLPrCgiOEGD3niJJD8JgX4VPXyt9HufgYUoQsgtntt+4Hv8u+
           EAJOi6D7sTP3xBrTLKh53xTqKtcnSjJa/ilnD3tZsTKceu9sekQEcREe44fzJvcZxg
           X59EIz+jHqYwuAxuOO1okA0aqyOlwRsdH7kFODGg=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 22 Mar 2021 21:37:39 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v4 2/3] net: dsa: lantiq: verify compatible strings against hardware
Date:   Mon, 22 Mar 2021 21:37:16 +0100
Message-Id: <20210322203717.20616-3-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322203717.20616-1-olek2@wp.pl>
References: <20210322203717.20616-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 9ac0d3bae7ad8b28748cfac08e73befe
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0100003 [0cAw]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify compatible string against hardware.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/dsa/lantiq_gswip.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 4cab5cd26928..26d0e3bb5dea 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1907,7 +1907,7 @@ static int gswip_gphy_fw_list(struct gswip_priv *priv,
 static int gswip_probe(struct platform_device *pdev)
 {
 	struct gswip_priv *priv;
-	struct device_node *mdio_np, *gphy_fw_np;
+	struct device_node *np, *mdio_np, *gphy_fw_np;
 	struct device *dev = &pdev->dev;
 	int err;
 	int i;
@@ -1944,6 +1944,24 @@ static int gswip_probe(struct platform_device *pdev)
 	priv->dev = dev;
 	version = gswip_switch_r(priv, GSWIP_VERSION);
 
+	np = dev->of_node;
+	switch (version) {
+	case GSWIP_VERSION_2_0:
+	case GSWIP_VERSION_2_1:
+		if (!of_device_is_compatible(np, "lantiq,xrx200-gswip"))
+			return -EINVAL;
+		break;
+	case GSWIP_VERSION_2_2:
+	case GSWIP_VERSION_2_2_ETC:
+		if (!of_device_is_compatible(np, "lantiq,xrx300-gswip") &&
+		    !of_device_is_compatible(np, "lantiq,xrx330-gswip"))
+			return -EINVAL;
+		break;
+	default:
+		dev_err(dev, "unknown GSWIP version: 0x%x", version);
+		return -ENOENT;
+	}
+
 	/* bring up the mdio bus */
 	gphy_fw_np = of_get_compatible_child(dev->of_node, "lantiq,gphy-fw");
 	if (gphy_fw_np) {
-- 
2.20.1

