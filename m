Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356D9653BA5
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 06:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbiLVFLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 00:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbiLVFK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 00:10:57 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E42F178A5;
        Wed, 21 Dec 2022 21:10:55 -0800 (PST)
From:   Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1671685848;
        bh=FtucXeOqhf/uwSmZUOmwGhFgKFDCA9qaKfFhVklXs0M=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=YHzejwL7SuWZwjrhLR4DKptcjvIT0orp+tF+YwprS6dypbmp5pN0ErmSymXZ8rHaq
         b8qEunKXylgKdVCial+uCfm7rLoNo7q8xzz45BIpWTtgePfpw4VyOgJVJvCkOwN+9g
         yQ/FHPfOZM2uuJfFqb6bSYCIuDa3BOIqIjvhYnd4=
Date:   Thu, 22 Dec 2022 05:10:45 +0000
Subject: [PATCH 2/8] HID: usbhid: Make hid_is_usb() non-inline
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <20221222-hid-v1-2-f4a6c35487a5@weissschuh.net>
References: <20221222-hid-v1-0-f4a6c35487a5@weissschuh.net>
In-Reply-To: <20221222-hid-v1-0-f4a6c35487a5@weissschuh.net>
To:     Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.11.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671685845; l=1506;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=FtucXeOqhf/uwSmZUOmwGhFgKFDCA9qaKfFhVklXs0M=;
 b=UB9Y4WcNg/MqRsY8fH/mjN2XW796kfEfNDKTuo1LtScaZE8nN1kABWW19n6EWmxAjQoUxpyFCdsW
 iDklWEpCCfNE5urMvYanl8sjuNuTpr5lCp+bnHJVX94T5Pje9X+N
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By making hid_is_usb() a non-inline function the lowlevel usbhid driver
does not have to be exported anymore.

Also mark the argument as const as it is not modified.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/hid/usbhid/hid-core.c | 6 ++++++
 include/linux/hid.h           | 5 +----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index be4c731aaa65..54b0280d0073 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1334,6 +1334,12 @@ struct hid_ll_driver usb_hid_driver = {
 };
 EXPORT_SYMBOL_GPL(usb_hid_driver);
 
+bool hid_is_usb(const struct hid_device *hdev)
+{
+	return hdev->ll_driver == &usb_hid_driver;
+}
+EXPORT_SYMBOL_GPL(hid_is_usb);
+
 static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_host_interface *interface = intf->cur_altsetting;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 8677ae38599e..e8400aa78522 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -864,10 +864,7 @@ static inline bool hid_is_using_ll_driver(struct hid_device *hdev,
 	return hdev->ll_driver == driver;
 }
 
-static inline bool hid_is_usb(struct hid_device *hdev)
-{
-	return hid_is_using_ll_driver(hdev, &usb_hid_driver);
-}
+extern bool hid_is_usb(const struct hid_device *hdev);
 
 #define	PM_HINT_FULLON	1<<5
 #define PM_HINT_NORMAL	1<<1

-- 
2.39.0
