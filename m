Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B3953DAD2
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 10:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244699AbiFEIPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 04:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244674AbiFEIPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 04:15:22 -0400
Received: from m12-12.163.com (m12-12.163.com [220.181.12.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C5F627158;
        Sun,  5 Jun 2022 01:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=lEcK3LonWdWGRModNJ
        64JeNky6+6P88OyA7vjpOXQiU=; b=eVTIXHX2ua17qlGeaAiWG7ha5+IIY7z3dR
        O21bfl/gEqY/oD+IjQ0q2X+PPeovrVVmkYN009HZ5NfLOwECP38F5J0Hb5AmSrr7
        Vi6uWpT+uUqPTLu3AlXYIE1TFXogZoyCY2qeaTfjnhyWx278L6Zt+OcVpW7x+FD3
        ydite3eZY=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp8 (Coremail) with SMTP id DMCowAAHFRoEZpxiWhXTGA--.25686S4;
        Sun, 05 Jun 2022 16:15:02 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] nfc: nfcmrvl: Fix memory leak in nfcmrvl_play_deferred
Date:   Sun,  5 Jun 2022 16:14:55 +0800
Message-Id: <20220605081455.34610-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DMCowAAHFRoEZpxiWhXTGA--.25686S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF1kury5JF4rWr17AF4UCFg_yoW8WFWrpr
        Z8GrWYvrWjgrWSqwsxAwsxua45Jw4xC3yjkr17u343X3WYg3W8GaySqFyfAFykKr1rGw12
        vr4jvayrW3Z5Kw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piy89_UUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbiTgYXMFUDPVh78wAAsU
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiaohuizhang98 <ruc_zhangxiaohui@163.com>

We detected a suspected bug with our code clone detection tool.

Similar to the handling of play_deferred in commit 19cfe912c37b
("Bluetooth: btusb: Fix memory leak in play_deferred"), we thought
a patch might be needed here as well.

Currently usb_submit_urb is called directly to submit deferred tx
urbs after unanchor them.

So the usb_giveback_urb_bh would failed to unref it in usb_unanchor_urb
and cause memory leak.

Put those urbs in tx_anchor to avoid the leak, and also fix the error
handling.

Signed-off-by: xiaohuizhang98 <ruc_zhangxiaohui@163.com>
---
 drivers/nfc/nfcmrvl/usb.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index a99aedff795d..ea7309453096 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -388,13 +388,25 @@ static void nfcmrvl_play_deferred(struct nfcmrvl_usb_drv_data *drv_data)
 	int err;
 
 	while ((urb = usb_get_from_anchor(&drv_data->deferred))) {
+		usb_anchor_urb(urb, &drv_data->tx_anchor);
+
 		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err)
+		if (err) {
+			kfree(urb->setup_packet);
+			usb_unanchor_urb(urb);
+			usb_free_urb(urb);
 			break;
+		}
 
 		drv_data->tx_in_flight++;
+		usb_free_urb(urb);
+	}
+
+	/* Cleanup the rest deferred urbs. */
+	while ((urb = usb_get_from_anchor(&drv_data->deferred))) {
+		kfree(urb->setup_packet);
+		usb_free_urb(urb);
 	}
-	usb_scuttle_anchored_urbs(&drv_data->deferred);
 }
 
 static int nfcmrvl_resume(struct usb_interface *intf)
-- 
2.17.1

