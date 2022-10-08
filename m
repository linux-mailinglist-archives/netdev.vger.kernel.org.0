Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378EB5F851A
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 13:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiJHLt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 07:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJHLty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 07:49:54 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A87193FD;
        Sat,  8 Oct 2022 04:49:53 -0700 (PDT)
Received: from localhost.localdomain (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 002464077AE4;
        Sat,  8 Oct 2022 11:49:49 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 002464077AE4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1665229790;
        bh=eGhQBNtLRT/iMFU1ypAtNfUplajfF0B7mQZ1FqvKb6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmsIvw93BGjxV+uEf5ZUFZFc5MwdQyTTCo+AYcHXk2UF/PRppEVBUidOkzG2sqKPy
         gWT/IJbrkjOSfe4NGHUF/VNU5W93l1zjr+UmfvevwkdKICcfvlEYDVMrHUI8GQSlcA
         W6AkJ8cEXeqT94el3yHCbNHMaEBgUW5T+HP21fME=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH v2] ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()
Date:   Sat,  8 Oct 2022 14:49:17 +0300
Message-Id: <20221008114917.21404-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <87ilkvcys7.fsf@toke.dk>
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

It is possible that skb is freed in ath9k_htc_rx_msg(), then
usb_submit_urb() fails and we try to free skb again. It causes
use-after-free bug. Moreover, if alloc_skb() fails, urb->context becomes
NULL but rx_buf is not freed and there can be a memory leak.

The patch removes unnecessary nskb and makes skb processing more clear: it
is supposed that ath9k_htc_rx_msg() either frees old skb or passes its
managing to another callback function.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 3deff76095c4 ("ath9k_htc: Increase URB count for REG_IN pipe")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
v1->v2: add comment about freeing an skb and remove double blank line

 drivers/net/wireless/ath/ath9k/hif_usb.c | 28 +++++++++++++-----------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 4d9002a9d082..401b408cb7a4 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -708,14 +708,13 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
 	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
 	struct sk_buff *skb = rx_buf->skb;
-	struct sk_buff *nskb;
 	int ret;
 
 	if (!skb)
 		return;
 
 	if (!hif_dev)
-		goto free;
+		goto free_skb;
 
 	switch (urb->status) {
 	case 0:
@@ -724,7 +723,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	case -ECONNRESET:
 	case -ENODEV:
 	case -ESHUTDOWN:
-		goto free;
+		goto free_skb;
 	default:
 		skb_reset_tail_pointer(skb);
 		skb_trim(skb, 0);
@@ -735,25 +734,27 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	if (likely(urb->actual_length != 0)) {
 		skb_put(skb, urb->actual_length);
 
-		/* Process the command first */
+		/*
+		 * Process the command first.
+		 * skb is either freed here or passed to be
+		 * managed to another callback function.
+		 */
 		ath9k_htc_rx_msg(hif_dev->htc_handle, skb,
 				 skb->len, USB_REG_IN_PIPE);
 
-
-		nskb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
-		if (!nskb) {
+		skb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
+		if (!skb) {
 			dev_err(&hif_dev->udev->dev,
 				"ath9k_htc: REG_IN memory allocation failure\n");
-			urb->context = NULL;
-			return;
+			goto free_rx_buf;
 		}
 
-		rx_buf->skb = nskb;
+		rx_buf->skb = skb;
 
 		usb_fill_int_urb(urb, hif_dev->udev,
 				 usb_rcvintpipe(hif_dev->udev,
 						 USB_REG_IN_PIPE),
-				 nskb->data, MAX_REG_IN_BUF_SIZE,
+				 skb->data, MAX_REG_IN_BUF_SIZE,
 				 ath9k_hif_usb_reg_in_cb, rx_buf, 1);
 	}
 
@@ -762,12 +763,13 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret) {
 		usb_unanchor_urb(urb);
-		goto free;
+		goto free_skb;
 	}
 
 	return;
-free:
+free_skb:
 	kfree_skb(skb);
+free_rx_buf:
 	kfree(rx_buf);
 	urb->context = NULL;
 }
-- 
2.25.1

