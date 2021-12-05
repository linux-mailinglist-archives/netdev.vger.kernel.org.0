Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF3346891B
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhLEE13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhLEE1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:27:19 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA5AC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:23:53 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id k4so7090177pgb.8
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qDwXdMqlBKlcabo1l62Px149VuPWYKtTf0Af1AK9Ihw=;
        b=PXaJn08FlOMGaQpeWd9eC+ZpbLHUAiGyKfsSYBcKmReeeCkQ8eLc9hvcA67SgjFcNR
         ePlFjl13/E22II5JRBmSmeT3aJ6n36SP08jEfkgqJJKTmuqp350kJlQJGJCpfGqQZ0QN
         EXRcYZOg7cpLSpcOKwH1MYsOVlmrxcyD6xwwwlVlR260rrKCQvfyNeFQU4P1tsyIRrpX
         86Pjkg+ye5U6Gx6SPXY5pXilPz0qVIESEPTn99uvb+KpStH6xrvVd9nHkAVQk2vcy2oM
         EGKqx/GOBaKm2ekS6kXIPZHmHRjskC5C5A2UAN3gKOtciwFf06ms2yoWGo+kFz0lxyi/
         4yPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qDwXdMqlBKlcabo1l62Px149VuPWYKtTf0Af1AK9Ihw=;
        b=rboeAnOl7023nmEDHAsDDsflHAladH7fpdoqA3rgw9ysh7eLmCnH9Psr1roi7SiEQK
         huJCr151qJPPjhd8Hdf/NL6YSlszUMBTU5SGMI1WLsUf1Yb2mFaVieV4OZEJB8QAv9IG
         1r3tlIX4yFYiJTA+mc4YgktiCW6rSyXB5Fn21BMWCY7KC0VlnSyYocmJWaKI0HWAba3m
         T0Bqsh/tFUr1J5+3K0wUkWhLqzHz3FNU3zJl3IEDpb0ZTk4x3JOUpBkjkYA+QoVMNsPN
         ki1u8zpYx4/iYPAHYY0rH5fhpu+KhG++C+zYK1aW5fIBCEWQuf/Aw4mL//80KusyeYgp
         lS6g==
X-Gm-Message-State: AOAM530uFno4uTa9SymWFHAtah7dnuMc45mq26epyppWZTjlDlNw4otX
        Czd1Q/9vFkz+y9GU11pocTk=
X-Google-Smtp-Source: ABdhPJzux6Dy2KHAXOpVK2cYI2xCOW6mAQe6B2YMcNk6I4DF0Bu4Fy/3ZpQ6RDPRrv1Dis/dzzGqGg==
X-Received: by 2002:a05:6a00:1a8e:b0:49f:a4a9:8f1e with SMTP id e14-20020a056a001a8e00b0049fa4a98f1emr28803611pfv.67.1638678232963;
        Sat, 04 Dec 2021 20:23:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:23:52 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 15/23] net: add net device refcount tracker to struct neigh_parms
Date:   Sat,  4 Dec 2021 20:22:09 -0800
Message-Id: <20211205042217.982127-16-eric.dumazet@gmail.com>
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

