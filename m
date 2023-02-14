Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68738696125
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjBNKmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbjBNKlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:41:44 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC06625E0E;
        Tue, 14 Feb 2023 02:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676371281; x=1707907281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QTCEvWMBpzgY5YyohEVC7852Z+3PzYdmpKIe3hK+24o=;
  b=jh7tHP5l3MvNnuTwRXzSgvdaS2FxVRynjozpFoqfbhet8Me+jdQD7HvG
   K/fms4smrfVGF4EhgjaeWOkIJJCOcANxSmaX/T8lZ9lkZcpwvAe0FOaw0
   XcBfeh6gXRFDX/4Y7qr8XwJKGt7HHChBnz33dKAsWZN0YAV/tI5+qrbe7
   gXBUNzdDBH9v4to4yIo9EkPQnippaGaLV31Q7R04YM695OzD2H+prBl8a
   gbxtPBkxRb0kgKi1mJbUPHhAZA7fRVkj7L0wpZwReNjw/dRlIG6hMqrL/
   Sl+5OnW7t9iCJrsv0GTgUjv9v6v++VZUV7PYFO70UKwORLmNti9tTR9k1
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,296,1669100400"; 
   d="scan'208";a="200417835"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Feb 2023 03:41:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 03:41:10 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 03:41:07 -0700
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
Subject: [PATCH net-next v2 04/10] net: microchip: sparx5: Use chain ids without offsets when enabling rules
Date:   Tue, 14 Feb 2023 11:40:43 +0100
Message-ID: <20230214104049.1553059-5-steen.hegelund@microchip.com>
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

This improves the check performed on linked rules when enabling or
disabling them.  The chain id used must be the chain id without the offset
used for linking the rules.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 68e04d47f6fd..4847d0d99ec9 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1649,10 +1649,8 @@ bool vcap_is_next_lookup(struct vcap_control *vctrl, int src_cid, int dst_cid)
 	if (vcap_api_check(vctrl))
 		return false;
 
-	/* The offset must be at least one lookup, round up */
-	next_cid = src_cid + VCAP_CID_LOOKUP_SIZE;
-	next_cid /= VCAP_CID_LOOKUP_SIZE;
-	next_cid *= VCAP_CID_LOOKUP_SIZE;
+	/* The offset must be at least one lookup so round up one chain */
+	next_cid = roundup(src_cid + 1, VCAP_CID_LOOKUP_SIZE);
 
 	if (dst_cid < next_cid)
 		return false;
@@ -2177,12 +2175,13 @@ static int vcap_get_next_chain(struct vcap_control *vctrl,
 static bool vcap_path_exist(struct vcap_control *vctrl, struct net_device *ndev,
 			    int dst_cid)
 {
+	int cid = rounddown(dst_cid, VCAP_CID_LOOKUP_SIZE);
 	struct vcap_enabled_port *eport = NULL;
 	struct vcap_enabled_port *elem;
 	struct vcap_admin *admin;
 	int tmp;
 
-	if (dst_cid == 0) /* Chain zero is always available */
+	if (cid == 0) /* Chain zero is always available */
 		return true;
 
 	/* Find first entry that starts from chain 0*/
@@ -2201,7 +2200,7 @@ static bool vcap_path_exist(struct vcap_control *vctrl, struct net_device *ndev,
 		return false;
 
 	tmp = eport->dst_cid;
-	while (tmp != dst_cid && tmp != 0)
+	while (tmp != cid && tmp != 0)
 		tmp = vcap_get_next_chain(vctrl, ndev, tmp);
 
 	return !!tmp;
-- 
2.39.1

