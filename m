Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF0A4F92B1
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 12:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiDHKSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 06:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbiDHKRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 06:17:37 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE39D1F9;
        Fri,  8 Apr 2022 03:15:33 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0624D2223A;
        Fri,  8 Apr 2022 12:15:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649412930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=v2qEIy/Xj+a1c46BagxOsDi8BmH6B2xRT/8GZpDHXxI=;
        b=TgqQZwtVYpvIuRLh5GZklXqR0kjEIzIqKUZinbf5hCk8+0i6qZ/P0MrqHllLQDkwUV5IP9
        z79OL4x+wGfoGATnq+rxOu1FjQuT++c34l6VCp66YWBLSsm/6wtXV6Fy6OTtNLqBgcmYP6
        zNSlq8SdoDTjYkiIzCGEWrtQjQ5gT4k=
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
Subject: [PATCH net v2] net: dsa: felix: suppress -EPROBE_DEFER errors
Date:   Fri,  8 Apr 2022 12:15:21 +0200
Message-Id: <20220408101521.281886-1-michael@walle.cc>
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

The DSA master might not have been probed yet in which case the probe of
the felix switch fails with -EPROBE_DEFER:
[    4.435305] mscc_felix 0000:00:00.5: Failed to register DSA switch: -517

It is not an error. Use dev_err_probe() to demote this particular error
to a debug message.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Michael Walle <michael@walle.cc>
---
changes since v1:
 - add Fixes tag and thus use net instead of net-next
 - just replace this particular dev_err() with dev_err_probed()
 - reword commit message

 drivers/net/dsa/ocelot/felix_vsc9959.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 8d382b27e625..52a8566071ed 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2316,7 +2316,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 
 	err = dsa_register_switch(ds);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", err);
+		dev_err_probe(&pdev->dev, err, "Failed to register DSA switch\n");
 		goto err_register_ds;
 	}
 
-- 
2.30.2

