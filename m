Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047B4696120
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbjBNKl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBNKlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:41:31 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98AE25E2B;
        Tue, 14 Feb 2023 02:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676371266; x=1707907266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e1mnShQAa1T1MjAsWoZ1kSb7/9+7Gmh5X558Qs7HZWA=;
  b=ISCWc2WvCXLOebAPIYPx4z/IAkb5luTSm+SzaKTTMm5p3GMf8aVf3olM
   qGHld6d8ljnSQguk3cEgWP/8mS9S/FbVJgVnR3f2CCEa3pNXhNi0aMdwx
   LYZ2a6myx7yQtT0ExTZjreN533LJLv8TaOY5TAHIAdHL1rTh0OWNFw3kW
   0DElPI+QZcJUb+aiElVf5wiYjN77Dz1IrFjW64XaOZSF09eqolfXKAQOE
   vIAqFklcvelUpZbs2D0zXqvGmDFwj4GtuXrVtxeSiisJtmt5gwb2k5Wt/
   5rtLjBJNHwjPjoE5jE+X6i/HFCsjVVRk4AKvhOLegEYlpaoOTjvVFlrwc
   A==;
X-IronPort-AV: E=Sophos;i="5.97,296,1669100400"; 
   d="scan'208";a="200417801"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Feb 2023 03:40:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 03:40:59 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 03:40:55 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 01/10] net: microchip: sparx5: Discard frames with SMAC multicast addresses
Date:   Tue, 14 Feb 2023 11:40:40 +0100
Message-ID: <20230214104049.1553059-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214104049.1553059-1-steen.hegelund@microchip.com>
References: <20230214104049.1553059-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A valid frame should never use a multicast address as its source MAC
address, so discard these invalid frames.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_port.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 246259b2ae94..3a1b1a1f5a19 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -1071,6 +1071,11 @@ int sparx5_port_init(struct sparx5 *sparx5,
 	/* Discard pause frame 01-80-C2-00-00-01 */
 	spx5_wr(PAUSE_DISCARD, sparx5, ANA_CL_CAPTURE_BPDU_CFG(port->portno));
 
+	/* Discard SMAC multicast */
+	spx5_rmw(ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS_SET(0),
+		 ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS,
+		 sparx5, ANA_CL_FILTER_CTRL(port->portno));
+
 	if (conf->portmode == PHY_INTERFACE_MODE_QSGMII ||
 	    conf->portmode == PHY_INTERFACE_MODE_SGMII) {
 		err = sparx5_serdes_set(sparx5, port, conf);
-- 
2.39.1

