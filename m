Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3673A202A1A
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 12:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbgFUKnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 06:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729732AbgFUKnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 06:43:41 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34E3C061794;
        Sun, 21 Jun 2020 03:43:40 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id c17so16100437lji.11;
        Sun, 21 Jun 2020 03:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=0jfMkEZWrYezS9uZR+4li6B/DaAPDq43HDV7xKrW+u8=;
        b=ukvLAbAW5ZNyya2vWq5Gb0c9cPNSMt1D6x3tfXtr2WVBxxTrfGCWMcIy33yqZ6u8Ds
         l34GXrTu0xzG9ztGv9kMtOEvZtx10P9uACreV1kdxP448hs+XsR1zDo0AG1TW396KOz2
         j3nxndfPiXINklQeNn9u8ywdmEJXxafAGWWTe+Ito2Fi8aVC7Bms0wxMF1yS4wkgKRdg
         1hCvL2oo0xCippc31mZPOTPM2WCrJoztGko69671sz/6jQlLoCKHgg36sG5Qd6mLA2ML
         VXBwTjvaf3L+bQvf6/AzaCUMNoS5zDQPNYmRkK2L/0wYPM3SLJU2/QIA8FzPB2+o7v8y
         gPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=0jfMkEZWrYezS9uZR+4li6B/DaAPDq43HDV7xKrW+u8=;
        b=mM33wwEcAFVw2bK9J5z2KavL9FjE43wBkASV0PsXDDhcsYRkuX4uXgnJmYIpTFIxxk
         i7Qxk3v4vDwSKJP+rCiflz1xcqME5bgLjcdqJCA/Y1B08b7lFj2JSSlq2vVDQrurfbKw
         4GJHkjHsLqevyh55bOa78MQZmq9h2F/ClYAOTT0zv4H3fob14Xyrd42fedjC5uMFgcNE
         9z7BjsavQIWBNwwgjRQO+7IOCMuF4Y8WCCQo3RrAimlDJXWLb6aZKtW1qVeiWZl0jEGY
         WK3T4hd9vc4aYyMog+Awo7vRs1+p/nFG8cBmEthTvRP7bKWfHO61oBqbJwClmPVda7+/
         +hGQ==
X-Gm-Message-State: AOAM533jhUh7fM+msE0AhSOj5s3oPer7ri1Fzga+Dmrluu5kj9OHGMpS
        MoStnzNk7jVDNI7rr8mLuzWObpXW7rQ=
X-Google-Smtp-Source: ABdhPJzs4X+XdCoLtfSEbtZoUdD/2KRC4uvUydI7B6w8pwlcxBOfgYRz2bPexgjJtZVxNPHzkh7GJA==
X-Received: by 2002:a2e:974a:: with SMTP id f10mr6182456ljj.283.1592736219464;
        Sun, 21 Jun 2020 03:43:39 -0700 (PDT)
Received: from localhost.localdomain (n2e4fgqko6hxp4lot-1.v6.elisa-mobile.fi. [2001:999:0:6ffe:75bb:c470:73e0:b3cd])
        by smtp.gmail.com with ESMTPSA id c20sm2652249lfb.33.2020.06.21.03.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 03:43:38 -0700 (PDT)
From:   Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To:     steve.glendinning@shawell.net
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Subject: [PATCH] usbnet: smsc95xx: Fix use-after-free after removal
Date:   Sun, 21 Jun 2020 13:43:26 +0300
Message-Id: <20200621104326.30604-1-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reports an use-after-free in workqueue context:

BUG: KASAN: use-after-free in mutex_unlock+0x19/0x40 kernel/locking/mutex.c:737
 mutex_unlock+0x19/0x40 kernel/locking/mutex.c:737
 __smsc95xx_mdio_read drivers/net/usb/smsc95xx.c:217 [inline]
 smsc95xx_mdio_read+0x583/0x870 drivers/net/usb/smsc95xx.c:278
 check_carrier+0xd1/0x2e0 drivers/net/usb/smsc95xx.c:644
 process_one_work+0x777/0xf90 kernel/workqueue.c:2274
 worker_thread+0xa8f/0x1430 kernel/workqueue.c:2420
 kthread+0x2df/0x300 kernel/kthread.c:255

It looks like that smsc95xx_unbind() is freeing the structures that are
still in use by the concurrently running workqueue callback. Thus switch
to using cancel_delayed_work_sync() to ensure the work callback really
is no longer active.

Reported-by: syzbot+29dc7d4ae19b703ff947@syzkaller.appspotmail.com
Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
---
Compile tested only.
---
 drivers/net/usb/smsc95xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 355be77f4241..3cf4dc3433f9 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1324,7 +1324,7 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
 
 	if (pdata) {
-		cancel_delayed_work(&pdata->carrier_check);
+		cancel_delayed_work_sync(&pdata->carrier_check);
 		netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 		kfree(pdata);
 		pdata = NULL;
-- 
2.17.1

