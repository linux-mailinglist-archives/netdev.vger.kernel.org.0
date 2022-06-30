Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD75561AA3
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbiF3MqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbiF3MqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:46:15 -0400
Received: from smtp2.infineon.com (smtp2.infineon.com [IPv6:2a00:18f0:1e00:4::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB1D22508;
        Thu, 30 Jun 2022 05:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1656593174; x=1688129174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+S/i0os03fT4PDMmolQDm3D23GK/ZwuYZfdR8J4uDrE=;
  b=K9eMvdpR1j9KVuHduZd7t9BDwgGHotADx4kMXTtNqGCm1GRJW3DCac3e
   qGIFjtVAOXkEuzY/4/yg6yempXAgW04ez10VGK0N6VSr1Ks/xLzaj5OsI
   wgytUK/OP/SFZKSfPGmnC1VJK1pxIKB9uNmBYgMUUigadS2euVIn9xkJO
   Q=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="186455692"
X-IronPort-AV: E=Sophos;i="5.92,234,1650924000"; 
   d="scan'208";a="186455692"
Received: from unknown (HELO mucxv001.muc.infineon.com) ([172.23.11.16])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:46:13 +0200
Received: from MUCSE803.infineon.com (MUCSE803.infineon.com [172.23.29.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv001.muc.infineon.com (Postfix) with ESMTPS;
        Thu, 30 Jun 2022 14:46:13 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 30 Jun
 2022 14:46:13 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 14:46:11 +0200
From:   Hakan Jansson <hakan.jansson@infineon.com>
CC:     Hakan Jansson <hakan.jansson@infineon.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
Subject: [PATCH v2 4/5] Bluetooth: hci_bcm: Prevent early baudrate setting in autobaud mode
Date:   Thu, 30 Jun 2022 14:45:23 +0200
Message-ID: <a211533dc6c9a0d5a5d1533d24a26fb996d45dc7.1656583541.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656583541.git.hakan.jansson@infineon.com>
References: <cover.1656583541.git.hakan.jansson@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE824.infineon.com (172.23.29.55) To
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
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
V1 -> V2:
  - No changes, submitted as part of updated patch series

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

