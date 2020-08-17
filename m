Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B152460FC
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgHQIrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgHQIrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:47:20 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C50C061388;
        Mon, 17 Aug 2020 01:47:20 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o5so7798856pgb.2;
        Mon, 17 Aug 2020 01:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sDB+8Tz8U9Ch6dcpkTtA+z2iicnUFyx5WajKnuGwbDA=;
        b=mQkr38lDq37Raa/13zjMqvZ9sWysD22QEBUTZoh79zdS+SoSEiGWMgPI07tYxYVQzo
         mHbWCTyVgmhcxYyXJeQUoby6HVbcOpP29Kwa49uRHB1+DP/Kkt/6d+BvVE/Di4Mpu/Sk
         lOxjczwuKAi4mG0Mtsmtw7GhZDrDXbHGVmhktcvtrUNXP3yDHut72eJyDUj2A2XbEKxs
         KHsWlI+/aXIpiPCjtmYFGQjKICL2Ai6EapwuSg7fsFB82t+/4NT8A5T+wljdM692F/sO
         a6WwhgkC0k4xCA2HVwhH9ZPJ0gqf/7oToPJCNghoJjSI5WOAdgsP3qlR54Xfj/nbftca
         JS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sDB+8Tz8U9Ch6dcpkTtA+z2iicnUFyx5WajKnuGwbDA=;
        b=IjY1g31aLVPUfGHyfo3vOi3EbN9Bntnn1ZKCvuO2WmB2ZhLDX13VpAzzX0I6s07XHx
         Lubmdxz5ITVvWZ3SzHtSuUG1844NZmk7mpfLR5wpq4Z8PPdjwkmAUcTfVx3hfHFqDGn/
         CHgFeVt8Ad/4YXBzdEltGKGve3ptjX0eRx3g51wmidixqPgY/uCy3KUJpCTK6+V1qr0f
         Kf99mIWMuBjnb59IG/Jj926wsJjBRXu1CNtERVsZ3sPsaZuiABSDHj7isw4acZ7MLR1j
         8ijURiKsT/Tyz+cgYHxoNa9tVnyJGXRzOkN4siGg7eWnB2h1aRMGyNHt7nUyodpwpjhh
         XN/Q==
X-Gm-Message-State: AOAM531kcSEpExI9T6Q6I+oCd9rDZYmmXtpUmE2nYddm6rLnigX8xnAJ
        5cYrX0pkKPMEtJ505xBrxYg=
X-Google-Smtp-Source: ABdhPJxIKYPF0Ovbi48FHHiSjY1UtWEDTFVVWL/Yijz4HEPwFhdhxl+1jiZgaP4oixNJOBgyid3jsA==
X-Received: by 2002:a62:8f4b:: with SMTP id n72mr10540579pfd.5.1597654040357;
        Mon, 17 Aug 2020 01:47:20 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:47:19 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 8/9] net: rtl8150: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:13 +0530
Message-Id: <20200817084614.24263-12-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817084614.24263-1-allen.cryptic@gmail.com>
References: <20200817084614.24263-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/usb/rtl8150.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index e7c630d37589..b6d70716321c 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -589,9 +589,9 @@ static void free_skb_pool(rtl8150_t *dev)
 		dev_kfree_skb(dev->rx_skb_pool[i]);
 }
 
-static void rx_fixup(unsigned long data)
+static void rx_fixup(struct tasklet_struct *t)
 {
-	struct rtl8150 *dev = (struct rtl8150 *)data;
+	struct rtl8150 *dev = from_tasklet(dev, t, tl);
 	struct sk_buff *skb;
 	int status;
 
@@ -890,7 +890,7 @@ static int rtl8150_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 
-	tasklet_init(&dev->tl, rx_fixup, (unsigned long)dev);
+	tasklet_setup(&dev->tl, rx_fixup);
 	spin_lock_init(&dev->rx_pool_lock);
 
 	dev->udev = udev;
-- 
2.17.1

