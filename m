Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A809C90C
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfHZGOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:14:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43263 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfHZGOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:14:18 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so9478007pld.10;
        Sun, 25 Aug 2019 23:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1UBHUR9VKG93a22dzMNTFen28F89ObW8ubmlHRRPTIA=;
        b=H/SA7m3nLvLRLZWZ8rELQCEjBT2HQA/VPtLvwz1tcMFS9SndzXOTTfBgLdDMhAycUV
         /e5zaVpIMya7tDCGgnVQfNhOktKS44s/+INyAbMOfb7/8xHqZUTE6Ge0hxan6qWZsmVR
         8T+hXstOZUr1Xr8B65XMjBITn4bq7DR8HcMzmCgl1AzcpKrNK9nMZjEk+YlWETEDB8VS
         +bW26qiNzt5lSgHXP8TTUXHEXN0A1s+YxZ9+hz/Y4oHnXSaKw+ES0zstJHB2mI13OP2v
         5vJTNObuM59tn1AhbX82QUR9rhGtMwXiF1OblA1tL2zH28cuMhj28NR7UkiTdNtJImIZ
         yIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1UBHUR9VKG93a22dzMNTFen28F89ObW8ubmlHRRPTIA=;
        b=N6OhmWPiV/zf9uCFeHqm2OGRA3EZFd1e2gICVANSJ7Bpxjw4wBaN6DK37AG6uyw4zV
         GNOIWMMrdoydCxx531pZv3uXbwuaD3o+rqaSEi+4lVWKeVr5FAG6leuAmK3nikUC6YnP
         pazIKXRclRycEXCKZUIUEwFVAk+noUgqSmQr4LEwmcebHieu/jsjKcv+B7ZSpnmoBW/P
         xe1l5ljvAZynN8s6GFtIIpR+nwO18ZWJEgDKFepN2BhquawL7UAC2O80N5rr18CdkZAx
         CVMSwRYMfT/5Eju3le/ciq6DVdIqFXcFe+xd9Vp7m+oUAS94QaSv5zVKKSIZwy34NnfL
         KzaQ==
X-Gm-Message-State: APjAAAX4fGYfsBDW8CJKraB8D+8Y+xSObtM2FkRoqRmIbeNtpNfv2d12
        o0S/Zo3AYu3dMDCDPldoyfU=
X-Google-Smtp-Source: APXvYqyLQHTcj9/MCu87ZFlr8/XqHwJ47fTFw8txT275/c0ODEjtBbQ4C7BwXiYe+6EmRZSgET7tWQ==
X-Received: by 2002:a17:902:ff05:: with SMTP id f5mr16803465plj.116.1566800057894;
        Sun, 25 Aug 2019 23:14:17 -0700 (PDT)
Received: from localhost.localdomain ([139.198.120.21])
        by smtp.gmail.com with ESMTPSA id s186sm14155837pfb.126.2019.08.25.23.14.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 25 Aug 2019 23:14:16 -0700 (PDT)
From:   Feng Sun <loyou85@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, dsterba@suse.com, dbanerje@akamai.com,
        fw@strlen.de, davej@codemonkey.org.uk, tglx@linutronix.de,
        matwey@sai.msu.ru, sakari.ailus@linux.intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Sun <loyou85@gmail.com>,
        Xiaojun Zhao <xiaojunzhao141@gmail.com>
Subject: [PATCH v2] net: fix skb use after free in netpoll
Date:   Mon, 26 Aug 2019 14:13:40 +0800
Message-Id: <1566800020-10007-1-git-send-email-loyou85@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566577920-20956-1-git-send-email-loyou85@gmail.com>
References: <1566577920-20956-1-git-send-email-loyou85@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit baeababb5b85d5c4e6c917efe2a1504179438d3b
("tun: return NET_XMIT_DROP for dropped packets"),
when tun_net_xmit drop packets, it will free skb and return NET_XMIT_DROP,
netpoll_send_skb_on_dev will run into following use after free cases:
1. retry netpoll_start_xmit with freed skb;
2. queue freed skb in npinfo->txq.
queue_process will also run into use after free case.

hit netpoll_send_skb_on_dev first case with following kernel log:

