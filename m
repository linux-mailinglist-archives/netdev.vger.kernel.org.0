Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8A427A116
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 14:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgI0MtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 08:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgI0MtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 08:49:20 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A09CC0613D4
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 05:49:20 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id j2so7100400eds.9
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 05:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2lSGROVpoGDqKpQV7Vk31ZIPu0grmXKx5AXVK7t2aWA=;
        b=YSpL+toI4XwAP28Dttrl4q1k50ljTdnyLNBAwqDbE+imYCHhfDXj4o6jp33Yb8CxVU
         QSNRPOrNf3Wnk3CmXc3NmT187UW0E0fRQTRkc30lWPz6ZHTEbZx+aUeZByJcig66B9NE
         Uk28IerZkYoqLZBOt/tFpPJNTI48oSxgfP60U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2lSGROVpoGDqKpQV7Vk31ZIPu0grmXKx5AXVK7t2aWA=;
        b=mXQQX1MMuYhiYhVckerXpLa3XYhTaWix8K5kcSEW2EoB2v3qEhmCN3cKfV/vw3ZKxj
         gv5fDutCtn/UOs9xZAlSjCCE3EIZWMk7XJlhFVDibtmmMreiAbwmgkkwV0CItY8Pb2vb
         fhcpoCcO/ZOY5XUqSughH94L2dkaJ0sOTDZgvJYt3SGF6G2Le5/Mo7i8nm49bfo0Z11+
         yd4Hh0S6WCTdTQsLRP8lA5YWYhY48hf8j6HhMlnriaxSwVWWo4CxgrBqyFqv/lxaF5tM
         JzsUL7f/C2v+TDu1UASXQc+UONp4hqT9nZLYe27Bsicxjj0ADaD3gJFeMz4qYN2Qyvkh
         +KgQ==
X-Gm-Message-State: AOAM531UymZwdk4JKavfbketgD6XFxPayfuI0Wq3JaMIs4c0A0SCU55L
        Vty0uXMIShqo3ROrwHd3eU7O/g==
X-Google-Smtp-Source: ABdhPJyxSaPGOBqQxH+Y/pTxrZfw1o2rmXjFy/PmXOqAuZT/2U3pYMsQlhZMvCMaW6Wxka5ynvPZ8Q==
X-Received: by 2002:a05:6402:50f:: with SMTP id m15mr11280382edv.41.1601210958742;
        Sun, 27 Sep 2020 05:49:18 -0700 (PDT)
Received: from taos.konsulko.bg (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id r16sm7234275edc.57.2020.09.27.05.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 05:49:18 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     gregKH@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Petko Manolov <petko.manolov@konsulko.com>
Subject: [PATCH RESEND v3 2/2] net: rtl8150: Use the new usb control message API.
Date:   Sun, 27 Sep 2020 15:49:09 +0300
Message-Id: <20200927124909.16380-3-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200927124909.16380-1-petko.manolov@konsulko.com>
References: <20200923134348.23862-9-oneukum@suse.com>
 <20200927124909.16380-1-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old usb_control_msg() let the caller handle the error and also did not
account for partial reads.  Since these are now considered harmful, move the
driver over to usb_control_msg_recv/send() calls.

Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
---
 drivers/net/usb/rtl8150.c | 32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 733f120c852b..b3a0b188b1a1 100644
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
+				    RTL8150_REQT_READ, indx, 0, data, size,
+				    1000, GFP_NOIO);
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
+				    RTL8150_REQT_WRITE, indx, 0, data, size,
+				    1000, GFP_NOIO);
 }
 
 static void async_set_reg_cb(struct urb *urb)
-- 
2.28.0

