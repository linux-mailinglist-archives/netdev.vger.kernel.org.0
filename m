Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415CA170EF5
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgB0DU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728355AbgB0DU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 22:20:27 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 057172468A;
        Thu, 27 Feb 2020 03:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582773626;
        bh=kX8BuZfbH9hIfaBPD4m1e+3r80SU/A/yPOwlea0pHjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVI+Eo5J10iBij5xpbgKUTPuXpAQ930ipseT8cVyD9I+O9pv8XC9GvMHuS+Fq55mv
         vfwHnhJ5g9OX21RLg1LzabyIYBoZpwlYUAL+zZ9Yw1kYGFbb4i2xTt5AhZucHqArxB
         i1Pz+TIK3ZepguTMvxs7fio1dyCKQAUGsugVuObg=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC v4 bpf-next 06/11] net: core: Rename do_xdp_generic to do_xdp_generic_rx and export
Date:   Wed, 26 Feb 2020 20:20:08 -0700
Message-Id: <20200227032013.12385-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200227032013.12385-1-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Rename do_xdp_generic to do_xdp_generic_rx to emphasize its use in the
Rx path, and export it as a general purpose function. It will just run
XDP program on skb but will not handle XDP actions.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 drivers/net/tun.c         | 4 ++--
 include/linux/netdevice.h | 2 +-
 net/core/dev.c            | 7 ++++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 650c937ed56b..7cc5a1acaef2 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1932,7 +1932,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		rcu_read_lock();
 		xdp_prog = rcu_dereference(tun->xdp_prog);
 		if (xdp_prog) {
-			ret = do_xdp_generic(xdp_prog, skb);
+			ret = do_xdp_generic_rx(xdp_prog, skb);
 			if (ret != XDP_PASS) {
 				rcu_read_unlock();
 				local_bh_enable();
@@ -2498,7 +2498,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	skb_probe_transport_header(skb);
 
 	if (skb_xdp) {
-		err = do_xdp_generic(xdp_prog, skb);
+		err = do_xdp_generic_rx(xdp_prog, skb);
 		if (err != XDP_PASS)
 			goto out;
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bc58c489e959..c3549006b8fc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3700,7 +3700,7 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 }
 
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
-int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
+int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb);
 u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
 			struct bpf_prog *xdp_prog);
 int netif_rx(struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index bfa7a64c4e68..c943fc7b8054 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4636,7 +4636,7 @@ EXPORT_SYMBOL_GPL(generic_xdp_tx);
 
 static DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
 
-int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
+int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 {
 	if (xdp_prog) {
 		struct netdev_rx_queue *rxqueue;
@@ -4668,7 +4668,7 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 	kfree_skb(skb);
 	return XDP_DROP;
 }
-EXPORT_SYMBOL_GPL(do_xdp_generic);
+EXPORT_SYMBOL_GPL(do_xdp_generic_rx);
 
 static int netif_rx_internal(struct sk_buff *skb)
 {
@@ -5017,7 +5017,8 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		int ret2;
 
 		preempt_disable();
-		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
+		ret2 = do_xdp_generic_rx(rcu_dereference(skb->dev->xdp_prog),
+					 skb);
 		preempt_enable();
 
 		if (ret2 != XDP_PASS)
-- 
2.21.1 (Apple Git-122.3)

