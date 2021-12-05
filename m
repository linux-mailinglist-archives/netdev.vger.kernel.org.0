Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AA046891E
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhLEE1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhLEE1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:27:35 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BB5C061354
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:24:08 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y7so4889259plp.0
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n5f/tXjsxBdlKXOqSXxOpThsLdatHM6TCJlr2uwfB3o=;
        b=eXBrW1SWconqZjJKZp/DLM4tw6OIGrbawhYs67YOCUkN6YSCgVPiMifru69aKZZzQ9
         fLcxpp1BYi8tBWQoNwPbrmPFtH6U7cMFSP6YfU7aT16yp8p0b9G0o0/mQJAETLvtjLUJ
         6ei5Q5MrW+YCxXRW57043P0iMMlSjRiTV00CvwFz71OJpPGJM0mU91Axshg/urryPctG
         JxmJokwpkQpjZx+5axt/K2X/BoKDaTapdDR+kK+FMiQaGAueo99k/SFjAlBm6qA/02eR
         Ug0ngI8r+It343Adxds28XNs7NMoBN8qS3hLiG0XC1ST8nr6CQwG0dbithca2d1Qf7EP
         MGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n5f/tXjsxBdlKXOqSXxOpThsLdatHM6TCJlr2uwfB3o=;
        b=n7QZp31c47feTuJyHX3PuU6LeXuay4zgEE1fZULdMVgU8UsRwRut0RabFPyd25N2Kl
         zak4SS7H9eEaKwOY+n/Sk8Pw1AHU96bPKkpsqxYAXANFmxN9dgsPfIQmeTi8DGi7N8bs
         XUIa+qhoWZ7TXrYqqh4n0cpvt90DKTdGyRO3KW8+7I+rDsg6OeA2aXtkBSSDN+8IGyUn
         XiF9exQ5tIpC9izfV2Ek6VQH3dJQj3+WoudS/yZFItyTuc7intuH5uZYmcTBHC7vMXrg
         2kYGJzugWK9vztmL0o7+rknKUL2M0UZAX9/4zWcTNpGrsWuHoXs+pITO/zppIIguAs45
         86KA==
X-Gm-Message-State: AOAM532qmxOVfsDVYXojbCQlKyGdRHYGHaRJhtSOmjxfIMnnhwDwghEI
        LGReZaJt7EuIt0/J4MjZG5S23VmtmBk=
X-Google-Smtp-Source: ABdhPJz+xj5kOWMG4hwjInoYz2sUi9AyoPV04gtVbFwwec3BnPWpGD6MeRAbbI2vnXaq31g6RVt11w==
X-Received: by 2002:a17:90b:1b07:: with SMTP id nu7mr27404655pjb.140.1638678248496;
        Sat, 04 Dec 2021 20:24:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:24:08 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 18/23] ipv4: add net device refcount tracker to struct in_device
Date:   Sat,  4 Dec 2021 20:22:12 -0800
Message-Id: <20211205042217.982127-19-eric.dumazet@gmail.com>
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

