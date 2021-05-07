Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B06376AE5
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 21:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhEGT6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 15:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhEGT6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 15:58:13 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754BCC061574
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 12:57:12 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b21so1531379pft.10
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 12:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=keKVx8ecKfHyBnMmZojREe/lOoF10dNBHzj+OjKNMnM=;
        b=rH0D6MrG6wmI/a62m2Xn1N1ki/V5y7mrOnbtmLEUYmfET5P3XB33PsZCDZqsm1ykfe
         Kwf5Tqzn6l817FDNjOAxpQeF5Hsn0RS+gxp5ZVa3o4ItpVTUmH/iezmpG6GvekkoaRgC
         1IQgZh/NKmY7z71zGV7TjY6SEAALQ8MsknyeAm40SD2QLga7s3l1FtX78yMv5Hm0hijS
         tv2UTXZWRJapgD7zL4ZWEcS7m3EQ2M1Kh9cl4z1BDkpvJcHV/4rDWVefjX72hb4N731Z
         tcvR90XrUAbBhAlROzq7mHdYHv3GUDgnfR7HHnyPkgkR+kzOydluM8rQ4qBLBLJb/btI
         52jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=keKVx8ecKfHyBnMmZojREe/lOoF10dNBHzj+OjKNMnM=;
        b=IZsv3bJrWstu32P3RjdwxwU4hqiy5DlCgR980eJFtrE8M4p/8bj7jrAZxH+N+SYR1Z
         E09Baolo+nOfJthEDOE2kA53wNj1I7TvP3tNXYlNw3BT8yKtpdVnFFE51sYUbvGl3cKV
         27B6FwMk5Q57750y1jka36zHhKnauVJMEa79woLPmY3fWPgGrBKPu0UorcOChc3NybT3
         onq8jESk0qmGlTfO00a4t+mqcNX17ZVASpCGJ03YXWRKyoFIt0j7BYme2leNUxRyZY6E
         Wh/PLHHsp39g6XZbkuyK+d08B6yYkbYSo+fuH7xfsEYkwB658Hqoh/slSJU1187IL7ch
         UlZQ==
X-Gm-Message-State: AOAM531kBhLI2RiM5APMV5gC0Xp93c0L+4M87d/wHe+/mC+CDg8hUoJz
        N//0de4cy4kE+QARLN5AU16IzA5T2rAWaw==
X-Google-Smtp-Source: ABdhPJzWuxzny4VEzZk7kyZgVllaH8qgykh/x7dK1QbbnOEdvp/AJysSqO4Tl7jOP+pF5AakrD4JFw==
X-Received: by 2002:a63:e443:: with SMTP id i3mr11903574pgk.114.1620417431570;
        Fri, 07 May 2021 12:57:11 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f1sm12312498pjt.50.2021.05.07.12.57.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 May 2021 12:57:10 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [PATCH net] tipc: skb_linearize the head skb when reassembling msgs
Date:   Sat,  8 May 2021 03:57:03 +0800
Message-Id: <c7d752b5522360de0a6886202c59fe49524a9fda.1620417423.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not a good idea to append the frag skb to a skb's frag_list if
the frag_list already has skbs from elsewhere, such as this skb was
created by pskb_copy() where the frag_list was cloned (all the skbs
in it were skb_get'ed) and shared by multiple skbs.

However, the new appended frag skb should have been only seen by the
current skb. Otherwise, it will cause use after free crashes as this
appended frag skb are seen by multiple skbs but it only got skb_get
called once.

The same thing happens with a skb updated by pskb_may_pull() with a
skb_cloned skb. Li Shuang has reported quite a few crashes caused
by this when doing testing over macvlan devices:

  [] kernel BUG at net/core/skbuff.c:1970!
  [] Call Trace:
  []  skb_clone+0x4d/0xb0
  []  macvlan_broadcast+0xd8/0x160 [macvlan]
  []  macvlan_process_broadcast+0x148/0x150 [macvlan]
  []  process_one_work+0x1a7/0x360
  []  worker_thread+0x30/0x390

  [] kernel BUG at mm/usercopy.c:102!
  [] Call Trace:
  []  __check_heap_object+0xd3/0x100
  []  __check_object_size+0xff/0x16b
  []  simple_copy_to_iter+0x1c/0x30
  []  __skb_datagram_iter+0x7d/0x310
  []  __skb_datagram_iter+0x2a5/0x310
  []  skb_copy_datagram_iter+0x3b/0x90
  []  tipc_recvmsg+0x14a/0x3a0 [tipc]
  []  ____sys_recvmsg+0x91/0x150
  []  ___sys_recvmsg+0x7b/0xc0

  [] kernel BUG at mm/slub.c:305!
  [] Call Trace:
  []  <IRQ>
  []  kmem_cache_free+0x3ff/0x400
  []  __netif_receive_skb_core+0x12c/0xc40
  []  ? kmem_cache_alloc+0x12e/0x270
  []  netif_receive_skb_internal+0x3d/0xb0
  []  ? get_rx_page_info+0x8e/0xa0 [be2net]
  []  be_poll+0x6ef/0xd00 [be2net]
  []  ? irq_exit+0x4f/0x100
  []  net_rx_action+0x149/0x3b0

  ...

This patch is to fix it by linearizing the head skb if it has frag_list
set in tipc_buf_append(). Note that we choose to do this before calling
skb_unshare(), as __skb_linearize() will avoid skb_copy(). Also, we can
not just drop the frag_list either as the early time.

Fixes: 45c8b7b175ce ("tipc: allow non-linear first fragment buffer")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/msg.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 3f0a253..ce6ab54 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -149,18 +149,13 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 		if (unlikely(head))
 			goto err;
 		*buf = NULL;
+		if (skb_has_frag_list(frag) && __skb_linearize(frag))
+			goto err;
 		frag = skb_unshare(frag, GFP_ATOMIC);
 		if (unlikely(!frag))
 			goto err;
 		head = *headbuf = frag;
 		TIPC_SKB_CB(head)->tail = NULL;
-		if (skb_is_nonlinear(head)) {
-			skb_walk_frags(head, tail) {
-				TIPC_SKB_CB(head)->tail = tail;
-			}
-		} else {
-			skb_frag_list_init(head);
-		}
 		return 0;
 	}
 
-- 
2.1.0

