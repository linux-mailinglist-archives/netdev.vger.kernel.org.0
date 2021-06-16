Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A3A3A8F02
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 04:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhFPCux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 22:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbhFPCuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 22:50:52 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF5FC061574;
        Tue, 15 Jun 2021 19:48:46 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e1so356190plh.8;
        Tue, 15 Jun 2021 19:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TXQCx1XJ6HTlKo6IRHScBGNPtU7ppfeIer1vG2PDblA=;
        b=GEY5fy/xzue7i2BElLiShQ3zpmiM80vgunSBErXtUv3IPjQOJSB4SMXXSMoHcfP5rL
         RIbu3GEBFdK5HIEBW8xvFcQvdPNNegnPJbEWM7exoblo4VtaGLIB7GhOMqi9YHYdukc9
         Zi/vm5dZqJkjnOClgfmboZufRDnBPTTiqkEHZ6mxuhrLj2C4g+eclYclpYRhRdcGqGAj
         V7/0sB0HI1fM7glXxADJr12A65/hj7LFHautOzWzG04yIr0KBbiCR2ouIK+nyhWbG8cA
         ZXzdeVQa4kOaYfpzUy5GclGqd97MwVUxgJQgnBhVvPt6sFX176PohOfIAscoEuRLTqYb
         y9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TXQCx1XJ6HTlKo6IRHScBGNPtU7ppfeIer1vG2PDblA=;
        b=OF5YF6xlQ/JkiSU9hsOLj2OCNnYksO74YQMoc7ysJxYhBp26DXaD6CK+Y0mGPvawkn
         8OeJrIy8/C28mDen3ijTPhRGNnkThJUf5CTs3dowGrQREJbOFXsezfSRmIoMwcyA28bR
         aezBCmMT8h9fmBF6wBCcvjYGkq1WpRqTW6Qi13AkVhe7vBVJ8uaLc3tJe1JELhuaf5lz
         ZAPX4u5EC//Tbf6KBn/75dEBUUtamTsqx9YU8jx9e29NVx3bCzRiGH3PU9ORmbby9zkx
         7WTtt3wERrsW7TzIdiI5DovHaEgF93OkqMsEr02BWhk/Y2y3PpRxj0NMJM/0a40+I0mG
         w85Q==
X-Gm-Message-State: AOAM531h9jexyk5ioRY8T9nvuzLfLvKDmevDa/mC3tlPcsKaF1a+2K8M
        ILlhh2apeDTZWKwI3sB2OC4=
X-Google-Smtp-Source: ABdhPJxf8cLqkAXkVDyPTTl2+mm3ZzhdrMWLZ4TGezrZJivej+B64Ut5e0xyGLKwGN9I8HD+zq7eDw==
X-Received: by 2002:a17:90a:3d47:: with SMTP id o7mr8347818pjf.68.1623811725958;
        Tue, 15 Jun 2021 19:48:45 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.27])
        by smtp.gmail.com with ESMTPSA id d6sm441731pgq.88.2021.06.15.19.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 19:48:45 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     steve.glendinning@shawell.net, davem@davemloft.net,
        kuba@kernel.org, paskripkin@gmail.com
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH v2] net: usb: fix possible use-after-free in smsc75xx_bind
Date:   Wed, 16 Jun 2021 10:48:33 +0800
Message-Id: <20210616024833.2761919-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
fails to clean up the work scheduled in smsc75xx_reset->
smsc75xx_set_multicast, which leads to use-after-free if the work is
scheduled to start after the deallocation. In addition, this patch
also removes a dangling pointer - dev->data[0].

This patch calls cancel_work_sync to cancel the scheduled work and set
the dangling pointer to NULL.

Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: split the err label into two labels - cancel_work and free_data
according to Pavel Skripkin; remove "pdata = NULL" according to gregkh
 drivers/net/usb/smsc75xx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index b286993da67c..13141dbfa3a8 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1483,7 +1483,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
 		netdev_warn(dev->net, "device not ready in smsc75xx_bind\n");
-		goto err;
+		goto free_pdata;
 	}
 
 	smsc75xx_init_mac_address(dev);
@@ -1492,7 +1492,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_reset(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "smsc75xx_reset error %d\n", ret);
-		goto err;
+		goto cancel_work;
 	}
 
 	dev->net->netdev_ops = &smsc75xx_netdev_ops;
@@ -1503,8 +1503,11 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->max_mtu = MAX_SINGLE_PACKET_SIZE;
 	return 0;
 
-err:
+cancel_work:
+	cancel_work_sync(&pdata->set_multicast);
+free_pdata:
 	kfree(pdata);
+	dev->data[0] = 0;
 	return ret;
 }
 
@@ -1515,7 +1518,6 @@ static void smsc75xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 		cancel_work_sync(&pdata->set_multicast);
 		netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 		kfree(pdata);
-		pdata = NULL;
 		dev->data[0] = 0;
 	}
 }
-- 
2.25.1

