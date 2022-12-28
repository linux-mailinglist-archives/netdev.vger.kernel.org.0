Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3823E658757
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 23:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiL1Wka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 17:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiL1Wk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 17:40:29 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6275213EA8;
        Wed, 28 Dec 2022 14:40:27 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 92BEF40737C3;
        Wed, 28 Dec 2022 22:40:23 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 92BEF40737C3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1672267223;
        bh=neoRbvxxP4comx0tozF7xdFmBO8iyRduD2eOKs2xLrk=;
        h=From:To:Cc:Subject:Date:From;
        b=d/CEL6tNNDZgMnIIXXZWjqdwqDmtKP1tC+KZyME68TRR1AeqYjYbO6STHDBcg2Z9z
         akjGR9HLFWn1hIfVpeqWLGNtQ6L7T9g1Ba9Z9bPQ3TECkzYAk9bVKeHm4BFx9IsJWb
         bKMxf1vGKVHruW3iJ72LCzOOMId0wsncdqQGIRIk=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Zekun Shen <bruceshenzk@gmail.com>,
        Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH] wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails
Date:   Thu, 29 Dec 2022 01:40:08 +0300
Message-Id: <20221228224008.146343-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller detected a memory leak of skbs in ath9k_hif_usb_rx_stream().
While processing skbs in ath9k_hif_usb_rx_stream(), the already allocated
skbs in skb_pool are not freed if ath9k_hif_usb_rx_stream() fails. If we
have an incorrect pkt_len or pkt_tag, the skb is dropped and all the
associated skb_pool buffers should be cleaned, too.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 6ce708f54cc8 ("ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream")
Fixes: 44b23b488d44 ("ath9k: hif_usb: Reduce indent 1 column")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 1a2e0c7eeb02..d02cec114280 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -586,14 +586,14 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 		if (pkt_tag != ATH_USB_RX_STREAM_MODE_TAG) {
 			RX_STAT_INC(hif_dev, skb_dropped);
-			return;
+			goto invalid_pkt;
 		}
 
 		if (pkt_len > 2 * MAX_RX_BUF_SIZE) {
 			dev_err(&hif_dev->udev->dev,
 				"ath9k_htc: invalid pkt_len (%x)\n", pkt_len);
 			RX_STAT_INC(hif_dev, skb_dropped);
-			return;
+			goto invalid_pkt;
 		}
 
 		pad_len = 4 - (pkt_len & 0x3);
@@ -654,6 +654,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				 skb_pool[i]->len, USB_WLAN_RX_PIPE);
 		RX_STAT_INC(hif_dev, skb_completed);
 	}
+	return;
+invalid_pkt:
+	for (i = 0; i < pool_index; i++)
+		kfree_skb(skb_pool[i]);
+	return;
 }
 
 static void ath9k_hif_usb_rx_cb(struct urb *urb)
-- 
2.34.1

