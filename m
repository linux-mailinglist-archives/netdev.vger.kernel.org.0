Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF03467045
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378277AbhLCCvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243291AbhLCCvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:43 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907AFC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:48:20 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso4079151pji.0
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZJIQeK0EgG/UV5Pt+YkA9U7JwgoNnEnSIPXGj3Jg9Fg=;
        b=L1uMVXmb4X2+FpKOA9muyrb3cnE3qVmxMS6oBUluU2d15OkQBuWAE6iOvR0ABP1uFW
         EoUqoUy4KnyxEHJarGxqfA4juDQ0wTGgGqFBJIZfGBdc3Jk5Tih+ptmaCXABlHM8mcF3
         ibQ9qvB25oKtWQCI/L1TzyfnmUdsMR+Rj1YbmQ4s1nkYaUYgCpwNgx6J3xe2Xli32Ma3
         eavSKjmu9FyY/SIZ8d5QFWaYYpzMDxZNxJwlUJcYsoYtEeajy5JfceS/3/3SOm5J1X4y
         q9M7oL5dzk1M8YiIYM/K9xNb8CBOofSX4xQEc0kWX7JdFeoZChfM//NxxCb07VGaf2TI
         T7Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZJIQeK0EgG/UV5Pt+YkA9U7JwgoNnEnSIPXGj3Jg9Fg=;
        b=5r/XoH9LU2LZzI/ozhqLiwXWQkpY/xZjcCtFIrc2KlAZmLkIwel481O/HTEzh++9s8
         xHhqI6ngxBmhDenVNpd8PQX+Pa8lPsawQMQD9pBeR5I9Nj1//6238odQUQz3uOjyoKGB
         1cDSJ8/urdrVE+LxcpIBN+iuKbgdgEZTN81IZe6pUb7IdM3jpn74cof0wk2cUTeizPxO
         Z5XA6UnkoZvp0tuPX8kb4qMv8Ugci/OIzZSrLkY2LWu7JfGuQUvnfsgWowgO7uJ+b+2T
         8BLqUVuM+HQWEvbLGtU4mHQq67qhpq6wDAPTvWS1MKSS3WMxup3DQqMYFv7pAotFgqXq
         NqYw==
X-Gm-Message-State: AOAM5321q4wxyPkJXCxRXGXpUf8jGsvyU2lDawLbC8ak/ogUJt7bpCWN
        v8YQrm9ZpcUg3qv/GMKsAUbpj+FMEJg=
X-Google-Smtp-Source: ABdhPJwgJqmIJbTu1O8PpxXhTwO5zB+0SgBPBJrwVAPmb2fNEf5BLZQKXSQCJ8jJvl2kBMdtUIBCFQ==
X-Received: by 2002:a17:90b:4a0f:: with SMTP id kk15mr10444126pjb.223.1638499700126;
        Thu, 02 Dec 2021 18:48:20 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:48:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 20/23] net: linkwatch: add net device refcount tracker
Date:   Thu,  2 Dec 2021 18:46:37 -0800
Message-Id: <20211203024640.1180745-21-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Add a netdevice_tracker inside struct net_device, to track
the self reference when a device is in lweventlist.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 1 +
 net/core/link_watch.c     | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d2bbae8464fc9a2367ee063bdbcba4caa994fa5c..990fb906b524860451b32df6b4bf625780b6d9d7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2279,6 +2279,7 @@ struct net_device {
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
 
 	u8 dev_addr_shadow[MAX_ADDR_LEN];
+	netdevice_tracker	linkwatch_dev_tracker;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 9599afd0862dabfca4560de6ec36606bf3742fd6..d7d089963b1da4142a0863715382aa81241625eb 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -109,7 +109,7 @@ static void linkwatch_add_event(struct net_device *dev)
 	spin_lock_irqsave(&lweventlist_lock, flags);
 	if (list_empty(&dev->link_watch_list)) {
 		list_add_tail(&dev->link_watch_list, &lweventlist);
-		dev_hold(dev);
+		dev_hold_track(dev, &dev->linkwatch_dev_tracker, GFP_ATOMIC);
 	}
 	spin_unlock_irqrestore(&lweventlist_lock, flags);
 }
@@ -166,7 +166,7 @@ static void linkwatch_do_dev(struct net_device *dev)
 
 		netdev_state_change(dev);
 	}
-	dev_put(dev);
+	dev_put_track(dev, &dev->linkwatch_dev_tracker);
 }
 
 static void __linkwatch_run_queue(int urgent_only)
-- 
2.34.1.400.ga245620fadb-goog

