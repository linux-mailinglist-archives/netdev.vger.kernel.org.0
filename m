Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B74465CB2
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355199AbhLBD0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355200AbhLBD0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:26:42 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75237C06174A
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:23:20 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u17so19220337plg.9
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/TH8J1Lr+N4KAbDXmbqKcN2jE+PzC1W24r5HvEEpBqo=;
        b=AmKsazsWejGUo2unyC2OMpATsNtBIRZ0lN5mNiOwOz5b54TSHhMcg53a9DceiNmTVV
         iyiqfKfYfKCyzKM4JYaLMOBcBOyjzw655HmozgOwd350JH1L7HCLMny4j8SpERllpvH0
         EjcA8Wob5/Odjh+NSlSNbsLEUkWnoYO6BRv5M4CF6NcaLxu07BQONR0l2Z4rd1fnvE7p
         6YlcVNjfzl/X54xXses/acguJvkzcTsSTGcb5TepG2udn+SPD0YDU5n1LnMCz5yjTEyx
         JeYQJm3AS9i0JwwoaadmQwjzGEQedELdEzG9cOqbKkkxEoeL1BkdNeOk5jy1BeK3/rUg
         xMkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/TH8J1Lr+N4KAbDXmbqKcN2jE+PzC1W24r5HvEEpBqo=;
        b=ai2vMEHq/nvt/6D139UL0hsUFMkkcg/3IDiV9xxs9/fIcDvmpz9gTRG80be2uSro9G
         fiCDKye5sf3U8G1BxTl1gorjrkqUTrX/dipacTCRqgT5lFG9AGlBVTbrrQXfY35wrx9F
         U811PIc7ncyto77j7372IDuH87oUwYCt/D6jJJlWfTjZCp+FllUO3jYSdNCwJhbvtZYF
         Fql2jHVe50cBf3w27rlvNifJaxgHyIVtBE/wCEfgXrzs6E4UIi3noLkTYBN6VDt/TmAg
         hgkrTEmvcVvkpvPSyRg7qmrYD7xQHwDsQhzQrUV0n2WSea/LCbQ6dvq9gxg1KpFxg72c
         I8VA==
X-Gm-Message-State: AOAM531e6WfZQIedxZeU24oN4XlAL/49HWWUZ4AMKR1Fl/G5HRcs+e9q
        SVgJpOahMjEd7uGWvHzDiNc=
X-Google-Smtp-Source: ABdhPJyfbPiJU8WkYjzUPOf6WTi2i369dzHvL5zSu5mMvPj8XxA3wce9Dwb/n3JO2TE+njwLjgH3+Q==
X-Received: by 2002:a17:903:286:b0:142:4abc:88b8 with SMTP id j6-20020a170903028600b001424abc88b8mr12455719plr.25.1638415400038;
        Wed, 01 Dec 2021 19:23:20 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:23:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 16/19] net: add net device refcount tracker to struct netdev_adjacent
Date:   Wed,  1 Dec 2021 19:21:36 -0800
Message-Id: <20211202032139.3156411-17-eric.dumazet@gmail.com>
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
 net/core/dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index bdfbfa4e291858f990f5e2c99c4ce0ee9ed687cd..337d927500af3c6332d7e2635449f9d4a9be007a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6534,6 +6534,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 
 struct netdev_adjacent {
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 
 	/* upper master flag, there can only be one master device per list */
 	bool master;
@@ -7298,7 +7299,7 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	adj->ref_nr = 1;
 	adj->private = private;
 	adj->ignore = false;
-	dev_hold(adj_dev);
+	dev_hold_track(adj_dev, &adj->dev_tracker, GFP_KERNEL);
 
 	pr_debug("Insert adjacency: dev %s adj_dev %s adj->ref_nr %d; dev_hold on %s\n",
 		 dev->name, adj_dev->name, adj->ref_nr, adj_dev->name);
@@ -7327,8 +7328,8 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	if (netdev_adjacent_is_neigh_list(dev, adj_dev, dev_list))
 		netdev_adjacent_sysfs_del(dev, adj_dev->name, dev_list);
 free_adj:
+	dev_put_track(adj_dev, &adj->dev_tracker);
 	kfree(adj);
-	dev_put(adj_dev);
 
 	return ret;
 }
@@ -7369,7 +7370,7 @@ static void __netdev_adjacent_dev_remove(struct net_device *dev,
 	list_del_rcu(&adj->list);
 	pr_debug("adjacency: dev_put for %s, because link removed from %s to %s\n",
 		 adj_dev->name, dev->name, adj_dev->name);
-	dev_put(adj_dev);
+	dev_put_track(adj_dev, &adj->dev_tracker);
 	kfree_rcu(adj, rcu);
 }
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

