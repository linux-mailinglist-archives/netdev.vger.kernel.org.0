Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305F653CD42
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 18:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343951AbiFCQc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 12:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343938AbiFCQcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 12:32:21 -0400
Received: from m12-11.163.com (m12-11.163.com [220.181.12.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B29F633EB3;
        Fri,  3 Jun 2022 09:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=UbU9S6Rop7ic3pmKN4
        Lz4yzIPUYdBXjItpANyNVVeb8=; b=Op/8GgX4M/t952BNr+YAq6LGzXkkQw6lOh
        bCY6a2zLRKaDBfcZjweBo5cWiJybFpbW/cL0ImuQxa5hk+UbSUmtrxdcaYSYmYhn
        5PmM7MEzg487/ZeJGVgS0i9P/qu1LQmmP+xaywB698lnMoamlDYBv12JY4Z8NmPp
        CLcBj1OVg=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp7 (Coremail) with SMTP id C8CowAAnr5ZiN5pisngmGA--.49354S4;
        Sat, 04 Jun 2022 00:31:38 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     hifoolno <553441439@qq.com>
Subject: [PATCH 1/1] nfc: nfcmrvl: Fix memory leak in nfcmrvl_play_deferred
Date:   Sat,  4 Jun 2022 00:31:27 +0800
Message-Id: <20220603163127.4994-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: C8CowAAnr5ZiN5pisngmGA--.49354S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArWDJry7Kw4fGFyxKF45Jrb_yoW8XF4Upr
        Z8GryYvrykKrWaqr13Arsxua45Jw4xC3yjkF1xu343Xa45Kay8KayxtF13AFZ5Kr4rGw12
        vFsFvay5W3WrK3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zKiihhUUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbiYwoVMFaEIyukDAAAs+
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

From: hifoolno <553441439@qq.com>

Currently usb_submit_urb is called directly to submit deferred tx
urbs after unanchor them.

So the usb_giveback_urb_bh would failed to unref it in usb_unanchor_urb
and cause memory leak.

Put those urbs in tx_anchor to avoid the leak, and also fix the error
handling.

Signed-off-by: hifoolno <553441439@qq.com>
---
 drivers/nfc/nfcmrvl/usb.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index a99aedff795d..815255b8d72e 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -388,13 +388,27 @@ static void nfcmrvl_play_deferred(struct nfcmrvl_usb_drv_data *drv_data)
 	int err;
 
 	while ((urb = usb_get_from_anchor(&drv_data->deferred))) {
+		usb_anchor_urb(urb, &drv_data->tx_anchor);
+
 		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err)
+		if (err) {
+			if (err != -EPERM && err != -ENODEV)
+				BT_ERR("%s urb %p submission failed (%d)",
+					drv_data->hdev->name, urb, -err);
+			kfree(urb->setup_packet);
+			usb_unanchor_urb(urb);
+			usb_free_urb(urb);
 			break;
+		}
 
 		drv_data->tx_in_flight++;
+		usb_free_urb(urb);
+	}
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

