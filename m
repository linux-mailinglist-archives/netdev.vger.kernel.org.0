Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B79465CA8
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355187AbhLBDZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355177AbhLBDZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:25:39 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5FFC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:22:17 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id k4so15517181pgb.8
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DwKye74xS/o+/oCC7HHBDHu1NiXUCS13Osw1+37JcqA=;
        b=qyjxkv+3Xr3R+z6R5+Sn5qdLp3LMsKCKNyjGm8vHecfxo24qxMOI2MSeYN1qqJlKIr
         WIBL17tNWLjPhIpgaJY0BfLR5HicTUj9K/pPRg4wKeKbt4esnOZBt+83rQO9z2SMv50l
         gPNm4L3z1AUiptyPAp7rBGkOp5tXZz0EP7NkPDJkyCIh5vw9s/79z/6TP/P7MeELOmbM
         XqNWMbLD2d336QRrt9+SE/ivh/LNvPvXS8bptQcDG0wrgga2ST2rApHlSTUx1YbqaSmv
         eNTtYL71UT0b54vzxCtuXN/KgjmCHeNhyRqn4i9CrXleRx/E8REVDnR7Say7J6NwTTA1
         E91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DwKye74xS/o+/oCC7HHBDHu1NiXUCS13Osw1+37JcqA=;
        b=VNbjNMOu1vjVP2xkR325lx1Q3m8cyauMWT9F9Ak9rFh0c98kBCvfV1sU2whCxs2B2S
         S1vTEzH+QrDBa7Q/K69IrWH529oEucJhZX/pDqOdMJtsBPKlmf9qNZ6X6TEph+V9inXq
         ++RP9k9e5i+mU4ALokDCw1h15uBTEMmw5aQinD7VEhGmu4+n+MMxXw9YHHmFu5CzjgVH
         HltqadaxM5+VquHqbc3BTpaYDS93zMGpqfy5g1EIhQacVkWdVczl4lsb595pQnaAb5Qz
         lzKLHHDEhVKqp8AId45FgVK3Rpi+7gqhsPJPFKAIVQOLbanNYrJWQljQit/aiTXjEIw6
         OG+g==
X-Gm-Message-State: AOAM533KBq9Cw5ii60HGTcWQAvzN3EouXJAgqzTJtq10RjCKsrCl3Qs2
        MLLkxDk7pasmRzP/A/vEKPw=
X-Google-Smtp-Source: ABdhPJxxSmiR2BKDAcDWnQXUf2xOjJuIrHpZEjsesffCNFBKgh7tTcOZjLrOW6KNm9PdU7fWhcWO1Q==
X-Received: by 2002:a63:5526:: with SMTP id j38mr7625189pgb.86.1638415336935;
        Wed, 01 Dec 2021 19:22:16 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:22:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 05/19] net: add net device refcount tracker to struct netdev_queue
Date:   Wed,  1 Dec 2021 19:21:25 -0800
Message-Id: <20211202032139.3156411-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This will help debugging pesky netdev reference leaks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/net-sysfs.c      | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 01006e02f8e66fc3ee16890d3bbdb49e3e7386b6..b43102614696a97c919f601d1337746443d79557 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -586,6 +586,8 @@ struct netdev_queue {
  * read-mostly part
  */
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
+
 	struct Qdisc __rcu	*qdisc;
 	struct Qdisc		*qdisc_sleeping;
 #ifdef CONFIG_SYSFS
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 27a7ac2e516f65dbfdb2a2319e6faa27c7dd8f31..3b2cdbbdc858e06fb0a482a9b7fc778e501ba1e0 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1607,7 +1607,7 @@ static void netdev_queue_release(struct kobject *kobj)
 	struct netdev_queue *queue = to_netdev_queue(kobj);
 
 	memset(kobj, 0, sizeof(*kobj));
-	dev_put(queue->dev);
+	dev_put_track(queue->dev, &queue->dev_tracker);
 }
 
 static const void *netdev_queue_namespace(struct kobject *kobj)
@@ -1647,7 +1647,7 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 	/* Kobject_put later will trigger netdev_queue_release call
 	 * which decreases dev refcount: Take that reference here
 	 */
-	dev_hold(queue->dev);
+	dev_hold_track(queue->dev, &queue->dev_tracker, GFP_KERNEL);
 
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
-- 
2.34.0.rc2.393.gf8c9666880-goog

