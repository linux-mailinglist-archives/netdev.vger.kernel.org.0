Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5088D6AF84D
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjCGWKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjCGWKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:10:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C005499D67;
        Tue,  7 Mar 2023 14:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678226999; x=1709762999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ks8peiwMHdeehdgm3BNCLpVCjBIizRLwzcw2Hv1nR/4=;
  b=cmb7jTWMVJdxcZ2ARRznjXsK4mnxDghaZId27h5E5XkFT1uccwYvgfi3
   3lJI/5XzEY1ysQ/u0sijX9xi6/PtCYpZKa5ppyPd/wcSRX/7vy2siADeP
   /S0vp2/HJepQQemqvU2U5ER+FoKTXDFevdvEvzhu+cRnQQmd/TWrRE+ET
   Fu38pvi+A7M9R9DHQ6fSZa5uM6BsadA9g1cz/xI6wjAP+bJkfnoXUHA8R
   3icQAy8UessmlYqkW7xI5DCpr8QppgM06vesMn2ilGQbtq/UGgaNmY8GI
   HwFIY04gqvt9XuuRcRmLcCRCOkUjkhRZ7842RC9184ZYSc5k+KLEa94Dw
   A==;
X-IronPort-AV: E=Sophos;i="5.98,242,1673938800"; 
   d="scan'208";a="204184911"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 15:09:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 15:09:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 15:09:52 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 5/5] net: lan966x: Add support for IS1 VCAP ethernet protocol types
Date:   Tue, 7 Mar 2023 23:09:29 +0100
Message-ID: <20230307220929.834219-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230307220929.834219-1-horatiu.vultur@microchip.com>
References: <20230307220929.834219-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IS1 VCAP has it's own list of supported ethernet protocol types which is
different than the IS2 VCAP. Therefore separate the list of known
protocol types based on the VCAP type.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_tc_flower.c     | 36 ++++++++++++++-----
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index 570ac28736e03..47b2f7579dd23 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -5,14 +5,34 @@
 #include "vcap_api_client.h"
 #include "vcap_tc.h"
 
-static bool lan966x_tc_is_known_etype(u16 etype)
+static bool lan966x_tc_is_known_etype(struct vcap_tc_flower_parse_usage *st,
+				      u16 etype)
 {
-	switch (etype) {
-	case ETH_P_ALL:
-	case ETH_P_ARP:
-	case ETH_P_IP:
-	case ETH_P_IPV6:
-		return true;
+	switch (st->admin->vtype) {
+	case VCAP_TYPE_IS1:
+		switch (etype) {
+		case ETH_P_ALL:
+		case ETH_P_ARP:
+		case ETH_P_IP:
+		case ETH_P_IPV6:
+			return true;
+		}
+		break;
+	case VCAP_TYPE_IS2:
+		switch (etype) {
+		case ETH_P_ALL:
+		case ETH_P_ARP:
+		case ETH_P_IP:
+		case ETH_P_IPV6:
+		case ETH_P_SNAP:
+		case ETH_P_802_2:
+			return true;
+		}
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(st->fco->common.extack,
+				   "VCAP type not supported");
+		return false;
 	}
 
 	return false;
@@ -69,7 +89,7 @@ lan966x_tc_flower_handler_basic_usage(struct vcap_tc_flower_parse_usage *st)
 	flow_rule_match_basic(st->frule, &match);
 	if (match.mask->n_proto) {
 		st->l3_proto = be16_to_cpu(match.key->n_proto);
-		if (!lan966x_tc_is_known_etype(st->l3_proto)) {
+		if (!lan966x_tc_is_known_etype(st, st->l3_proto)) {
 			err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_ETYPE,
 						    st->l3_proto, ~0);
 			if (err)
-- 
2.38.0

