Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD06AD4ADB
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 01:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfJKXTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 19:19:20 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33260 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfJKXTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 19:19:20 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so5140724pls.0;
        Fri, 11 Oct 2019 16:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/G9uKyk/90w+wc42UoUQODWgnKhQYlxOUwgCeA9A5ho=;
        b=sSefBXmyQMjx8Ggd1c55GcBum9XQOvWbUnc/XYDBHl7EbqFBk/WcM0Bni7J4jzmcwq
         OAQq8AbZuKJJr8N7zaBsrIN4noc2yDWiLBdrNwJ16UWfY9a+U+98WGwyZ+j/p/rvTUhT
         pR2ft0rq1MY+7HZ7HE1jB1m7TLq9JOElmY6ORGH/N5+i1AiAuiNclWabJQgJF4ZyYr7j
         2FXuro4buGSHDMlGR2SEgCGY+4HpqyQGViMt3awUuJoLbvT1xb0tspjJkSd3ttWkF5pz
         QsPnQSSFwQMpnefSJlBc3BTMIJDPTX+Pvi2PWbkUDZ39ik/BBTAHZ6hOlq/+Aqkh4j/G
         6u2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/G9uKyk/90w+wc42UoUQODWgnKhQYlxOUwgCeA9A5ho=;
        b=T0hwz1mnucB3Aqpgkn9zE+qOgyKl3A86mGIJjmV19v2Ue4MnYXacXQD1CHjxb2XGoB
         8gMnCu80XkTdC71RkMRyhxYqdvUlfIX+ZZzWdWeKj3IHo59W3b9/WpMtyUuI6v/yaDnE
         CqNXW9oRgLnoXMedTN5/dMYJsZyEUK2BlIQhgULSyXxpb9xkuPbMNu8SWycjkNHmjwr8
         F2L1S0LBpT6lOr5uVEtRiwq8czl120B7JJjTnzk53BZyS+PBurqoEor9fz4yHm9fpY+d
         6ByBxwsaK2Y0zANFRjbhKQCG9wecHXX0u/7O31hcN7H3F+hyBsaUwJZ1TB6wx08ItYFM
         LStA==
X-Gm-Message-State: APjAAAWu6djXGMC/W2MWjJOw1zi6PncQ5xsdPWnHlU32XiDtcsJ2sUtE
        BpeqQHlcTUAe4OZz5JvG+znf+SJx
X-Google-Smtp-Source: APXvYqwwVWuSHP/noxdWfl1rCLKl5ioAbmqbftaXp7u7n3bR6ooq9PcqpcLpUWdnxM5GuDmTjJtYQw==
X-Received: by 2002:a17:902:9f94:: with SMTP id g20mr1733531plq.319.1570835958930;
        Fri, 11 Oct 2019 16:19:18 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f185sm13311997pfb.183.2019.10.11.16.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 16:19:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     phil@raspberrypi.org, jonathan@raspberrypi.org,
        matthias.bgg@kernel.org, linux-rpi-kernel@lists.infradead.org,
        wahrenst@gmx.net, nsaenzjulienne@suse.de,
        Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: bcmgenet: Generate a random MAC if none is valid
Date:   Fri, 11 Oct 2019 16:19:15 -0700
Message-Id: <20191011231915.9347-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having a hard failure and stopping the driver's probe
routine, generate a random Ethernet MAC address to keep going.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 12cb77ef1081..5c20829ffa0f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3461,16 +3461,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	if (dn) {
+	if (dn)
 		macaddr = of_get_mac_address(dn);
-		if (IS_ERR(macaddr)) {
-			dev_err(&pdev->dev, "can't find MAC address\n");
-			err = -EINVAL;
-			goto err;
-		}
-	} else {
+	else
 		macaddr = pd->mac_address;
-	}
 
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
@@ -3482,7 +3476,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	dev_set_drvdata(&pdev->dev, dev);
-	ether_addr_copy(dev->dev_addr, macaddr);
+	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr))
+		eth_hw_addr_random(dev);
+	else
+		ether_addr_copy(dev->dev_addr, macaddr);
 	dev->watchdog_timeo = 2 * HZ;
 	dev->ethtool_ops = &bcmgenet_ethtool_ops;
 	dev->netdev_ops = &bcmgenet_netdev_ops;
-- 
2.17.1

