Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C1C467040
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378268AbhLCCv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350635AbhLCCv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:28 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF69C061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:48:05 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id x7so1277596pjn.0
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qDwXdMqlBKlcabo1l62Px149VuPWYKtTf0Af1AK9Ihw=;
        b=fC3aHnhDfoJcvt6dII6L3QZKE5iQbTT+0XqidI7SJdA03Dp//FCFp2bQKbVjGFVfs7
         sMJ29A5cdOeH1VHxCFzzZ0WPqRZuB/ZzY2gpHLn8tvTKjvYemrxSVVzp9kTJ3axJ695k
         DPoKrlamBBbsidPSmSPSlukQPaE8X0oaQZiuSvrOGe/07uP0eDfSn9wqeBc+2pemmi/7
         Gv8nLK3onTkCYaVVnI28n/VcpdHLk8AH5sf4NO4LWo0jG/zjXyey49uvI6j8sUI0YWSE
         uxqF+jzNUxIf53q1wWVklJRlAUoFyRmKTKp+OSTNGw98yXPf43t38GlztccbdcMSLLcu
         o+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qDwXdMqlBKlcabo1l62Px149VuPWYKtTf0Af1AK9Ihw=;
        b=yd496Ruvxv6OB/mNPYxJsblhMT/Uqqo2IfHYh97lF4WLlxY9htGc/rU7uGrjGsGA0M
         4A3NhyLEwyJdDBfHaN1EyVTciYk2yyF0Owvajdb4Rsxx+oWT+zqe+e6a7tG7G2SCz90G
         DhSKFS0EbjJLnSzHj+KPbEoKrrhAnVJ4xzizK21Ozmz5xhHvok3xmnNuo7ev75RpF381
         cuAoLXFLr4XxYy26v6fS6OKiPy/mFH16V2frgNV922cD7bcU2chpDs0phEHLQuWm2YZs
         votRvwUqq78fnM8POSLMijw+JqCqPIBA5y3beHqdw20fY26qP+6p1xgkn0cuPFg02wzl
         YpVg==
X-Gm-Message-State: AOAM531UcroNeNZ9uwl+g9uwOb1MLlBFLCz2R4m0PBHDkeFSiUOImuiB
        GrnhO/f7wMyBy+D+yA6mpHM=
X-Google-Smtp-Source: ABdhPJwKwmJiFKhX5HFwT5SAbCS4sMDB/LCJPhLBqtd6w+I8E89rvU0cHLY/g0nmX/g1fWkZy6Y6mQ==
X-Received: by 2002:a17:902:8d8a:b0:143:bb4a:d1a with SMTP id v10-20020a1709028d8a00b00143bb4a0d1amr19599467plo.1.1638499685464;
        Thu, 02 Dec 2021 18:48:05 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:48:05 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 15/23] net: add net device refcount tracker to struct neigh_parms
Date:   Thu,  2 Dec 2021 18:46:32 -0800
Message-Id: <20211203024640.1180745-16-eric.dumazet@gmail.com>
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
2.34.1.400.ga245620fadb-goog

