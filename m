Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCAD8DC17
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfHNRls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:41:48 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42884 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbfHNRls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:41:48 -0400
Received: by mail-yw1-f67.google.com with SMTP id z63so41231722ywz.9;
        Wed, 14 Aug 2019 10:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sHuMccop5UgrrMj0/XyByQ81In/IvXzzxsdeKT5qeXY=;
        b=jdld6SlHNDZmGx5M3pz405dLCUtfNHUjnXWEnLfagn1Zs0CiYAFaJpiv/OUfTUqbD1
         BqK2rGZX6O4W9or6Pi14cpxZsPPcUX4oxIvfGcgCI4MM1jHm2MDBYqNxyW6lX/AbLPDV
         5zEtnvGeckFaIo3PAKw08h4xjtUA3wijSsvnc81ug4eOBmwXSf97wTyogWTKmCBZ/jiQ
         3MGHiS+CjoY4OarSbG3xlmqqQ5ivNtT7ecdkytuXMlFd7mL2fQ7q1cLH9gx7SKdKryvB
         gAoeNDe7HFtU4Sag7LeWtVigiXvWR2RLxNGJPv6h+WpAUmORDjHO7mC0SzrxiwEFPGoA
         0vFg==
X-Gm-Message-State: APjAAAXEjuOW/N8+n6IXdf6HdCtZ8PLC4UpsN8eTes13c7jL5MzLrNpr
        roxFCT3e7mPbCdVy2zmZWfB/sF8Ncbs=
X-Google-Smtp-Source: APXvYqzpOodDIOzylD9sAsHwz6A1p4UQi0peD2Q4IDhPLW3fYKkvbnyyL0Au0Uw7CLG/07aow+hvgQ==
X-Received: by 2002:a81:5c87:: with SMTP id q129mr266407ywb.403.1565804507497;
        Wed, 14 Aug 2019 10:41:47 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id q65sm115032ywc.11.2019.08.14.10.41.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 10:41:46 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:USB "USBNET" DRIVER FRAMEWORK),
        linux-usb@vger.kernel.org (open list:USB NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: usbnet: fix a memory leak bug
Date:   Wed, 14 Aug 2019 12:41:33 -0500
Message-Id: <1565804493-7758-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In usbnet_start_xmit(), 'urb->sg' is allocated through kmalloc_array() by
invoking build_dma_sg(). Later on, if 'CONFIG_PM' is defined and the if
branch is taken, the execution will go to the label 'deferred'. However,
'urb->sg' is not deallocated on this execution path, leading to a memory
leak bug.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/usb/usbnet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 72514c4..f17fafa 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1433,6 +1433,7 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 		usb_anchor_urb(urb, &dev->deferred);
 		/* no use to process more packets */
 		netif_stop_queue(net);
+		kfree(urb->sg);
 		usb_put_urb(urb);
 		spin_unlock_irqrestore(&dev->txq.lock, flags);
 		netdev_dbg(dev->net, "Delaying transmission for resumption\n");
-- 
2.7.4

