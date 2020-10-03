Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67DE2826BF
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 23:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgJCVUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 17:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgJCVUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 17:20:15 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F44DC0613D0;
        Sat,  3 Oct 2020 14:20:15 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kk9so3031551pjb.2;
        Sat, 03 Oct 2020 14:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=snQrsKK9wGUFakYFc3REQ5zRMVVl45uxLHEVZUf1zPE=;
        b=uW8S+Fcu7cIrW1qdaLgGVCTcAXyZtwcLuuFHOuASPkpEY5tMlqyE2xZEsr+U7O7jnU
         /oPYqWZ019qoXJ2N8XTHDr2274AVt/GhmPhdV7pPp07oYF2PRtQlignkwNwcUvY/pWI8
         7QOdpol5oWv2i/+dIP77XbIiuWVLwPYfpI8fzoPiuscI2GXfNIyuYgpfbs6xG/ThizmK
         wonsMN9Bdc4ZanBrm0TLxpQe8RMyMGb4FOc2s2PrhmGqYUsE7pDlRPIOIFCF3QvEeMEh
         rojF6mDqPIpfDhdfk7OtAC6hct9CwhFiy8EGAR8m+p2/9LiU6Q9aAXapS8JQWHbA7SoO
         OJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=snQrsKK9wGUFakYFc3REQ5zRMVVl45uxLHEVZUf1zPE=;
        b=TLfUFKv4majQaAxxd+Mz5WdJh4sipRi1Tftr5TlauH3BIrIxM6Eh6J9hS6vvAIt/5p
         L9smz3O+PKfMxaioNc1qtKSlAKPAoJZI/j+SUg5iPJsgG5e9mqqxWpTGABZA/u7/RPE+
         xILs25/LqHCBces/zA0Y/uZ4I273qbRd/4w7KlHEGNVcMABtrp96lIUCC6AC3ILqfo9w
         skSXedPLIkp+mUg+id+q25Jo+skkkffJ1JlwHUMz7wb90IlHP93fulCp35Nnqeju2fRe
         OX3NoWtOiyKRGblt4mGEv3Zu62CWkCHw1vyCc3W/jjrvrrM28bABARNQEOAuMxcxuZQD
         jftg==
X-Gm-Message-State: AOAM532S+l96T9OOMe8EWINls9GOMICeNwC1M4nzMT40YhY1urLzwfa9
        9JzgUoPVRtrIX/XBWhD5IGU=
X-Google-Smtp-Source: ABdhPJxu6wgoODYD1L249tBKjrit5dqjZ8vAWqt9NDnX4FUgsb5CwVv9+fEdutwq+r/QCMsLlyhyJQ==
X-Received: by 2002:a17:90a:128d:: with SMTP id g13mr9016097pja.35.1601760014082;
        Sat, 03 Oct 2020 14:20:14 -0700 (PDT)
Received: from localhost.localdomain ([49.207.217.69])
        by smtp.gmail.com with ESMTPSA id u8sm2406380pfk.79.2020.10.03.14.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 14:20:13 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org, joe@perches.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails
Date:   Sun,  4 Oct 2020 02:49:31 +0530
Message-Id: <20201003211931.11544-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When get_registers() fails, in set_ethernet_addr(),the uninitialized
value of node_id gets copied as the address. This can be considered as
set_ethernet_addr() itself failing.

The return type of set_ethernet_addr() is modified to indicate if it
failed or not, and return values are appropriately checked by caller.

When set_ethernet_addr() fails, a randomly generated MAC address is set
as the MAC address instead.

On the other hand, for the case when get_registers() does succeed,
set_ethernet_addr() has been updated to use ether_addr_copy() to copy
the address, instead of memcpy().

Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Acked-by: Petko Manolov <petkan@nucleusys.com>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
Changes in v3:

	* Set a random MAC address to the device rather than making
	  the device not work at all in the even set_ethernet_addr()
	  fails. (Suggested by David Miller <davem@davemloft.net>)

	* Update set_ethernet_addr() to use ether_addr_copy() to copy 
	  the MAC Address (instead of using memcpy() for that same).
	  (Suggested by Joe Perches <joe@perches.com>)


Changes in v2:

	* Modified condition checking get_registers()'s return value to 
		ret == sizeof(node_id)
	  for stricter checking in compliance with the new usb_control_msg_recv()
	  API

	* Added Acked-by: Petko Manolov

 drivers/net/usb/rtl8150.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 733f120c852b..bbd49ebdf095 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -274,12 +274,17 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
 		return 1;
 }
 
-static inline void set_ethernet_addr(rtl8150_t * dev)
+static bool set_ethernet_addr(rtl8150_t *dev)
 {
-	u8 node_id[6];
+	u8 node_id[ETH_ALEN];
+	int ret;
 
-	get_registers(dev, IDR, sizeof(node_id), node_id);
-	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
+	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
+	if (ret == sizeof(node_id)) {
+		ether_addr_copy(dev->netdev->dev_addr, node_id);
+		return true;
+	}
+	return false;
 }
 
 static int rtl8150_set_mac_address(struct net_device *netdev, void *p)
@@ -909,7 +914,10 @@ static int rtl8150_probe(struct usb_interface *intf,
 		goto out1;
 	}
 	fill_skb_pool(dev);
-	set_ethernet_addr(dev);
+	if (!set_ethernet_addr(dev)) {
+		dev_err(&intf->dev, "assigining a random MAC address\n");
+		eth_hw_addr_random(dev->netdev);
+	}
 
 	usb_set_intfdata(intf, dev);
 	SET_NETDEV_DEV(netdev, &intf->dev);
-- 
2.25.1

