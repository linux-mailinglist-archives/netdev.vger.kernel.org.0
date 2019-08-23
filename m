Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02BA19B487
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436756AbfHWQci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:32:38 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46054 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436736AbfHWQcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:32:35 -0400
Received: by mail-pl1-f196.google.com with SMTP id y8so5854991plr.12;
        Fri, 23 Aug 2019 09:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=N2qESvJr/1pmMF3Ae2nRMhv+Yh2vmLQcSbPIwWU4XqU=;
        b=L6NTSam0xaVt4B1J7FbhhrgYZP5WgZ6n71bwbPTlq2kKZHhL5RuqZ8ASRxgVGcNDJO
         4l6xeLN7Amq8qyJuqZ8BKsmzBSpjL0fBodG1aqg3UfhX6kRDtMkALRfnDKWE7ZtTH7JU
         RoRqaR659oAqLh7aS3qTx0YfSYjWqVcQisBLf5f40AGfUPg4zHD9y+BvYW210M62/e1W
         7h05jsT5TrcwvoaMS3lN7XLJ+2/CPSU7xhD0XTVGn7lURuVtuAk5VFS3WSqmsxHNh93W
         7XOSKSrxSSfOiGwWmK9wJy7maWwdg9vnZ9JZRC7OyTup80tmVAixLvHOureZG0T2CZLA
         BMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N2qESvJr/1pmMF3Ae2nRMhv+Yh2vmLQcSbPIwWU4XqU=;
        b=djy3bmJbeZOWUcQ8FIvnDgis+46EnmEUAi+E8COaVS+RiQrSo1vUkyEndC03WR2LbN
         32zyq2E+92hdrDqz/KWKIc9byoNgdAU3w9uLRM669uau7ZNA2V3vkybnHkD3aBG+yKW1
         oAl26Xet5QcpTqLwtLX3OsNohnIeTExCGGFj76fku+F5MudtjTAGR5a6oLkSepUVypyQ
         HuIWvsjd47dPHR6YpszxGB0e/vitpOYZ4YrxZPICbu2aN0/K0f8RoBWOOJ/ct6knmNu9
         2Rz2SL0I1iBbyg6oGsfwBKakz1x1Rg2K1jadkdxRxMwmqeND60ttrF1Yx7XIhUt3+fF8
         jRlA==
X-Gm-Message-State: APjAAAUaD09s78AWFhvuwk5+H4whQNEJRrcPWeUUBjGKsC1CBqtQKLQb
        1cwwi4xGRvjs70aXh6+9Hts=
X-Google-Smtp-Source: APXvYqyacElY5Z9Q1CVjkdFuKXjzLiIAcvlHdRQz9qpZxIchxNE4oR4O04kSRxy29esYPVZIl+YGdg==
X-Received: by 2002:a17:902:aa03:: with SMTP id be3mr5842278plb.240.1566577954950;
        Fri, 23 Aug 2019 09:32:34 -0700 (PDT)
Received: from localhost.localdomain ([139.198.121.136])
        by smtp.gmail.com with ESMTPSA id u7sm3060251pfm.96.2019.08.23.09.32.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 23 Aug 2019 09:32:34 -0700 (PDT)
From:   Feng Sun <loyou85@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, dsterba@suse.com, dbanerje@akamai.com,
        fw@strlen.de, davej@codemonkey.org.uk, tglx@linutronix.de,
        matwey@sai.msu.ru, sakari.ailus@linux.intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Sun <loyou85@gmail.com>,
        Xiaojun Zhao <xiaojunzhao141@gmail.com>
Subject: [PATCH] net: fix skb use after free in netpoll_send_skb_on_dev
Date:   Sat, 24 Aug 2019 00:32:00 +0800
Message-Id: <1566577920-20956-1-git-send-email-loyou85@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit baeababb5b85d5c4e6c917efe2a1504179438d3b
("tun: return NET_XMIT_DROP for dropped packets"),
when tun_net_xmit drop packets, it will free skb and return NET_XMIT_DROP,
netpoll_send_skb_on_dev will run into two use after free cases:
1. retry netpoll_start_xmit with freed skb;
2. queue freed skb in npinfo->txq.

hit the first case with following kernel log:

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
 net/core/netpoll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 2cf27da..b4bffe6 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -335,7 +335,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 
 				HARD_TX_UNLOCK(dev, txq);
 
-				if (status == NETDEV_TX_OK)
+				if (status == NETDEV_TX_OK || status == NET_XMIT_DROP)
 					break;
 
 			}
@@ -352,7 +352,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 
 	}
 
-	if (status != NETDEV_TX_OK) {
+	if (status != NETDEV_TX_OK && status != NET_XMIT_DROP) {
 		skb_queue_tail(&npinfo->txq, skb);
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}
-- 
2.7.4

