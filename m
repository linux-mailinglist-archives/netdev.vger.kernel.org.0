Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0738C8DD95
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 20:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfHNS4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 14:56:53 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:40245 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfHNS4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 14:56:52 -0400
Received: by mail-yw1-f66.google.com with SMTP id z64so844183ywe.7;
        Wed, 14 Aug 2019 11:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qThyM3uosTzdaiq3sOMT9s9AE6tgP51TOvbLYoMxBkY=;
        b=TbZv6Ye+WPWkIAB76pfDf7yBFn1yByBxmyo5pglaXHidIntg+uYoXbjD0JyYJe0Od+
         8LijEeQQs04Vr7oaxaBsknB9vSJLl/0hQkduUD+7/jwEZfes0hfhgfZGl6iCEgKK/rAc
         4Qqdo44SJNcbFMpVLJokU1n/Zms3KpD5L7uPVc+9EGXCoC4oGMbCs1wWF2JBdxeqEjvQ
         0CaDv2OZcyJ2ygkY0JWsDMocddmf66WVrpEsgRf8uedgZBheEUkt7V7od6KDgBCxwq5z
         2DdkLNyYRkr2MokF0Ppki1MEEXTnYGRNNl4nwblqOhsZdtulBsKyjgArgx9a6gfcHj7M
         3ybg==
X-Gm-Message-State: APjAAAWo/lN8WwMbCz0vggeK6VrT+Yh/EmGfQPbzR2Ja+vNXgQmRNl+p
        XFhpJm3PVjnWQFG6DeGVp/I=
X-Google-Smtp-Source: APXvYqy6iF4tzSFsfEjnjvIojvYZv6hAuiEgy4pi2UVVJ0ghBS6yudgAnVal845gs4IB/CyVH87R2Q==
X-Received: by 2002:a81:9b49:: with SMTP id s70mr511290ywg.51.1565809011860;
        Wed, 14 Aug 2019 11:56:51 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id c123sm155732ywf.25.2019.08.14.11.56.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 11:56:50 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-usb@vger.kernel.org (open list:USB NETWORKING DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: kalmia: fix memory leaks
Date:   Wed, 14 Aug 2019 13:56:43 -0500
Message-Id: <1565809005-8437-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In kalmia_init_and_get_ethernet_addr(), 'usb_buf' is allocated through
kmalloc(). In the following execution, if the 'status' returned by
kalmia_send_init_packet() is not 0, 'usb_buf' is not deallocated, leading
to memory leaks. To fix this issue, add the 'out' label to free 'usb_buf'.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/usb/kalmia.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
index d62b670..fc5895f 100644
--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -113,16 +113,16 @@ kalmia_init_and_get_ethernet_addr(struct usbnet *dev, u8 *ethernet_addr)
 	status = kalmia_send_init_packet(dev, usb_buf, ARRAY_SIZE(init_msg_1),
 					 usb_buf, 24);
 	if (status != 0)
-		return status;
+		goto out;
 
 	memcpy(usb_buf, init_msg_2, 12);
 	status = kalmia_send_init_packet(dev, usb_buf, ARRAY_SIZE(init_msg_2),
 					 usb_buf, 28);
 	if (status != 0)
-		return status;
+		goto out;
 
 	memcpy(ethernet_addr, usb_buf + 10, ETH_ALEN);
-
+out:
 	kfree(usb_buf);
 	return status;
 }
-- 
2.7.4

