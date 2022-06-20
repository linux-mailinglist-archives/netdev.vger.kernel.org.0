Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F4F55180B
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242040AbiFTMCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242064AbiFTMCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:02:38 -0400
Received: from smtp2.infineon.com (smtp2.infineon.com [IPv6:2a00:18f0:1e00:4::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25281186E9;
        Mon, 20 Jun 2022 05:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1655726557; x=1687262557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+DO0GysfnOu/T2g2F1GH31syJUmR4jep8XCV00kA/ms=;
  b=OE8Rz1ZoM659Z/SGX2oVr+xLbD9y20j9h6QSIGMVR9i5RSyuYuB9mB9b
   EheAzaO5vpbGJI1GshKZotbdc2RMNlfZuooY7WgZHXycAiO1hDfdzO3du
   GEY9jvK+Vx2zrW+aliqkJb8k5l3I5zWGAJ0WZU0EVDxqKVC9M8h53hJHa
   0=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="184450174"
X-IronPort-AV: E=Sophos;i="5.92,306,1650924000"; 
   d="scan'208";a="184450174"
Received: from unknown (HELO mucxv001.muc.infineon.com) ([172.23.11.16])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 14:02:34 +0200
Received: from MUCSE822.infineon.com (MUCSE822.infineon.com [172.23.29.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv001.muc.infineon.com (Postfix) with ESMTPS;
        Mon, 20 Jun 2022 14:02:34 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 20 Jun
 2022 14:02:34 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 20 Jun 2022 14:02:33 +0200
From:   Hakan Jansson <hakan.jansson@infineon.com>
CC:     Hakan Jansson <hakan.jansson@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
Subject: [PATCH 3/4] Bluetooth: hci_bcm: Prevent early baudrate setting in autobaud mode
Date:   Mon, 20 Jun 2022 14:01:28 +0200
Message-ID: <0e3c48f0f38b167d83feb102284eaf24caa8c500.1655723462.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655723462.git.hakan.jansson@infineon.com>
References: <cover.1655723462.git.hakan.jansson@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE805.infineon.com (172.23.29.31) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always prevent trying to set device baudrate before calling setup() when
using autobaud mode.

This was previously happening for devices which had device specific data
with member no_early_set_baudrate set to 0.

Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
---
 drivers/bluetooth/hci_bcm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 9a129867a4c0..0ae627c293c5 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -484,7 +484,7 @@ static int bcm_open(struct hci_uart *hu)
 		/* If oper_speed is set, ldisc/serdev will set the baudrate
 		 * before calling setup()
 		 */
-		if (!bcm->dev->no_early_set_baudrate)
+		if (!bcm->dev->no_early_set_baudrate && !bcm->dev->use_autobaud_mode)
 			hu->oper_speed = bcm->dev->oper_speed;
 
 		err = bcm_gpio_set_power(bcm->dev, true);
@@ -1204,9 +1204,6 @@ static int bcm_of_probe(struct bcm_device *bdev)
 {
 	bdev->use_autobaud_mode = device_property_read_bool(bdev->dev,
 							    "brcm,requires-autobaud-mode");
-	if (bdev->use_autobaud_mode)
-		bdev->no_early_set_baudrate = true;
-
 	device_property_read_u32(bdev->dev, "max-speed", &bdev->oper_speed);
 	device_property_read_u8_array(bdev->dev, "brcm,bt-pcm-int-params",
 				      bdev->pcm_int_params, 5);
-- 
2.25.1

