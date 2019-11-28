Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F9110CDCE
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfK1RYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:24:45 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42688 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK1RYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:24:44 -0500
Received: by mail-lf1-f68.google.com with SMTP id y19so20572152lfl.9;
        Thu, 28 Nov 2019 09:24:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=trn2oJruIhuwCs6xMuGwp0kYiOcQXsbNZbrdFQNLYJE=;
        b=QteH4IQ22KTDPseojpdNhFGKl9L1O/chT62Cik94gJLML6M5X7nVARktSDXUmZZ8FL
         i07qSUjq7mGwrPVXO5ZUPGCQX+DXqenJR4dGvJN4Tq8OQ4WHLP96rBcVtw//+ypwXP+P
         CYTYtOHRVAL2BJnLMGGL6WkXamiEwomXIZrpr1buPUYnBY5sZ7bUsJagi3qNfZtZhQCp
         sJp+NivfJCZz8UwZt6mM5A0MT8KFkWidpMR8gIVCb22lgqosMvtxTzCcfrhMW9sTQceg
         EJOoMC2DVQTgZvCRMeLb3xS0VRq2YaIW4JOSwD4UHCO76LZKhsuc2zVFeof+kMJM8AAX
         apyg==
X-Gm-Message-State: APjAAAWUEz9E8kLGd9smY7h2Kz44Loc3ODsNTd4F/9ClQnq511AXYXdM
        NN93MqYIWloPDAZu8CRt8cc=
X-Google-Smtp-Source: APXvYqxtH+XIdpH4HnL/JWO08m2iRo/IyYF6xtb7plDsp4uwvtDcMSNpC+r46yKkqLPgibeG4e5ejg==
X-Received: by 2002:a19:da1a:: with SMTP id r26mr34062739lfg.60.1574961881917;
        Thu, 28 Nov 2019 09:24:41 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id 145sm4249850ljj.69.2019.11.28.09.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 09:24:41 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iaNWz-0006wR-HU; Thu, 28 Nov 2019 18:24:41 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 1/5] rsi: fix use-after-free on failed probe and unbind
Date:   Thu, 28 Nov 2019 18:22:00 +0100
Message-Id: <20191128172204.26600-2-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191128172204.26600-1-johan@kernel.org>
References: <20191128172204.26600-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure to stop both URBs before returning after failed probe as well
as on disconnect to avoid use-after-free in the completion handler.

Reported-by: syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com
Fixes: a4302bff28e2 ("rsi: add bluetooth rx endpoint")
Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Cc: stable <stable@vger.kernel.org>     # 3.15
Cc: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Fariya Fatima <fariyaf@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 53f41fc2cadf..30bed719486e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -292,6 +292,15 @@ static void rsi_rx_done_handler(struct urb *urb)
 		dev_kfree_skb(rx_cb->rx_skb);
 }
 
+static void rsi_rx_urb_kill(struct rsi_hw *adapter, u8 ep_num)
+{
+	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
+	struct rx_usb_ctrl_block *rx_cb = &dev->rx_cb[ep_num - 1];
+	struct urb *urb = rx_cb->rx_urb;
+
+	usb_kill_urb(urb);
+}
+
 /**
  * rsi_rx_urb_submit() - This function submits the given URB to the USB stack.
  * @adapter: Pointer to the adapter structure.
@@ -823,10 +832,13 @@ static int rsi_probe(struct usb_interface *pfunction,
 	if (adapter->priv->coex_mode > 1) {
 		status = rsi_rx_urb_submit(adapter, BT_EP);
 		if (status)
-			goto err1;
+			goto err_kill_wlan_urb;
 	}
 
 	return 0;
+
+err_kill_wlan_urb:
+	rsi_rx_urb_kill(adapter, WLAN_EP);
 err1:
 	rsi_deinit_usb_interface(adapter);
 err:
@@ -857,6 +869,10 @@ static void rsi_disconnect(struct usb_interface *pfunction)
 		adapter->priv->bt_adapter = NULL;
 	}
 
+	if (adapter->priv->coex_mode > 1)
+		rsi_rx_urb_kill(adapter, BT_EP);
+	rsi_rx_urb_kill(adapter, WLAN_EP);
+
 	rsi_reset_card(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);
-- 
2.24.0

