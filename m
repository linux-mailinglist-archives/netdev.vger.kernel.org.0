Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF03A467043
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378276AbhLCCvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378269AbhLCCvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:37 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EB9C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:48:14 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id k4so1624795pgb.8
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n5f/tXjsxBdlKXOqSXxOpThsLdatHM6TCJlr2uwfB3o=;
        b=BowOCAx1vsK65TIeE0YAcV2kru1Ug94aaFwFVnYVvrkTtL4Xju9S+xfRwANRuIFL84
         ozK9frXUQCfG6jtc18CMyEBG1z6w9tr7ZyrOkS/v8byQLIt7XNYiMWTVdgsMLufrz4LL
         OuxddJ/2joCNpv7qyG40d8K84Hng/i0kYDGotHOgZFX+uJMubEkCRddlcUzihYO45ERb
         yMxMLUA8vHWOhjccnmT91+K/WjJUQMAJteHOSeW0aZF9xZ+15/PWnCtIeFyELOsPHgmT
         hl9gZQ7aWK1k/UYr0JnNgGbckdbtcDizMTpbPtHyutBPuha2iqp1FEzedNQE6KYVA97p
         6hdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n5f/tXjsxBdlKXOqSXxOpThsLdatHM6TCJlr2uwfB3o=;
        b=oQc6J6yzqqn07HNEQbwknSDDG2zEqIId2Ieaxnm9v6k5KXxlCS7GF7Q6GhaWAmJAim
         ya4bMOYN1pGN5/+ZmGmbNbjpc0sa7uKXsT1vH6sV56+m59MmiqEKJtYC7gZztAGq0c9I
         cleZJd3ZD+XrjQNlUj9hYzR/9ziKMGzSDLX+AOq7RNPgE7cE0ZCJVwSmwQFowBZZzvty
         88F0oq+/wS4+zPzIgiUHpuMwmI6f9KOXEt1Jek6qHhxnsNqdVt9Cv5gITvl9hmd6nP5E
         xbogiUbzKsvbE9IUbsYDwkvzIwFw1CM8/2HiLw9I+eSrUcH7JslOClj1oYx92g0rCeVx
         nPsQ==
X-Gm-Message-State: AOAM533JPhb5LDI8H5xFxte0ZfeVn0YfdHcCwq2BruwgWJBq0i1LeFu0
        UKC2mA1HLBCkYlEHjPBy98c=
X-Google-Smtp-Source: ABdhPJwp+zIIQsr1P/+EldniOkPAImCNFN4VT52G/EHmAm+nGcLJyHpn+Gva0PvXPscYNvr2KnS8nw==
X-Received: by 2002:a05:6a00:2387:b0:49f:af00:d5d0 with SMTP id f7-20020a056a00238700b0049faf00d5d0mr16716516pfc.1.1638499693908;
        Thu, 02 Dec 2021 18:48:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:48:13 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 18/23] ipv4: add net device refcount tracker to struct in_device
Date:   Thu,  2 Dec 2021 18:46:35 -0800
Message-Id: <20211203024640.1180745-19-eric.dumazet@gmail.com>
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
2.34.1.400.ga245620fadb-goog

