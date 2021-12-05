Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E5946891C
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhLEE1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhLEE1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:27:24 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE23DC0613F8
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:23:57 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 200so7139469pga.1
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=20Cb5L4Nfh6M+TGH/ohYepS0hgWA3PLHDkuxzPE2zO0=;
        b=cLBi2JBfBrtGtPzoR0ozeShjcmil67Gg+TwUsSPxDK88pqw3ppwESt/SZ6M75krWbg
         gqxwyI0+KYInMfyntgagKplQsw2R8iwyVrQM3v/0Ru5o56Osy+JeSBMqGVaAOh16tJvy
         DODEA30BXRvhldc+EiAk6THmOHT2Z5sLGkDgKEaj8N4uTtg6DvEvmjQf/IZo/JVJUCdD
         OtawmiuNR0i87z6AJpkg+E1r4onqzgB37uPERPbSioBqigOaPDt7d00oPB+FH0akQvK9
         dBd7gGAESL7CY/KVka/hONYKPp3qPIeEstdgQOIv/0bXliXzRIPcCI4ACr7hKzWlU6kX
         PCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=20Cb5L4Nfh6M+TGH/ohYepS0hgWA3PLHDkuxzPE2zO0=;
        b=fvGV3HZXZvA6xIAtZEOGV0yVIFg65ci+aLqdS0UzhwZ0Yx6Ezoi52TpJB1DgjxWo3r
         drChBZXv1v9LEXwPJcGJMlRrQ/rvru1b9w3HUde9pVClI2k8ynPNmJWYSc5cnh1kHdX4
         G+vp8mD1WvuEeyM8/MeXq4IJSz8Fb3uqU2ahHv/OOCwz9BsHm0cxmaFotKpZtLujXvT9
         WdzON+0+9S6GawQouvBdklfyxo6XP6biizf/TE7E5q88UGkgvNuKIR5HZCWLU67IuSnV
         au718oR3GtSvHWpGaVI7bfip3EE+zfhlNvcofnj1/7yeyOERCh+dPUENBlYTbwNIrgXs
         AD2A==
X-Gm-Message-State: AOAM531jvzbjd8dMUG9VOybX9yVOZVmagZWZpOXxCb1m8zmgDpnTEFC8
        WxPg7RW0DmfcUVUnp2JZ9nM85ALng+I=
X-Google-Smtp-Source: ABdhPJxw3OoMEj4f+yOyHgZVNuOjOMpaFZ5o+CGG1WC8he6btRmJ3R97W5HGssMUyZeExkqd4kke3g==
X-Received: by 2002:a05:6a00:2af:b0:4a2:a6f0:8eec with SMTP id q15-20020a056a0002af00b004a2a6f08eecmr28389750pfs.23.1638678237554;
        Sat, 04 Dec 2021 20:23:57 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:23:57 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 16/23] net: add net device refcount tracker to struct netdev_adjacent
Date:   Sat,  4 Dec 2021 20:22:10 -0800
Message-Id: <20211205042217.982127-17-eric.dumazet@gmail.com>
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
 net/core/dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1740d6cfe86b58359cceaec7ee9cc015a3843723..4420086f3aeb34614fc8222206dff2b2caa31d02 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6537,6 +6537,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 
 struct netdev_adjacent {
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 
 	/* upper master flag, there can only be one master device per list */
 	bool master;
@@ -7301,7 +7302,7 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	adj->ref_nr = 1;
 	adj->private = private;
 	adj->ignore = false;
-	dev_hold(adj_dev);
+	dev_hold_track(adj_dev, &adj->dev_tracker, GFP_KERNEL);
 
 	pr_debug("Insert adjacency: dev %s adj_dev %s adj->ref_nr %d; dev_hold on %s\n",
 		 dev->name, adj_dev->name, adj->ref_nr, adj_dev->name);
@@ -7330,8 +7331,8 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	if (netdev_adjacent_is_neigh_list(dev, adj_dev, dev_list))
 		netdev_adjacent_sysfs_del(dev, adj_dev->name, dev_list);
 free_adj:
+	dev_put_track(adj_dev, &adj->dev_tracker);
 	kfree(adj);
-	dev_put(adj_dev);
 
 	return ret;
 }
@@ -7372,7 +7373,7 @@ static void __netdev_adjacent_dev_remove(struct net_device *dev,
 	list_del_rcu(&adj->list);
 	pr_debug("adjacency: dev_put for %s, because link removed from %s to %s\n",
 		 adj_dev->name, dev->name, adj_dev->name);
-	dev_put(adj_dev);
+	dev_put_track(adj_dev, &adj->dev_tracker);
 	kfree_rcu(adj, rcu);
 }
 
-- 
2.34.1.400.ga245620fadb-goog

