Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49564487C4A
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 19:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiAGSj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 13:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiAGSj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 13:39:58 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BEDC061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 10:39:58 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id v25so6157750pge.2
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 10:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wwbW+yFwmJjhAUCbo9w6iK2w0XKPcwtYSPoV2dB3vqE=;
        b=flZoqKbUh9GkK0fcn7nH4vHCXikJMsAA5bNn8/vtLyWtFjwZrgfcQYXoJAbTl10zB2
         xMaFxpb99ppWHWV5Q4P5iWFV6b8tqKYLDRmqSNTYjRV/wkwE4n0n1v9V0WjcaB6MN0hW
         ENw+NLpOQ61FfUjWrtNAzDO4EmEKAbY5IGqXA7NUPjAXM1Yn/L59xwCWLHviaYvNcBaK
         ITwjSMNMS14JvYKTbH+yaR0T8G7huSb1iNIWW8crpURUQn4jXJ85vRna8WOq6OZUXXaq
         zHzuHinhlo4s9OwyLN6VhtpWTLprsX5nOa0wrvFOK8TcUd1AzpRU22PWyEgoHTZew3A7
         rnPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wwbW+yFwmJjhAUCbo9w6iK2w0XKPcwtYSPoV2dB3vqE=;
        b=AL+w/Rm02pCZnMI9DPgi1QuXt2L0GAGQ4Woq9hFCWQYsg3lYi5HR+3JvMdHU+YAUo5
         JIUjPVZYMssKpmZmXjfH05fmXHqons/A2Cpd7Bx3C3trWnvzIQf+fAHduDLc6gIcIGUf
         Gm33S/7x8bwR6M/K7gw0fBHWzH/JdYePQEb84+Vhk2qEp6m/6jLXkxKm3TmsMVYTHFOu
         V3ehQvPNioWcRuTW/ezq96R3SmRReMK8GbihmiqCMJOtjAVQVrBy7dv2ek0iwpciEPas
         9/9uRnWLl+jB+E/rRYZh47Y3rs0VFg7T7GXFkr5a2kM6/jItWY5vLJRJlrhIM0RiU6g6
         YAaQ==
X-Gm-Message-State: AOAM532dsa0M5qF1/oBMtH+8Vy78/zYhnl3R4L9Qim0jk8kho52midbZ
        Sn7pGH3VSLrRw/gBrL0UJ2g=
X-Google-Smtp-Source: ABdhPJybzyj3h15+qisba7406+VEYEz03Zj1D2bkCfNcDa1OPk1/qyqBICovGypGushLbMF5MG3Hmg==
X-Received: by 2002:a05:6a00:21c2:b0:4bc:fb2d:4b6f with SMTP id t2-20020a056a0021c200b004bcfb2d4b6fmr6605105pfj.62.1641580797933;
        Fri, 07 Jan 2022 10:39:57 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:391a:d6f:6a77:ec68])
        by smtp.gmail.com with ESMTPSA id lb12sm6769746pjb.27.2022.01.07.10.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 10:39:57 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] af_packet: fix tracking issues in packet_do_bind()
Date:   Fri,  7 Jan 2022 10:39:53 -0800
Message-Id: <20220107183953.3886647-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It appears that my changes in packet_do_bind() were
slightly wrong.

syzbot found that calling bind() twice would trigger
a false positive.

Remove proto_curr/dev_curr variables and rewrite things
to be less confusing (like not having to use netdev_tracker_alloc(),
and instead use the standard dev_hold_track())

Fixes: f1d9268e0618 ("net: add net device refcount tracker to struct packet_type")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/packet/af_packet.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 9bbe7282efb65fa72278267266f0e55632ee79e2..5bd409ab4cc2001f2ac2d045e77f96c8bbba956a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3162,12 +3162,10 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 			  __be16 proto)
 {
 	struct packet_sock *po = pkt_sk(sk);
-	struct net_device *dev_curr;
-	__be16 proto_curr;
-	bool need_rehook;
 	struct net_device *dev = NULL;
-	int ret = 0;
 	bool unlisted = false;
+	bool need_rehook;
+	int ret = 0;
 
 	lock_sock(sk);
 	spin_lock(&po->bind_lock);
@@ -3192,14 +3190,10 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 		}
 	}
 
-	dev_hold(dev);
-
-	proto_curr = po->prot_hook.type;
-	dev_curr = po->prot_hook.dev;
-
-	need_rehook = proto_curr != proto || dev_curr != dev;
+	need_rehook = po->prot_hook.type != proto || po->prot_hook.dev != dev;
 
 	if (need_rehook) {
+		dev_hold(dev);
 		if (po->running) {
 			rcu_read_unlock();
 			/* prevents packet_notifier() from calling
@@ -3208,7 +3202,6 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 			WRITE_ONCE(po->num, 0);
 			__unregister_prot_hook(sk, true);
 			rcu_read_lock();
-			dev_curr = po->prot_hook.dev;
 			if (dev)
 				unlisted = !dev_get_by_index_rcu(sock_net(sk),
 								 dev->ifindex);
@@ -3218,25 +3211,21 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 		WRITE_ONCE(po->num, proto);
 		po->prot_hook.type = proto;
 
-		dev_put_track(dev_curr, &po->prot_hook.dev_tracker);
-		dev_curr = NULL;
+		dev_put_track(po->prot_hook.dev, &po->prot_hook.dev_tracker);
 
 		if (unlikely(unlisted)) {
-			dev_put(dev);
 			po->prot_hook.dev = NULL;
 			WRITE_ONCE(po->ifindex, -1);
 			packet_cached_dev_reset(po);
 		} else {
-			if (dev)
-				netdev_tracker_alloc(dev,
-						     &po->prot_hook.dev_tracker,
-						     GFP_ATOMIC);
+			dev_hold_track(dev, &po->prot_hook.dev_tracker,
+				       GFP_ATOMIC);
 			po->prot_hook.dev = dev;
 			WRITE_ONCE(po->ifindex, dev ? dev->ifindex : 0);
 			packet_cached_dev_assign(po, dev);
 		}
+		dev_put(dev);
 	}
-	dev_put_track(dev_curr, &po->prot_hook.dev_tracker);
 
 	if (proto == 0 || !need_rehook)
 		goto out_unlock;
-- 
2.34.1.575.g55b058a8bb-goog

