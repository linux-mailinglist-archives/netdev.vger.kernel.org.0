Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7C362E76B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbiKQV5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240975AbiKQV4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:56:12 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA117208F;
        Thu, 17 Nov 2022 13:56:11 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 601D31C0005;
        Thu, 17 Nov 2022 21:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1668722170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EiTXZxb081Yq5NNkWBz6w6sjlyDhWaDs7oz/56WKrNA=;
        b=G5Tf20EnfkAQSv27n4L27uE2jLAH3+81NXSpi6NWygE3N22a/E6UYI1OkS0qhQ6p0XATsZ
        OPgAj40ILTgLbMhYyOILXCWyqeNH5ghkwi0PDyRbiSgRTHrrLB1i3cQq5Th0BkZfVaCGiu
        S3IOVFhGA6mLXf/TmkBUZekrK4Iegw4TzCtkOWmTTn8lY8szMq6XVb0XRyHSptCCOW2xFb
        LLfClmSu/h3Eu6KiMpzWmc65cV9dMBh7wyMUl5fBIAeF0bHtHeacL4G+xeRMYm5ixRxKqO
        iMIoPhxk9lI9ZizylLOGXu0YUL2wODN7x3L4ZRKGRFOOnCzQqyRnrh36Owb8Jg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH net-next 5/6] net: marvell: prestera: Avoid unnecessary DT lookups
Date:   Thu, 17 Nov 2022 22:55:56 +0100
Message-Id: <20221117215557.1277033-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver fist makes an expensive DT lookup to retrieve its DT node
(this is a PCI driver) in order to later search for the
base-mac-provider property. This property has no reality upstream and
this code should not have been accepted like this in the first
place. Instead, there is a proper nvmem interface that should be
used. Let's avoid these extra lookups and rely on the nvmem internal
logic.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 .../net/ethernet/marvell/prestera/prestera_main.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 24f9d6024745..d4b48f674a88 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -862,17 +862,10 @@ static void prestera_event_handlers_unregister(struct prestera_switch *sw)
 
 static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
 {
-	struct device_node *base_mac_np;
-	int ret = 0;
-
-	if (sw->np) {
-		base_mac_np = of_parse_phandle(sw->np, "base-mac-provider", 0);
-		if (base_mac_np) {
-			ret = of_get_mac_address(base_mac_np, sw->base_mac);
-			of_node_put(base_mac_np);
-		}
-	}
+	int ret;
 
+	if (sw->np)
+		ret = of_get_mac_address(sw->np, sw->base_mac);
 	if (!is_valid_ether_addr(sw->base_mac) || ret) {
 		eth_random_addr(sw->base_mac);
 		dev_info(prestera_dev(sw), "using random base mac address\n");
@@ -1376,7 +1369,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
 {
 	int err;
 
-	sw->np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
+	sw->np = sw->dev->dev->of_node;
 
 	err = prestera_hw_switch_init(sw);
 	if (err) {
-- 
2.34.1

