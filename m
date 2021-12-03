Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779F746703F
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378266AbhLCCvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350593AbhLCCvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:25 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A697C061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:48:02 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id f125so1701831pgc.0
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GDtiZ9MlMKx0wR1tSzrOI9t3DpPfRAAmdOIzJGgoHJE=;
        b=Xpm4yZ+s5QnzE+gBYAUjlFILY1K1sF9RuBhlAlNxCOvCcDH21y0WJanM5jy7eLhkt6
         659bcKcMF7SArxEY/jHdnmrdRusRIQFZXzBsSy5DCSGadGbCgYuYLRy/AT1sM+cwn9gu
         hAUy1nYl5uZbyap3k2+76js+b0Q/bmr6Yz668ZrMRwXXP8R8Zn2q8ejWGs7etaGGhGKw
         gz0eVBubpaecUzkrrD1C8dVbi9PCRtqk7g3GW0lLwtD/x6lsbtHYfKkKfHdgQl9sNc+b
         NsU2RjrL2qrdSRRpM6gBwvpuxbXiF08TU3DK08Dm29We/XCAuh+Sv18C/k00TrmlTb7s
         jWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GDtiZ9MlMKx0wR1tSzrOI9t3DpPfRAAmdOIzJGgoHJE=;
        b=eoYf2hLwWAL3Ckdirbcp4Jaboh7B/QLuiTFoEULdC3rCPZv+w4E3q5wp86fE+0VP3+
         HSp0151RtyaxAqPUd4a067ALLwcjwkEonp7WxcaORhXrmmty9477Y7Q2aHsmWmZgMnKZ
         YFk/KggiDpCB9R6Fj5XduBRnYvkHJXGWpXOL7tSnb9NfWil6vQbwu8FLpE3gOm6+nuV5
         rLsawfAfv/kJEQ4B4n1Z1VcQcT22wJKG872TpDCY5ViCjKDEQFR0l6mIn4V0HhnYCUkH
         ZkmxTFZ5ZvACgMPf/3RChqZ/8l0JK85NSNY0Ox9j87l4kLBL06cv/6fwzqztSb0KYwb7
         JFhA==
X-Gm-Message-State: AOAM5324aAdiz15ET9ump/8hDl/j4bVc5n/7AnZlk0P0aLtwCmAA7eBz
        xAX2hrqzQoEGLn80RgEWCZc=
X-Google-Smtp-Source: ABdhPJwCv3o1R9x4ohZcdhgXhnDJjLexWrEz/i8pe55OD9K/DO1MqVnkoN/TZbLLocSsUCgQwCCpDw==
X-Received: by 2002:a62:7c8b:0:b0:49f:a8ae:de33 with SMTP id x133-20020a627c8b000000b0049fa8aede33mr16356740pfc.29.1638499681997;
        Thu, 02 Dec 2021 18:48:01 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:48:01 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 14/23] net: add net device refcount tracker to struct pneigh_entry
Date:   Thu,  2 Dec 2021 18:46:31 -0800
Message-Id: <20211203024640.1180745-15-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
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

