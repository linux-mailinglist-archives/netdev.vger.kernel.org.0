Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98118468919
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhLEE1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhLEE1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:27:02 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB72C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:23:35 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y7so4888870plp.0
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qwiO23AB0bDvllXH4j2dl319YdLwYZlD78jd251Gbg=;
        b=OumXFdYos1zjd/tCX8ml70R6DoZzEj7R6AqASv4on16AGLQyKaXASq+80jhinzR0Ti
         K1hrR8qFfmErUh3s2uMMGZLwPxD6pAIpH9ufJ1bUnVuEWhqxWa8RnfqC6SX4dbwo8//u
         Qv5NdQzWfYPN/K7KP0CLvNtbuHryGty7eyy/d4XOy2D5iMWK9UXqwpK0Iuc9dtGywp25
         WKEiOdsTbzZBAbRuJq1DpKAKpOTTThTg68oG09Fyjw5uae36Asg78Q8+hMIkKKt9QON9
         xmIyhTX2RrNPXBh/E1JqBYXaa/vf+fIrjaF92wzZ21R4x2ZmSDLfvOjEoZh8m9V6VtBH
         JWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qwiO23AB0bDvllXH4j2dl319YdLwYZlD78jd251Gbg=;
        b=lelucYxt9K2nLZKUnk7bRri2j8kaE1hjSFQzH9TSh0cah3NrvSNxT4KZebtNcV7RBA
         o+pH6cR7D66zpNixw9dgrOU2tIv5EF7aLb0mEuLvotwzUpGnk+eVOqPLpfRg1m7fVa0r
         RB6Bmymn5cV9fbl24AWwIbXxqUJDdY3L3A0Or1cSsNWPupUeuxBvkhHZqTvcN7atSmmf
         yT0J5Cm4G7C4CM1nwwOybJQw2jnUVUrSK+/vmf7+9JDAThsMpqkCrgonI1TKyFMF1cQw
         50SXpicDx/GHGkgc8ZvvZPgklDl/tAy+7MqTzQeQu91G4yyrtWKiuIXBfwSY9QdFh2lx
         7n+A==
X-Gm-Message-State: AOAM530IMzQJ+t6DyixF5UcIKcBb5LtTdawU97BSPEcATgbbzly8UMEI
        xIPPZA66jp3/6WYw2RS51e1y6ZDhEWs=
X-Google-Smtp-Source: ABdhPJyhp8ppzyPWWV/M6nMfKar6QkQXSu15snAAfPlmz57SaW4ABhE9mRT44poZodlqlbT4Ptod5w==
X-Received: by 2002:a17:902:bd88:b0:143:d318:76e6 with SMTP id q8-20020a170902bd8800b00143d31876e6mr34660101pls.66.1638678215219;
        Sat, 04 Dec 2021 20:23:35 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:23:34 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 13/23] net: add net device refcount tracker to struct neighbour
Date:   Sat,  4 Dec 2021 20:22:07 -0800
Message-Id: <20211205042217.982127-14-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
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
2.34.1.400.ga245620fadb-goog

