Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB96738F40C
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhEXUEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhEXUEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:04:49 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373B7C061574;
        Mon, 24 May 2021 13:03:20 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id o8so35268924ljp.0;
        Mon, 24 May 2021 13:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0TvcNqO8y/T8IOAJyjMW8G5WN+KH4SERQRY6RJUUVRw=;
        b=IuaRkBUxYutRp/MLX85Bv4hSJUyKCYGgXgnWXiP2Qj/xgc3Dj9kQbatOc7H8Ok33Hp
         Y8U8jHuC0o3fHQBjnP9OezFQQbBoldnhmMo1BxJ1mKVcu115S8KcArIODzVsf8mDyMjE
         Uun67iM8BGnioUpYzie8357yQB3rbEiZez1okEVcRMhtH9+cLE8CHN2J8sgh5Scn3jwG
         ss4feSZWkPA/QLdjls4MOdxMVK+E7gup9o2Euey2EoUiSfuGCn+fbls9rcOzkbmC31Hy
         pzQaKomK57bH9sk+qaDmIWWrftv849UCeIckcLFm4Y1afIJJtLA+s/CGAqtDNsmPjeWN
         JPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0TvcNqO8y/T8IOAJyjMW8G5WN+KH4SERQRY6RJUUVRw=;
        b=My4TXcUIrs/hWY4m3MRmltlVwNyXplbQvI9a3GVVDKDEZDZfaZXcrjHK/aViWyzI0V
         M0ZGP1Eu4qNOdIWU4LDifjLagDZDp3nNzoP1u0OBmxf1/jop28f7JuOsrZYh2jbhXIwQ
         fg4lSYP/YQ0y9DCeSrIpEpLLAiEpkTRJ6iIEiL/vbdjiw/XW07eQfSCrO0ow4PcX9YhY
         B9+Wvs8rSsJl8difkHWorHpbM0Bb5WP/V/LRTE1ImfaDqMXTsmvwr6Q1WX2vhowAVNP4
         cYIBFB0V6cC8Kk6f4YAHeA6owlMr4+TtHYwnSOMomwnJhUZ6JqvlUysClbj5MalTF017
         QZuA==
X-Gm-Message-State: AOAM533e653hozPm8+Nm1kqj2rg3e7wp/Z89QfuEO/oN/f/qabM8N51G
        s9Beg58ZHvbFFVv+X2tqTuk=
X-Google-Smtp-Source: ABdhPJzbxGDW3Al7PoN5M/RPXxhfzW9bbMx9Uet1by/yGEsH0DKWA3xcacXj4rTRDqgtAbnbttH8Dg==
X-Received: by 2002:a2e:8710:: with SMTP id m16mr17914571lji.165.1621886598592;
        Mon, 24 May 2021 13:03:18 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.209])
        by smtp.gmail.com with ESMTPSA id d22sm1877957ljl.15.2021.05.24.13.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 13:03:18 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     steve.glendinning@shawell.net, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@kernel.vger.org,
        syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com
Subject: [PATCH] net: usb: fix memory leak in smsc75xx_bind
Date:   Mon, 24 May 2021 23:02:08 +0300
Message-Id: <20210524200208.31621-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in smsc75xx_bind().
The problem was is non-freed memory in case of
errors after memory allocation.

backtrace:
  [<ffffffff84245b62>] kmalloc include/linux/slab.h:556 [inline]
  [<ffffffff84245b62>] kzalloc include/linux/slab.h:686 [inline]
  [<ffffffff84245b62>] smsc75xx_bind+0x7a/0x334 drivers/net/usb/smsc75xx.c:1460
  [<ffffffff82b5b2e6>] usbnet_probe+0x3b6/0xc30 drivers/net/usb/usbnet.c:1728

Fixes: d0cad871703b ("smsc75xx: SMSC LAN75xx USB gigabit ethernet adapter driver")
Cc: stable@kernel.vger.org
Reported-and-tested-by: syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/usb/smsc75xx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index f8cdabb9ef5a..b286993da67c 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1483,7 +1483,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
 		netdev_warn(dev->net, "device not ready in smsc75xx_bind\n");
-		return ret;
+		goto err;
 	}
 
 	smsc75xx_init_mac_address(dev);
@@ -1492,7 +1492,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_reset(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "smsc75xx_reset error %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	dev->net->netdev_ops = &smsc75xx_netdev_ops;
@@ -1502,6 +1502,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
 	dev->net->max_mtu = MAX_SINGLE_PACKET_SIZE;
 	return 0;
+
+err:
+	kfree(pdata);
+	return ret;
 }
 
 static void smsc75xx_unbind(struct usbnet *dev, struct usb_interface *intf)
-- 
2.31.1

