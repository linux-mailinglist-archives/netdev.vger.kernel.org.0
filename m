Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D04323B97
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhBXLxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbhBXLwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:52:49 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C261C06178B;
        Wed, 24 Feb 2021 03:52:09 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id h18so1465049ils.2;
        Wed, 24 Feb 2021 03:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oIqFjy2sxPsPKADV+56fV2GGjexKPCQIKDGcS+nsODo=;
        b=qBkJvqk3srrY0dAP9l4B9HESHDLf/T2JK5BLQam8N15lVY+rnJ/lXRefMujZ6NserB
         5+Ri+/NaN0cZr4TMZxhrfCDQ+t2r5ok3mGRvkS9CRDYfGWusQGBqO+144+E2jpj1VyDy
         C+dNupFGIhPEdqfGuALXPYF8CDRdmvX+d8bVh/Dpwh1z2JKhQEclHoH9ltqGr0K0rANs
         MSrl6OBbzVOm3q7p6mD8izAlaXu8N7e5Xkw+cPnXpGYEA2Z5VjEtAX60E+t/ako+yUkY
         n3VFZkSuc8/GpkElNQ+DTneTL8AJ22RKMhBRm/Q+zv7t5iirvkkFV9l6Qe0ZEJpzfUkg
         M7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oIqFjy2sxPsPKADV+56fV2GGjexKPCQIKDGcS+nsODo=;
        b=cFUOyAlmayHD/jpkyCOw5GGn4A7W3rn7NbZ4XpWvgAYp9Y/ttyPuLj01Q/erfuhe+u
         XK/3K5X+sS6zntFqwNp/NiFhCcJlFbFUQ6rxPlEemFOETOx0QUZWLoXuWlbz5zWopL6O
         lQ+xcQkgpBnlnPGw5TLZw7AIAgKdtZH42H2gPsgSaxlKi6QqrtyuoXZkB4XWSqNT9Jc3
         VBvbIP1KuR2icc3CieA3/KMksmtLbTvYDRBIzHzTT6DokEEIdnBbsmSQlC2/5J8ycZ3w
         q0JzP3C5S0eXIyfJx13ymwPz2GA1iuf0WA+GswHtQ+W0lJ2hQjIEX3/GI1pVyicgsyFF
         I+Rg==
X-Gm-Message-State: AOAM532Ahkg3e+rH/RWo6nq9c/smRhlGpJMX7rdr+cjXEOEqUZtJqaHp
        6yMbNY+EDu2Djs+d+JM+PxwJtbcDhoF/Sg==
X-Google-Smtp-Source: ABdhPJwAUnPND4FALnmGYMN3u2Xq0xn+btBxvYlpsPpff5iTqLa2G5BsJCAE6c0slKAFkbCxdd1aog==
X-Received: by 2002:a05:6e02:82:: with SMTP id l2mr20771072ilm.185.1614167528591;
        Wed, 24 Feb 2021 03:52:08 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:de9c:d296:189b:385a])
        by smtp.gmail.com with ESMTPSA id l16sm1500001ils.11.2021.02.24.03.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:52:08 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 4/5] net: ethernet: ravb: Enable optional refclk
Date:   Wed, 24 Feb 2021 05:51:44 -0600
Message-Id: <20210224115146.9131-4-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224115146.9131-1-aford173@gmail.com>
References: <20210224115146.9131-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For devices that use a programmable clock for the AVB reference clock,
the driver may need to enable them.  Add code to find the optional clock
and enable it when available.

Signed-off-by: Adam Ford <aford173@gmail.com>
---
V3:  Change 'avb' to 'AVB'
     Remove unnessary else statement and pointer maniupluation when 
     enabling the refclock. 
     Add disable_unprepare call in remove funtion.
      
V2:  The previous patch to fetch the fclk was dropped.  In its place
     is code to enable the refclk

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 7453b17a37a2..ff363797bd2b 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -994,6 +994,7 @@ struct ravb_private {
 	struct platform_device *pdev;
 	void __iomem *addr;
 	struct clk *clk;
+	struct clk *refclk;
 	struct mdiobb_ctrl mdiobb;
 	u32 num_rx_ring[NUM_RX_QUEUE];
 	u32 num_tx_ring[NUM_TX_QUEUE];
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index bd30505fbc57..614448e6eb24 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2148,6 +2148,13 @@ static int ravb_probe(struct platform_device *pdev)
 		goto out_release;
 	}
 
+	priv->refclk = devm_clk_get_optional(&pdev->dev, "refclk");
+	if (IS_ERR(priv->refclk)) {
+		error = PTR_ERR(priv->refclk);
+		goto out_release;
+	}
+	clk_prepare_enable(priv->refclk);
+
 	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
@@ -2260,6 +2267,9 @@ static int ravb_remove(struct platform_device *pdev)
 	if (priv->chip_id != RCAR_GEN2)
 		ravb_ptp_stop(ndev);
 
+	if (priv->refclk)
+		clk_disable_unprepare(priv->refclk);
+
 	dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
 			  priv->desc_bat_dma);
 	/* Set reset mode */
-- 
2.25.1

