Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4232829ECC9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgJ2NXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgJ2NXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:23:37 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA67C0613D2;
        Thu, 29 Oct 2020 06:23:36 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t22so1276081plr.9;
        Thu, 29 Oct 2020 06:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GXWZRuxu4VR36pF/cjVXXRZb5YESqKLE2k0JDNWMpBU=;
        b=Ba+fdg0/mxmgFjx3BLhYuwhBgDs7yEH1xttYt57NG88+f0TEcVpfvrejTKwXT6T9Jv
         zd+bPE4ayZFtQJ7MoOoMci+vPQs/fDnVQH9S+u2G0VNACi+uUEOdXhga+LZF8Wm7rBhP
         LM2/qFbrQ3anWMpqrW3f4TjSyECdwmt4D7T4zqGuoa/9MNQ6hDJZap2lMFf2PZeZvSaR
         O9Lg8fF1fV01q7Loptb/jRBtEk8XS+YDdjeeVgGOsWWEdHY1WnKTT1nBVYU2zczf9EKB
         UjFya2ka4Pp1fMueAV1fJQq2xy3acTYSNR7dmiYoXPsbgEAClxUBfpMMtvbQ+UA7gr5/
         B7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GXWZRuxu4VR36pF/cjVXXRZb5YESqKLE2k0JDNWMpBU=;
        b=bTtIicXMv1Vtr1CcAOd5GTDDjNqw+wPxc8CWEwggxBej+Li3B/yjsjHmFvj/6J6yYk
         AfOsNxNbiTT9lwi6Yy7aCw4NksImEFPWbIR5YWR9T7odOo+IET0Sb6fVivaaUF1t1Y5h
         zWA6Cxoo370jjqo/nDCGR4TPARsrUqjnhiLqUbN81oGYYfRZZ6qfL8E6C9I3Ii/mZBRm
         cFR2nvC7+VilzxhoOfhvDAb3RHmsrtUpy1Jf3pW8afeOfcA1a6gqUhpJpXXA3Wzvb/4G
         DOaXyslbeDG484Z4jPPpuOf128aHKGwtX3p/t60b+jNRC5pSJUyt3Huj6wJJQunnPi1I
         4nQw==
X-Gm-Message-State: AOAM533IGmlrWSyDVcIYycs5uW1rKNPc02VjWudgyOAhDXrIEYCeP868
        LU44s0oTnxjQl0RoNaS6sFo3dvIpqZfTnL3v6NA=
X-Google-Smtp-Source: ABdhPJwOTAUNTtIHl2nJJxRVPqBOxgwW3ox58eG5wvfAmz1vNeMZX5wHcOnEQ6xyE0OJ2VNHkuFomQ==
X-Received: by 2002:a17:902:690b:b029:d6:41d8:bdc7 with SMTP id j11-20020a170902690bb02900d641d8bdc7mr3918041plk.7.1603977816207;
        Thu, 29 Oct 2020 06:23:36 -0700 (PDT)
Received: from localhost.localdomain ([49.207.222.191])
        by smtp.gmail.com with ESMTPSA id i1sm2795872pfa.168.2020.10.29.06.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 06:23:35 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: [PATCH v2] net: usb: usbnet: update __usbnet_{read|write}_cmd() to use new API
Date:   Thu, 29 Oct 2020 18:52:56 +0530
Message-Id: <20201029132256.11793-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201010065623.10189-1-anant.thazhemadam@gmail.com>
References: <20201010065623.10189-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, __usbnet_{read|write}_cmd() use usb_control_msg(),
and thus consider potential partial reads/writes being done to 
be perfectly valid.
Quite a few callers of usbnet_{read|write}_cmd() don't enforce
checking for partial reads/writes into account either, automatically
assuming that a complete read/write occurs.

However, the new usb_control_msg_{send|recv}() APIs don't allow partial
reads and writes.
Using the new APIs also relaxes the return value checking that must
be done after usbnet_{read|write}_cmd() is called.

Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
Changes in v2:
	* Fix build error

This patch has been compile and build tested with a .config file that
was generated using make allyesconfig, and the build error has been 
fixed.
Unfortunately, I wasn't able to get my hands on a usbnet adapter for testing,
and would appreciate it if someone could do that.

 drivers/net/usb/usbnet.c | 52 ++++++++--------------------------------
 1 file changed, 10 insertions(+), 42 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index bf6c58240bd4..2f7c7b7f4047 100644
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
+			      cmd, reqtype, value, index, data, size,
+			      USB_CTRL_GET_TIMEOUT, GFP_KERNEL);
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
+			cmd, reqtype, value, index, data, size,
+			USB_CTRL_SET_TIMEOUT, GFP_KERNEL);
 }
 
 /*
-- 
2.25.1

