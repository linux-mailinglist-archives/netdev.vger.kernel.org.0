Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285C2465CB5
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355215AbhLBD1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355203AbhLBD0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:26:55 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D457C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:23:33 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id o14so19253037plg.5
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NCRWwJ15iKzDVwus3bpAunOI6VdjtwPdp927p9MxAvU=;
        b=QiW2SKfYGJDiDPq79Js1Kbx2IxfCyxkTc7he7AE89jZcRjL8GINVMKW9sRw4tDkp/n
         hFG8J74Bh2z5X6tLPc0GL5vQwJdzpbHg3Y7VSgtsi0fM7DGYyifqAr5tX5Fgwnl1MBuf
         //RLBosg518SLy2PLVZ7Pm4gFZfs2yOBeb4yBGFjVKku74GvwT/geTagabYONplw2Awe
         xZ77/wJMlbvVYPclx1P3hE7ImeaUVqSU5BN4UEc1SUjzGYDvD9VMQJGnyW/gxur+6Ilx
         rWrx/NF8gzSwr8cCpHLleAl23xhJYlvDSSDHaLp5Eu2sSpYSZf7UurjW4CzJi5bly3vn
         rFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NCRWwJ15iKzDVwus3bpAunOI6VdjtwPdp927p9MxAvU=;
        b=4g2US10WM1tGoP4GSv7It104PldrIYvPJqZasYSGilTnpgCOs8qjJ2XLwowGmEaA/s
         PuK1FwnCBLTLxYPG0qQWd/SbRZldFMQK060V6ackbmyT+Yo/K1JKwMg0oV6zTdTAzYWm
         IBfCG+6QKgO5QbHa/FUR2llh9OcTb94dlM88o0YRMSFuJ0BxnKlsmFIE70nRy4zYwU6L
         1CjTc6o5EjDcHoVmWRsuOZwa/z+F6c55nXgGg3xl/llMqHB4hbBZoThRdHrd8pwZky5v
         j9vnL7s5B+wQ5vgsMWx4aU2VKiQbhPQ/brb2Y1ODriyYeHMkr6eJnrRFppKEu/DezjXM
         H/qQ==
X-Gm-Message-State: AOAM533E9V92VO9jRg3lKW9kJvbG2wxCHYy46uFENujeZquH5WsvqPJB
        kB0EpdMNZiO2H80aE+09nCk=
X-Google-Smtp-Source: ABdhPJxc0EoZg3aqui+jLjNnIM49p5aPaL1p7zwhNQSe79nQd1uiawwhfrAt6azGB0jDjIysvCq05Q==
X-Received: by 2002:a17:90a:98f:: with SMTP id 15mr2863249pjo.166.1638415413117;
        Wed, 01 Dec 2021 19:23:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:23:32 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 18/19] ipv4: add net device refcount tracker to struct in_device
Date:   Wed,  1 Dec 2021 19:21:38 -0800
Message-Id: <20211202032139.3156411-19-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/inetdevice.h | 2 ++
 net/ipv4/devinet.c         | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 518b484a7f07ebfa75cb8e4b41d78c15157f9aac..674aeead626089c2740ef844a7c8c8b799ee79dd 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -24,6 +24,8 @@ struct ipv4_devconf {
 
 struct in_device {
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
+
 	refcount_t		refcnt;
 	int			dead;
 	struct in_ifaddr	__rcu *ifa_list;/* IP ifaddr chain		*/
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 323e622ff9b745350a0ce63a238774281ab326e4..fba2bffd65f7967f390dcaf5183994af1ae5493b 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -243,7 +243,7 @@ void in_dev_finish_destroy(struct in_device *idev)
 #ifdef NET_REFCNT_DEBUG
 	pr_debug("%s: %p=%s\n", __func__, idev, dev ? dev->name : "NIL");
 #endif
-	dev_put(dev);
+	dev_put_track(dev, &idev->dev_tracker);
 	if (!idev->dead)
 		pr_err("Freeing alive in_device %p\n", idev);
 	else
@@ -271,7 +271,7 @@ static struct in_device *inetdev_init(struct net_device *dev)
 	if (IPV4_DEVCONF(in_dev->cnf, FORWARDING))
 		dev_disable_lro(dev);
 	/* Reference in_dev->dev */
-	dev_hold(dev);
+	dev_hold_track(dev, &in_dev->dev_tracker, GFP_KERNEL);
 	/* Account for reference dev->ip_ptr (below) */
 	refcount_set(&in_dev->refcnt, 1);
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

