Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1557465CA7
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355180AbhLBDZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355178AbhLBDZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:25:35 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80564C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:22:13 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so1333811pjc.4
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QonKtI/vol5OMXM6N4aZU6C7EHW8LoX8FZwTRiSZlBY=;
        b=AHYenBHL206uGy1RRgucpEKd6Qg31J+S4nqd+6c1V2hStumnLg26v/1ChHkY8KiTuK
         HN6eHfQwwZOWEX5AsFepwfpxIy/k+2hHmO93SHpyvekDBKKAdrrNnd41DBL2SkzUKf+m
         gkpdaNtKLScNoFRI0RLJxguSqZsvyahCKIbi0oPlEWsZ+mihkydQB9trztaLO5ZbwEFI
         YQuI13IsVweXnrC+HzdggWNHlRDXBKpLUD2VOLgzaNSM5Z9SYo2XilmsPTFdCvPijMMv
         rP80Lc/0CPNwrzgtZrseR0EawtEFstQpaT8jh/KW1XiPwCPmFwC8Ku/NPG6+bDb/rxsE
         lFOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QonKtI/vol5OMXM6N4aZU6C7EHW8LoX8FZwTRiSZlBY=;
        b=TUrTaiucdlWYsdqbXIpDVYlVZJ/HBegG0o1a1g/eZWxsVWqMHfHqthP0mMOzA63hSn
         w+kXAoGiDsKwqz10GDyo66XBp2FCfkPpvw8TUnjgB3dyuS9OPcNfJ1ClIibXUGTqnbCL
         c2C9ONTWgWcRWQQSMwLshxUSYJDUR29j7lKx+1SAqkq0Q+2wjgMJiyPXbBlKFLnqxHB3
         XAjaOhm/xtLhmHE4BaW3zaq1ZumRtSySXvMSUtYASakUy2cqIpIw6XeUDgPMEXmA5X9O
         SbKEWrE+Dmf8x2OZtlTK7gaZ+ijB1kvMVsFAKxukHjauev0otoodEx1NU++qBCqaiszC
         AV4Q==
X-Gm-Message-State: AOAM533IF7Xoy6OSJDW3wIz9RZoyy9Rzj9vKO/Qay+EQcBt7xTRkK3lI
        9tGCpFLSlvl8mSXR2IuEOA8=
X-Google-Smtp-Source: ABdhPJxx3rNadXZjezw/LnZ/ye14BZHj4xI4z8vpOQYmXo11ZtOL7x4VoGxW1XPxAsz2ex/RmzPH/g==
X-Received: by 2002:a17:903:124e:b0:143:a388:a5de with SMTP id u14-20020a170903124e00b00143a388a5demr12441647plh.73.1638415333099;
        Wed, 01 Dec 2021 19:22:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:22:12 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 04/19] net: add net device refcount tracker to struct netdev_rx_queue
Date:   Wed,  1 Dec 2021 19:21:24 -0800
Message-Id: <20211202032139.3156411-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This helps debugging net device refcount leaks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/net-sysfs.c      | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ddced0fa20f5c7a4548c340788214ea909a265f..01006e02f8e66fc3ee16890d3bbdb49e3e7386b6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -741,6 +741,8 @@ struct netdev_rx_queue {
 #endif
 	struct kobject			kobj;
 	struct net_device		*dev;
+	netdevice_tracker		dev_tracker;
+
 #ifdef CONFIG_XDP_SOCKETS
 	struct xsk_buff_pool            *pool;
 #endif
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index affe34d71d313498d8fae4a319696250aa3aef0a..27a7ac2e516f65dbfdb2a2319e6faa27c7dd8f31 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1004,7 +1004,7 @@ static void rx_queue_release(struct kobject *kobj)
 #endif
 
 	memset(kobj, 0, sizeof(*kobj));
-	dev_put(queue->dev);
+	dev_put_track(queue->dev, &queue->dev_tracker);
 }
 
 static const void *rx_queue_namespace(struct kobject *kobj)
@@ -1044,7 +1044,7 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 	/* Kobject_put later will trigger rx_queue_release call which
 	 * decreases dev refcount: Take that reference here
 	 */
-	dev_hold(queue->dev);
+	dev_hold_track(queue->dev, &queue->dev_tracker, GFP_KERNEL);
 
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
-- 
2.34.0.rc2.393.gf8c9666880-goog

