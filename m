Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADDC644BD5
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiLFSfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiLFSfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:35:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABAD6349;
        Tue,  6 Dec 2022 10:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670351706; x=1701887706;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=A5PoAKCak51gwau3gk4Z68MLvJ/ijOTtPKUqHzhQ844=;
  b=yyX2q3uG9h0PsCQ0VdOZlJRgVAKgL1PyJh3H/YgdI4C2wJ4aqTOj27+Q
   xZItiOy3iZrEy+Eh1zque79eQVbYw1VMxXPIG6I5ZiHKHKikzrIEW5/hX
   /JwNaOqYZCtxECmG4g2dIGmS6KWMQXSXjZOHSp+pTEdTHRdYYTdEOSEW7
   ryFyKw2RQN6Wwa0+LEVsiqLvVw/j6GRybGx4k538RqYfjAmLiCFXM+VQV
   r7ejqXNJWzclAh0HH7mUsbBbaLJlhcEZSejPA5VVJSHUToCaHVtkSn590
   uoQkISNBD3e7kwdKh+/Thyq8DSmhXd+iXdvnFV+lHxpTK7bnhKwLU5SBI
   w==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="126791961"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 11:35:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 11:35:05 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 11:35:03 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v3 1/2] dsa: lan9303: Add port_max_mtu API
Date:   Tue, 6 Dec 2022 12:34:59 -0600
Message-ID: <20221206183500.6898-2-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221206183500.6898-1-jerry.ray@microchip.com>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding in support for reporting the max mtu for a given
port.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 80f07bd20593..baa336bb9d15 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1279,6 +1279,25 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+/* For non-cpu ports, the max frame size is 1518.
+ * The CPU port supports a max frame size of 1522.
+ * There is a JUMBO flag to make the max size 2048, but this driver
+ * presently does not support using it.
+ */
+static int lan9303_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
+	struct lan9303 *chip = ds->priv;
+
+	dev_dbg(chip->dev, "%s(%d) entered. NET max_mtu is %d",
+		__func__, port, p->max_mtu);
+
+	if (dsa_port_is_cpu(dsa_to_port(ds, port)))
+		return 1522 - ETH_HLEN - ETH_FCS_LEN;
+	else
+		return 1518 - ETH_HLEN - ETH_FCS_LEN;
+}
+
 static const struct dsa_switch_ops lan9303_switch_ops = {
 	.get_tag_protocol = lan9303_get_tag_protocol,
 	.setup = lan9303_setup,
@@ -1299,6 +1318,7 @@ static const struct dsa_switch_ops lan9303_switch_ops = {
 	.port_fdb_dump          = lan9303_port_fdb_dump,
 	.port_mdb_add           = lan9303_port_mdb_add,
 	.port_mdb_del           = lan9303_port_mdb_del,
+	.port_max_mtu		= lan9303_port_max_mtu,
 };
 
 static int lan9303_register_switch(struct lan9303 *chip)
-- 
2.17.1

