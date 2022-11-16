Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F01962B5C3
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbiKPI6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiKPI6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:58:00 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BFF62E3;
        Wed, 16 Nov 2022 00:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668589079; x=1700125079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yQiMXryQ5CnJworTdlI0xW4U42SpOH1ZlqiWstKe+mg=;
  b=10SOtl3gijhDNTdd69SVJCgTtrzz/2cVBFZUuSFMH4Y/LSPHr6fLV3jW
   PsnKi54QR5W0GBlJ4cRd7oWVfRlAwU630Tk1EZO8gCavyc7hzU+oHr0EZ
   roVJpZaP69CuVYIBaLeimiVkUwoh+R8rB95P9bLa3w6BQbhpAY5fAIwiV
   MZVrVM+VF4j5tMeQM/1d7Me4F/VnmTdtOqTySss9Sq7VijtNDka0CplVT
   PuTrqltDjcL9mHPnUbPHX/vDH/j7mS8GiNTp6OZakJKWbfk3MxvuLclXP
   iBZEC8ua0KhPzz3GOzdEM8icHsTH44sP7gVDGJiNpFq6X2vh50eI/pOU4
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="200006026"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Nov 2022 01:57:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 16 Nov 2022 01:57:58 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 16 Nov 2022 01:57:55 -0700
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
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next 1/8] net: microchip: sparx5: Ensure L3 protocol has a default value
Date:   Wed, 16 Nov 2022 09:57:40 +0100
Message-ID: <20221116085747.3810427-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116085747.3810427-1-steen.hegelund@microchip.com>
References: <20221116085747.3810427-1-steen.hegelund@microchip.com>
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

This ensures that the l3_proto always have a valid value and that any
dissector parsing errors causes the flower rule to be discarded.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index a48baeacc1d2..04fc2f3b1979 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -648,7 +648,11 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 		return PTR_ERR(vrule);
 
 	vrule->cookie = fco->cookie;
-	sparx5_tc_use_dissectors(fco, admin, vrule, &l3_proto);
+
+	l3_proto = ETH_P_ALL;
+	err = sparx5_tc_use_dissectors(fco, admin, vrule, &l3_proto);
+	if (err)
+		goto out;
 
 	err = sparx5_tc_add_rule_counter(admin, vrule);
 	if (err)
-- 
2.38.1

