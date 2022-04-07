Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1164F800C
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 15:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbiDGNIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 09:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238752AbiDGNIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 09:08:36 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C8816E213;
        Thu,  7 Apr 2022 06:06:34 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BB5E422175;
        Thu,  7 Apr 2022 15:06:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649336792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mGBUqm9BChmBe7dh0JTZ4798EIwidcsw946G7NWcDFY=;
        b=W5h2VBtaQACq3DPMDkfvlP6xoiphSkRel7NLQpKQJl2X+Ycnm9kUlbjQIWWcQZ+VyO3Q5R
        kQklyg4HbnpJflIgWtoFFaM5RXMWkk+TbAGH1AZC7R1Drw4Xlloa4L1WmWJddfZe0P8/IW
        4Pl7cEDAMF4p0cW1a6jLcxow0VBuMpA=
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: dsa: felix: suppress -EPROBE_DEFER errors
Date:   Thu,  7 Apr 2022 15:06:25 +0200
Message-Id: <20220407130625.190078-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to missing prerequisites the probe of the felix switch might be
deferred:
[    4.435305] mscc_felix 0000:00:00.5: Failed to register DSA switch: -517

It's not an error. Use dev_err_probe() to demote the error to a debug
message. While at it, replace all the dev_err()'s in the probe with
dev_err_probe().

Signed-off-by: Michael Walle <michael@walle.cc>
---

Should this be a patch with a Fixes tag?

 drivers/net/dsa/ocelot/felix_vsc9959.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 8d382b27e625..1f8c4c6de01b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2268,14 +2268,14 @@ static int felix_pci_probe(struct pci_dev *pdev,
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		dev_err(&pdev->dev, "device enable failed\n");
+		dev_err_probe(&pdev->dev, err, "device enable failed\n");
 		goto err_pci_enable;
 	}
 
 	felix = kzalloc(sizeof(struct felix), GFP_KERNEL);
 	if (!felix) {
 		err = -ENOMEM;
-		dev_err(&pdev->dev, "Failed to allocate driver memory\n");
+		dev_err_probe(&pdev->dev, err, "Failed to allocate driver memory\n");
 		goto err_alloc_felix;
 	}
 
@@ -2293,7 +2293,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 					&felix_irq_handler, IRQF_ONESHOT,
 					"felix-intb", ocelot);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to request irq\n");
+		dev_err_probe(&pdev->dev, err, "Failed to request irq\n");
 		goto err_alloc_irq;
 	}
 
@@ -2316,7 +2316,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 
 	err = dsa_register_switch(ds);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", err);
+		dev_err_probe(&pdev->dev, err, "Failed to register DSA switch\n");
 		goto err_register_ds;
 	}
 
-- 
2.30.2

