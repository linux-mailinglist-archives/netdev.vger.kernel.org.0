Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A41267F55
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 13:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgIMLhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 07:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgIMLho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 07:37:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0A6C061573
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 04:37:43 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g21so1828447plq.1
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 04:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O3SsmOzr+fbC5y019x+72fktAEhgHZsYFbWAdfH2+6I=;
        b=EEdOUN6E7KCLSY06sJbazMzdA60BCmFgnqX9Bep1h5357CXuV64s31cxxaOvrcCyBS
         UUvOW2Hl2YJLuUIxNpEKlZ0xXGsqmW6Ho1mKH4xUOUeHLsl+Kv0fL/a4n8J/wCcFb6Yc
         Dsne8TCdbQOwjcFvVkD96vqcPkVk4nC/ZEISmH1fG3CuDf1WJoR4pUte8LT/R3+thyOn
         WkU51X3bTCw48X4VBoF8cPQdh0/3l+yWmxh3JSwlgMvFvC+gP9HdATBj+Dy+XTn6Ir9e
         NRRgcrkjpltQ0TLAJLoVlXsGU0Ufw7tSfAK2bPEmVdJUihr+LOih4JjR26R+fcrsTs1i
         gfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O3SsmOzr+fbC5y019x+72fktAEhgHZsYFbWAdfH2+6I=;
        b=tGYlcVKvS8LEL7ESqVaqikZyuStNf6ZbYU6wa9F0t4BGav/7IoEqFXtO/j876wkJhq
         3ZiFUfD1suvkWuhW1nZO2YpFzokdgzO6b7GWqHIpZoXdHo06rtT5WtEXHCwgkuqoh50N
         hLgx2EYST3ltO8JEO4mWeTUBV9Ky8NnhGKlhR6Ai9Yr0uVanPbtQqYzfXyhMLpKpswR3
         lBSzCRWBxo/qNlRyCDNHNjbRghmkCWwhaTdNl0wZnD9HEvF7P3jtjsh16qBVxbKaEgIB
         FXjcZCrifKv02yHAS9naBNaRx4iNxDNeru26as1LEcQCVa0aPa1KIJMeK4yzHByGm4/c
         ZkSg==
X-Gm-Message-State: AOAM532s3FSENMXfUVpLcS5b7r6SkK3FCEOhc5m5fLkgWUwqR4X11zD8
        z8uzq0FHLJsGBJpzNa4t3mIeDWNjkec=
X-Google-Smtp-Source: ABdhPJyr9SQCUN52OEa7f/Sph/5HNWLw11AIKdMMui1WiVCv8F0swvzzDbVdRpgWYjI5GUe2OD23+Q==
X-Received: by 2002:a17:90b:a44:: with SMTP id gw4mr9280089pjb.26.1599997060023;
        Sun, 13 Sep 2020 04:37:40 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j18sm5837320pgm.30.2020.09.13.04.37.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Sep 2020 04:37:39 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [PATCH net] tipc: use skb_unshare() instead in tipc_buf_append()
Date:   Sun, 13 Sep 2020 19:37:31 +0800
Message-Id: <0fcddb2bab6bde5632dcd4889961ebce1ec8bb8f.1599997051.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tipc_buf_append() it may change skb's frag_list, and it causes
problems when this skb is cloned. skb_unclone() doesn't really
make this skb's flag_list available to change.

Shuang Li has reported an use-after-free issue because of this
when creating quite a few macvlan dev over the same dev, where
the broadcast packets will be cloned and go up to the stack:

 [ ] BUG: KASAN: use-after-free in pskb_expand_head+0x86d/0xea0
 [ ] Call Trace:
 [ ]  dump_stack+0x7c/0xb0
 [ ]  print_address_description.constprop.7+0x1a/0x220
 [ ]  kasan_report.cold.10+0x37/0x7c
 [ ]  check_memory_region+0x183/0x1e0
 [ ]  pskb_expand_head+0x86d/0xea0
 [ ]  process_backlog+0x1df/0x660
 [ ]  net_rx_action+0x3b4/0xc90
 [ ]
 [ ] Allocated by task 1786:
 [ ]  kmem_cache_alloc+0xbf/0x220
 [ ]  skb_clone+0x10a/0x300
 [ ]  macvlan_broadcast+0x2f6/0x590 [macvlan]
 [ ]  macvlan_process_broadcast+0x37c/0x516 [macvlan]
 [ ]  process_one_work+0x66a/0x1060
 [ ]  worker_thread+0x87/0xb10
 [ ]
 [ ] Freed by task 3253:
 [ ]  kmem_cache_free+0x82/0x2a0
 [ ]  skb_release_data+0x2c3/0x6e0
 [ ]  kfree_skb+0x78/0x1d0
 [ ]  tipc_recvmsg+0x3be/0xa40 [tipc]

So fix it by using skb_unshare() instead, which would create a new
skb for the cloned frag and it'll be safe to change its frag_list.
The similar things were also done in sctp_make_reassembled_event(),
which is using skb_copy().

Reported-by: Shuang Li <shuali@redhat.com>
Fixes: 37e22164a8a3 ("tipc: rename and move message reassembly function")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/msg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 848fae6..52e93ba 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -150,7 +150,8 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 	if (fragid == FIRST_FRAGMENT) {
 		if (unlikely(head))
 			goto err;
-		if (unlikely(skb_unclone(frag, GFP_ATOMIC)))
+		frag = skb_unshare(frag, GFP_ATOMIC);
+		if (unlikely(!frag))
 			goto err;
 		head = *headbuf = frag;
 		*buf = NULL;
-- 
2.1.0

