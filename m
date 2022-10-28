Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C686114FC
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 16:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiJ1OqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 10:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiJ1OqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 10:46:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC371D066B;
        Fri, 28 Oct 2022 07:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666968363; x=1698504363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZDHBa9bzc08ycTyWSkWtXZaUle+cl64Y3IvIAL+eqRc=;
  b=iArI9sjAlLwCDSGI47KkkMKUkrbF7G6XDk55wS+LhgH0X2SgGVQs8oaJ
   zVBnqqNbBu1rkDYWqs3srBbb1YYjnOF1KgFEEebe7NUccWmpM3RviTGE1
   tcNrbaqe64zBSzujVJFZVmXO8YCY6f+KjRE0dvT8YvXOa4H6WVtrtPMx+
   qFWEPG3BS5t27xFY2cvx/sD0sKwsCJRS7h3uKaTPn1gzbFwGK55bRDx/o
   KYCTdCzHYfKOkICe3wnxEkS5xSoeTEbLbJvYTILVnhw4wrAdtUFkNvsJD
   ramSPBDNJqp+dg1XUtRphuSTrLsRYPMn6PhIeP9BsY3UcAgPgIpgRDoG6
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="184379665"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2022 07:45:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 28 Oct 2022 07:45:54 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 28 Oct 2022 07:45:51 -0700
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
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v2 1/5] net: microchip: sparx5: Differentiate IPv4 and IPv6 traffic in keyset config
Date:   Fri, 28 Oct 2022 16:45:36 +0200
Message-ID: <20221028144540.3344995-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028144540.3344995-1-steen.hegelund@microchip.com>
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This changes the port keyset configuration for Sparx5 IS2 so that

- IPv4 generates a IP4_TCP_UDP keyset for IPv4 TCP/UDP frames and a
  IP4_OTHER keyset for other IPv4 frames (both UC and MC)
- IPv6 generates a IP_7TUPLE keyset (both UC and MC)

ARP and non-IP traffic continues to generate the MAC_ETYPE keyset

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_vcap_impl.c       | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 50153264179e..e4428d55af2b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -21,6 +21,14 @@
 #define STREAMSIZE (64 * 4)  /* bytes in the VCAP cache area */
 
 #define SPARX5_IS2_LOOKUPS 4
+#define VCAP_IS2_KEYSEL(_ena, _noneth, _v4_mc, _v4_uc, _v6_mc, _v6_uc, _arp) \
+	(ANA_ACL_VCAP_S2_KEY_SEL_KEY_SEL_ENA_SET(_ena) | \
+	 ANA_ACL_VCAP_S2_KEY_SEL_NON_ETH_KEY_SEL_SET(_noneth) | \
+	 ANA_ACL_VCAP_S2_KEY_SEL_IP4_MC_KEY_SEL_SET(_v4_mc) | \
+	 ANA_ACL_VCAP_S2_KEY_SEL_IP4_UC_KEY_SEL_SET(_v4_uc) | \
+	 ANA_ACL_VCAP_S2_KEY_SEL_IP6_MC_KEY_SEL_SET(_v6_mc) | \
+	 ANA_ACL_VCAP_S2_KEY_SEL_IP6_UC_KEY_SEL_SET(_v6_uc) | \
+	 ANA_ACL_VCAP_S2_KEY_SEL_ARP_KEY_SEL_SET(_arp))
 
 /* IS2 port keyset selection control */
 
@@ -368,13 +376,12 @@ static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
 	/* all traffic types generate the MAC_ETYPE keyset for now in all
 	 * lookups on all ports
 	 */
-	keysel = ANA_ACL_VCAP_S2_KEY_SEL_KEY_SEL_ENA_SET(true) |
-		ANA_ACL_VCAP_S2_KEY_SEL_NON_ETH_KEY_SEL_SET(VCAP_IS2_PS_NONETH_MAC_ETYPE) |
-		ANA_ACL_VCAP_S2_KEY_SEL_IP4_MC_KEY_SEL_SET(VCAP_IS2_PS_IPV4_MC_MAC_ETYPE) |
-		ANA_ACL_VCAP_S2_KEY_SEL_IP4_UC_KEY_SEL_SET(VCAP_IS2_PS_IPV4_UC_MAC_ETYPE) |
-		ANA_ACL_VCAP_S2_KEY_SEL_IP6_MC_KEY_SEL_SET(VCAP_IS2_PS_IPV6_MC_MAC_ETYPE) |
-		ANA_ACL_VCAP_S2_KEY_SEL_IP6_UC_KEY_SEL_SET(VCAP_IS2_PS_IPV6_UC_MAC_ETYPE) |
-		ANA_ACL_VCAP_S2_KEY_SEL_ARP_KEY_SEL_SET(VCAP_IS2_PS_ARP_MAC_ETYPE);
+	keysel = VCAP_IS2_KEYSEL(true, VCAP_IS2_PS_NONETH_MAC_ETYPE,
+				 VCAP_IS2_PS_IPV4_MC_IP4_TCP_UDP_OTHER,
+				 VCAP_IS2_PS_IPV4_UC_IP4_TCP_UDP_OTHER,
+				 VCAP_IS2_PS_IPV6_MC_IP_7TUPLE,
+				 VCAP_IS2_PS_IPV6_UC_IP_7TUPLE,
+				 VCAP_IS2_PS_ARP_MAC_ETYPE);
 	for (lookup = 0; lookup < admin->lookups; ++lookup) {
 		for (portno = 0; portno < SPX5_PORTS; ++portno) {
 			spx5_wr(keysel, sparx5,
-- 
2.38.1

