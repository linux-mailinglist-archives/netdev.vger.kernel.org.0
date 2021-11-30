Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6021463DD2
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244668AbhK3SdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245486AbhK3SdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 13:33:02 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A45FC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 10:29:43 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r138so20695796pgr.13
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 10:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DNNkGRhX9bo1wJ9oGn9hcpAs1XzT/55AlDCCL1S8Wi0=;
        b=ffm3S7WLzFIOa9p6pGq2MCZtO8ChLuSJRE/oehjCUdhrG1RWp9mRTwxtGFrHgv9dir
         zA7IFD9F7U5WmLLGSqBEOFoijEjegsoJjuo7/lpmWZOPT3h2q3wTJzp0LWKPG//McUQe
         +8fIwSG4VG0uZ55d4tkhcy7QWeSN+yl4OTrZBJzPbldEeTGtoAAmblU2V7mCeXzYpp1J
         EibZT73vrHIXNGGTlkVn2uNmRh8oZWFt33eQroy+diR+oh8JAlZLFDzfg+v6HVZ4D0JS
         1r6AJP3iOqzzt8svPgPronZl47FJbmtxQO8HbT8rYZHkrNTw7pyhi5fd01oNTk3+W7l8
         Loaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DNNkGRhX9bo1wJ9oGn9hcpAs1XzT/55AlDCCL1S8Wi0=;
        b=NW8FD5dCX8pfTK+td03ShxR+pcwpKXD2QoDmEQ7ERteKGnO6z/LEBqptq5e84FWk8X
         n4d33l0RLPQLZxvxrRqTNUw+4SaqnN0qkdEMFHg9Wjiqz/AOBkvzJZrlkq5JAdi3PXWP
         0ZZTesNG+kx9c7owE2YqU1570hqjSNO/SEOhTBN5CPbcT65yPxFqGbzd8oiwtwXoCd6g
         2dU8ZSHlvwyj6mLiEsPXN/73SiCc8qT1p9rY3Plb7S/feX7tTYDrWivgYgVi4ql5gYd+
         97Eeu5fjyaWl+3gjAsL5CDYcE0HFTppKdfodLpCYY1BCJFqZY527+bm1vOod8yfxWjR6
         XmcQ==
X-Gm-Message-State: AOAM532oYtPWIdDFjiUiFVDMFZxael9kU/gqD/4rSf4tHsV3+MqEziv+
        0on0+5wW49p4aLXh0vy54lI=
X-Google-Smtp-Source: ABdhPJxujn1RvquO0oQZiz6mFxOI0iJsPWDrIvtWeXdAShmgg8RUZt8Q2TfClK27HLo40hyDlY4IWA==
X-Received: by 2002:aa7:9ddb:0:b0:4a4:f597:a4ca with SMTP id g27-20020aa79ddb000000b004a4f597a4camr885805pfq.57.1638296982648;
        Tue, 30 Nov 2021 10:29:42 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8fa3:c6c6:cc36:151])
        by smtp.gmail.com with ESMTPSA id h128sm20816550pfg.212.2021.11.30.10.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 10:29:42 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: avoid uninit-value from tcp_conn_request
Date:   Tue, 30 Nov 2021 10:29:39 -0800
Message-Id: <20211130182939.2584764-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

A recent change triggers a KMSAN warning, because request
sockets do not initialize @sk_rx_queue_mapping field.

Add sk_rx_queue_update() helper to make our intent clear.

