Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F334427FA54
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbgJAHdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgJAHdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:33:22 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3E0C0613D0;
        Thu,  1 Oct 2020 00:33:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k8so3703531pfk.2;
        Thu, 01 Oct 2020 00:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MMQaSvH0Kx6bA3nvjTwxRxny7XPXqNvhRkFHeW4802Q=;
        b=D72DiC0Y4x01OSsq8PYVmh2eyPP1awTN2KmJxwDa2llYQkx4PYUuNyQN/dmE6ZDm2P
         NbUUEkSI0e/8ZqqVSO2NmXqzvDVFTO5Sf8Ylmd/SqzLrhK7fx6Pp+5msfOi8tH+43zxS
         yX7dALP9mpNFLvpC++q6WplnJaKkvI2e/vu/Kpvi+U+5no6MKrwTcsZjP7wq+mt0pQae
         1WZ3AHCJrH8Bn9KokXVZd3139UU9OZYe6z3NnnfEMN7/71YgzjgKqMM3F8ErL8Af/WxG
         HCVr0MOemfFzIx3ZjE/PX5wk5UuxEpPlsPjBTwCmDL6o/R5a7FOHlzF4gLBVlPQi67HM
         9DDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MMQaSvH0Kx6bA3nvjTwxRxny7XPXqNvhRkFHeW4802Q=;
        b=FsetFPlwztg5Y+ZdW8AzDsPdVzjwUy9DnRrE5IEOEiMjzX+SXNXbWNpEHRH81JXJlv
         MDfxD0tav2LrxU1bAuvBS3vbnUUuIp+Pc47RzSS3tVWKriY4p0Zohb948ASro4XdrG0E
         kb3dvD7Dct5mGOCqxYYpaWINRK7nRpix/OOPNgVni707Qr5ra1vPFUp1GBb5w4/6mM/i
         LVpAjQYX7fndWT7T0ev454V7IWSzOndr8USfjjNGwOdvl7YfiC83gfLJFZMEjvWz4kgh
         m2wnu6Anzw2WoC2VgfAwOGbPpbj0bHo7lBz0x7qQtDkN/tkzUE/BV2YxE0HbgJkes6E1
         R/pQ==
X-Gm-Message-State: AOAM533qhgSPwk4KsGP8NVWXl4ecRem7Ok4GUgyS5NHAk3m3HsC+1gTn
        On7cm/ghIGUwLxXq8Oy1WZ0=
X-Google-Smtp-Source: ABdhPJwuU76xzp1pRklPBcovrJe7OwB7CKUmZLAEVCOio2OiSt94fQu2tR4KKcbO4pQVITEWWqgagQ==
X-Received: by 2002:a63:e1a:: with SMTP id d26mr5191223pgl.190.1601537599777;
        Thu, 01 Oct 2020 00:33:19 -0700 (PDT)
Received: from localhost.localdomain ([49.207.212.76])
        by smtp.gmail.com with ESMTPSA id u14sm5058589pfm.80.2020.10.01.00.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 00:33:18 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees][PATCH v2] net: usb: rtl8150: prevent set_ethernet_addr from setting uninit address
Date:   Thu,  1 Oct 2020 13:02:20 +0530
Message-Id: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When get_registers() fails (which happens when usb_control_msg() fails)
in set_ethernet_addr(), the uninitialized value of node_id gets copied
as the address.

Checking for the return values appropriately, and handling the case
wherein set_ethernet_addr() fails like this, helps in avoiding the
mac address being incorrectly set in this manner.

Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Acked-by: Petko Manolov <petkan@nucleusys.com>
---
Changes in v2:
	* Modified condition checking get_registers()'s return value to 
		ret == sizeof(node_id)
	  for stricter checking in compliance with the new usb_control_msg_recv()
	  API
	* Added Acked-by: Petko Manolov

Since Petko didn't explicitly mention an email-id in his Ack, I put the
email-id present in the MAINTAINERS file. I hope that's not an issue.


 drivers/net/usb/rtl8150.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 733f120c852b..e542a9ab2ff8 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -150,7 +150,7 @@ static const char driver_name [] = "rtl8150";
 **	device related part of the code
 **
 */
-static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
+static int get_registers(rtl8150_t *dev, u16 indx, u16 size, void *data)
 {
 	void *buf;
 	int ret;
@@ -274,12 +274,17 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
 		return 1;
 }
 
-static inline void set_ethernet_addr(rtl8150_t * dev)
+static bool set_ethernet_addr(rtl8150_t *dev)
 {
 	u8 node_id[6];
+	int ret;
 
-	get_registers(dev, IDR, sizeof(node_id), node_id);
-	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
+	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
+	if (ret == sizeof(node_id)) {
+		memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
+		return true;
+	}
+	return false;
 }
 
 static int rtl8150_set_mac_address(struct net_device *netdev, void *p)
@@ -909,21 +914,24 @@ static int rtl8150_probe(struct usb_interface *intf,
 		goto out1;
 	}
 	fill_skb_pool(dev);
-	set_ethernet_addr(dev);
-
+	if (!set_ethernet_addr(dev)) {
+		dev_err(&intf->dev, "couldn't set the ethernet address for the device\n");
+		goto out2;
+	}
 	usb_set_intfdata(intf, dev);
 	SET_NETDEV_DEV(netdev, &intf->dev);
 	if (register_netdev(netdev) != 0) {
 		dev_err(&intf->dev, "couldn't register the device\n");
-		goto out2;
+		goto out3;
 	}
 
 	dev_info(&intf->dev, "%s: rtl8150 is detected\n", netdev->name);
 
 	return 0;
 
-out2:
+out3:
 	usb_set_intfdata(intf, NULL);
+out2:
 	free_skb_pool(dev);
 out1:
 	free_all_urbs(dev);
-- 
2.25.1

