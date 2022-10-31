Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92244613AD2
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiJaP4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiJaP4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:56:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A316F120B9;
        Mon, 31 Oct 2022 08:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667231779; x=1698767779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZDHBa9bzc08ycTyWSkWtXZaUle+cl64Y3IvIAL+eqRc=;
  b=Oiu5zs2QQpe8F7HXvwRiiPtT8RjMi4/RdtFGq90fokqA8alDKMdrL2QY
   6iVbWvQ4baU+0wfG9MiAxi8NuP+HPg6n2DrTvm4kx2ocbuuYszbAvvI9D
   wXCP7LnqRfpFlxxpLXAtynBa8TuO2J6SGsdWc1QBtPmAaWXw0/HjoInpS
   G7acLo1EFpLU9LH1XsNRyOAKtWGMjgnq6ZlPS4SphmbYHv86GKhFxhgLV
   WMxTMIGCrlMH1UWesV378o27Js8rtfA1s26hG0upGnIDSFe7pPHUflEzV
   bMi9+uDE68DsjY32xWVL6vKtwCjU1OgH3i/qAircekRCpU6dKISvJHi5q
   A==;
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="197768470"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Oct 2022 08:56:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 31 Oct 2022 08:56:17 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 31 Oct 2022 08:56:14 -0700
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
Subject: [PATCH net-next v3 1/5] net: microchip: sparx5: Differentiate IPv4 and IPv6 traffic in keyset config
Date:   Mon, 31 Oct 2022 16:56:03 +0100
Message-ID: <20221031155607.3615381-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031155607.3615381-1-steen.hegelund@microchip.com>
References: <20221031155607.3615381-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

