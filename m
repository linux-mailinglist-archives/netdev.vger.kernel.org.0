Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C85110CDCD
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfK1RZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:25:06 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45002 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbfK1RYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:24:46 -0500
Received: by mail-lj1-f195.google.com with SMTP id c19so2244048lji.11;
        Thu, 28 Nov 2019 09:24:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zEpgrcz5cY6Ra8WYykk85CUZbzbFys1lSb0pPL5E4ss=;
        b=IZz51qFvTrq5K8SzBG4uH0UuzRAXCOVzKPEu8hKgjsKa2HYJbbKOi169jss2LnqM9s
         y/k1cQ1ffTE3qg4KMmjmRZrKh1gfIhc0M9v3LVWM4JTczyrtL3skOfaVofSPUjgY1R3H
         eXHS/aZDen3NZYhUJTSXIa9Piwvv0Q8sE0rp2trTmTJuzNrVZkEIXloEPtxe3v8aqpwk
         w2H0I4oPJwdQCp3pcUX6pEm7R3VT7p3QacYOYV4w+M1iK0cBmBjt8F80I5+62c+CjRgc
         Vzdz7voP0r56W8Qf+aRN3iN46s3K+h0oloBTXGd6kUvZAhS8N8DpP2giaRob/b4CWrtt
         +JvA==
X-Gm-Message-State: APjAAAWfZkrTNZITy12z2oAn/zr17OmuCDeHjyWqa7WtMMfQbzmWpHPs
        GPoJ8GvADPEVRSwXPAv0hjI=
X-Google-Smtp-Source: APXvYqxD73DK18Dce9vMPPWdSB6pO3ua+Sf+1evEb3MHPpO0BdRfc+0cLAeSf6U6oIO+cPPKHirUYA==
X-Received: by 2002:a2e:8509:: with SMTP id j9mr33787504lji.247.1574961884451;
        Thu, 28 Nov 2019 09:24:44 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id t8sm8786109lfl.51.2019.11.28.09.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 09:24:42 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iaNWz-0006wg-Pg; Thu, 28 Nov 2019 18:24:41 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 4/5] rsi: fix non-atomic allocation in completion handler
Date:   Thu, 28 Nov 2019 18:22:03 +0100
Message-Id: <20191128172204.26600-5-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191128172204.26600-1-johan@kernel.org>
References: <20191128172204.26600-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB completion handlers are called in atomic context and must
specifically not allocate memory using GFP_KERNEL.

Fixes: a1854fae1414 ("rsi: improve RX packet handling in USB interface")
Cc: stable <stable@vger.kernel.org> # 4.17
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 2c869df1c62e..ead75574e10a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/types.h>
 #include <net/rsi_91x.h>
 #include "rsi_usb.h"
 #include "rsi_hal.h"
@@ -29,7 +30,7 @@ MODULE_PARM_DESC(dev_oper_mode,
 		 "9[Wi-Fi STA + BT LE], 13[Wi-Fi STA + BT classic + BT LE]\n"
 		 "6[AP + BT classic], 14[AP + BT classic + BT LE]");
 
-static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num);
+static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num, gfp_t flags);
 
 /**
  * rsi_usb_card_write() - This function writes to the USB Card.
@@ -285,7 +286,7 @@ static void rsi_rx_done_handler(struct urb *urb)
 	status = 0;
 
 out:
-	if (rsi_rx_urb_submit(dev->priv, rx_cb->ep_num))
+	if (rsi_rx_urb_submit(dev->priv, rx_cb->ep_num, GFP_ATOMIC))
 		rsi_dbg(ERR_ZONE, "%s: Failed in urb submission", __func__);
 
 	if (status)
@@ -307,7 +308,7 @@ static void rsi_rx_urb_kill(struct rsi_hw *adapter, u8 ep_num)
  *
  * Return: 0 on success, a negative error code on failure.
  */
-static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num)
+static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num, gfp_t mem_flags)
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	struct rx_usb_ctrl_block *rx_cb = &dev->rx_cb[ep_num - 1];
@@ -337,7 +338,7 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num)
 			  rsi_rx_done_handler,
 			  rx_cb);
 
-	status = usb_submit_urb(urb, GFP_KERNEL);
+	status = usb_submit_urb(urb, mem_flags);
 	if (status) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in urb submission\n", __func__);
 		dev_kfree_skb(skb);
@@ -827,12 +828,12 @@ static int rsi_probe(struct usb_interface *pfunction,
 		rsi_dbg(INIT_ZONE, "%s: Device Init Done\n", __func__);
 	}
 
-	status = rsi_rx_urb_submit(adapter, WLAN_EP);
+	status = rsi_rx_urb_submit(adapter, WLAN_EP, GFP_KERNEL);
 	if (status)
 		goto err1;
 
 	if (adapter->priv->coex_mode > 1) {
-		status = rsi_rx_urb_submit(adapter, BT_EP);
+		status = rsi_rx_urb_submit(adapter, BT_EP, GFP_KERNEL);
 		if (status)
 			goto err_kill_wlan_urb;
 	}
-- 
2.24.0