[  117.864773] kernel BUG at mm/slub.c:306!
[  117.864773] invalid opcode: 0000 [#1] SMP PTI
[  117.864774] CPU: 3 PID: 2627 Comm: loop_printmsg Kdump: loaded Tainted: P           OE     5.3.0-050300rc5-generic #201908182231
[  117.864775] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  117.864775] RIP: 0010:kmem_cache_free+0x28d/0x2b0
[  117.864781] Call Trace:
[  117.864781]  ? tun_net_xmit+0x21c/0x460
[  117.864781]  kfree_skbmem+0x4e/0x60
[  117.864782]  kfree_skb+0x3a/0xa0
[  117.864782]  tun_net_xmit+0x21c/0x460
[  117.864782]  netpoll_start_xmit+0x11d/0x1b0
[  117.864788]  netpoll_send_skb_on_dev+0x1b8/0x200
[  117.864789]  __br_forward+0x1b9/0x1e0 [bridge]
[  117.864789]  ? skb_clone+0x53/0xd0
[  117.864790]  ? __skb_clone+0x2e/0x120
[  117.864790]  deliver_clone+0x37/0x50 [bridge]
[  117.864790]  maybe_deliver+0x89/0xc0 [bridge]
[  117.864791]  br_flood+0x6c/0x130 [bridge]
[  117.864791]  br_dev_xmit+0x315/0x3c0 [bridge]
[  117.864792]  netpoll_start_xmit+0x11d/0x1b0
[  117.864792]  netpoll_send_skb_on_dev+0x1b8/0x200
[  117.864792]  netpoll_send_udp+0x2c6/0x3e8
[  117.864793]  write_msg+0xd9/0xf0 [netconsole]
[  117.864793]  console_unlock+0x386/0x4e0
[  117.864793]  vprintk_emit+0x17e/0x280
[  117.864794]  vprintk_default+0x29/0x50
[  117.864794]  vprintk_func+0x4c/0xbc
[  117.864794]  printk+0x58/0x6f
[  117.864795]  loop_fun+0x24/0x41 [printmsg_loop]
[  117.864795]  kthread+0x104/0x140
[  117.864795]  ? 0xffffffffc05b1000
[  117.864796]  ? kthread_park+0x80/0x80
[  117.864796]  ret_from_fork+0x35/0x40

Signed-off-by: Feng Sun <loyou85@gmail.com>
Signed-off-by: Xiaojun Zhao <xiaojunzhao141@gmail.com>
---
Changes in v2:
- change commit and title
- add netpoll_xmit_complete helper
- add one more return value check of netpoll_start_xmit
---
 net/core/netpoll.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 2cf27da..a3f20e9 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -95,6 +95,11 @@ static int netpoll_start_xmit(struct sk_buff *skb, struct net_device *dev,
 	return status;
 }
 
+static inline bool netpoll_xmit_complete(int rc)
+{
+	return dev_xmit_complete(rc);
+}
+
 static void queue_process(struct work_struct *work)
 {
 	struct netpoll_info *npinfo =
@@ -122,7 +127,7 @@ static void queue_process(struct work_struct *work)
 		txq = netdev_get_tx_queue(dev, q_index);
 		HARD_TX_LOCK(dev, txq, smp_processor_id());
 		if (netif_xmit_frozen_or_stopped(txq) ||
-		    netpoll_start_xmit(skb, dev, txq) != NETDEV_TX_OK) {
+		    !netpoll_xmit_complete(netpoll_start_xmit(skb, dev, txq))) {
 			skb_queue_head(&npinfo->txq, skb);
 			HARD_TX_UNLOCK(dev, txq);
 			local_irq_restore(flags);
@@ -335,7 +340,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 
 				HARD_TX_UNLOCK(dev, txq);
 
-				if (status == NETDEV_TX_OK)
+				if (netpoll_xmit_complete(status))
 					break;
 
 			}
@@ -352,7 +357,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 
 	}
 
-	if (status != NETDEV_TX_OK) {
+	if (!netpoll_xmit_complete(status)) {
 		skb_queue_tail(&npinfo->txq, skb);
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}
-- 
2.7.4

