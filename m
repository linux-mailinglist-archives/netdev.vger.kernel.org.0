Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA97468917
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhLEE0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhLEE0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:26:51 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD01FC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:23:24 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id np3so5258741pjb.4
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CC+G1w21LFBn90K6gAip7Dqueu3xcesCxWFiIThECwY=;
        b=DlXXXJAY5LB9AbdISdFL9Xt6wdvc8boUjF7VuawRxj0fPG2cspkufLhYyJ4gvKIYk+
         xmtozZ8AW3mvVMMP3ayiJY9SeLo7P5xiKI5mbfaZ/so9avJMkZghqMmtfxZf7xL0lJJe
         a6qCp63XadUNaDf+ueo9x5w5kyPkIJBUdwn4zjuUMbXbCfB4rsbi/u+gDfhcghoTc6T7
         MyMRHi50xEtA8n63++O375j/O0MpC0IDw1Rot7bRmbuQpDAr3VCeJLTHwvv3ZAHc14Ya
         ml7P4GEnWsg4iHtg9Okbr2c5Ra5MAvCG81TEoFAEpyqzQJpG3uU51gxwj1g9OfSlvjVt
         uT8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CC+G1w21LFBn90K6gAip7Dqueu3xcesCxWFiIThECwY=;
        b=Hd1piNY4kpLSp3KNRLB0fsuiEujMleYwVix+UFe398vJhQbLNAJVpsideBhG7GCXXs
         7yEE1rMCMOBLgU1Dy7KWqM4mOIB+22LNS/vp/OE6b+aJp49+N9L+KiRhsgsRQTaYS3KL
         8A8hmi1qWU2MiW81J+v64MVu7VQMqgoPznMCTm26zl9TymVzx1R4/ml0b+cLwU3z9UNr
         KUoJ2cQIhegkcRuAouJ8oOootfKteJ8LnaiALZdWhF3ehWgCIHWMgDYGFxlZEUk+2Sy5
         IZaqr2hLX2q8HnJIB71+x/qYwHMCvYVQhtkcA17MArrB3xNOEKQ2ih6M4OtICi5Doyku
         Mvkw==
X-Gm-Message-State: AOAM531vffj7f9N2Hn2NzUMzRgHtILjx0Ai0WOa4lQtPiUzLaHp9himh
        lGA3Uj44mNRgxb4MMt73oxI=
X-Google-Smtp-Source: ABdhPJwxcHsujgbI6PWs4WfjtWQdjiRiMYFq75OVK2Q+15N6xWmfWA/PTpwnxj9gDx4+eslo9bLNow==
X-Received: by 2002:a17:902:934a:b0:142:6ed6:5327 with SMTP id g10-20020a170902934a00b001426ed65327mr34507640plp.85.1638678204311;
        Sat, 04 Dec 2021 20:23:24 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:23:23 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 11/23] sit: add net device refcount tracking to ip_tunnel
Date:   Sat,  4 Dec 2021 20:22:05 -0800
Message-Id: <20211205042217.982127-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Note that other ip_tunnel users do not seem to hold a reference
on tunnel->dev. Probably needs some investigations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip_tunnels.h | 3 +++
 net/ipv6/sit.c           | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index bc3b13ec93c9dcd3f5d4c0ad8598200912172863..0219fe907b261952ec1f140d105cd74d7eda6b40 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -104,7 +104,10 @@ struct metadata_dst;
 struct ip_tunnel {
 	struct ip_tunnel __rcu	*next;
 	struct hlist_node hash_node;
+
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
+
 	struct net		*net;	/* netns for packet i/o */
 
 	unsigned long	err_time;	/* Time when the last ICMP error
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 1b57ee36d6682e04085aa271c6c5c09e6e3a7b7e..057c0f83c8007fb0756ca0d3a2231fab8eebaacb 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -521,7 +521,7 @@ static void ipip6_tunnel_uninit(struct net_device *dev)
 		ipip6_tunnel_del_prl(tunnel, NULL);
 	}
 	dst_cache_reset(&tunnel->dst_cache);
-	dev_put(dev);
+	dev_put_track(dev, &tunnel->dev_tracker);
 }
 
 static int ipip6_err(struct sk_buff *skb, u32 info)
@@ -1463,7 +1463,7 @@ static int ipip6_tunnel_init(struct net_device *dev)
 		dev->tstats = NULL;
 		return err;
 	}
-	dev_hold(dev);
+	dev_hold_track(dev, &tunnel->dev_tracker, GFP_KERNEL);
 	return 0;
 }
 
-- 
2.34.1.400.ga245620fadb-goog

