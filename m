Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824C5467042
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378272AbhLCCvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378269AbhLCCve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:34 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A54C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:48:11 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 137so1655012pgg.3
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K+AadUv33QFmjFDOBOvnFpBm7Lw7zZYJtLUilhe63TU=;
        b=ZJ4PlXxjX2lftb8BX5v0JSYBVXhN/flxonV6GkHwzVI0o0qOKeUZoNCfjR9nJTmVF5
         cPFWpAJdRk53+t+meXand+XoH3Qbp6S/OM4/Srcisg1oBlKHCuXAGRUxQqwTNWpqVx68
         a2VVEi4KJqPaUf1ujJ6zgA8oi9h20lxmCgKRIfdgeZn1YcItZmCOcYDqGa/jPklVGbGp
         YQDZo6RPIi6cK0mI5sEevS2nqkVr81jsTaQXFYOupMs0w3OGkovFb3lGFZDgSBdgO3gi
         PrIXKmh+9P3VWR9Qmfwu/FfufT6Uvx9pPSnijekzbceKZWURxEULnjZlTGNyuGTP9mxB
         N+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K+AadUv33QFmjFDOBOvnFpBm7Lw7zZYJtLUilhe63TU=;
        b=VsWVEzFLWzlXhojXXfZ5PxC0P7sg7YtT+n7zBRAwsM4UXOTg6QnguR0DxA8A6Pym5f
         +RPYc0U8gdXHImYZ+DDl1tQKG8zF5aqBGgzxzlkbw3gIkyOjTH5cuUI4HSenUt3MSPl7
         VhHcCzPWmxKFBYjdsbo8nxtG/CLZ6JhGTujehUTMhIe72cqV930XeM2tIS+/WjMa23Mz
         AYWwSjfHvZxcNawc9ZC09NTR7IulCOgUgINPBosDnJmLMtfCWO83jPyB0kzO9PmjYI0b
         BtHM7Qk2iVtIAEvVQD1atk3wP+pyJ7aWpgs8ATxPhjipf4yPK1HfxyDPULzsKN/qHnpK
         h6lA==
X-Gm-Message-State: AOAM533RyQIq8FiAHNYMO1Y/Q9ZOcKdJjw4VBa2uECzkdmJuKJCz+3va
        BgegghVGeI0TEB0x6cgXDgg=
X-Google-Smtp-Source: ABdhPJwQWmUo3EeJjEmhqdCdAErHrw4N1NCmN1Smpz9OC+/QpFBAtjb1RCm7Ah3jeRt50qwPScGJhQ==
X-Received: by 2002:a63:6a82:: with SMTP id f124mr2529692pgc.154.1638499691248;
        Thu, 02 Dec 2021 18:48:11 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:48:10 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 17/23] ipv6: add net device refcount tracker to struct inet6_dev
Date:   Thu,  2 Dec 2021 18:46:34 -0800
Message-Id: <20211203024640.1180745-18-eric.dumazet@gmail.com>
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
2.34.1.400.ga245620fadb-goog

