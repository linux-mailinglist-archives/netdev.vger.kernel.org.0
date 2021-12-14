Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171D847460D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 16:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhLNPJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 10:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhLNPJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 10:09:39 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D254C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 07:09:39 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id r130so18117562pfc.1
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 07:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qoCjHSvPYLfUOvgjoAGkJghTc3AJpNv7c8eUyFv8+RY=;
        b=VaErVsW8pMeAU3uQA7txd/ayHqkvsMPRFe5drPTmW1wseT2G6EeDNG+JdHZOsdcntE
         ooCUDR/aUPtjJuimOB/g0plH2GBcTEJxo7ekS+ztMqfr39ni05FyBlWUhWyL89Nm5qfr
         oRU91a9NQwJpicODSEbDmVv7HOtQJZCZI8uRtAbb8V+vC77UdpWNY/tg7lWTPDLqoCdL
         WNje3bLSe5Nmd90pBwF52uMMbzfmnA2aK/TB/e/H/7VZ82Qg4fIoakhmtvDRNXtOy6M1
         LL0+uNye29bB6xHyKQ1p+s6A0njzSoWueo9mqINNQ5ZkdTawLpnlFcFKBPUQ1e+byk4t
         6Dyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qoCjHSvPYLfUOvgjoAGkJghTc3AJpNv7c8eUyFv8+RY=;
        b=IDraZdp+ZMAaAYDwcHyPPq451Jdgb9FIHD99vNDyUmHz1ft922Wcbmn9QFTtu1aUR2
         lLX+VmdLzTm6ut9J4uGitpFYaHsluwFfOrsyJE0Wh27VE7PWPy7cc9BaBQnOzQxlDbtG
         aV5z0gGw9oRGK4xf5zc3O+MuGeIKVLPSwIBm1w0kFIaX2uSuOBpDy+Z70Ll2d9buOVvy
         S8RRD188BALT/GI3YH+CasflrhYaq+mpOnlkWQYuFSpSG7+lEMMB+jfNsq8jXaFQuGCk
         7hi8xo/GiiXsreCiQqfgfWOwj5KGEil/pNqWz9IusAM4La9ZUQak6KbL3+rL7PVviVET
         lS0A==
X-Gm-Message-State: AOAM530Vg2McR7usqsQbCuKD3dE+RqrLziNjLtksomp/gOAFhly+NcUN
        1+jNezWhZRky6xl0j8SyA6Q=
X-Google-Smtp-Source: ABdhPJw4hZJNlEBITEt32P4DV7I26hSWixWekr48ELYx8YlHtP8Jjba3ICBeOA2hLGcPC7Ng2oHgAw==
X-Received: by 2002:a63:3704:: with SMTP id e4mr4140726pga.551.1639494578625;
        Tue, 14 Dec 2021 07:09:38 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5cbb:7251:72ab:eb48])
        by smtp.gmail.com with ESMTPSA id g5sm2828955pjt.15.2021.12.14.07.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 07:09:37 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [PATCH net-next] net: add net device refcount tracker to struct packet_type
Date:   Tue, 14 Dec 2021 07:09:33 -0800
Message-Id: <20211214150933.242895-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Most notable changes are in af_packet, tipc ones are trivial.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
---
 include/linux/netdevice.h |  1 +
 net/packet/af_packet.c    | 14 +++++++++++---
 net/tipc/bearer.c         |  4 ++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 235d5d082f1a446c8d898ffcc5b1983df7c04f35..0ed0a6f0d69d3565c1db9203040838801cd71e99 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2533,6 +2533,7 @@ struct packet_type {
 	__be16			type;	/* This is really htons(ether_type). */
 	bool			ignore_outgoing;
 	struct net_device	*dev;	/* NULL is wildcarded here	     */
+	netdevice_tracker	dev_tracker;
 	int			(*func) (struct sk_buff *,
 					 struct net_device *,
 					 struct packet_type *,
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a1ffdb48cc474dcf91bddfd1ab96386a89c20375..71854a16afbbc1c06005e48a65cdb7007d61b019 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3109,7 +3109,7 @@ static int packet_release(struct socket *sock)
 	packet_cached_dev_reset(po);
 
 	if (po->prot_hook.dev) {
-		dev_put(po->prot_hook.dev);
+		dev_put_track(po->prot_hook.dev, &po->prot_hook.dev_tracker);
 		po->prot_hook.dev = NULL;
 	}
 	spin_unlock(&po->bind_lock);
@@ -3217,18 +3217,25 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 		WRITE_ONCE(po->num, proto);
 		po->prot_hook.type = proto;
 
+		dev_put_track(dev_curr, &po->prot_hook.dev_tracker);
+		dev_curr = NULL;
+
 		if (unlikely(unlisted)) {
 			dev_put(dev);
 			po->prot_hook.dev = NULL;
 			WRITE_ONCE(po->ifindex, -1);
 			packet_cached_dev_reset(po);
 		} else {
+			if (dev)
+				netdev_tracker_alloc(dev,
+						     &po->prot_hook.dev_tracker,
+						     GFP_ATOMIC);
 			po->prot_hook.dev = dev;
 			WRITE_ONCE(po->ifindex, dev ? dev->ifindex : 0);
 			packet_cached_dev_assign(po, dev);
 		}
 	}
-	dev_put(dev_curr);
+	dev_put_track(dev_curr, &po->prot_hook.dev_tracker);
 
 	if (proto == 0 || !need_rehook)
 		goto out_unlock;
@@ -4138,7 +4145,8 @@ static int packet_notifier(struct notifier_block *this,
 				if (msg == NETDEV_UNREGISTER) {
 					packet_cached_dev_reset(po);
 					WRITE_ONCE(po->ifindex, -1);
-					dev_put(po->prot_hook.dev);
+					dev_put_track(po->prot_hook.dev,
+						      &po->prot_hook.dev_tracker);
 					po->prot_hook.dev = NULL;
 				}
 				spin_unlock(&po->bind_lock);
diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 60bc74b76adc5909fdb5294f205229682a09d031..473a790f58943537896c16c72b60061b5ffe6840 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -787,7 +787,7 @@ int tipc_attach_loopback(struct net *net)
 	if (!dev)
 		return -ENODEV;
 
-	dev_hold(dev);
+	dev_hold_track(dev, &tn->loopback_pt.dev_tracker, GFP_KERNEL);
 	tn->loopback_pt.dev = dev;
 	tn->loopback_pt.type = htons(ETH_P_TIPC);
 	tn->loopback_pt.func = tipc_loopback_rcv_pkt;
@@ -800,7 +800,7 @@ void tipc_detach_loopback(struct net *net)
 	struct tipc_net *tn = tipc_net(net);
 
 	dev_remove_pack(&tn->loopback_pt);
-	dev_put(net->loopback_dev);
+	dev_put_track(net->loopback_dev, &tn->loopback_pt.dev_tracker);
 }
 
 /* Caller should hold rtnl_lock to protect the bearer */
-- 
2.34.1.173.g76aa8bc2d0-goog

