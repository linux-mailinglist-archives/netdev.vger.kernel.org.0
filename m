Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7B52A1AC7
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 22:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgJaVfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 17:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJaVfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 17:35:41 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144C6C0617A6;
        Sat, 31 Oct 2020 14:35:41 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p17so4739892pli.13;
        Sat, 31 Oct 2020 14:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wfCT45RfkJARqEdgNwcfbDfcbSKvbfRG89bIaFDMst0=;
        b=JSFxhC8embsdBlmRAd/0qfuxccXL+iaUC6GWCe1N4R/3m9+Ut4QX19B5yud2sBMovS
         CXKiz52hK30PKf7pjqduUDpiqRGkGPg9scwlsn+EsuWqq8UR0GIbMc5tTwZ7eil50Rde
         n4ygmICjE6YSPa2l+M7x/dzxM7AsAjZc2lgBXtFt3xdBFBEXkTD4U7VCy+io8g4g0gOl
         Rssycrx4EvS6454W6yzK7MKFZtLd3VO0jwx80xCWNbO58Om16SjzwArW62UrpL61X8Lh
         upjFesRYL/1S1bz8ejZSz4bjK4bqreu2ZM0Hts0GgsOXO9ivdS0X/0USVzSpGrcDBAqE
         1+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wfCT45RfkJARqEdgNwcfbDfcbSKvbfRG89bIaFDMst0=;
        b=bwSD4rvfpVjMmLBHiOEA1tjfzjsVtLV6QbFSSEbznAE7/CNxIanobQQBLoXUZEI2G0
         fzaNpwBorMQFwvGgzVRzfObfWHvHOnZMMoYRXC/XflbZ1ZnUtz3WXGQJUpHrJDV3rdq8
         3UsjejtxxdS0OtWP8bEJpphnSQyra+cfEffRu2vBoArHTb4luImB2j2Zws6ysAgut8Cd
         halPszOAbZmXPXftx9Vh0JUGjELcgb6qmPxYE44CHxflkBNKtDzUlI5cNkuHpNVpqTBr
         mVTa7SquaaI18zB4CoB6K1KE1n1rmPPULaFf2vB6yZfBef0iii79jzIoIrONxXRmDvP0
         ORNw==
X-Gm-Message-State: AOAM533O6G3ghFqyq0QDN4XhmHmn7/0OMd7E4BNvm1gdWyDLkboMK1s+
        nyBA+ONr6Z/0DQ5FyLAFCkQ=
X-Google-Smtp-Source: ABdhPJzIlWkoN797x3ywygdN18Gump/LE3OvdSCnv0RMA1pQVAkHpY20FVxifomV5tADNP1kB3rwmw==
X-Received: by 2002:a17:90b:180d:: with SMTP id lw13mr155056pjb.149.1604180140454;
        Sat, 31 Oct 2020 14:35:40 -0700 (PDT)
Received: from localhost.localdomain ([49.207.221.93])
        by smtp.gmail.com with ESMTPSA id l123sm104958pfd.97.2020.10.31.14.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 14:35:39 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: [PATCH v3] net: usb: usbnet: update __usbnet_{read|write}_cmd() to use new API
Date:   Sun,  1 Nov 2020 03:05:33 +0530
Message-Id: <20201031213533.40829-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201029132256.11793-1-anant.thazhemadam@gmail.com>
References: <20201029132256.11793-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, __usbnet_{read|write}_cmd() use usb_control_msg().
However, this could lead to potential partial reads/writes being
considered valid, and since most of the callers of
usbnet_{read|write}_cmd() don't take partial reads/writes into account
(only checking for negative error number is done), and this can lead to
issues.

However, the new usb_control_msg_{send|recv}() APIs don't allow partial
reads and writes.
Using the new APIs also relaxes the return value checking that must
be done after usbnet_{read|write}_cmd() is called.

Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
Changes in v3:
	* Aligned continuation lines after the opening brackets
Changes in v2:
	* Fix build error

 drivers/net/usb/usbnet.c | 52 ++++++++--------------------------------
 1 file changed, 10 insertions(+), 42 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index bf6c58240bd4..b2df3417a41c 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1982,64 +1982,32 @@ EXPORT_SYMBOL(usbnet_link_change);
 static int __usbnet_read_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 			     u16 value, u16 index, void *data, u16 size)
 {
-	void *buf = NULL;
-	int err = -ENOMEM;
 
 	netdev_dbg(dev->net, "usbnet_read_cmd cmd=0x%02x reqtype=%02x"
 		   " value=0x%04x index=0x%04x size=%d\n",
 		   cmd, reqtype, value, index, size);
 
-	if (size) {
-		buf = kmalloc(size, GFP_KERNEL);
-		if (!buf)
-			goto out;
-	}
-
-	err = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
-			      cmd, reqtype, value, index, buf, size,
-			      USB_CTRL_GET_TIMEOUT);
-	if (err > 0 && err <= size) {
-        if (data)
-            memcpy(data, buf, err);
-        else
-            netdev_dbg(dev->net,
-                "Huh? Data requested but thrown away.\n");
-    }
-	kfree(buf);
-out:
-	return err;
+	return usb_control_msg_recv(dev->udev, 0,
+				    cmd, reqtype, value, index, data, size,
+				    USB_CTRL_GET_TIMEOUT, GFP_KERNEL);
 }
 
 static int __usbnet_write_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 			      u16 value, u16 index, const void *data,
 			      u16 size)
 {
-	void *buf = NULL;
-	int err = -ENOMEM;
-
 	netdev_dbg(dev->net, "usbnet_write_cmd cmd=0x%02x reqtype=%02x"
 		   " value=0x%04x index=0x%04x size=%d\n",
 		   cmd, reqtype, value, index, size);
 
-	if (data) {
-		buf = kmemdup(data, size, GFP_KERNEL);
-		if (!buf)
-			goto out;
-	} else {
-        if (size) {
-            WARN_ON_ONCE(1);
-            err = -EINVAL;
-            goto out;
-        }
-    }
-
-	err = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
-			      cmd, reqtype, value, index, buf, size,
-			      USB_CTRL_SET_TIMEOUT);
-	kfree(buf);
+	if (size && !data) {
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
 
-out:
-	return err;
+	return usb_control_msg_send(dev->udev, 0,
+				    cmd, reqtype, value, index, data, size,
+				    USB_CTRL_SET_TIMEOUT, GFP_KERNEL);
 }
 
 /*
-- 
2.25.1

