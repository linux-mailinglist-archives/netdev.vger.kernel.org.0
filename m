Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C451468912
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhLEE0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhLEE0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:26:14 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB52C0613F8
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:22:48 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v23so5255373pjr.5
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eOkbTqC70cMxk+SiiC//4vDcMoRtO5s+8GF7iQiCxQY=;
        b=RUtP0sLMbS1UjWyurpex245tw7JbuX4AFjJ/GVIvY+/8p3Ou0qOnF5PZN34RJ5wxI8
         5SZS4JXWaCVQBpy3df5Xz89RZpfk2P2mXBJ6T13Ch3DLWdTWR+03CietrbR0a3R+I00L
         85AC0VGC5zPLXsQmheqtAr7fA9rSEHxv6nbBJa6KHLqWRXi+T6WNQacbbwSqaKJo1GF/
         AjjwRxaU/3BUBp6UhBGVqcn2d3NIF7u85LgIMjelXqyPW6Sd+WaC8MXl9n6WYy46sfAM
         pY4TOMjzE/MAvTuL5tNBKKOSu0+d+hXqG/4tTNSaBLJm+2AamgWxaeLGp/cETPf0Gj9H
         AhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eOkbTqC70cMxk+SiiC//4vDcMoRtO5s+8GF7iQiCxQY=;
        b=cvB2ZXhOOkPzFIuYh+Mda4hJPt2Pt5G/kK8CmKBMCFWubB2P4C/KJc64knUtTfQ80F
         LHYLUlMtU5lh1lG5xsYfACH+abpwc6nbE3AUPCNHkhohCYgMB8t3eJ3aYyrxkJTCMLY3
         lHxy4LItb/GmRn+qj/o/IYGcg9+T6n4TwE4nrhDrgZucU8u1OKEo0y10Cd9MHAUyL6G8
         CsE4mXfxdPDBxqjujdAAvSsDJvX9Jxz8bQtCeBGI+XOwnxiTHL6jjYURO8itWGcQkhaP
         XFkYk3LGIyUTtb1gpZK5lUy1z0mD0zNtKXqni/yzU3K8Zse4VJ2w6fqXNx5Jv+cPKoJ9
         wECw==
X-Gm-Message-State: AOAM531Z6CPZ30v5T5+lxjtZDkmVFYYgKmxjtTnK1NWTCUESDKL7Ktgl
        Bf9qCMClZ+2D70SHJSta7KY=
X-Google-Smtp-Source: ABdhPJytoj9PrQmQ62Zy2AIDRss5TNegknqL/d8kI1AAmjqK2ccPh9s35eIHbt8i/HhUwazQBfbR2g==
X-Received: by 2002:a17:902:8e87:b0:143:759c:6a2d with SMTP id bg7-20020a1709028e8700b00143759c6a2dmr33715022plb.59.1638678167738;
        Sat, 04 Dec 2021 20:22:47 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:22:47 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 06/23] net: add net device refcount tracker to ethtool_phys_id()
Date:   Sat,  4 Dec 2021 20:22:00 -0800
Message-Id: <20211205042217.982127-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This helper might hold a netdev reference for a long time,
lets add reference tracking.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ethtool/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index fa8aa5ec19ba1cfff611a159c5b8bcd02f74c5ca..9a113d89352123acf56ec598c191bb75985c6be5 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1989,6 +1989,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	struct ethtool_value id;
 	static bool busy;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
+	netdevice_tracker dev_tracker;
 	int rc;
 
 	if (!ops->set_phys_id)
@@ -2008,7 +2009,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	 * removal of the device.
 	 */
 	busy = true;
-	dev_hold(dev);
+	dev_hold_track(dev, &dev_tracker, GFP_KERNEL);
 	rtnl_unlock();
 
 	if (rc == 0) {
@@ -2032,7 +2033,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	}
 
 	rtnl_lock();
-	dev_put(dev);
+	dev_put_track(dev, &dev_tracker);
 	busy = false;
 
 	(void) ops->set_phys_id(dev, ETHTOOL_ID_INACTIVE);
-- 
2.34.1.400.ga245620fadb-goog

