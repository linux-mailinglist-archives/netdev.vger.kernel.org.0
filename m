Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8BC46AFD2
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245107AbhLGBfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245099AbhLGBea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:30 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B286C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:01 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so1308798pjb.5
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zMLxuBkr1/zzwEczBt883CMhryMr7pdXtAV6W0rtThY=;
        b=SimEhnlujAR4s95i7KplsORdsSp0CTAhhOEIGYaM9vaQ1QamZVaSnbcSbHTBWyTccC
         GP7+yjgLxrl5NObI7BtfcZMTW5BwHkmWqjLxI75qqRvbQ5xA6SgJjNvu97hTjNFhLivc
         xxVAt2dP5RsIVJ1F1qwdWXSxIcN70475/sBlvBN5uGGRZxQCYES90L3AaZwh1G4Kgxl9
         Ibi29OJ1C8IeIikEVyIEqjhdQwg3y+if3N8x7W3GhTZAnZa4KgEx14FxKvKh3NpQnIKM
         yiyFBhRXdqI9MWM77uh5TqvRkaYQtGN4SW+KpWXXPPXuhrnmxtTtqVv2qYQDOgagj5PO
         rxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zMLxuBkr1/zzwEczBt883CMhryMr7pdXtAV6W0rtThY=;
        b=SiyUQPlnJp+algMGWenByXJON3/E91XEIGqk2evD17Dx57Gw8cgGNBHJNmQes9mUIF
         sB1FMGnsEegMxwK5Trxf2jtRuq/0eCpa4vTonZ4ZAvl/bNWYJjjw1lxpfrid65k46g2x
         0SNYR4vETfubo/gnaJXAN/dzVEA4a10PUjIugoHWUISWkpaY0IJSxFeKeYRf8gkDBWwR
         0kY10xVZZoygVybcfgp9xw6wOszCCSWsEOviH54DiNxUYP4e9eZDdw+o+/1wSsKDzSMx
         GbMg76W0HTT+iSHkKeMhneXyqegi0jTR5s9W3U1qR+TMcBQgSUP3SV5vpktc8cxlNaRu
         ZRYw==
X-Gm-Message-State: AOAM530PWtHASBkOgNVX0/8a9kjvkVHvlW/k9Yy0KxHbxg0kajSEzY4J
        ZP6G1e3HYzOyeS0BZaf/ekVBhIC63Iw=
X-Google-Smtp-Source: ABdhPJxhdXt++Nyn7WK/gd/bHeV6w/0InLD77gRod8Pu2uSOdmXTgKC8uGxyDCDF9ECbjJwpiWJNdA==
X-Received: by 2002:a17:90b:3e85:: with SMTP id rj5mr2817776pjb.172.1638840660603;
        Mon, 06 Dec 2021 17:31:00 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:00 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 03/13] net: bridge: add net device refcount tracker
Date:   Mon,  6 Dec 2021 17:30:29 -0800
Message-Id: <20211207013039.1868645-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/bridge/br_if.c      | 6 +++---
 net/bridge/br_private.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 3915832a03c25e22ae2215ee93dceb0f8e5b5cc4..a52ad81596b72dde8e9a0affccd38c91ab59315d 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -274,7 +274,7 @@ static void destroy_nbp(struct net_bridge_port *p)
 
 	p->br = NULL;
 	p->dev = NULL;
-	dev_put(dev);
+	dev_put_track(dev, &p->dev_tracker);
 
 	kobject_put(&p->kobj);
 }
@@ -423,7 +423,7 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
 		return ERR_PTR(-ENOMEM);
 
 	p->br = br;
-	dev_hold(dev);
+	dev_hold_track(dev, &p->dev_tracker, GFP_KERNEL);
 	p->dev = dev;
 	p->path_cost = port_cost(dev);
 	p->priority = 0x8000 >> BR_PORT_BITS;
@@ -434,7 +434,7 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
 	br_stp_port_timer_init(p);
 	err = br_multicast_add_port(p);
 	if (err) {
-		dev_put(dev);
+		dev_put_track(dev, &p->dev_tracker);
 		kfree(p);
 		p = ERR_PTR(err);
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c0efd697865abea651263fc5258715e50c151726..af2b3512d86c8bc0fe799d9d698fa9b6bf3cb94b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -344,6 +344,7 @@ struct net_bridge_mdb_entry {
 struct net_bridge_port {
 	struct net_bridge		*br;
 	struct net_device		*dev;
+	netdevice_tracker		dev_tracker;
 	struct list_head		list;
 
 	unsigned long			flags;
-- 
2.34.1.400.ga245620fadb-goog