BUG: KMSAN: uninit-value in sk_rx_queue_set include/net/sock.h:1922 [inline]
BUG: KMSAN: uninit-value in tcp_conn_request+0x3bcc/0x4dc0 net/ipv4/tcp_input.c:6922
 sk_rx_queue_set include/net/sock.h:1922 [inline]
 tcp_conn_request+0x3bcc/0x4dc0 net/ipv4/tcp_input.c:6922
 tcp_v4_conn_request+0x218/0x2a0 net/ipv4/tcp_ipv4.c:1528
 tcp_rcv_state_process+0x2c5/0x3290 net/ipv4/tcp_input.c:6406
 tcp_v4_do_rcv+0xb4e/0x1330 net/ipv4/tcp_ipv4.c:1738
 tcp_v4_rcv+0x468d/0x4ed0 net/ipv4/tcp_ipv4.c:2100
 ip_protocol_deliver_rcu+0x760/0x10b0 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_local_deliver+0x584/0x8c0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:460 [inline]
 ip_sublist_rcv_finish net/ipv4/ip_input.c:551 [inline]
 ip_list_rcv_finish net/ipv4/ip_input.c:601 [inline]
 ip_sublist_rcv+0x11fd/0x1520 net/ipv4/ip_input.c:609
 ip_list_rcv+0x95f/0x9a0 net/ipv4/ip_input.c:644
 __netif_receive_skb_list_ptype net/core/dev.c:5505 [inline]
 __netif_receive_skb_list_core+0xe34/0x1240 net/core/dev.c:5553
 __netif_receive_skb_list+0x7fc/0x960 net/core/dev.c:5605
 netif_receive_skb_list_internal+0x868/0xde0 net/core/dev.c:5696
 gro_normal_list net/core/dev.c:5850 [inline]
 napi_complete_done+0x579/0xdd0 net/core/dev.c:6587
 virtqueue_napi_complete drivers/net/virtio_net.c:339 [inline]
 virtnet_poll+0x17b6/0x2350 drivers/net/virtio_net.c:1557
 __napi_poll+0x14e/0xbc0 net/core/dev.c:7020
 napi_poll net/core/dev.c:7087 [inline]
 net_rx_action+0x824/0x1880 net/core/dev.c:7174
 __do_softirq+0x1fe/0x7eb kernel/softirq.c:558
 invoke_softirq+0xa4/0x130 kernel/softirq.c:432
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0x76/0x130 kernel/softirq.c:648
 common_interrupt+0xb6/0xd0 arch/x86/kernel/irq.c:240
 asm_common_interrupt+0x1e/0x40
 smap_restore arch/x86/include/asm/smap.h:67 [inline]
 get_shadow_origin_ptr mm/kmsan/instrumentation.c:31 [inline]
 __msan_metadata_ptr_for_load_1+0x28/0x30 mm/kmsan/instrumentation.c:63
 tomoyo_check_acl+0x1b0/0x630 security/tomoyo/domain.c:173
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_check_open_permission+0x61f/0xe10 security/tomoyo/file.c:777
 tomoyo_file_open+0x24f/0x2d0 security/tomoyo/tomoyo.c:311
 security_file_open+0xb1/0x1f0 security/security.c:1635
 do_dentry_open+0x4e4/0x1bf0 fs/open.c:809
 vfs_open+0xaf/0xe0 fs/open.c:957
 do_open fs/namei.c:3426 [inline]
 path_openat+0x52f1/0x5dd0 fs/namei.c:3559
 do_filp_open+0x306/0x760 fs/namei.c:3586
 do_sys_openat2+0x263/0x8f0 fs/open.c:1212
 do_sys_open fs/open.c:1228 [inline]
 __do_sys_open fs/open.c:1236 [inline]
 __se_sys_open fs/open.c:1232 [inline]
 __x64_sys_open+0x314/0x380 fs/open.c:1232
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 __alloc_pages+0xbc7/0x10a0 mm/page_alloc.c:5409
 alloc_pages+0x8a5/0xb80
 alloc_slab_page mm/slub.c:1810 [inline]
 allocate_slab+0x287/0x1c20 mm/slub.c:1947
 new_slab mm/slub.c:2010 [inline]
 ___slab_alloc+0xbdf/0x1e90 mm/slub.c:3039
 __slab_alloc mm/slub.c:3126 [inline]
 slab_alloc_node mm/slub.c:3217 [inline]
 slab_alloc mm/slub.c:3259 [inline]
 kmem_cache_alloc+0xbb3/0x11c0 mm/slub.c:3264
 reqsk_alloc include/net/request_sock.h:91 [inline]
 inet_reqsk_alloc+0xaf/0x8b0 net/ipv4/tcp_input.c:6712
 tcp_conn_request+0x910/0x4dc0 net/ipv4/tcp_input.c:6852
 tcp_v4_conn_request+0x218/0x2a0 net/ipv4/tcp_ipv4.c:1528
 tcp_rcv_state_process+0x2c5/0x3290 net/ipv4/tcp_input.c:6406
 tcp_v4_do_rcv+0xb4e/0x1330 net/ipv4/tcp_ipv4.c:1738
 tcp_v4_rcv+0x468d/0x4ed0 net/ipv4/tcp_ipv4.c:2100
 ip_protocol_deliver_rcu+0x760/0x10b0 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_local_deliver+0x584/0x8c0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:460 [inline]
 ip_sublist_rcv_finish net/ipv4/ip_input.c:551 [inline]
 ip_list_rcv_finish net/ipv4/ip_input.c:601 [inline]
 ip_sublist_rcv+0x11fd/0x1520 net/ipv4/ip_input.c:609
 ip_list_rcv+0x95f/0x9a0 net/ipv4/ip_input.c:644
 __netif_receive_skb_list_ptype net/core/dev.c:5505 [inline]
 __netif_receive_skb_list_core+0xe34/0x1240 net/core/dev.c:5553
 __netif_receive_skb_list+0x7fc/0x960 net/core/dev.c:5605
 netif_receive_skb_list_internal+0x868/0xde0 net/core/dev.c:5696
 gro_normal_list net/core/dev.c:5850 [inline]
 napi_complete_done+0x579/0xdd0 net/core/dev.c:6587
 virtqueue_napi_complete drivers/net/virtio_net.c:339 [inline]
 virtnet_poll+0x17b6/0x2350 drivers/net/virtio_net.c:1557
 __napi_poll+0x14e/0xbc0 net/core/dev.c:7020
 napi_poll net/core/dev.c:7087 [inline]
 net_rx_action+0x824/0x1880 net/core/dev.c:7174
 __do_softirq+0x1fe/0x7eb kernel/softirq.c:558

