Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197A3486D6D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 23:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245304AbiAFW5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 17:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245298AbiAFW5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 17:57:21 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FE2C061245;
        Thu,  6 Jan 2022 14:57:21 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id r4so9058547lfe.7;
        Thu, 06 Jan 2022 14:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UdCmD/UwBhEFtymZANYdsCS1w6l9z2rsk0A6CL2RM3E=;
        b=aqdheB2pKIGQ4KkGcSE4+g6S0fZ4EktwfN2VTJEyp6DUzBw9yZOZmnd8UbxCVtiPtk
         hAB4LISehLJxjtLVKNxKPhSmYMXTKMykI9EXsUygC+kRn3eGO8YVX8sr8G6zwPURvi9n
         /DioIGB+v+b02+h9B1Qmljb4WL/0rKA16AmwTH+Ks1lb2eqY/HXZt7H5u+pvhyYpwrrS
         QqJW8o2VC/2oQbh82+Lcf6501HL9n38bPcU7Qrq4w+DOCEjHKiQMs8x5dOwIv+fm2pct
         LWCyuinrBR0TGBpdvD/4F0a6EiG5t8XexA/3FiJ7qmlh3hF36mT87iaqg8POhT80S7lx
         OhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UdCmD/UwBhEFtymZANYdsCS1w6l9z2rsk0A6CL2RM3E=;
        b=isyYoU6ZWTbT6nIdg/AG3o2gLeYj9oUFRwqFZIDhoPo1cL0j5vKBTRr3ZG0QpkO4nf
         MgC2/n//c5XeJzAhcqe99ICopztmtYrJcHLArQcEeMHC4+Kd7ION01gi1Q7VrSaGgW5m
         fG+gOpoU9iRHj96kfGMOBbPdGBaldAeYeVZ/NpVQFc4Rdx606zN4WNI4IsTUEJRFTzR9
         PPq/Vz5bW52SvigG1GtiQolqJNoYCxdU4CiE/2SSBYcz95yGVuBtwFmqkAlAymS9Y5mZ
         f1RmgsyktY3TOs5POvf0plWZ3JPGn6nbaZTd9jH41QOKTZkjEPIcVjoHwd33Essp9MHZ
         tHaQ==
X-Gm-Message-State: AOAM532jghGDjclC34W2nvfwDaBN6t7eNpj3PUQ3TrvwOpcgio6JUpp2
        t/u9wurn8u6OwH9hBpnCvTipIyXuIys=
X-Google-Smtp-Source: ABdhPJyHg3VMu6zjZrbDbcsE+z4el31/Mwd/HgSt/iXNWaUe3KX3jn70A5NO1j+VfTl1w+00oQY4JQ==
X-Received: by 2002:a2e:5151:: with SMTP id b17mr49758832lje.213.1641509839256;
        Thu, 06 Jan 2022 14:57:19 -0800 (PST)
Received: from localhost.localdomain ([94.103.227.53])
        by smtp.gmail.com with ESMTPSA id g19sm331024lfr.269.2022.01.06.14.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 14:57:18 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, tanghui20@huawei.com,
        andrew@lunn.ch, oneukum@suse.com, arnd@arndb.de
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+003c0a286b9af5412510@syzkaller.appspotmail.com
Subject: [PATCH] net: mcs7830: handle usb read errors properly
Date:   Fri,  7 Jan 2022 01:57:16 +0300
Message-Id: <20220106225716.7425-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported uninit value in mcs7830_bind(). The problem was in
missing validation check for bytes read via usbnet_read_cmd().

usbnet_read_cmd() internally calls usb_control_msg(), that returns
number of bytes read. Code should validate that requested number of bytes
was actually read.

So, this patch adds missing size validation check inside
mcs7830_get_reg() to prevent uninit value bugs

CC: Arnd Bergmann <arnd@arndb.de>
Reported-and-tested-by: syzbot+003c0a286b9af5412510@syzkaller.appspotmail.com
Fixes: 2a36d7083438 ("USB: driver for mcs7830 (aka DeLOCK) USB ethernet adapter")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

@Arnd, I am not sure about mcs7830_get_rev() function. 

Is get_reg(22, 2) == 1 valid read? If so, I think, we should call
usbnet_read_cmd() directly here, since other callers care only about
negative error values.  

Thanks


---
 drivers/net/usb/mcs7830.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 326cc4e749d8..fdda0616704e 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -108,8 +108,16 @@ static const char driver_name[] = "MOSCHIP usb-ethernet driver";
 
 static int mcs7830_get_reg(struct usbnet *dev, u16 index, u16 size, void *data)
 {
-	return usbnet_read_cmd(dev, MCS7830_RD_BREQ, MCS7830_RD_BMREQ,
-				0x0000, index, data, size);
+	int ret;
+
+	ret = usbnet_read_cmd(dev, MCS7830_RD_BREQ, MCS7830_RD_BMREQ,
+			      0x0000, index, data, size);
+	if (ret < 0)
+		return ret;
+	else if (ret < size)
+		return -ENODATA;
+
+	return ret;
 }
 
 static int mcs7830_set_reg(struct usbnet *dev, u16 index, u16 size, const void *data)
-- 
2.34.1

