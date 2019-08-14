Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5858D7FD
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfHNQXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:23:19 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:34127 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbfHNQXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:23:19 -0400
Received: by mail-yw1-f68.google.com with SMTP id n126so3670815ywf.1;
        Wed, 14 Aug 2019 09:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0ou2VxvAp7i/GQYsd8swwwCLKBJVkWjDqEHUyfXhbz8=;
        b=EW9EfHx7Rq1EW//SuoGcI7HYLMjC4Ia+j92Tw0Ih+ZDELev/vjZxI37Eg4wYwGcXUI
         US5TEZCR+uSbVdxXIJaeWwlZpwOORwmWeczpUaVXQ9S0G7nfwYTc/Id59O+E6wb1wKcN
         D7WS7HPQF0e32oDIxvioUkQMY7L+tSREQCuk4iK/zmcy9XAq1Onmqx92UNOT3mc4TMEL
         NXgzypOqrAARDnxNloEaVQqwWfSQoNbHXbaV78+OuYrwnUVYIa+WK2qgQP6ADNyvlqoB
         Tki6g8VqlFf+Adwwd0rdSwMX77xCWjRIB2tvLSspO/zCvbbRZnSKxNoE+vmFqB4GGMXD
         WJ1Q==
X-Gm-Message-State: APjAAAWxvzXRzHmwsoeLhyjjdi+rITY13/54MGMza0iUzGqzPfFP/6hr
        +HIO8l+78O4lD+B70frydwk=
X-Google-Smtp-Source: APXvYqyokExhM7ajSieOAYtdyJnQLxyrcKuwHEvgdnbA8f+tMLLXAihm/Btc6NJd4GYOHCX3CpMvGw==
X-Received: by 2002:a0d:fc44:: with SMTP id m65mr46165ywf.109.1565799798387;
        Wed, 14 Aug 2019 09:23:18 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id g68sm63128ywb.87.2019.08.14.09.23.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 09:23:17 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:USB LAN78XX ETHERNET DRIVER),
        linux-usb@vger.kernel.org (open list:USB NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] lan78xx: Fix memory leaks
Date:   Wed, 14 Aug 2019 11:23:13 -0500
Message-Id: <1565799793-7446-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In lan78xx_probe(), a new urb is allocated through usb_alloc_urb() and
saved to 'dev->urb_intr'. However, in the following execution, if an error
occurs, 'dev->urb_intr' is not deallocated, leading to memory leaks. To fix
this issue, invoke usb_free_urb() to free the allocated urb before
returning from the function.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/usb/lan78xx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3d92ea6..f033fee 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3792,7 +3792,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	ret = register_netdev(netdev);
 	if (ret != 0) {
 		netif_err(dev, probe, netdev, "couldn't register the device\n");
-		goto out3;
+		goto out4;
 	}
 
 	usb_set_intfdata(intf, dev);
@@ -3807,12 +3807,14 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_phy_init(dev);
 	if (ret < 0)
-		goto out4;
+		goto out5;
 
 	return 0;
 
-out4:
+out5:
 	unregister_netdev(netdev);
+out4:
+	usb_free_urb(dev->urb_intr);
 out3:
 	lan78xx_unbind(dev, intf);
 out2:
-- 
2.7.4

