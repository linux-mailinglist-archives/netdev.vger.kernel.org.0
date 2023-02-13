Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C100E6940ED
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjBMJZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjBMJZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:25:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D361314E8A;
        Mon, 13 Feb 2023 01:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676280301; x=1707816301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Dz6X4Xb9XGpExKsggN/aLNn8f0s4UocxH2zuKRm47Y=;
  b=wJkqgBQTEoYHrKPqsrEbpnuhzmQfPjFiKAR48qhGMVbhggauR+iXCskL
   Fivtadi63ns73GTNFg6JtwPDJTxQAZR+7GYxl2T4SkiD9xlH56tTq7KmI
   uLoaDdiVv71n6Z4tvFfV1JJu7GKS2fFMPcQRFb6aMIGkDZmsOVW6ff3Va
   EreiW58tQ5NijuXaBXuLjSXSiPoePVsr6aWyeHXR/6lYzbc8cu1j+6z/M
   J32VBzBcjH4PdXQQhkKXmwIex+qe/Hv6K+GYZSdqoLAdUM3FOzR0VkskP
   ft/XpzyxVR/+ydUk9XcjWLsAQ0gxeE+b9dbYIlnIYFlz+IEkq+Aku29fw
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,293,1669100400"; 
   d="scan'208";a="196611601"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 02:24:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 02:24:54 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 02:24:51 -0700
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
Subject: [PATCH net-next 05/10] net: microchip: sparx5: Improve the error handling for linked rules
Date:   Mon, 13 Feb 2023 10:24:21 +0100
Message-ID: <20230213092426.1331379-6-steen.hegelund@microchip.com>
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

Ensure that an error is returned if the VCAP instance was not found.
The chain offset (diff) is allowed to be zero as this just means that the
user did not request rules to be linked.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index d73668dcc6b6..82d5138f149e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -551,12 +551,16 @@ static int sparx5_tc_add_rule_link(struct vcap_control *vctrl,
 	struct vcap_admin *to_admin = vcap_find_admin(vctrl, to_cid);
 	int diff, err = 0;
 
-	diff = vcap_chain_offset(vctrl, from_cid, to_cid);
-	if (!(to_admin && diff > 0)) {
+	if (!to_admin) {
 		pr_err("%s:%d: unsupported chain direction: %d\n",
 		       __func__, __LINE__, to_cid);
 		return -EINVAL;
 	}
+
+	diff = vcap_chain_offset(vctrl, from_cid, to_cid);
+	if (!diff)
+		return 0;
+
 	if (admin->vtype == VCAP_TYPE_IS0 &&
 	    to_admin->vtype == VCAP_TYPE_IS0) {
 		/* Between IS0 instances the G_IDX value is used */
-- 
2.39.1

