Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3AB46891A
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhLEE1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhLEE1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:27:10 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D14FC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:23:44 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id s137so7118417pgs.5
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GDtiZ9MlMKx0wR1tSzrOI9t3DpPfRAAmdOIzJGgoHJE=;
        b=Fvc/ELsXW9d72jdm3AIVYPS1nAv4RE5bsuH5QxeUsSNz4bUn6bUS9DRU9uF76SWk4r
         TYixdmB5fJzkRmdAf2xC4o8j3FPsxEnbjm1tvOcM2VjOzQ9Okn+ZjUWYD45ofB/aXkT2
         g+P3g76U+G12sbFSO7SudWnB4mZuWsbmZGw8Ky9pJbjcF8Pl2vuEjFpBDdU8q8+R4vPU
         rQZjRZCSi0oY8nxfKxR6GVaPq2PE9SqVaNZ/G9KIteDa31Wie8AbzzfR/jAfgaE8P+Sa
         gvj8eBKjG7Fqlg63qA47o1v31ug7E2+ar6ixOamS4OCgocvFMOPirpP1NwVI/FYEXUub
         4nmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GDtiZ9MlMKx0wR1tSzrOI9t3DpPfRAAmdOIzJGgoHJE=;
        b=RrsTkmPMsfc9+wIhS8HM0wCkA0DQQswIESLpFyw2gN8F3+U80fQ4CcBVBcQXk0pglK
         DhbKGeYFeAszbUEs3WzDBDgeCKyNuDd9k5sh6OlAq8pIxUGCwoz1n7diEu+mxe+JsnQM
         aacoZXRywcxGd79fx+pfRiZbAhst8iNDDnGOXbSudYbF4vXxAYsLVVtoU+L+qHF5lm/0
         Cd/25Hj8fuTYJLpW1/QIKwkTcp4tMqBibLsqNZkpKc1kGBdqkuOP6qLk1vpMWGkSSRxA
         6/44yZhzbVEV1KMZg5PI8QW+4rLUqHkZhNt8moYgGc4MPWIUbbwM9kh5LpuPU19ox2B/
         tohw==
X-Gm-Message-State: AOAM531+9QUbj7HDB4n8yf+lhko15QrqeoFg1rqNybJTGrZ/giseDJOt
        9IO3E10umbwPamPvzFa847g=
X-Google-Smtp-Source: ABdhPJxKeul879q6L+gGWdCmEmc3FASAdlBwo6ORexu3WmlrYZfEdCxiJKpwHk82iycHW6wx/ESQGg==
X-Received: by 2002:a62:5215:0:b0:49f:a996:b724 with SMTP id g21-20020a625215000000b0049fa996b724mr28856598pfb.3.1638678224062;
        Sat, 04 Dec 2021 20:23:44 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:23:43 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 14/23] net: add net device refcount tracker to struct pneigh_entry
Date:   Sat,  4 Dec 2021 20:22:08 -0800
Message-Id: <20211205042217.982127-15-eric.dumazet@gmail.com>
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
 net/core/neighbour.c    | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 190b07fe089ef5c900a0d97df0bc4d667d8bdcd6..5fffb783670a6d2432896a06d3044f6ac83feaf4 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -174,6 +174,7 @@ struct pneigh_entry {
 	struct pneigh_entry	*next;
 	possible_net_t		net;
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
 	u32			flags;
 	u8			protocol;
 	u8			key[];
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index fb340347e4d88f0058383697071cfb5bfbd9f925..56de74f8d2b1c896c478ded2c659b0207d7b5c75 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -771,10 +771,10 @@ struct pneigh_entry * pneigh_lookup(struct neigh_table *tbl,
 	write_pnet(&n->net, net);
 	memcpy(n->key, pkey, key_len);
 	n->dev = dev;
-	dev_hold(dev);
+	dev_hold_track(dev, &n->dev_tracker, GFP_KERNEL);
 
 	if (tbl->pconstructor && tbl->pconstructor(n)) {
-		dev_put(dev);
+		dev_put_track(dev, &n->dev_tracker);
 		kfree(n);
 		n = NULL;
 		goto out;
@@ -806,7 +806,7 @@ int pneigh_delete(struct neigh_table *tbl, struct net *net, const void *pkey,
 			write_unlock_bh(&tbl->lock);
 			if (tbl->pdestructor)
 				tbl->pdestructor(n);
-			dev_put(n->dev);
+			dev_put_track(n->dev, &n->dev_tracker);
 			kfree(n);
 			return 0;
 		}
@@ -839,7 +839,7 @@ static int pneigh_ifdown_and_unlock(struct neigh_table *tbl,
 		n->next = NULL;
 		if (tbl->pdestructor)
 			tbl->pdestructor(n);
-		dev_put(n->dev);
+		dev_put_track(n->dev, &n->dev_tracker);
 		kfree(n);
 	}
 	return -ENOENT;
-- 
2.34.1.400.ga245620fadb-goog

