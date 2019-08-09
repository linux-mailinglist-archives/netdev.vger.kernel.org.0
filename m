Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C03872FA
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 09:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405785AbfHIHat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 03:30:49 -0400
Received: from mail5.windriver.com ([192.103.53.11]:35634 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405691AbfHIHas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 03:30:48 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x797SGKJ017009
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Fri, 9 Aug 2019 00:28:57 -0700
Received: from pek-yxue-d1.wrs.com (128.224.155.90) by ALA-HCB.corp.ad.wrs.com
 (147.11.189.41) with Microsoft SMTP Server id 14.3.468.0; Fri, 9 Aug 2019
 00:28:41 -0700
From:   Ying Xue <ying.xue@windriver.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <jon.maloy@ericsson.com>, <hdanton@sina.com>,
        <tipc-discussion@lists.sourceforge.net>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH 1/3] tipc: fix memory leak issue
Date:   Fri, 9 Aug 2019 15:16:55 +0800
Message-ID: <1565335017-21302-2-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565335017-21302-1-git-send-email-ying.xue@windriver.com>
References: <1565335017-21302-1-git-send-email-ying.xue@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found the following memory leak:

[   68.602482][ T7130] kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
BUG: memory leak
unreferenced object 0xffff88810df83c00 (size 512):
  comm "softirq", pid 0, jiffies 4294942354 (age 19.830s)
  hex dump (first 32 bytes):
    38 1a 0d 0f 81 88 ff ff 38 1a 0d 0f 81 88 ff ff  8.......8.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000009375ee42>] kmem_cache_alloc_node+0x153/0x2a0
    [<000000004c563922>] __alloc_skb+0x6e/0x210
    [<00000000ec87bfa1>] tipc_buf_acquire+0x2f/0x80
    [<00000000d151ef84>] tipc_msg_create+0x37/0xe0
    [<000000008bb437b0>] tipc_group_create_event+0xb3/0x1b0
    [<00000000947b1d0f>] tipc_group_proto_rcv+0x569/0x640
    [<00000000b75ab039>] tipc_sk_filter_rcv+0x9ac/0xf20
    [<000000000dab7a6c>] tipc_sk_rcv+0x494/0x8a0
    [<00000000023a7ddd>] tipc_node_xmit+0x196/0x1f0
    [<00000000337dd9eb>] tipc_node_distr_xmit+0x7d/0x120
    [<00000000b6375182>] tipc_group_delete+0xe6/0x130
    [<000000000361ba2b>] tipc_sk_leave+0x57/0xb0
    [<000000009df90505>] tipc_release+0x7b/0x5e0
    [<000000009f3189da>] __sock_release+0x4b/0xe0
    [<00000000d3568ee0>] sock_close+0x1b/0x30
    [<00000000266a6215>] __fput+0xed/0x300

Reported-by: syzbot+78fbe679c8ca8d264a8d@syzkaller.appspotmail.com
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 net/tipc/node.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 7ca0190..d1852fc 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1469,10 +1469,13 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 	spin_unlock_bh(&le->lock);
 	tipc_node_read_unlock(n);
 
-	if (unlikely(rc == -ENOBUFS))
+	if (unlikely(rc == -ENOBUFS)) {
 		tipc_node_link_down(n, bearer_id, false);
-	else
+		skb_queue_purge(list);
+		skb_queue_purge(&xmitq);
+	} else {
 		tipc_bearer_xmit(net, bearer_id, &xmitq, &le->maddr);
+	}
 
 	tipc_node_put(n);
 
-- 
2.7.4

