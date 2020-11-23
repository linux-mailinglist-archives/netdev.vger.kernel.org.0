Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBBE2C1270
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 18:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbgKWR4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729604AbgKWR4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:56:14 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9422CC0613CF;
        Mon, 23 Nov 2020 09:56:14 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id w4so14914010pgg.13;
        Mon, 23 Nov 2020 09:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=py5JSSlXJWcBrQyWwWpRNK4T/vAv6z6ZKSuuqxdy+GI=;
        b=Vy3Ex6kTxISbSehx1V6iapmkiA2wFujIN7sbtzzuTfrcAkZJZpsN6hTXRShAQtn5UJ
         qj7SepGSHvll+bePskpvjZGYJmkV5cb5m1PKI/W8Q6pHKj2NlUKwR+Re9yYppVND3xoY
         +dkISyCr7o1JXX0HH2Qd3wUnEa/ETFAgYQ8q3UmlMgC56lQtuvme/nx4AxmrG0lCnJTM
         NNGx6aygUu0janeRnpB01qYw0ZxV4V9mknGXO//azAAMAqqqsKwtOnh84aAVKWbfe1A5
         5TM1gbFQZyLxPEyoR/H2UfsVHYHOhMx6rvXbiTM31i0M3ofckVCFB1aNnrofG96hVFOW
         OClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=py5JSSlXJWcBrQyWwWpRNK4T/vAv6z6ZKSuuqxdy+GI=;
        b=Ml79WI53E70zU/AsvdlMCu8OPJvBtX378W+75wY43JwIfiRj52TQl6/sncpQ8kmrKt
         N6L9Ve9sJ8RiNGFA+QeWQJJ+y9kfNvoA8rX/iBqETHwtILrInNz5c3MZvAbulqvhZhZU
         d3+SUPpY4Iu5r0fDNrNeoyqKRfRP2t8afFdyUVNI0RlhdoFVqA6CNO6eLZZyaIWano2o
         InwJUXRAXjIhgQWeT2j06agK1RQUmSBH0kC6/kGoFMMPJm5zSXUF6Rw4/RELJA1l8P1A
         JBiym0F8hKrneE/C/94EHFcOE28NV5DzB2KIuw+DC1fFeK05UTCZSJHsarh7oseuQdw/
         WuSw==
X-Gm-Message-State: AOAM531tjTa72O2LuCwJdvlQBvrb/xMsHfbL19M4oFvIg3YVzFDqBk1e
        HV1LQAva18ANh0Cl2Cs6V3qo2Yxv9f7RRVn0
X-Google-Smtp-Source: ABdhPJxDTEDp+vPd4v7YrUMs9vuZSE3UyxwzBOlsZN6gCiHjUSOvl2qfj4WixGlLMmWQBjrnBCvTcg==
X-Received: by 2002:aa7:982e:0:b029:18b:6372:d445 with SMTP id q14-20020aa7982e0000b029018b6372d445mr466612pfl.31.1606154174168;
        Mon, 23 Nov 2020 09:56:14 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id y5sm12903423pfc.165.2020.11.23.09.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 09:56:12 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        jonathan.lemon@gmail.com, yhs@fb.com, weqaar.janjua@gmail.com,
        magnus.karlsson@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf v2] net, xsk: Avoid taking multiple skbuff references
Date:   Mon, 23 Nov 2020 18:56:00 +0100
Message-Id: <20201123175600.146255-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Commit 642e450b6b59 ("xsk: Do not discard packet when NETDEV_TX_BUSY")
addressed the problem that packets were discarded from the Tx AF_XDP
ring, when the driver returned NETDEV_TX_BUSY. Part of the fix was
bumping the skbuff reference count, so that the buffer would not be
freed by dev_direct_xmit(). A reference count larger than one means
that the skbuff is "shared", which is not the case.

If the "shared" skbuff is sent to the generic XDP receive path,
netif_receive_generic_xdp(), and pskb_expand_head() is entered the
BUG_ON(skb_shared(skb)) will trigger.

This patch adds a variant to dev_direct_xmit(), __dev_direct_xmit(),
where a user can select the skbuff free policy. This allows AF_XDP to
avoid bumping the reference count, but still keep the NETDEV_TX_BUSY
behavior.

Reported-by: Yonghong Song <yhs@fb.com>
Fixes: 642e450b6b59 ("xsk: Do not discard packet when NETDEV_TX_BUSY")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
v2:
  Removed the bool parameter, and inlined dev_direct_xmit(). (Daniel)
---
 include/linux/netdevice.h | 11 ++++++++++-
 net/core/dev.c            |  8 ++------
 net/xdp/xsk.c             |  8 +-------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494b0e8d..bd841f31dfab 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2815,7 +2815,16 @@ u16 dev_pick_tx_cpu_id(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev);
 int dev_queue_xmit(struct sk_buff *skb);
 int dev_queue_xmit_accel(struct sk_buff *skb, struct net_device *sb_dev);
-int dev_direct_xmit(struct sk_buff *skb, u16 queue_id);
+int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id);
+static inline int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
+{
+	int ret;
+
+	ret = __dev_direct_xmit(skb, queue_id);
+	if (!dev_xmit_complete(ret))
+		kfree_skb(skb);
+	return ret;
+}
 int register_netdevice(struct net_device *dev);
 void unregister_netdevice_queue(struct net_device *dev, struct list_head *head);
 void unregister_netdevice_many(struct list_head *head);
diff --git a/net/core/dev.c b/net/core/dev.c
index 82dc6b48e45f..8588ade790cb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4180,7 +4180,7 @@ int dev_queue_xmit_accel(struct sk_buff *skb, struct net_device *sb_dev)
 }
 EXPORT_SYMBOL(dev_queue_xmit_accel);
 
-int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
+int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 {
 	struct net_device *dev = skb->dev;
 	struct sk_buff *orig_skb = skb;
@@ -4210,17 +4210,13 @@ int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 	dev_xmit_recursion_dec();
 
 	local_bh_enable();
-
-	if (!dev_xmit_complete(ret))
-		kfree_skb(skb);
-
 	return ret;
 drop:
 	atomic_long_inc(&dev->tx_dropped);
 	kfree_skb_list(skb);
 	return NET_XMIT_DROP;
 }
-EXPORT_SYMBOL(dev_direct_xmit);
+EXPORT_SYMBOL(__dev_direct_xmit);
 
 /*************************************************************************
  *			Receiver routines
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 5a6cdf7b320d..b7b039bd9d03 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -411,11 +411,7 @@ static int xsk_generic_xmit(struct sock *sk)
 		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
 		skb->destructor = xsk_destruct_skb;
 
-		/* Hinder dev_direct_xmit from freeing the packet and
-		 * therefore completing it in the destructor
-		 */
-		refcount_inc(&skb->users);
-		err = dev_direct_xmit(skb, xs->queue_id);
+		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
 			skb->destructor = sock_wfree;
@@ -429,12 +425,10 @@ static int xsk_generic_xmit(struct sock *sk)
 		/* Ignore NET_XMIT_CN as packet might have been sent */
 		if (err == NET_XMIT_DROP) {
 			/* SKB completed but not sent */
-			kfree_skb(skb);
 			err = -EBUSY;
 			goto out;
 		}
 
-		consume_skb(skb);
 		sent_frame = true;
 	}
 

base-commit: 178648916e73e00de83150eb0c90c0d3a977a46a
-- 
2.27.0

