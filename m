Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2381466DEE
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 00:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349615AbhLBXkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 18:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbhLBXkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 18:40:52 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154BAC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 15:37:30 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 137so1295122pgg.3
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 15:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pSOjQcEHl+jIhy0NuyRLzXyfTvIt1SsvTrR2whrkg2g=;
        b=Sh2nDxIX9nBTslom7JEHU6oOybcwnyskreXTZxuxUjW146fNG2ETphT6qo5yTO3z+v
         As9g9XyEPJjTpdtvKpg12neaZhOUzNtbsdahBNzNL6Vap2DHUBXhwTJuPUCL31WES82R
         pvRj0UyrNWIjPTlKJ6LSTHjrmihJ+UZjx3nbU+InXMEPg6uCO2cKjq87bxDacQzTT7Aw
         Cmf0jgmCquH67DRonfdDXbHWntAXokPmqYjECV6MwKmS1ryTH1CAaj22O9B/ZQPWKKw5
         fcODB8kpFB4Z3KGdlQMqLaSuM8YqMldYAK/QqIWZ+K/QupAgCrjZ52hJkEj4Q0CzF4Fn
         +ceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pSOjQcEHl+jIhy0NuyRLzXyfTvIt1SsvTrR2whrkg2g=;
        b=cByhRj0/iSOf9D+zhGeVQBXPy2lIfaoerUHGcmbXr4kBy9h6+oflYbNaGCVzk7MuP0
         Pd8u2uvZovTcyRAftV1t+J8zGoH5d8KYuwvb41w6Vdv7WzRfftanqgKn0NfmhSMeoERU
         i876/BePoAV7w1DFS0Jsi11cU15X9PigevdQfNXX1CjBm3qtycGdXS3vZR2vD4hyNr8u
         cy/rgtHvFbXqxheLwYIPdFm0xWfPNnsag/UQ1ZZ62NqjPR66G5SpDjFPa4qEeaxP5Xdy
         htaIO3C4ERZRMIQI9Pj4yTdVIwu+jp8JTLM8vdUvne42VmjbAlA/OZvoYDaRuSxBk6NW
         Sqmw==
X-Gm-Message-State: AOAM532uGsdogTdhcgbN2qiHg8M0hlQ+fM6ViuCmbwApP0oVGnrsra3C
        tU6fFhIWGJUYQrfX/9Bx/iY=
X-Google-Smtp-Source: ABdhPJyktv2nWhPubl8vygqSNTtdWhf7wRd3jKbq3mNkcGWS+izusTILyz95DllcZxAkIGdSgmzrEg==
X-Received: by 2002:a63:a59:: with SMTP id z25mr1776746pgk.285.1638488249316;
        Thu, 02 Dec 2021 15:37:29 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id y7sm575619pge.44.2021.12.02.15.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 15:37:28 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] tcp: fix another uninit-value (sk_rx_queue_mapping)
Date:   Thu,  2 Dec 2021 15:37:24 -0800
Message-Id: <20211202233724.325226-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

KMSAN is still not happy [1].

I missed that passive connections do not inherit their
sk_rx_queue_mapping values from the request socket,
but instead tcp_child_process() is calling
sk_mark_napi_id(child, skb)

We have many sk_mark_napi_id() callers, so I am providing
a new helper, forcing the setting sk_rx_queue_mapping
and sk_napi_id.

Note that we had no KMSAN report for sk_napi_id because
passive connections got a copy of this field from the listener.
sk_rx_queue_mapping in the other hand is inside the
sk_dontcopy_begin/sk_dontcopy_end so sk_clone_lock()
leaves this field uninitialized.

We might remove dead code populating req->sk_rx_queue_mapping
in the future.

[1]

BUG: KMSAN: uninit-value in __sk_rx_queue_set include/net/sock.h:1924 [inline]
BUG: KMSAN: uninit-value in sk_rx_queue_update include/net/sock.h:1938 [inline]
BUG: KMSAN: uninit-value in sk_mark_napi_id include/net/busy_poll.h:136 [inline]
BUG: KMSAN: uninit-value in tcp_child_process+0xb42/0x1050 net/ipv4/tcp_minisocks.c:833
 __sk_rx_queue_set include/net/sock.h:1924 [inline]
 sk_rx_queue_update include/net/sock.h:1938 [inline]
 sk_mark_napi_id include/net/busy_poll.h:136 [inline]
 tcp_child_process+0xb42/0x1050 net/ipv4/tcp_minisocks.c:833
 tcp_v4_rcv+0x3d83/0x4ed0 net/ipv4/tcp_ipv4.c:2066
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
 run_ksoftirqd+0x33/0x50 kernel/softirq.c:920
 smpboot_thread_fn+0x616/0xbf0 kernel/smpboot.c:164
 kthread+0x721/0x850 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

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
 sk_prot_alloc+0xeb/0x570 net/core/sock.c:1914
 sk_clone_lock+0xd6/0x1940 net/core/sock.c:2118
 inet_csk_clone_lock+0x8d/0x6a0 net/ipv4/inet_connection_sock.c:956
 tcp_create_openreq_child+0xb1/0x1ef0 net/ipv4/tcp_minisocks.c:453
 tcp_v4_syn_recv_sock+0x268/0x2710 net/ipv4/tcp_ipv4.c:1563
 tcp_check_req+0x207c/0x2a30 net/ipv4/tcp_minisocks.c:765
 tcp_v4_rcv+0x36f5/0x4ed0 net/ipv4/tcp_ipv4.c:2047
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
Fixes: a37a0ee4d25c ("net: avoid uninit-value from tcp_conn_request")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/busy_poll.h  | 13 +++++++++++++
 net/ipv4/tcp_minisocks.c |  4 ++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 7994455ec714610fbcb563d8c7a1411b02201e05..c4898fcbf923bf01f14c6bcc694eb036d75d7195 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -136,6 +136,19 @@ static inline void sk_mark_napi_id(struct sock *sk, const struct sk_buff *skb)
 	sk_rx_queue_update(sk, skb);
 }
 
+/* Variant of sk_mark_napi_id() for passive flow setup,
+ * as sk->sk_napi_id and sk->sk_rx_queue_mapping content
+ * needs to be set.
+ */
+static inline void sk_mark_napi_id_set(struct sock *sk,
+				       const struct sk_buff *skb)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
+#endif
+	sk_rx_queue_set(sk, skb);
+}
+
 static inline void __sk_mark_napi_id_once(struct sock *sk, unsigned int napi_id)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cf913a66df17023bbab8b42e313ce646858c268a..7c2d3ac2363acebcfd92d7a4886c052c8aa120b9 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -829,8 +829,8 @@ int tcp_child_process(struct sock *parent, struct sock *child,
 	int ret = 0;
 	int state = child->sk_state;
 
-	/* record NAPI ID of child */
-	sk_mark_napi_id(child, skb);
+	/* record sk_napi_id and sk_rx_queue_mapping of child. */
+	sk_mark_napi_id_set(child, skb);
 
 	tcp_segs_in(tcp_sk(child), skb);
 	if (!sock_owned_by_user(child)) {
-- 
2.34.1.400.ga245620fadb-goog

