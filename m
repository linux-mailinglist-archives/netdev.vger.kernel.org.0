Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9114946703C
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378247AbhLCCvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378260AbhLCCvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:15 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04638C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:52 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so4054306pja.1
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CC+G1w21LFBn90K6gAip7Dqueu3xcesCxWFiIThECwY=;
        b=cNVlcEeMXxr5RkobVV1WOG9OjYCibCJTV6qFHkgGWgIZb1OJdCQ9FuB3T0PJZ6gH8S
         y3NN9SPydt+vDbuVhYw7tJKVvlS6WGDVYGcLGR5yL1d/U9XMcv9NfuN2xKehd8Ll1z6D
         UdC2twyU1qqQ+/0Vv6L8mjufFjvoOspYSDtumKoW8zD1YnmsGXhR8+INPYteWOFQJlQ3
         O9QzkFuOHErWgNAcbhmIBZ5b5hqN52SUZNpp7XzLZs1GG55SwxQWSvaTDXpauI7y+7Fd
         EiqE9HHhQ57wRZYC9FIDnTfc8oiJoDjqCe1a+GWCg8BU5fPiEZtYadCqe1DBCHbW4OYF
         dW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CC+G1w21LFBn90K6gAip7Dqueu3xcesCxWFiIThECwY=;
        b=XWJQmtWcYsKahQbBIkiTIzH4vDtYbiWZ1kzWAbn67sSYEJz6aslPFvjtZpmkVF4TAU
         NY0daSzdZ0DWgygc1dEZq6KZF7Ljkk145z+HIlQJDIZHI2CVYhIEXeIhP2B45UBA/O/M
         V3jm/FcWys0WQYB3puub6PMO1E38dyjl64AgbjLr7uJ6PfjscsvgJAq69n7eC/5l04sI
         8eCPWJZpDhbiwXW2oW11jn8qmLxHlA3H6GOOTWaY+L1jHc7szRqPrm5AkEKKLzyCZIYk
         YNSm9u3qTFitk7p8s6IldP1ClBlPCDrRU8B2YJ+4VF0sYUtgCyIYX392pGd+Jhi31AgI
         x0Lw==
X-Gm-Message-State: AOAM531TIM8tt4s0Giwhzy87/37yUh/pBe2PRbK41yqBg0WsRka0KIeZ
        mI/k/8wOeG23CMkP8wF9PAQ=
X-Google-Smtp-Source: ABdhPJwYr4W7qlCi4LSzsNahrbfYBBto/uotImbAdEIexSW1CcpF/56BN0Oi1RUiNH3MeoRTMDcKvw==
X-Received: by 2002:a17:902:c404:b0:142:28c5:5416 with SMTP id k4-20020a170902c40400b0014228c55416mr19901148plk.62.1638499671554;
        Thu, 02 Dec 2021 18:47:51 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:51 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 11/23] sit: add net device refcount tracking to ip_tunnel
Date:   Thu,  2 Dec 2021 18:46:28 -0800
Message-Id: <20211203024640.1180745-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
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

