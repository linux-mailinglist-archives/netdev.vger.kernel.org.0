Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F17D3A8826
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 19:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhFOR5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 13:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhFOR5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 13:57:44 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C446C061574;
        Tue, 15 Jun 2021 10:55:39 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso15118180oto.12;
        Tue, 15 Jun 2021 10:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CRI05j+5T2aqXEW9ArA8iI3525TNmhlSCKGX7OS+rXQ=;
        b=W8B5sNgOR6tXolvHuxTawhXRruFzBrahFDKBjKzfRvideKowSB+Z61I4QY7LkB3d7V
         FU0EaB2Aknq/VMZFh7f4ODKbVyW3hjFQLmFdic5ITHZ9sWMb9/l4g/ikBYozr/3XMR+C
         NIggVvVAxlZlQpe3XnoGO82vBxaiXukrQ0tZ0yllEH5MrkFxN5nm79rFOPye/yeydcsn
         xL7mBXyA5Sn3HosG9gXcO09zOrZqCwiBrZKPToBJoimpe8ZKIS+keImLI0FJERBQ+JNr
         RLLTFqpsq+w8R/PvinQ/SeruFz904N9f3rma2ph1PIwaNtcZ+VcXC7kvYFTBnsEcKY1h
         zGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CRI05j+5T2aqXEW9ArA8iI3525TNmhlSCKGX7OS+rXQ=;
        b=biaksoBzF6WVNbcCLRMD/al2DLLWyYgDfyWd02uX0K5zONg9PJA2YQ5A31/kvu4AJy
         28XjOtS4khe8aIXUqHPLccqY7ibJKjkzkdGJ646vVUlGf8b9QX57lXnWctEHAA9ubx9Q
         a7UqRXb81lW70y5dmm+gEhOERk94AG7XGM+3aNJ6fEnp1BGGD9Kh5MkclaP/6PHCCcCb
         D0JRb7cIvchombsAIgJPRbWddb/eUAlhYdcTrsa/jd7NQpD4RNigJ8PlGFIgbf9qaCQd
         eOxLKBrx5aXr5ZgNIUczfnFAc1JftvZvzRYKG0qhOyvKL7H/T0pSEGErfHR6j2QDRel5
         S+ZQ==
X-Gm-Message-State: AOAM532wAUOZQUyFOlW44UEwJziieIIdP+Mlx1Le6v0ErVFAb/XOsOda
        hWrZjIEYtQxtWH4RZKHVh1+fR1xPM03u
X-Google-Smtp-Source: ABdhPJzDbqs4NXHsM7buoHD+Hib0P1dnwGqEWUqRrqrTeHpkfAQJK1jg2gPAePNDUfXLvPB/qw6izw==
X-Received: by 2002:a9d:945:: with SMTP id 63mr382284otp.47.1623779737814;
        Tue, 15 Jun 2021 10:55:37 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id d136sm3810592oib.4.2021.06.15.10.55.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jun 2021 10:55:37 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next] net: dsa: xrs700x: forward HSR supervision frames
Date:   Tue, 15 Jun 2021 12:55:26 -0500
Message-Id: <20210615175526.19829-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forward supervision frames between redunant HSR ports. This was broken
in the last commit.

Fixes: 1a42624aecba ("net: dsa: xrs700x: allow HSR/PRP supervision dupes
for node_table")
Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/xrs700x/xrs700x.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index a79066174a77..130abb0f1438 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -337,7 +337,8 @@ static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
  * This is required to correctly populate the HSR/PRP node_table.
  * Leave the policy disabled, it will be enabled as needed.
  */
-static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port)
+static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port,
+				       int fwdport)
 {
 	struct xrs700x *priv = ds->priv;
 	unsigned int val = 0;
@@ -368,6 +369,9 @@ static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port)
 	if (ret)
 		return ret;
 
+	if (fwdport >= 0)
+		val |= BIT(fwdport);
+
 	/* Allow must be set prevent duplicate discard */
 	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_ALLOW(port, 1), val);
 	if (ret)
@@ -405,10 +409,6 @@ static int xrs700x_port_setup(struct dsa_switch *ds, int port)
 		ret = xrs700x_port_add_bpdu_ipf(ds, port);
 		if (ret)
 			return ret;
-
-		ret = xrs700x_port_add_hsrsup_ipf(ds, port);
-		if (ret)
-			return ret;
 	}
 
 	return 0;
@@ -562,6 +562,7 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 	struct net_device *slave;
 	int ret, i, hsr_pair[2];
 	enum hsr_version ver;
+	bool fwd = false;
 
 	ret = hsr_get_version(hsr, &ver);
 	if (ret)
@@ -607,6 +608,7 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 	if (ver == HSR_V1) {
 		val &= ~BIT(partner->index);
 		val &= ~BIT(port);
+		fwd = true;
 	}
 	val &= ~BIT(dsa_upstream_port(ds, port));
 	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(partner->index), val);
@@ -616,10 +618,19 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 			    XRS_PORT_FORWARDING);
 	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
 
-	/* Enable inbound policy added by xrs700x_port_add_hsrsup_ipf()
-	 * which allows HSR/PRP supervision forwarding to the CPU port without
-	 * discarding duplicates.
+	/* Enable inbound policy which allows HSR/PRP supervision forwarding
+	 * to the CPU port without discarding duplicates. Continue to
+	 * forward to redundant ports when in HSR mode while discarding
+	 * duplicates.
 	 */
+	ret = xrs700x_port_add_hsrsup_ipf(ds, partner->index, fwd ? port : -1);
+	if (ret)
+		return ret;
+
+	ret = xrs700x_port_add_hsrsup_ipf(ds, port, fwd ? partner->index : -1);
+	if (ret)
+		return ret;
+
 	regmap_update_bits(priv->regmap,
 			   XRS_ETH_ADDR_CFG(partner->index, 1), 1, 1);
 	regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 1, 1);
-- 
2.11.0

