Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474001C2277
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 05:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgEBDQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 23:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgEBDQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 23:16:27 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391A9C061A0E
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 20:16:27 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id p13so5676922qvt.12
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 20:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lworb5UpeNJ31ys+5ITTrjwjHLN/UBHgYQzxeY/UWSo=;
        b=JOixvvnm2PR5uwk2LWcLrBVanrBNhBVeaTDWR/IKBzx5R+33lRaJ1gThE7UktcTRDs
         sy2A2TQHBNmQpgFkfvv5QY8vg5FJjy9sKTN2c56ZupeKWrJQqTTZm3O72r70AKXJlcEq
         j5Td8mYMii7DxTf+ymu9Vv/ePUEJYop+XEsA92B4/GrxEY4SROAKQWZinQdqlZBUPws9
         NVpPI9bEod9OZVA4WT1a11p9vAN4qK9qa3d05UKToW0eBS7HVnJerRfyMlDKULU+Xzly
         fliUwrR5OsxievIIebshI32+WLnkdwC/M57y34G865/iTekTY692cyz7i5RaEOVKbBGq
         EaEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lworb5UpeNJ31ys+5ITTrjwjHLN/UBHgYQzxeY/UWSo=;
        b=qm1w5JvwXGVGPZlQgyMqOqPnQBeDE047K31vajuCQnCoBKhvPn9p5Y7tpkBZjz4yeO
         DIv2IV0z1npZKnH9va9FGMApq+sKZbQN6Aw+ItQni+ox4mFVDbrpEFFwv4kZGFk1misU
         CI1Q9jPm3XOhssGwsgVMixnna2v+jszPwr+7mtokJXzYua/tZKc+L5FtGS+YAoIxw4ll
         RoYf4yuEnW487B3dCnrGLGkLB63dkX3FN/Q6buON9J7xWEO62YP7nv4+Nlxn4TSeBWey
         MiR9ddWKlk7fmY+WA8Pl13SgrzP0RR3tmJVVRwl204bhpzMQICsJkn4aWU8W3ZzH5XLs
         6cpA==
X-Gm-Message-State: AGi0PuaLgXYoX1uK4RjM4cMmE38YzmUHpGWHlT2olZVC8vTCaWeh07RP
        U9gZmqwcPOsCL3Z18Q9mlR9hqqbtMm+12Q==
X-Google-Smtp-Source: APiQypLJj58lOu5lGcplNS+Tiyudn02eVeYcPZQIMtWaeHOntzj35Uc1/rmg1qAnaw0+uRzDjMDPZw==
X-Received: by 2002:ad4:4c03:: with SMTP id bz3mr6821544qvb.224.1588389386189;
        Fri, 01 May 2020 20:16:26 -0700 (PDT)
Received: from ovpn-112-11.phx2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id c5sm4325806qkj.101.2020.05.01.20.16.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 20:16:25 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>
Subject: [PATCH] net: fix memory leaks in flush_backlog() with RPS
Date:   Fri,  1 May 2020 23:15:16 -0400
Message-Id: <20200502031516.2825-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_receive_skb_list_internal() could call enqueue_to_backlog() to put
some skb to softnet_data.input_pkt_queue and then in
ip_route_input_slow(), it allocates a dst_entry to be used in
skb_dst_set(). Later,

cleanup_net
  default_device_exit_batch
    unregister_netdevice_many
      rollback_registered_many
        flush_all_backlogs

will call flush_backlog() for all CPUs which would call kfree_skb() for
each skb on the input_pkt_queue without calling skb_dst_drop() first.

unreferenced object 0xffff97008e4c4040 (size 176):
 comm "softirq", pid 0, jiffies 4295173845 (age 32012.550s)
 hex dump (first 32 bytes):
   00 d0 a5 74 04 97 ff ff 40 72 1a 96 ff ff ff ff  ...t....@r......
   c1 a3 c5 95 ff ff ff ff 00 00 00 00 00 00 00 00  ................
 backtrace:
   [<0000000030483fae>] kmem_cache_alloc+0x184/0x430
   [<000000007ae17545>] dst_alloc+0x8e/0x128
   [<000000001efe9a1f>] rt_dst_alloc+0x6f/0x1e0
   rt_dst_alloc at net/ipv4/route.c:1628
   [<00000000e67d4dac>] ip_route_input_rcu+0xdfe/0x1640
   ip_route_input_slow at net/ipv4/route.c:2218
   (inlined by) ip_route_input_rcu at net/ipv4/route.c:2348
   [<000000009f30cbc0>] ip_route_input_noref+0xab/0x1a0
   [<000000004f53bd04>] arp_process+0x83a/0xf50
   arp_process at net/ipv4/arp.c:813 (discriminator 1)
   [<0000000061fd547d>] arp_rcv+0x276/0x330
   [<0000000007dbfa7a>] __netif_receive_skb_list_core+0x4d2/0x500
   [<0000000062d5f6d2>] netif_receive_skb_list_internal+0x4cb/0x7d0
   [<000000002baa2b74>] gro_normal_list+0x55/0xc0
   [<0000000093d04885>] napi_complete_done+0xea/0x350
   [<00000000467dd088>] tg3_poll_msix+0x174/0x310 [tg3]
   [<00000000498af7d9>] net_rx_action+0x278/0x890
   [<000000001e81d7e6>] __do_softirq+0xd9/0x589
   [<00000000087ee354>] irq_exit+0xa2/0xc0
   [<000000001c4db0cd>] do_IRQ+0x87/0x180

Signed-off-by: Qian Cai <cai@lca.pw>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..b898cd3036da 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5496,6 +5496,7 @@ static void flush_backlog(struct work_struct *work)
 	skb_queue_walk_safe(&sd->input_pkt_queue, skb, tmp) {
 		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
 			__skb_unlink(skb, &sd->input_pkt_queue);
+			skb_dst_drop(skb);
 			kfree_skb(skb);
 			input_queue_head_incr(sd);
 		}
-- 
2.21.0 (Apple Git-122.2)

