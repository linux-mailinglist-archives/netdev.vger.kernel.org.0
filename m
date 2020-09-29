Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFC827BF28
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgI2IVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgI2IVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:21:14 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8595C061755;
        Tue, 29 Sep 2020 01:21:14 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d6so3768021pfn.9;
        Tue, 29 Sep 2020 01:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2IG2LUHqbbcHboNgwqS1w0pMbuO40GaU7Cwhtd/F7+A=;
        b=t5XTKkDj9sdkpQ8SO5mAnE6QPYPgPaXdVXF3frmYCydG4TCOwlyppJl5k694T60cOl
         n4uKdFeZFmDZyreOOd0rLorkaBkJixrJtiGaz2fsRtszrdL7NnitD9jpDLGr+G6HsgRF
         dmDGL5+IZH/D5PyMq2//BPGtvJfKEfaU1KU/hMsGzGil4AUBeXjrJMHwjjEnPNwjogSk
         rWVP6dpXvpzJ7hJ055I4m+gaAT0wCzget4UASB9nm2bP68cN5Ygkz7MoUBXSrIN08SXg
         J32SoRqMv/NK8aoBwZn+FOQUj3ubWAdPh94W9Vvs/0eEmXk+MaV5ayqVPHYkDfwd+zkm
         aSiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2IG2LUHqbbcHboNgwqS1w0pMbuO40GaU7Cwhtd/F7+A=;
        b=EpwnX57ljci8fbG+2ThUCR3hLFAdEaf/LFgCU+AwKFxxz4UGRrjdCLIXVbnqS4iEs2
         AGCXpCKz/cXxeBbii9+Jfoay08bo3Rmna5cRN2kxP51cEM1uL8/3vTeJJ7fNvoKIPxPU
         wKlQai5K4X8tuzwRvgQlV/NkriMoqpfzlWKR8vFI9a25QkEg8q6glFop5l0lC3Gyapk5
         kGf4WEDS3Z+G01jGcnjvPbK82UkK+u7tsPnQ0WPR4XWwk5DZ1zyZMVfoeporVfG3AL6t
         OEmcRKccKluMUWWLFYt3X2LOQPfcKvyKOxJk1Vb1RTJaumDXdc8rg5nTZMIOxStkDRmf
         Iuqg==
X-Gm-Message-State: AOAM531kkPPFrN0FKr9cnOR0FpYE4ElA+k97BbBKYj4ySyDiCtFN3iRl
        lRKy2eZFErSJPblZ/XywsRcA5o/4MDN+Xt2/4fk=
X-Google-Smtp-Source: ABdhPJymBuqDQprFF3XXwMA343nL48tGqWCZXcN3Uj49AeWf99JOtrfiyk/h92hAMNaNOlaRgi+HSg==
X-Received: by 2002:a63:d245:: with SMTP id t5mr2258997pgi.283.1601367674255;
        Tue, 29 Sep 2020 01:21:14 -0700 (PDT)
Received: from localhost.localdomain ([49.207.218.220])
        by smtp.gmail.com with ESMTPSA id a18sm3704592pgw.50.2020.09.29.01.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 01:21:13 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees][PATCH] net: usb: rtl8150: prevent set_ethernet_addr from setting uninit address
Date:   Tue, 29 Sep 2020 13:50:28 +0530
Message-Id: <20200929082028.50540-1-anant.thazhemadam@gmail.com>
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
---
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
+	if (ret > 0 && ret <= sizeof(node_id)) {
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

