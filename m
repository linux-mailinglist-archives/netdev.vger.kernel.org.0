Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1886937D1
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 15:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBLOxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 09:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBLOxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 09:53:03 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C166F11E8F;
        Sun, 12 Feb 2023 06:53:01 -0800 (PST)
Received: from fpc.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 0730D44C101D;
        Sun, 12 Feb 2023 14:53:00 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 0730D44C101D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1676213580;
        bh=UAcNy4s3ciQEP3RErmHWu+rLoVRfErmjChDp+m1b2o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+VjZMC49qlkZexnhD4yW9hADORqhf5tfgncJUuHBa2rcYCSUcuxyScRpertiGcAr
         tab3kdwH7MrvqCkW3ofbxS/ts5nyUzDpTfwJ/LO9QbxLPWtNflR/jpBIy3GDh40ZKK
         unEbzBqH8Fs3m7503RjagPPO6Vl+rfx2LFrRFo0E=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 1/1] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
Date:   Sun, 12 Feb 2023 17:52:38 +0300
Message-Id: <20230212145238.123055-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230212145238.123055-1-pchelkin@ispras.ru>
References: <20230212145238.123055-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hif_dev->remain_skb is allocated and used exclusively in
ath9k_hif_usb_rx_stream(). It is implied that an allocated remain_skb is
processed and subsequently freed (in error paths) only during the next
call of ath9k_hif_usb_rx_stream().

So, if the device is deinitialized between those two calls or if the skb
contents are incorrect, it is possible that ath9k_hif_usb_rx_stream() is
not called next time and the allocated remain_skb is leaked. Our local
Syzkaller instance was able to trigger that.

Fix the leak by introducing a function to explicitly free remain_skb (if
it is not NULL) when the device is being deinitialized. remain_skb is NULL
when it has not been allocated at all (hif_dev struct is kzalloced) or
when it has been proccesed in next call to ath9k_hif_usb_rx_stream().

Proper spinlocks are held to prevent possible concurrent access to
remain_skb from the interrupt context ath9k_hif_usb_rx_stream(). These
accesses should not happen as rx_urbs have been deallocated before but
it prevents a dangerous race condition in these cases.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f521dfa2f194..e03ab972edf7 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -534,6 +534,23 @@ static struct ath9k_htc_hif hif_usb = {
 	.send = hif_usb_send,
 };
 
+/* Need to free remain_skb allocated in ath9k_hif_usb_rx_stream
+ * in case ath9k_hif_usb_rx_stream wasn't called next time to
+ * process the buffer and subsequently free it.
+ */
+static void ath9k_hif_usb_free_rx_remain_skb(struct hif_device_usb *hif_dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hif_dev->rx_lock, flags);
+	if (hif_dev->remain_skb) {
+		dev_kfree_skb_any(hif_dev->remain_skb);
+		hif_dev->remain_skb = NULL;
+		hif_dev->rx_remain_len = 0;
+	}
+	spin_unlock_irqrestore(&hif_dev->rx_lock, flags);
+}
+
 static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				    struct sk_buff *skb)
 {
@@ -1129,6 +1146,7 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
 static void ath9k_hif_usb_dev_deinit(struct hif_device_usb *hif_dev)
 {
 	ath9k_hif_usb_dealloc_urbs(hif_dev);
+	ath9k_hif_usb_free_rx_remain_skb(hif_dev);
 }
 
 /*
-- 
2.34.1