Fixes: 342159ee394d ("net: avoid dirtying sk->sk_rx_queue_mapping")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/busy_poll.h |  2 +-
 include/net/sock.h      | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 4202c609bb0b09345c0f1c5105adf409a3a89f74..7994455ec714610fbcb563d8c7a1411b02201e05 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -133,7 +133,7 @@ static inline void sk_mark_napi_id(struct sock *sk, const struct sk_buff *skb)
 	if (unlikely(READ_ONCE(sk->sk_napi_id) != skb->napi_id))
 		WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
 #endif
-	sk_rx_queue_set(sk, skb);
+	sk_rx_queue_update(sk, skb);
 }
 
 static inline void __sk_mark_napi_id_once(struct sock *sk, unsigned int napi_id)
diff --git a/include/net/sock.h b/include/net/sock.h
index 715cdb4b2b79c4e79256fe5421c98a70e2eff880..9058634a9709f5d148eea29dd069b16cc5818d04 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1913,18 +1913,32 @@ static inline int sk_tx_queue_get(const struct sock *sk)
 	return -1;
 }
 
-static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
+static inline void __sk_rx_queue_set(struct sock *sk,
+				     const struct sk_buff *skb,
+				     bool force_set)
 {
 #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 	if (skb_rx_queue_recorded(skb)) {
 		u16 rx_queue = skb_get_rx_queue(skb);
 
-		if (unlikely(READ_ONCE(sk->sk_rx_queue_mapping) != rx_queue))
+		if (force_set ||
+		    unlikely(READ_ONCE(sk->sk_rx_queue_mapping) != rx_queue))
 			WRITE_ONCE(sk->sk_rx_queue_mapping, rx_queue);
 	}
 #endif
 }
 
+static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
+{
+	__sk_rx_queue_set(sk, skb, true);
+}
+
+static inline void sk_rx_queue_update(struct sock *sk, const struct sk_buff *skb)
+{
+	__sk_rx_queue_set(sk, skb, false);
+}
+
+
 static inline void sk_rx_queue_clear(struct sock *sk)
 {
 #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
-- 
2.34.0.rc2.393.gf8c9666880-goog

