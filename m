Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7774D9C99D
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfHZGqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:46:47 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40641 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfHZGqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:46:47 -0400
Received: by mail-pf1-f195.google.com with SMTP id w16so11155152pfn.7;
        Sun, 25 Aug 2019 23:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2vA3heResnG5vt68ph7pxPA3D8xS2Q1JgmsfcGTRFL4=;
        b=lJkbIxy2Wot9gYOWfwEFzY+K4W1Rs4+WvM+PeBmUvHJexXNNHsyEtQ5Yn1Gk5XfMEQ
         o833wfifzriZGDRFLSaMum4XbAVUp7qpjiMgvRSoA96ooVra7uojQJmP7fg2tFJ26+88
         iEBxcLgYRRuu+VhVqKJ/N0N9UPqTIEMs1Yv57iQWJqNCfqwoftqlRhBeUoqLyqgaL2YM
         28rV9R7AfBo8D0vGhaU4myIh0h0TaPFt56hzZwv7kDyQdifFHCO4YtXg1dPbMMkY9R8q
         VC+v/LF389M2r0/loS2bui6CIOnMPn8TIh1IjVB56Jyq0dT1Q4lsx5zPWHCT2DAmhFSl
         +m2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2vA3heResnG5vt68ph7pxPA3D8xS2Q1JgmsfcGTRFL4=;
        b=XfRkHo1bwYLSVxpRAayf8Se0SxCvaQSJju3EDypBNI1EYSk9zfYeeHPwyITfVrcGX3
         saLyZEs6ZohSfzfkTfQkLZpT6XIIPUWQrzuUWn6L9ibfUhYq5ELbmcN1LhxgER6DE9Y7
         Fr3SD0hCoMOI8BFHk3OtBwWrWO2fTuwG79hNMyEgBWCvX+o9KbZPeFxGz6+X756W6w0j
         2fi/8ymIGG8jwSvQ5GeWUePi91fVPq/2N4v/dWwvZT30jUzuFwdG0D/ZAcviD9elJN94
         I1cj3E8sKGDX7fqMAtaX/wfG50l11E5Nanqyq/ibkGtE6ohOwhoG1Cn6PdKm/cHpLcCz
         q1Xw==
X-Gm-Message-State: APjAAAV235wRGPUpVOZjjUCUNGoIUWBSFJ7pDyy6a5P46Gqg6tPesP35
        jHEh3EkBhfZ0QDZwwvRRF54=
X-Google-Smtp-Source: APXvYqz6b0rc+XsFLPRYzJtdbm4nAK7c/KmGjkCeYQsPBAR0XNEXPma1xE+It2qVWIs6wo/uDlj+0g==
X-Received: by 2002:a63:6904:: with SMTP id e4mr14827260pgc.321.1566802006616;
        Sun, 25 Aug 2019 23:46:46 -0700 (PDT)
Received: from localhost.localdomain ([139.198.120.21])
        by smtp.gmail.com with ESMTPSA id j11sm2361512pfa.113.2019.08.25.23.46.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 25 Aug 2019 23:46:45 -0700 (PDT)
From:   Feng Sun <loyou85@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, dsterba@suse.com, dbanerje@akamai.com,
        fw@strlen.de, davej@codemonkey.org.uk, tglx@linutronix.de,
        matwey@sai.msu.ru, sakari.ailus@linux.intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Sun <loyou85@gmail.com>,
        Xiaojun Zhao <xiaojunzhao141@gmail.com>
Subject: [PATCH v3] net: fix skb use after free in netpoll
Date:   Mon, 26 Aug 2019 14:46:04 +0800
Message-Id: <1566801964-14691-1-git-send-email-loyou85@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20190825.232003.1145950065287854577.davem@davemloft.net>
References: <20190825.232003.1145950065287854577.davem@davemloft.net>
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
Changes in v3:
- use dev_xmit_complete directly

Changes in v2:
- change commit and title
- add netpoll_xmit_complete helper
- add one more return value check of netpoll_start_xmit
---
 net/core/netpoll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 2cf27da..849380a6 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -122,7 +122,7 @@ static void queue_process(struct work_struct *work)
 		txq = netdev_get_tx_queue(dev, q_index);
 		HARD_TX_LOCK(dev, txq, smp_processor_id());
 		if (netif_xmit_frozen_or_stopped(txq) ||
-		    netpoll_start_xmit(skb, dev, txq) != NETDEV_TX_OK) {
+		    !dev_xmit_complete(netpoll_start_xmit(skb, dev, txq))) {
 			skb_queue_head(&npinfo->txq, skb);
 			HARD_TX_UNLOCK(dev, txq);
 			local_irq_restore(flags);
@@ -335,7 +335,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 
 				HARD_TX_UNLOCK(dev, txq);
 
-				if (status == NETDEV_TX_OK)
+				if (dev_xmit_complete(status))
 					break;
 
 			}
@@ -352,7 +352,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 
 	}
 
-	if (status != NETDEV_TX_OK) {
+	if (!dev_xmit_complete(status)) {
 		skb_queue_tail(&npinfo->txq, skb);
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}
-- 
2.7.4

