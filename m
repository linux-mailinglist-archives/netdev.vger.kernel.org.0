Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D788E1B3
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 02:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfHOAKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 20:10:50 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:43109 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbfHOAKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 20:10:48 -0400
Received: by mail-qt1-f201.google.com with SMTP id p56so927076qtb.10
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 17:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lGPm9MxbmAUQCAKDVOCo9m8+lWvsCTcXX7D5eQLMP4k=;
        b=Mp3lCcnBAHWzuwotdFJ22/AnWkFC0KJLTXRTjmTsZog9RCRoX7t4+uC3KkmfklMhZA
         xfixkm4outUQ2EvOnnh9fqnqogx0m/bINTwQ9Hi+JHx8RqDqpGBid4/RJAvE9HQL9i1L
         IRH/tAgSGu0tLg17w59p/VfJInZcgQoviKmW1elQsFCquQQpOZhvMNDvW4OCyawK5MAK
         rQFwua4Qk3tqpabsg9uCU6tUlXj1fErtnuCV2HdNPppRsyy1cZmip0OxAcFbxfNTtXvE
         wPaB55GpTTPCqJ7XJqbFBEVxuvgRD1Boq64oKXwC2+aTuJp+VM34PCHcV+LiiuQoNx9e
         ZTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lGPm9MxbmAUQCAKDVOCo9m8+lWvsCTcXX7D5eQLMP4k=;
        b=YnGxUZa4BnKAcxptD3op5BA0rPSM9pYQs/XDIzAT4svKvjET3saNjSXW2XLgC6+Wi6
         XgH+sqgFV7Hyp0unGGT7otljlNCcf1u2mM9e2xRQZeVaFuPESaOxO5JcXHCP6/Ajyzkm
         53ptup5IsLo89eMmCeCo3kEcdJQQnUkTEOQto6MViBH4Mf9c4zKKVxHLVBFZ1Qc08pcI
         TV2WFFOlQtxhJKa2uO5Xu3wr8nxxBz6SQKuWN5uHLiQCKTOILRXlxPJLWAQIEytoViaz
         4o3anG0z9p1UTPI8l4YAfoF2L7l3ovMYej54XVLTM9mIkRw8Mw4Wq2qjSDW7QWAhjM9w
         v36g==
X-Gm-Message-State: APjAAAXFTbpDSvRyZUxUbFGFRmxy3ibgbw3lTBwrHRGZ09RPjuHDszPg
        d/jLWNxgzbp1JkTJehKRm/JN3uh2wPJnZdax9Q==
X-Google-Smtp-Source: APXvYqz9Ui9f44A9T7dzKwgLs4cZuRrliuHzLHIwhhWkG/wEx/eeWTDelEvSgYt0nTo+rRU82eHwlulVhw1WZVWTjg==
X-Received: by 2002:a37:4c92:: with SMTP id z140mr1741376qka.245.1565827847608;
 Wed, 14 Aug 2019 17:10:47 -0700 (PDT)
Date:   Wed, 14 Aug 2019 17:10:43 -0700
Message-Id: <20190815001043.153874-1-wsommerfeld@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH] ipvlan: set hw_enc_features like macvlan
From:   Bill Sommerfeld <wsommerfeld@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YueHaibing <yuehaibing@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bill Sommerfeld <wsommerfeld@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow encapsulated packets sent to tunnels layered over ipvlan to use
offloads rather than forcing SW fallbacks.

Since commit f21e5077010acda73a60 ("macvlan: add offload features for
encapsulation"), macvlan has set dev->hw_enc_features to include
everything in dev->features; do likewise in ipvlan.

Signed-off-by: Bill Sommerfeld <wsommerfeld@google.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 1c96bed5a7c4..887bbba4631e 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -126,6 +126,7 @@ static int ipvlan_init(struct net_device *dev)
 		     (phy_dev->state & IPVLAN_STATE_MASK);
 	dev->features = phy_dev->features & IPVLAN_FEATURES;
 	dev->features |= NETIF_F_LLTX | NETIF_F_VLAN_CHALLENGED;
+	dev->hw_enc_features |= dev->features;
 	dev->gso_max_size = phy_dev->gso_max_size;
 	dev->gso_max_segs = phy_dev->gso_max_segs;
 	dev->hard_header_len = phy_dev->hard_header_len;
-- 
2.23.0.rc1.153.gdeed80330f-goog

