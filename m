Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32FB465CB4
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355202AbhLBD0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355214AbhLBD0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:26:39 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E55C061748
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:23:16 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id k4so15519033pgb.8
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lPAg9CqmL/od/8VHtg2Hl2oiYPYjTcUvvNkryGEYnGg=;
        b=iOP9DsKwdABkQGAgY/jeGUnTLxs0yQICCNaFptPDC8xYJysB4Xj1CusN2XDg29hAqf
         TONF1nxXWLeQQhj31YdKHCxYLzwrBf/Ww21McdEqCfhaZ2vER1j5OO4LcA/Ghp/L0Bxx
         eGK/RbX+w/6JJ9uGoiNixXw8/IMCfufBvwwxsF/9EYRgNJL72Xvz5ST/8B9LSyospTfp
         fslIDXBAihN5yFJyFdxfCkrLPmWptVCDVoRQufwULmb9i07QXp9bfKFgu3jka4RupKRI
         f2/PTyejuGOisfaXVKrZvX4evLZmt5cAMZQglZppKfWPB3Y6agAi96/p6FKMNJpgcv2u
         xZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lPAg9CqmL/od/8VHtg2Hl2oiYPYjTcUvvNkryGEYnGg=;
        b=6i9lAHV4J5f0Jf5RA5vkcVMt+omAPBIpCftQG47EQfhR6gfX/Zaqfx1xcMghyLkMHW
         bGfhmBJPfSgyBrXDenLuPP0WFVOvakDy4/EBEf92w9TgyJwtB0dAlTBwvCGu3fJoQzWT
         pau/0bLOf/yvpZYGbnw8n2dsVzBGmXyuc/mNtL781VEHk0woIWyKNQO8JlvQ46IJuCfi
         /Ev4HSekNv/od6roNMtmuTs2Xwfn3517zkIflwGk69o3iaaQw/P2QoEHfnFHrlrAmTV1
         EXWXMrvxAgy7KjljI9SkfNdYOlhfoiGuFQCMnpkWWmyb8wzkwHv8BVdKvCe495cHAou8
         z1zQ==
X-Gm-Message-State: AOAM530eHZX2TR4Hl+VpmCNIVO/fQl1P/8pCLmDg7xXvqJ4lvZQiiB6S
        8EXFmCDIRvQ4n4E0jEDKbtQ=
X-Google-Smtp-Source: ABdhPJwxRDtwwvItXo9N4A4sBzD6A4hStIYwj9Uf8JEBYE/AGUM12kLRPifzmBDxajgJ2TgNsv27Uw==
X-Received: by 2002:a63:66c7:: with SMTP id a190mr7715880pgc.463.1638415396142;
        Wed, 01 Dec 2021 19:23:16 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:23:15 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 15/19] net: add net device refcount tracker to struct neigh_parms
Date:   Wed,  1 Dec 2021 19:21:35 -0800
Message-Id: <20211202032139.3156411-16-eric.dumazet@gmail.com>
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
 net/core/neighbour.c    | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 5fffb783670a6d2432896a06d3044f6ac83feaf4..937389e04c8e26b6f5a4c1362a90930145671889 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -70,6 +70,7 @@ enum {
 struct neigh_parms {
 	possible_net_t net;
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 	struct list_head list;
 	int	(*neigh_setup)(struct neighbour *);
 	struct neigh_table *tbl;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 56de74f8d2b1c896c478ded2c659b0207d7b5c75..dd271ffedf11cdd3a1b6bf5fad7b0ddcc5d41e80 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1666,13 +1666,13 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
 		refcount_set(&p->refcnt, 1);
 		p->reachable_time =
 				neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));
-		dev_hold(dev);
+		dev_hold_track(dev, &p->dev_tracker, GFP_KERNEL);
 		p->dev = dev;
 		write_pnet(&p->net, net);
 		p->sysctl_table = NULL;
 
 		if (ops->ndo_neigh_setup && ops->ndo_neigh_setup(dev, p)) {
-			dev_put(dev);
+			dev_put_track(dev, &p->dev_tracker);
 			kfree(p);
 			return NULL;
 		}
@@ -1703,7 +1703,7 @@ void neigh_parms_release(struct neigh_table *tbl, struct neigh_parms *parms)
 	list_del(&parms->list);
 	parms->dead = 1;
 	write_unlock_bh(&tbl->lock);
-	dev_put(parms->dev);
+	dev_put_track(parms->dev, &parms->dev_tracker);
 	call_rcu(&parms->rcu_head, neigh_rcu_free_parms);
 }
 EXPORT_SYMBOL(neigh_parms_release);
-- 
2.34.0.rc2.393.gf8c9666880-goog

