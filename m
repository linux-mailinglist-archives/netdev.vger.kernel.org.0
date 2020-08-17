Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B90824613E
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgHQIwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgHQIwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:52:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B373C061388;
        Mon, 17 Aug 2020 01:52:03 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y10so5603974plr.11;
        Mon, 17 Aug 2020 01:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/Dwv0Cic7T6kz8Rts1cgLM7pEUoAzAWE8onSffb/CRY=;
        b=CoGj2d/h+8Kc9CWQDDtSzGXdf08Gnkjryfx4wKEKQ2hzvLKCAnNWJCx1nm0ddyU8YK
         V6c2cURPPd2WUu91ps+wgkH4s0FZLalYBMI/7HH7gnSRgxdIAUSBxGeiVdRrHzdisAaB
         rfCXlOTlJIi3uwTXOLf+1FVEWCdjiq/Tq6a8GctK+hotTmNXK33F2ugGf7510Nodjdxo
         JHMVle1h6yzBVPKVVGK4ZyYyOGM55FRqalHY7jOFE/Te9peW80xoOAA5rblb8aCQ37hO
         gUNUlxMp+YJz2piUpHaXcpautwjevnR8wGPezLBo0pAOFc36kB+Q/KtJ2p6+z2KxBQUU
         46zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/Dwv0Cic7T6kz8Rts1cgLM7pEUoAzAWE8onSffb/CRY=;
        b=ijTnR+3O3fgn9rruujy9kWYwQr2fBgy5MN3+VtP6QtS6lqhcddPr/L+2HUG4DCElS2
         GFQRpVGQ8rZRuKiWvinDB9MTFjrw0wF0hdVpBpj168s1ZxgrcR4Ne8ncVfB4G/TEG8iv
         B4niU98zTgEK/nQupBKBKWl9OlCRAKYELSTgeGO44FL+xXwEsdMIUYMmANw8Udxch4/u
         N127IfQMv3Mk3bBobW67Cx309szwMm2VEs9B7TkMImKfLRbzwlMhYMDEi6m3PBzOSNnA
         KF5zXgPvvdj69fghHQO8cwuTPPZwZpy1j3bFizRz1McauEBTGuFJlAzQMwNzrBJjcZmJ
         7YKA==
X-Gm-Message-State: AOAM531inZ5xRzD5ULvwMb3G7XzgOEkhC8Fr+aIpcTaJsaSHZ1s47qjb
        EeWb8GbSg4/7vg7Kwsdn+Ec=
X-Google-Smtp-Source: ABdhPJytBX5O91tG68f9TX19wYBPt+IKOmYp94gCzm4N16NATR0r2Ef8mF3P33JY9+mj9FNO5dwIvw==
X-Received: by 2002:a17:90a:ea91:: with SMTP id h17mr11482982pjz.36.1597654322795;
        Mon, 17 Aug 2020 01:52:02 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id b185sm18554863pfg.71.2020.08.17.01.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:52:02 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 4/8] net: mac802154: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:21:16 +0530
Message-Id: <20200817085120.24894-4-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085120.24894-1-allen.cryptic@gmail.com>
References: <20200817085120.24894-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 net/mac802154/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 06ea0f8bfd5c..520cedc594e1 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -20,9 +20,9 @@
 #include "ieee802154_i.h"
 #include "cfg.h"
 
-static void ieee802154_tasklet_handler(unsigned long data)
+static void ieee802154_tasklet_handler(struct tasklet_struct *t)
 {
-	struct ieee802154_local *local = (struct ieee802154_local *)data;
+	struct ieee802154_local *local = from_tasklet(local, t, tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue))) {
@@ -91,9 +91,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);
 
-	tasklet_init(&local->tasklet,
-		     ieee802154_tasklet_handler,
-		     (unsigned long)local);
+	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
 
 	skb_queue_head_init(&local->skb_queue);
 
-- 
2.17.1

