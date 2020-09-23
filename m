Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49802753F7
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIWJG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIWJGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:06:25 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924E5C0613CE;
        Wed, 23 Sep 2020 02:06:25 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o20so14635135pfp.11;
        Wed, 23 Sep 2020 02:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9wqyDxCNM1ZmfXa7nbXb7Mn0Y5gUAzSUKtchYYWUpJU=;
        b=dISF/+v1MKuq0CK2motDdh3V2whOwEUQ0JQa9nsULg7BgNFuOPOPMev3ItuaoT6cyr
         18ahUyW73hY7lapUSnFqh6NOYsMuKbkZD1MdUOHCa4uRofa/fH1CtoQC9tQlZnonvfOB
         WcBRQK4uSS/5hj76YHa03/UiGig/VrVOWFXlj7MJnml8TzkSF2qbgcPvjxUzV/qCNKir
         fmTucJV/ocmQkG3ZzjFmjP0T/a+Aku9HRlPiw4hlDRRsRBAlDAw11KPIe9nApFpl4dZu
         H1Z+EdbICMo9FNe70JlKq0iq4g8PFVFSBugHYGWewVMvTTK8lGYxnQXQ18H6K4gARDWK
         u/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9wqyDxCNM1ZmfXa7nbXb7Mn0Y5gUAzSUKtchYYWUpJU=;
        b=MGiv8ZdsbcQ1MMDmxFlAiejE1Y0NZJIM6iHW99S8UdL5jWNeaMf9GlnlAGLbCmjXXF
         Balrf+FnNOcO3ez9MXi9YT7gdIHb49NijDLNQon557z6JZVOefJQZBp4x+/7FkO/ZBpT
         JLJeGHAw6V6umkKVPbFfVirNXFzf44DWWv30JhmMy9JJvuJw0gA1rZGHVJBqln1DnyOC
         1n5Y9unnjBAblsEZjReW38orE5LWfk7OXrzipGDVin+SueRBLcvcBUOuhOIN6obcjt3P
         aCmjJIvQvsko+9hQlKFOwCTIm2/ucR869iim3FeOFyHsYObt4kREw2MExFJZ3hEuZKIp
         hUyw==
X-Gm-Message-State: AOAM531UXXvA7c9/ZiOlufKtY34tVO/8MfNAQFmyzwEk83wJSUo93pzh
        edIvz5bs9m9ODa4Aj4oNp8laEfHw7X1Dfw==
X-Google-Smtp-Source: ABdhPJxaQQZDbcNj1V/nmPJgyNv/1vOPTcJ94kyuQKAHILMIKBY+cdozA5yX3z9UKcfNL8ZFpPuX2Q==
X-Received: by 2002:a63:a548:: with SMTP id r8mr6914557pgu.256.1600851985200;
        Wed, 23 Sep 2020 02:06:25 -0700 (PDT)
Received: from localhost.localdomain ([2405:205:c8e3:4b96:985a:95b9:e0cd:1d5e])
        by smtp.gmail.com with ESMTPSA id a13sm16496226pgq.41.2020.09.23.02.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 02:06:24 -0700 (PDT)
From:   Himadri Pandya <himadrispandya@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, oneukum@suse.com,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        yuehaibing@huawei.com, petkan@nucleusys.com, ogiannou@gmail.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org,
        Himadri Pandya <himadrispandya@gmail.com>
Subject: [PATCH 1/4] net: usbnet: use usb_control_msg_recv() and usb_control_msg_send()
Date:   Wed, 23 Sep 2020 14:35:16 +0530
Message-Id: <20200923090519.361-2-himadrispandya@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923090519.361-1-himadrispandya@gmail.com>
References: <20200923090519.361-1-himadrispandya@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Potential incorrect use of usb_control_msg() has resulted in new wrapper
functions to enforce its correct usage with proper error check. Hence
use these new wrapper functions instead of calling usb_control_msg()
directly.

Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
---
 drivers/net/usb/usbnet.c | 46 ++++------------------------------------
 1 file changed, 4 insertions(+), 42 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 2b2a841cd938..a38a85bef46a 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1982,64 +1982,26 @@ EXPORT_SYMBOL(usbnet_link_change);
 static int __usbnet_read_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 			     u16 value, u16 index, void *data, u16 size)
 {
-	void *buf = NULL;
-	int err = -ENOMEM;
-
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
+	return usb_control_msg_recv(dev->udev, 0,
+			      cmd, reqtype, value, index, data, size,
 			      USB_CTRL_GET_TIMEOUT);
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
+	return usb_control_msg_send(dev->udev, 0,
+			      cmd, reqtype, value, index, data, size,
 			      USB_CTRL_SET_TIMEOUT);
-	kfree(buf);
-
-out:
-	return err;
 }
 
 /*
-- 
2.17.1

