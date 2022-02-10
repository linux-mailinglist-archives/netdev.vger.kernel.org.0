Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29FE4B17CD
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 22:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344740AbiBJVmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 16:42:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344766AbiBJVmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 16:42:44 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7052B197
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 13:42:44 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso6893690pjh.5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 13:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o7qxZjiOeYyr10sIEQm2OIgJQXTVAJpUcNUmvwaLp6s=;
        b=L+mJDbFwAnllOUL2CeVfIK8UxsD4IgxBVal6MdpZNojuFtbs11kvmenNwl8LwInFFw
         Gb8C6Us7OOQr4bsrLDlhnTlznA5IMkV4Fh78vEbobUBUg0npzA6U3ZbJaAtEfA0ZDyoA
         IBTrn5xd+n1gbYTXv6nwS1pmdTTry3nmrvXj/gxWtYmWziXG3efo2y+FbRZEBlofBOqE
         rJiWy4UOfgKopX1qGEDFra/JQu8tYZJsJMzSbYpBiiynWwPQHYyGERXQvBSZVpYd4ho6
         St2/hPmEqO5uc25TcvMrwIIW3v07WTHZHg3eO+mEzOZ2BDmYs8KXN8wmEyBnoe0ZZqwH
         drLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o7qxZjiOeYyr10sIEQm2OIgJQXTVAJpUcNUmvwaLp6s=;
        b=ahymY/8QVP++Q7LU/2oMPGDKs/bkc9yKAAWjPmVc1qgr06OGCiP1ovOBpfhHdyJ1Kq
         Nb2UqSJIQz86rXzE8AS7oz0hXcL/NMqcNPVlT8wj8DbyDJ4itTroVKH2kd4l4RSCftbJ
         L/T1neFmJHpViFLlLRrpjSTnEs5e1szj2hlHsoCmkfu/CsCn5RxxLuY4IDjd0sm9UzrU
         Ghg/sO3s7E2gEseWu04ktV+2RZHdO/CA38wR5lZIMs1esPmU0aXHIQ5Y2L2g1UeqWWUF
         P3jMK6DBjMU/OrXhpX0ZkchzR6vnTIoVHbCDAfejI6JinVSnLZfAVqOtC5xI4tAnVoVn
         gzGQ==
X-Gm-Message-State: AOAM532X+Yw8LvzVVWugjdEuiI4vfZ6LEaFBOJ6Aw2NpgcDu7jb1ij5I
        ICEqOtN3es0cFUzWhK6qvHI=
X-Google-Smtp-Source: ABdhPJwklsFKRkwhSQ2bfLxqK94nVQp5p/SGhUN/FDErL+ExPJQVGi3N8qFZKrxYxk774zgUjx8gMA==
X-Received: by 2002:a17:902:eb8c:: with SMTP id q12mr9639354plg.131.1644529363968;
        Thu, 10 Feb 2022 13:42:43 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:60c1:10c1:3f4f:199d])
        by smtp.gmail.com with ESMTPSA id s19sm23824098pfu.34.2022.02.10.13.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:42:43 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/4] ipv6: add (struct uncached_list)->quarantine list
Date:   Thu, 10 Feb 2022 13:42:30 -0800
Message-Id: <20220210214231.2420942-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220210214231.2420942-1-eric.dumazet@gmail.com>
References: <20220210214231.2420942-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This is an optimization to keep the per-cpu lists as short as possible:

Whenever rt6_uncached_list_flush_dev() changes one rt6_info
matching the disappearing device, it can can transfer the object
to a quarantine list, waiting for a final rt6_uncached_list_del().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/route.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 5fc1a1de9481c859adc332746ccfcf237db6541f..6690666c9b0e32e7e801ac481876ea4aa31e4ead 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -130,6 +130,7 @@ static struct fib6_info *rt6_get_route_info(struct net *net,
 struct uncached_list {
 	spinlock_t		lock;
 	struct list_head	head;
+	struct list_head	quarantine;
 };
 
 static DEFINE_PER_CPU_ALIGNED(struct uncached_list, rt6_uncached_list);
@@ -151,7 +152,7 @@ void rt6_uncached_list_del(struct rt6_info *rt)
 		struct uncached_list *ul = rt->rt6i_uncached_list;
 
 		spin_lock_bh(&ul->lock);
-		list_del(&rt->rt6i_uncached);
+		list_del_init(&rt->rt6i_uncached);
 		spin_unlock_bh(&ul->lock);
 	}
 }
@@ -162,16 +163,21 @@ static void rt6_uncached_list_flush_dev(struct net_device *dev)
 
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul = per_cpu_ptr(&rt6_uncached_list, cpu);
-		struct rt6_info *rt;
+		struct rt6_info *rt, *safe;
+
+		if (list_empty(&ul->head))
+			continue;
 
 		spin_lock_bh(&ul->lock);
-		list_for_each_entry(rt, &ul->head, rt6i_uncached) {
+		list_for_each_entry_safe(rt, safe, &ul->head, rt6i_uncached) {
 			struct inet6_dev *rt_idev = rt->rt6i_idev;
 			struct net_device *rt_dev = rt->dst.dev;
+			bool handled = false;
 
 			if (rt_idev->dev == dev) {
 				rt->rt6i_idev = in6_dev_get(blackhole_netdev);
 				in6_dev_put(rt_idev);
+				handled = true;
 			}
 
 			if (rt_dev == dev) {
@@ -179,7 +185,11 @@ static void rt6_uncached_list_flush_dev(struct net_device *dev)
 				dev_replace_track(rt_dev, blackhole_netdev,
 						  &rt->dst.dev_tracker,
 						  GFP_ATOMIC);
+				handled = true;
 			}
+			if (handled)
+				list_move(&rt->rt6i_uncached,
+					  &ul->quarantine);
 		}
 		spin_unlock_bh(&ul->lock);
 	}
@@ -6721,6 +6731,7 @@ int __init ip6_route_init(void)
 		struct uncached_list *ul = per_cpu_ptr(&rt6_uncached_list, cpu);
 
 		INIT_LIST_HEAD(&ul->head);
+		INIT_LIST_HEAD(&ul->quarantine);
 		spin_lock_init(&ul->lock);
 	}
 
-- 
2.35.1.265.g69c8d7142f-goog

