Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE3E6940F4
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjBMJZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjBMJZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:25:05 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1108615557;
        Mon, 13 Feb 2023 01:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676280303; x=1707816303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pSgEuxZNu+d4XoNLOzFnDmUYzYsXumWoRDae7nv3+Uk=;
  b=i2+zMuAzlshgwwtSnNjdH7t60BvTXWkAg/QM1zkpq4KeiN0S4UizUZBZ
   xeeOjiw6KferM6E2mtor27LgpNvxIF8QhPgJ0DQ8+m3Cpab68kZtK7f3F
   z+r2QPrbllkqkXwhlQ1dCkfjGj7OLHZljbsXxk6quE5Ts1pdPEZSrGmxl
   sdBhwqJ+SdNkuN2iTr9tHY9ZwVC1H61ukt+EApHFAhiSKxRzmX9Ad7CLV
   PHQXlJ47dBRXLSOJ0ic9iT44Ruc65c5TxZz3lwsdHqDz7uY1vhEsgZ91w
   FckB60as0WAxV4Z1J/r0xua+8+Er435Z8tlP7ciYrnrhT6XKpSqKiis88
   A==;
X-IronPort-AV: E=Sophos;i="5.97,293,1669100400"; 
   d="scan'208";a="196611576"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 02:24:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 02:24:47 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 02:24:43 -0700
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
Subject: [PATCH net-next 03/10] net: microchip: sparx5: Egress VLAN TPID configuration follows IFH
Date:   Mon, 13 Feb 2023 10:24:19 +0100
Message-ID: <20230213092426.1331379-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213092426.1331379-1-steen.hegelund@microchip.com>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
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

This changes the TPID of the egress frames to use the TPID stored in the
IFH (internal frame header), which ensures that this is the TPID classified
for the frame at ingress.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
index 34f954bbf815..ac001ae59a38 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
@@ -219,8 +219,8 @@ void sparx5_vlan_port_apply(struct sparx5 *sparx5,
 	spx5_wr(val, sparx5,
 		ANA_CL_VLAN_FILTER_CTRL(port->portno, 0));
 
-	/* Egress configuration (REW_TAG_CFG): VLAN tag type to 8021Q */
-	val = REW_TAG_CTRL_TAG_TPID_CFG_SET(0);
+	/* Egress configuration (REW_TAG_CFG): VLAN tag selected via IFH */
+	val = REW_TAG_CTRL_TAG_TPID_CFG_SET(5);
 	if (port->vlan_aware) {
 		if (port->vid)
 			/* Tag all frames except when VID == DEFAULT_VLAN */
-- 
2.39.1

