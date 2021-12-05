Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D3C468916
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhLEE0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhLEE0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:26:41 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23B6C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:23:14 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so5694380pjb.5
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SqS8l1rp8xDuoheLvvuPOhg+iERtHrbdIDpDHRwHj/U=;
        b=f49k55VpBuP4tApjIDMq2zpCGadCwlFgYc/TCMBnPotg5TA9lHs+JSU6/Gx7DBmnwr
         JfupV7YxDGt4C9GrmkyLzkkYB0IKvXI6d3gH2TIZtutU//9YkcW39IUD0kGrCARfHEfo
         EApUsLihgpxFp2M9cJ8IxClOYW1+K5j6zTIXW6QlQgKGmXEItEJsXoMjbop/fg/AeF4x
         EY1DgVogOCWbZNEbrmfl6+EdWobsjo6VfPpQPYWOpgWdOGG2XlBzK4wxo/u2kvg4m/kp
         9jqHgddO6DzBZT2cdtPbc91EBT37B+A9htmGVjFfio3qbEXqsfo0rMwGpWP95QcnZ+YG
         /wLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SqS8l1rp8xDuoheLvvuPOhg+iERtHrbdIDpDHRwHj/U=;
        b=Z7h+QEF9z7zJZuy9hwhUmGIr4tQ6qZSOclhAFx0Tc78iLLWcoLp+mAP0Ge/vkwYtJc
         YgzotcOv1GYQHy247TtJ3gpT+DWUOnYMz6q1OpRdJq/TKti8Tm3nULi6hybrJBS5olHO
         Cc+lPQpFj9q0ux7glWkXpAsvsCBLxmt7JKlXb4FugDA1qsqDqw09FGvAGFagylXOMX3X
         ckKYD+Aw90POybXC3eGCNJxMBdJVpPTOAvLraj86G2vJzo/79vaMEoRuStecuJHR70d6
         NzTtxlBcoOeqGyOTzB6oZMUbphtJ/2ZkDB3MkIHoOHleEJwgE7gmxLsg1stuPV2Kd5Dv
         1eAA==
X-Gm-Message-State: AOAM532trT7Jtz/zAm1vUzTof98ff6+NlDMMmE/aIJ7KdH4yIzNxhak7
        1LyLSSx1PptcScRMtwkUzPo=
X-Google-Smtp-Source: ABdhPJxzb1a+maOKzOjMzMu5G+9TJpG8VKv7iVzokrn3nlOp3YB8A+MdrpT0Gf6NHbcdCvfGTuxFtw==
X-Received: by 2002:a17:90b:1b4a:: with SMTP id nv10mr27004433pjb.118.1638678194536;
        Sat, 04 Dec 2021 20:23:14 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:23:14 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 10/23] ipv6: add net device refcount tracker to rt6_probe_deferred()
Date:   Sat,  4 Dec 2021 20:22:04 -0800
Message-Id: <20211205042217.982127-11-eric.dumazet@gmail.com>
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
 net/ipv6/route.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index ba4dc94d76d63c98ff49c41b712231f81eb8af40..8d834f901b483edf75c493620d38f979a4bcbf69 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -593,6 +593,7 @@ struct __rt6_probe_work {
 	struct work_struct work;
 	struct in6_addr target;
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 };
 
 static void rt6_probe_deferred(struct work_struct *w)
@@ -603,7 +604,7 @@ static void rt6_probe_deferred(struct work_struct *w)
 
 	addrconf_addr_solict_mult(&work->target, &mcaddr);
 	ndisc_send_ns(work->dev, &work->target, &mcaddr, NULL, 0);
-	dev_put(work->dev);
+	dev_put_track(work->dev, &work->dev_tracker);
 	kfree(work);
 }
 
@@ -657,7 +658,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 	} else {
 		INIT_WORK(&work->work, rt6_probe_deferred);
 		work->target = *nh_gw;
-		dev_hold(dev);
+		dev_hold_track(dev, &work->dev_tracker, GFP_KERNEL);
 		work->dev = dev;
 		schedule_work(&work->work);
 	}
-- 
2.34.1.400.ga245620fadb-goog

