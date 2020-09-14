Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957B526860A
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgINHdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgINHc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:32:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A29C06178C;
        Mon, 14 Sep 2020 00:32:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so11878939pff.6;
        Mon, 14 Sep 2020 00:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K0rmesgrD1bNmF9t8bmkqT387fehM4IpA+AzqZalpKU=;
        b=GXJdPUG29R8FUBVBZnHRp2Z/lTMkXqZnl4KcnN9aRnHmzNUYoGUimbJZzNVyn8X8pC
         r7HDGOTBFYr+X6E51GVpXyDLl0IX/O+DQftgmfIWYC8/qFoDQTdsWqKg7czQQiG762Mx
         gq8VVArl4KRT4MRv6XyezaeCcxTKJWMaofwRC75X+dOFtFzVIeQRZTFXzu5+toGUf2Uy
         FNEpnmckajir9moz34A1z4uGTMqkrINQriVNQ1Ytqb3snaQz+5NJ+CtXHFz/Os0smXb2
         z1PzgFLjuGGxy9sT+IamGkgJsW0goYLTUUhZg9mkwQd96EIaWbdglbCM1jLDkyNRnW62
         UwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K0rmesgrD1bNmF9t8bmkqT387fehM4IpA+AzqZalpKU=;
        b=YHwNB6saI76cQzKIPuZC1We5qfSAU/ncwr261DjMQx7o4oN0vzCW27tcaO5wACkI8a
         CKGg1sCNbnlkXAFuHVVxgoJLDler7/AF+CTQookgY3Qe6pYlxrisr4DyV5ZnEScU8bJG
         dweGab5iL84hbnRrl3CZNZjjfcg7MU6jOgJ+MJBVgpRVSiVAh3lq8vQ58f47TSdrmn3X
         c3At3eH7ZZ9q2Bik1FR0XBUkG/whi2Yd71GcRKtIeBEw+bmFi6sMPnEc8Q4kZ/vB9vgO
         BvkeC9DM85G65BUb9blLGHgLX5jL8/dna4saG03mFoa+TlnJXrkLZ9PJ9A/TEmJG16d7
         h9OQ==
X-Gm-Message-State: AOAM531i4kW/d8OVT7QrC+ZDGwW6vNsFMhn6D7QI6NoxC7WNs1zgIoJJ
        ZjIGMLClyrhdQkmobGKb6YY=
X-Google-Smtp-Source: ABdhPJxS0j7ADLRTEookln5rqrNLK43WurPXZsjHswtpXE9mZv55cdPFAYGWWq2FHjQeqBLJaBjqOg==
X-Received: by 2002:a17:902:b786:b029:d0:89f4:621d with SMTP id e6-20020a170902b786b02900d089f4621dmr13729644pls.5.1600068748171;
        Mon, 14 Sep 2020 00:32:28 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:32:27 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 11/12] net: rtl8150: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:30 +0530
Message-Id: <20200914073131.803374-12-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914073131.803374-1-allen.lkml@gmail.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/usb/rtl8150.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 733f120c852b..d8f3b44efc08 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -589,9 +589,9 @@ static void free_skb_pool(rtl8150_t *dev)
 		dev_kfree_skb(dev->rx_skb_pool[i]);
 }
 
-static void rx_fixup(unsigned long data)
+static void rx_fixup(struct tasklet_struct *t)
 {
-	struct rtl8150 *dev = (struct rtl8150 *)data;
+	struct rtl8150 *dev = from_tasklet(dev, t, tl);
 	struct sk_buff *skb;
 	int status;
 
@@ -890,7 +890,7 @@ static int rtl8150_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 
-	tasklet_init(&dev->tl, rx_fixup, (unsigned long)dev);
+	tasklet_setup(&dev->tl, rx_fixup);
 	spin_lock_init(&dev->rx_pool_lock);
 
 	dev->udev = udev;
-- 
2.25.1

