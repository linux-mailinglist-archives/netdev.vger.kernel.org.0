Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EBF2C09D0
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387892AbgKWNMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730459AbgKWNMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:12:50 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6384C0613CF;
        Mon, 23 Nov 2020 05:12:50 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so14881661pfu.1;
        Mon, 23 Nov 2020 05:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8PerAbw8X9GpFmXgDgTfgJ6bCTqd2WGnMdhkkg2spdI=;
        b=VFN2GDfAtravz2TUuDaQaNkq+Syi4uNoA4YVzpJjAp4Ps8DlWFo79XOM4jaIy1Pp2W
         28aGmI05fEsvFSZlBFuwz5eYH2kCR0VLFY4C+HWWM/p+DQ2izlXbSNVfIU4VMQMM7Tu6
         AYLygCd5wCyOrdVUK3ErvNChYM4mSyPikYl/pBooW3XI/XSPg75R5qFTHR6OdACqcYnm
         vhEXfj7Uc6k105kqW9LqHdoD9XH2TT/hdVKyjaKNd1g6MIffSZCiqvt1MDUeWczYV94A
         3sc6AX1fhk9mq2LamljvGWOSaDPGC167V2diN6oQ7BfLKmXMmeRXJANGxk87dA90lG+r
         GIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8PerAbw8X9GpFmXgDgTfgJ6bCTqd2WGnMdhkkg2spdI=;
        b=ejkaPhSk3Xa8G5Fg+VK2tbLK0x6zg45UGRDGeoCVQ8cbNL8MO06G5OwDeHbKphYaee
         yXv9B4gJJhD/09ORONgcj0PsOzp1Pi4LnLPErW8Z3CL6sROBuQ6ZGH0qHbo/iQvoMr9p
         BKhbRjadcVd/RlVCzQyliA/g5bzwktTqcI+zGZXUr390ywv+D9xB+2iDTAt0jvkAjETx
         KNLozJLlKQqn+yAyRvONPrvatcsX0RcR2BcOXhpGbegMc5nBgUFGoA0T58GEkXqhA+sf
         yJqCX5WwpTj77KNUY0IVdY1DB/fdv3qgSJ46hBbmLm8xXvn8NSl9tsJyjkYCqV7r1KuF
         a6+g==
X-Gm-Message-State: AOAM533rzOHE7pF2/o74QlI1R5FgZMqZcv+AvcxWQlO0hr8Cj1NEMi+R
        yySXQ1VbowxDt+8shiRYIw8=
X-Google-Smtp-Source: ABdhPJzrs9gjDc/tmdXIefNQhuYO6A1P0d/VPN9mTDa4zVbHnVycm/8TglIT84L63YaZ2fIoFW5pfw==
X-Received: by 2002:a17:90a:d246:: with SMTP id o6mr24193569pjw.236.1606137170249;
        Mon, 23 Nov 2020 05:12:50 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id t85sm10457143pgb.29.2020.11.23.05.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 05:12:48 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        jonathan.lemon@gmail.com, yhs@fb.com, weqaar.janjua@gmail.com,
        magnus.karlsson@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf] net, xsk: Avoid taking multiple skbuff references
Date:   Mon, 23 Nov 2020 14:12:15 +0100
Message-Id: <20201123131215.136131-1-bjorn.topel@gmail.com>
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
 include/linux/netdevice.h | 1 +
 net/core/dev.c            | 9 +++++++--
 net/xdp/xsk.c             | 8 +-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494b0e8d..e7402fca7752 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2815,6 +2815,7 @@ u16 dev_pick_tx_cpu_id(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev);
 int dev_queue_xmit(struct sk_buff *skb);
 int dev_queue_xmit_accel(struct sk_buff *skb, struct net_device *sb_dev);
+int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id, bool free_on_busy);
 int dev_direct_xmit(struct sk_buff *skb, u16 queue_id);
 int register_netdevice(struct net_device *dev);
 void unregister_netdevice_queue(struct net_device *dev, struct list_head *head);
diff --git a/net/core/dev.c b/net/core/dev.c
index 82dc6b48e45f..2af79a4253bb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4180,7 +4180,7 @@ int dev_queue_xmit_accel(struct sk_buff *skb, struct net_device *sb_dev)
 }
 EXPORT_SYMBOL(dev_queue_xmit_accel);
 
-int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
+int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id, bool free_on_busy)
 {
 	struct net_device *dev = skb->dev;
 	struct sk_buff *orig_skb = skb;
@@ -4211,7 +4211,7 @@ int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 
 	local_bh_enable();
 
-	if (!dev_xmit_complete(ret))
+	if (free_on_busy && !dev_xmit_complete(ret))
 		kfree_skb(skb);
 
 	return ret;
@@ -4220,6 +4220,11 @@ int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 	kfree_skb_list(skb);
 	return NET_XMIT_DROP;
 }
+
+int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
+{
+	return __dev_direct_xmit(skb, queue_id, true);
+}
 EXPORT_SYMBOL(dev_direct_xmit);
 
 /*************************************************************************
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 5a6cdf7b320d..c6ad31b374b7 100644
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
+		err = __dev_direct_xmit(skb, xs->queue_id, false);
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

