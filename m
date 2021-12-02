Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710BE465CB3
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355198AbhLBD0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343623AbhLBD0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:26:52 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E45C061757
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:23:29 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso3503816pjb.0
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5toKGzfgoX9Zic6erot0JqtltzqshyxoLAvATvfXmGc=;
        b=WQ2hxhp4Ic+fRzsFdAw1Brw51Qa46fDfaN8DmcbVxgvjnLFVjmA8dhsvDmUjug30Q0
         mOb6OAspfxeN1XI7CbCs/amlUNXvj/XNauURXuSBBJXoHvK2Hbrj5oXsjaKUvFmsnv1U
         YiSxde8T9CXVBQcFJWOujslG+M8OS2jMneZbrz49Uxz3iS/mKlPK1hgN/hbCI+rO6f9v
         PpkWGxhHPVvEw+uajwSoNB/L0DPI25LCaDvCL5hmUtzkbRRfLn1yDPiOO6uWM6cjl/ZE
         lyfYQ1zebjEYWLIxMjbf+xamAkItahzUUFKcvHfxOJDEcPgfipRoO0SROX8Stbs9vv42
         ZzJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5toKGzfgoX9Zic6erot0JqtltzqshyxoLAvATvfXmGc=;
        b=Bc3SJA2fUfg48ZMt3QQ5jMb7hQ9lMGN5zHK4JDkA6767NXQyNH5Oo/m6x3kiD2Myvb
         XK5ZzSf3nBqow/tsj2H5SYLJt1Ce1SyDkoI7yqhxbC/5LCTsT1XGgf1DvBkKXDOtoL6Z
         NzEM+hqs0NSZO+38UDeoLq9lKjDwx3ngeQGcNuJ9PP3/JLpMhgI2Up27aWQ5xOM8xLUe
         PBhj1oLuwDO4FzCfv0d/EI7GabBXv0B2Kgoq6nedVx/3WcZpquvA6QIJ3xXZz0EgWGro
         s03oHVJgVwBKqbVkPDtCntfG5y/9WvbODL/oD76lwztT27bnq9/H3489gZugZMwRZSec
         qg0Q==
X-Gm-Message-State: AOAM530D739ox2EdWaqlWm6n5aiXeB8chfid6U/bMBV8k5w3N4sR+Zli
        ec9cx0+vbG9g8YqLaNoBeG8=
X-Google-Smtp-Source: ABdhPJzc8egj2ODlLcBjm4JjYC5SBWRa6pWwphH0f+IPMVN1Uc5ylxT04JXK/5bEL2YkydNKGyVL4g==
X-Received: by 2002:a17:90b:1d07:: with SMTP id on7mr2907961pjb.45.1638415408949;
        Wed, 01 Dec 2021 19:23:28 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:23:28 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 17/19] ipv6: add net device refcount tracker to struct inet6_dev
Date:   Wed,  1 Dec 2021 19:21:37 -0800
Message-Id: <20211202032139.3156411-18-eric.dumazet@gmail.com>
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
 include/net/if_inet6.h   | 1 +
 net/ipv6/addrconf.c      | 4 ++--
 net/ipv6/addrconf_core.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 653e7d0f65cb7a5e7458daf860215d1873c532e7..f026cf08a8e86c54ea5d9f1abddd5f0e3caf402b 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -160,6 +160,7 @@ struct ipv6_devstat {
 
 struct inet6_dev {
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
 
 	struct list_head	addr_list;
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3445f8017430f145496bad78afd6378bf5cb1c02..3eee17790a82fe6c528db4e821b11444cfa26866 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -405,13 +405,13 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	if (ndev->cnf.forwarding)
 		dev_disable_lro(dev);
 	/* We refer to the device */
-	dev_hold(dev);
+	dev_hold_track(dev, &ndev->dev_tracker, GFP_KERNEL);
 
 	if (snmp6_alloc_dev(ndev) < 0) {
 		netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
 			   __func__);
 		neigh_parms_release(&nd_tbl, ndev->nd_parms);
-		dev_put(dev);
+		dev_put_track(dev, &ndev->dev_tracker);
 		kfree(ndev);
 		return ERR_PTR(err);
 	}
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index 1d4054bb345b72204179c17b4ebc69e11e3faf53..881d1477d24ad5af79fd744bee1e0792fcfa483d 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -263,7 +263,7 @@ void in6_dev_finish_destroy(struct inet6_dev *idev)
 #ifdef NET_REFCNT_DEBUG
 	pr_debug("%s: %s\n", __func__, dev ? dev->name : "NIL");
 #endif
-	dev_put(dev);
+	dev_put_track(dev, &idev->dev_tracker);
 	if (!idev->dead) {
 		pr_warn("Freeing alive inet6 device %p\n", idev);
 		return;
-- 
2.34.0.rc2.393.gf8c9666880-goog

