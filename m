Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6745D465CB0
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355189AbhLBD02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355199AbhLBD0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:26:24 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFE0C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:23:02 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v23so19507890pjr.5
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pIB1yZNjkeCvyxOHtvefP/M6d++rAd5Z49t8wZUH8rk=;
        b=UScCS+BLPbO986z1yEZGEDfRz31Rvf4+bCZsbV8LgmVZcaO+Vb6qaRCWcMPJTpYnmd
         jSh8tnjwGCwD3w7xsZO99cZp1Z5tvxUIyj+VBgKOfnkBePaXd7X73uldO7KOG7/ifHbl
         iFVdSFJmPExSmTRLA9K3k5QjLB5j1WvIx1a2Z/CpaM/yMBvCzH7Ji4LDUsZEvQLy7tQx
         zQYWnfxhEteP53C/F41nBmZXs8OLZWrKGPYSFMQj+EuM5jCid6RaIYcYAWj26ZgStySw
         fH2g5LYy8uILgJUzDbcy04VU5sxXindM7p3WRC07f+S6JYj7lNSjETayBe+BEkWekLcQ
         rA9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pIB1yZNjkeCvyxOHtvefP/M6d++rAd5Z49t8wZUH8rk=;
        b=PTe8fNlj68syg91QLoZ3y0+jFJzR+nYG4LBwU1Qp5n4Hu/aafy85Z6tjYsauquBEja
         YahKfDqbmVAnK+FbU/Zud5rZ1ccq7f5fdjGe9RLvW73Mhr5QcSuNvtITgXGu+tK4/5RL
         7gkz6LCK2N9DtrAx28ZJ3QT7HawQuM9yTZd3411PbGfQvLkPMhlzSqBaZJCmK7Leut81
         myMfGfKJe+N6ipvn5X00op68VU3eeTNdovNBcfzsKu0EDXa1p/8FbgOjJrwJ+eJIgHBA
         cVewhf1JLXJ6dVH6Ra7JFshNlGLjk0H1rPauck50kJRPOyCz00vtwZ/VYltID958l+AP
         CnPQ==
X-Gm-Message-State: AOAM5331JP57FENqiCD1MVF6ZUPNtJzf7YaaJUwMPQ5529YvvcctASCB
        dNjJSCpPVy2To6NiG5wycYM=
X-Google-Smtp-Source: ABdhPJxLDGeGPyoA7KFLeaxmFgkA87+h3I7/SIoNukGoNWPTy1uiCgztWMxf+8zcOOzQ+OYo4a8NUQ==
X-Received: by 2002:a17:902:ea10:b0:142:112d:c0b9 with SMTP id s16-20020a170902ea1000b00142112dc0b9mr12392957plg.35.1638415382310;
        Wed, 01 Dec 2021 19:23:02 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:23:01 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 13/19] net: add net device refcount tracker to struct neighbour
Date:   Wed,  1 Dec 2021 19:21:33 -0800
Message-Id: <20211202032139.3156411-14-eric.dumazet@gmail.com>
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
 include/net/neighbour.h | 1 +
 net/core/neighbour.c    | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 55af812c3ed5704813bd64aa760246255aa5f93f..190b07fe089ef5c900a0d97df0bc4d667d8bdcd6 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -158,6 +158,7 @@ struct neighbour {
 	struct list_head	managed_list;
 	struct rcu_head		rcu;
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
 	u8			primary_key[0];
 } __randomize_layout;
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 72ba027c34cfea6f38a9e78927c35048ebfe7a7f..fb340347e4d88f0058383697071cfb5bfbd9f925 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -624,7 +624,7 @@ ___neigh_create(struct neigh_table *tbl, const void *pkey,
 
 	memcpy(n->primary_key, pkey, key_len);
 	n->dev = dev;
-	dev_hold(dev);
+	dev_hold_track(dev, &n->dev_tracker, GFP_ATOMIC);
 
 	/* Protocol specific setup. */
 	if (tbl->constructor &&	(error = tbl->constructor(n)) < 0) {
@@ -880,7 +880,7 @@ void neigh_destroy(struct neighbour *neigh)
 	if (dev->netdev_ops->ndo_neigh_destroy)
 		dev->netdev_ops->ndo_neigh_destroy(dev, neigh);
 
-	dev_put(dev);
+	dev_put_track(dev, &neigh->dev_tracker);
 	neigh_parms_put(neigh->parms);
 
 	neigh_dbg(2, "neigh %p is destroyed\n", neigh);
-- 
2.34.0.rc2.393.gf8c9666880-goog

