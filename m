Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE9E65C1F8
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 15:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbjACObX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 09:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237409AbjACObW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 09:31:22 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CF1B87A;
        Tue,  3 Jan 2023 06:31:21 -0800 (PST)
Received: from fedcomp.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 2B784419E9E3;
        Tue,  3 Jan 2023 14:31:20 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 2B784419E9E3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1672756280;
        bh=igzujiJxzrmRT5zmMdtGoH+qe02y/3twFq2INbwL4h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITfH/+rqflwuC03BhiWDxdUMPX6ESkwKjPijne4ATq8eqQuqepB2RjquarfcVUjvp
         H7oIO0Wf/ccbSpDxAGi0BFalbzoxaMO1sY0DzIm97TH5pAp3vEfeD5jTtQetJr6AUr
         w1AwnLs1+hJ22KBXqFhBYsYVeiuWy+vRfpiLYpIM=
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
        lvc-project@linuxtesting.org,
        syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com
Subject: [PATCH v2] wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails
Date:   Tue,  3 Jan 2023 17:30:29 +0300
Message-Id: <20230103143029.273695-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <87h6x95huy.fsf@toke.dk>
References: 
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
Reported-by: syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
v1->v2: added Reported-by tag

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

