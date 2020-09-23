Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1A72753FD
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgIWJGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIWJGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:06:45 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FF9C0613CE;
        Wed, 23 Sep 2020 02:06:45 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kk9so2835589pjb.2;
        Wed, 23 Sep 2020 02:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ohqofdSobCRCHUofKcLY6g/yoMPZMTZlQOhkO7ROpIc=;
        b=t45qHV5xy9oCsiCxleGrHt9GVIvdSr7r/29ELFE6fyyIECqNBASF2IXz4aPPAoDY5K
         K+p3/cSNcE6Ww4N/oMMXunz5zmcBJMYvhX/qM1RMr2x7AM0HOHFNMj6azREPcp43F/Kl
         pPprwzv1qQWoDeBNz/Ul9ZzeDRQqzuxtTU8eBsB9AS6CPCyLQKdL0aaPV5QsFpBbCTgR
         2hd1YWTeOo9lOaUcdgo6KfzXKCRR5QtNacpdldsFCbU7dBdboewwGqo/oAwfQYc5Z4kf
         n8IQkOXkhXrANnzYIxbN4jp9x+At41CD7vWYCO/UfSr2d5SENYvOM8tyJsvivjPTn4+z
         o0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ohqofdSobCRCHUofKcLY6g/yoMPZMTZlQOhkO7ROpIc=;
        b=rij+feCqg/x60OoaE/MsMoUYNlD6RoPyWyH29orsxZzDc0ThFX6H/drsGIuZzKTXsF
         3bFdHSYjndHOAdSHyF/M/W+7xMq9byte1XqHNhv0IriRxchJcCAxBqeyKfARLdbELKR+
         R66RY0Y+c7ZPaPpTLejv2yRE3VdL/+JfKAWnMAUyu56N+XqbAQlAtAFe9Z/TH4bTHOvn
         tjjt+J2aWhrzfHn4cHdxwpcSquhIHA1XUOKeci0fbUMPP7gB50jObE3X7HaatmvyvLu/
         ZR6RvWzsD+6DuMFHuuJr2/gz3YewWy6dzS39VMcGXEfdgUQVaeFN7T+LNNtoQ4t+LlxO
         fl6w==
X-Gm-Message-State: AOAM532mgoiJtgGiSZdL79uskfsuoVFWDiaGPfbov8NZ1nOatRGnpnKm
        3nkSk+/p0JXE4luQLu/+UZE=
X-Google-Smtp-Source: ABdhPJxWZjsJJUAi8SjYqaGIPZnjo6hVFfFI7ws+vWAwRi4JJbhwh0TRZ8zwgoZCawVZ511ar062WA==
X-Received: by 2002:a17:90a:9f09:: with SMTP id n9mr7403612pjp.88.1600852004228;
        Wed, 23 Sep 2020 02:06:44 -0700 (PDT)
Received: from localhost.localdomain ([2405:205:c8e3:4b96:985a:95b9:e0cd:1d5e])
        by smtp.gmail.com with ESMTPSA id a13sm16496226pgq.41.2020.09.23.02.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 02:06:43 -0700 (PDT)
From:   Himadri Pandya <himadrispandya@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, oneukum@suse.com,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        yuehaibing@huawei.com, petkan@nucleusys.com, ogiannou@gmail.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org,
        Himadri Pandya <himadrispandya@gmail.com>
Subject: [PATCH 3/4] net: usb: rtl8150: use usb_control_msg_recv() and usb_control_msg_send()
Date:   Wed, 23 Sep 2020 14:35:18 +0530
Message-Id: <20200923090519.361-4-himadrispandya@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923090519.361-1-himadrispandya@gmail.com>
References: <20200923090519.361-1-himadrispandya@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many usage of usb_control_msg() do not have proper error check on return
value leaving scope for bugs on short reads. New usb_control_msg_recv()
and usb_control_msg_send() nicely wraps usb_control_msg() with proper
error check. Hence use the wrappers instead of calling usb_control_msg()
directly.

Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
---
 drivers/net/usb/rtl8150.c | 32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 733f120c852b..e3002b675921 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -152,36 +152,16 @@ static const char driver_name [] = "rtl8150";
 */
 static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
 {
-	void *buf;
-	int ret;
-
-	buf = kmalloc(size, GFP_NOIO);
-	if (!buf)
-		return -ENOMEM;
-
-	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
-			      RTL8150_REQ_GET_REGS, RTL8150_REQT_READ,
-			      indx, 0, buf, size, 500);
-	if (ret > 0 && ret <= size)
-		memcpy(data, buf, ret);
-	kfree(buf);
-	return ret;
+	return usb_control_msg_recv(dev->udev, 0, RTL8150_REQ_GET_REGS,
+				    RTL8150_REQT_READ, indx, 0, data,
+				    size, 500);
 }
 
 static int set_registers(rtl8150_t * dev, u16 indx, u16 size, const void *data)
 {
-	void *buf;
-	int ret;
-
-	buf = kmemdup(data, size, GFP_NOIO);
-	if (!buf)
-		return -ENOMEM;
-
-	ret = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
-			      RTL8150_REQ_SET_REGS, RTL8150_REQT_WRITE,
-			      indx, 0, buf, size, 500);
-	kfree(buf);
-	return ret;
+	return usb_control_msg_send(dev->udev, 0, RTL8150_REQ_SET_REGS,
+				    RTL8150_REQT_WRITE, indx, 0, data,
+				    size, 500);
 }
 
 static void async_set_reg_cb(struct urb *urb)
-- 
2.17.1

