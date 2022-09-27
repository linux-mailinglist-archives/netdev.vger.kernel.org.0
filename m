Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B805ECE41
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbiI0USe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiI0USB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:18:01 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FF019281
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:17:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id b9-20020a17090a6e0900b00203a8013b45so4094536pjk.5
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=F72lE+m5jUyXJTZtAHspzg4fSLtIEdJfsL6DV7/dUu4=;
        b=Mn8MbU84gVPCY9rdXSLA84U8EL0aqabNS24qrZWJ2AnahzfD2GFj4FE4Z0n05/O/Zt
         V/aIs40HUCDBjONjB/LyF+BOhm2UoyobiRZGpXu8lr1esxucb3JZeu+8OKc2pVc2hh+x
         UbnmqFSEJ68jJdDpoYY6FLvV3Seo1t7Gv9OPvEIWZJuj7+TsSj0WhD3vvSxJxaBFJcr0
         ld8bUZgzL82VhOu3rnVqg118AzBJEQHny195aliXzFCnm2SSzbP2u1ixIV6zu1pdNmo5
         8zrLlDxN1AZsVn+LXYQQ7GgkBbtgIuNb5lkEruA8D7OJ2ywQrsl3f6gNazJf9QttXIYO
         gHbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=F72lE+m5jUyXJTZtAHspzg4fSLtIEdJfsL6DV7/dUu4=;
        b=K4I/i+3Wci0PJA+eaOtE5jukiTYc5hwm/wI21K+vP49efULoGbLu4oVeVKMn16+z9e
         b+oUsJLnJ1/KoQTZL8DASAlTBFEtxcATekmUdw438Mc2wjR9prAqE6jn97qiSftK9LHv
         aygSVzaW7mrm/hRbUZuolzv8cQmJhGu7nXjBq2CQ23N9ex2gtm6TQESBs/KraM0K/qCG
         dT1E19nXjEPv+/QrB8JniKY9TbbZVk7rUIfGq5O3lrJPFJgbmgUP9Ah92iqI7pQiJVmI
         1O1Vjco/OIyAbdvScemsYOQ964dZ4SjThTfH641c1cmyDaHmi/u84L6Q+ls1JIoEz9z0
         8Qzg==
X-Gm-Message-State: ACrzQf3/JKrIgW/lTZse+s64j72rI3eVM6xfvCGObsLSKHd1iUEE40e6
        s2vTCPxy4tGYNnjd50OREHUAS1Y2xNegl+EoyzELHw==
X-Google-Smtp-Source: AMsMyM4YN8OcX/N4kLK/55u37LO9rUT0u12bu6lrEYV/DZXomjgyk3g5okkp2Zpf8VEXOnvAkp4pZZsMv5Jul6oz+V5raQ==
X-Received: from abps.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:9b4])
 (user=abhishekpandit job=sendgmr) by 2002:aa7:9e0d:0:b0:540:94a7:9051 with
 SMTP id y13-20020aa79e0d000000b0054094a79051mr31047543pfq.59.1664309843219;
 Tue, 27 Sep 2022 13:17:23 -0700 (PDT)
Date:   Tue, 27 Sep 2022 13:17:20 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220927131717.v3.1.Ic8eabc8ed89a07c3d52726dd017539069faac6c4@changeid>
Subject: [PATCH v3] Bluetooth: Call shutdown for HCI_USER_CHANNEL
From:   Abhishek Pandit-Subedi <abhishekpandit@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

Some drivers depend on shutdown being called for proper operation.
Unset HCI_USER_CHANNEL and call the full close routine since shutdown is
complementary to setup.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

Using hci_qca, we can get the controller into a bad state simply by
trying to bind to userchannel twice (open+bind+close, then open+bind).
Without running the shutdown routine, the device seems to get into a bad
state. A similar bug also occurs with btmtksdio (using MT7921).

This change properly runs the shutdown routine, which should be
complementary to setup. The reason it unsets the HCI_USER_CHANNEL flag
is that some drivers have complex operations in their shutdown routine
(including sending hci packets) and we need to support the normal data
path for them (including cmd_timeout + recovery mechanisms).

Note for v2: I've gotten a chance to test this on more devices
and figure out why it wasn't working before in v1. I found two problems:
I had a signal pending (SIGTERM) that was messing things up in the
socket release function and the HCI_USER_CHANNEL flag was preventing
hci_sync from operating properly during shutdown on Intel chipsets
(which use the sync functions to send a reset command + other commands
sometimes).

This was tested with hci_qca (QCA6174-A-3), btmtksdio (MT7921-SDIO)
and btusb (with AX200).


Changes in v3:
- Added hci_dev_shutdown to wrap disabling and re-enabling flag.

Changes in v2:
- Clear HCI_USER_CHANNEL flag at start of close and restore at end.
- Add comment explaning why we need to clear flag and run shutdown.

 net/bluetooth/hci_sync.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 422f7c6911d9..15c75ef4c271 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4727,6 +4727,31 @@ static void hci_pend_le_actions_clear(struct hci_dev *hdev)
 	BT_DBG("All LE pending actions cleared");
 }
 
+static int hci_dev_shutdown(struct hci_dev *hdev)
+{
+	int err = 0;
+	/* Similar to how we first do setup and then set the exclusive access
+	 * bit for userspace, we must first unset userchannel and then clean up.
+	 * Otherwise, the kernel can't properly use the hci channel to clean up
+	 * the controller (some shutdown routines require sending additional
+	 * commands to the controller for example).
+	 */
+	bool was_userchannel =
+		hci_dev_test_and_clear_flag(hdev, HCI_USER_CHANNEL);
+
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			err = hdev->shutdown(hdev);
+	}
+
+	if (was_userchannel)
+		hci_dev_set_flag(hdev, HCI_USER_CHANNEL);
+
+	return err;
+}
+
 int hci_dev_close_sync(struct hci_dev *hdev)
 {
 	bool auto_off;
@@ -4746,13 +4771,7 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 		hdev->adv_instance_timeout = 0;
 	}
 
-	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-	    test_bit(HCI_UP, &hdev->flags)) {
-		/* Execute vendor specific shutdown routine */
-		if (hdev->shutdown)
-			err = hdev->shutdown(hdev);
-	}
+	err = hci_dev_shutdown(hdev);
 
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

