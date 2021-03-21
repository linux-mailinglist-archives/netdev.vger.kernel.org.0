Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC883433E5
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhCURrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:47:02 -0400
Received: from mx4.wp.pl ([212.77.101.12]:22359 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhCURqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 13:46:32 -0400
Received: (wp-smtpd smtp.wp.pl 3463 invoked from network); 21 Mar 2021 18:39:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1616348386; bh=lG6Bii9fME8kchCZeyvu/mMFQRMY63KG1Ma31ZOiqBU=;
          h=From:To:Cc:Subject;
          b=eI2FLF3F7Ya27LPr2qoFoxK0q8a0h5+0TEOjohaReJTJPdVQo0eqE2GK/dIQwmEUl
           NfatiJqAg1bK0BNX1iqJm9cc9LDbiGcNal0VpmgukCg38fASwbOuZI44bfK1ZP89Vp
           siGWns5ewnvo8xaN2nIlMKj4psS5p/d8+O4kYgFs=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 21 Mar 2021 18:39:46 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v3 2/3] net: dsa: lantiq: verify compatible strings against hardware
Date:   Sun, 21 Mar 2021 18:39:21 +0100
Message-Id: <20210321173922.2837-3-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210321173922.2837-1-olek2@wp.pl>
References: <20210321173922.2837-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: c1506cf8bc655d84f6ecec4d3eee7fc7
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [gfJ2]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify compatible string against hardware.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/dsa/lantiq_gswip.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 7149b9fcb16a..31798a7fc2cc 100644
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

