Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE73628C482
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732240AbgJLWIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729530AbgJLWIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:08:14 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957C1C0613D0;
        Mon, 12 Oct 2020 15:08:14 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c5so14670396qtw.3;
        Mon, 12 Oct 2020 15:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DkY+sUcOMAoS8nmckdVu9ASZTsctr9JsclEB9QDzMZs=;
        b=dg9cc6KLh7u4/QUK+hoO6KysUdgwblYObfJISGOIyj61fm6AUV55007j4Z+7o5jOoR
         OVGdAUMrZFwsYd5QlOAmKXNTbKXEXPKZwUzt6Yt7EC8Md6pBPb1rXPcr0M0c5bM0Y5+L
         Q0FrHB+AquFrhrlBsuLFBW8NCFAxwlcIG9ygHynQIj+NaHdkgHIjieS2m2HxX0mgG2aB
         zxMc4IIjKgqkTyIKGndsweKYNGnow2U71G4KFtajwQM7KOBpa+pNMRM+IldlMv8cq4dR
         7WhZUTF7TF4BxhUghxVsKn4QsFd4OzOsD7ikiz0K/yVfTH65D18xbQUVAN6ZGs4yLh6+
         v6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DkY+sUcOMAoS8nmckdVu9ASZTsctr9JsclEB9QDzMZs=;
        b=Mcq7iGrgzSZRpOzaGdVgqZ72Qf5oT3zskkRZ8Ryd4blbacY8forkVF1VA1Jd+Zps7S
         Hjd+pNoFzdySwEbKg7VdNkq8XX43brkhIab7SRBh2JonCVWhRY1WJVGkXIw+ZvpQg/J9
         vROf5RdJkf+21R80YR3FU1ACLlPeYlRjkeGKhJg0T34pIb7uyo7GfWKI9pSIW1/nKcHl
         W4Fx2CQf3X4JB5rdTgMHbAOnUPm61xWBFgikMndMaGGTJ94uyujtF6N1b+RXRlFviRiq
         ZQ0BULM1v5wjPSobTXk9o2rtf36y/TISkJ4h48rE7ZkhpK6EB3JPksozcfy5TOeoOm63
         whMA==
X-Gm-Message-State: AOAM532MjXxlF3iKIYVYTnwqfHe3K03fXOcSSGCprSc73jZKj34PtS/8
        uDsCOqqZjRcmbegQEQDKmyo=
X-Google-Smtp-Source: ABdhPJzhVtIcabyjjJ3556879wfhjKCVG2+80lefxf4s6oMwfMzVA0WDiICjqGGU1ruyjvTnFnW9TA==
X-Received: by 2002:ac8:5343:: with SMTP id d3mr12690143qto.357.1602540493434;
        Mon, 12 Oct 2020 15:08:13 -0700 (PDT)
Received: from seraph.myfiosgateway.com (pool-173-75-208-99.phlapa.fios.verizon.net. [173.75.208.99])
        by smtp.gmail.com with ESMTPSA id u90sm13467096qtd.29.2020.10.12.15.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:08:12 -0700 (PDT)
From:   Brooke Basile <brookebasile@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brooke Basile <brookebasile@gmail.com>
Subject: [PATCH] ath9k: revert "ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()"
Date:   Mon, 12 Oct 2020 18:08:09 -0400
Message-Id: <20201012220809.23225-1-brookebasile@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bug in USB/IP previously caused all syzkaller USB fuzzing instances to
return false positives when testing crash reproducers.
This patch reverts changes made in commit 03fb92a432ea which, due to
this bug, returned false positives when tested and introduced new
regressions.

Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()")
Signed-off-by: Brooke Basile <brookebasile@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 860da13bfb6a..38f07420f4f9 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -449,19 +449,10 @@ static void hif_usb_stop(void *hif_handle)
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
 	/* The pending URBs have to be canceled. */
-	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_pending, list) {
-		usb_get_urb(tx_buf->urb);
-		spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 		usb_kill_urb(tx_buf->urb);
-		list_del(&tx_buf->list);
-		usb_free_urb(tx_buf->urb);
-		kfree(tx_buf->buf);
-		kfree(tx_buf);
-		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	}
-	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
 	usb_kill_anchored_urbs(&hif_dev->mgmt_submitted);
 }
@@ -771,37 +762,27 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 	struct tx_buf *tx_buf = NULL, *tx_buf_tmp = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_buf, list) {
-		usb_get_urb(tx_buf->urb);
-		spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 		usb_kill_urb(tx_buf->urb);
 		list_del(&tx_buf->list);
 		usb_free_urb(tx_buf->urb);
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
-		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	}
-	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	hif_dev->tx.flags |= HIF_USB_TX_FLUSH;
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
-	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_pending, list) {
-		usb_get_urb(tx_buf->urb);
-		spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 		usb_kill_urb(tx_buf->urb);
 		list_del(&tx_buf->list);
 		usb_free_urb(tx_buf->urb);
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
-		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	}
-	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
 	usb_kill_anchored_urbs(&hif_dev->mgmt_submitted);
 }
-- 
2.28.0

