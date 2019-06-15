Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF31847203
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfFOUUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:20:00 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:34676 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOUT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:19:59 -0400
Received: by mail-pf1-f201.google.com with SMTP id i2so4253359pfe.1
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 13:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=m+tb1TxSVE7BW4UPuYGNWeOwHBJ8YiWVvNbsVf1UHPo=;
        b=HsnOyVvzOiCkBShWxSoO5xtoww08ZRGwwmt7tpJqR7tw2BYIKaqP6iLgiFsDnw+IuN
         8YUiIFKpkOTprPC9TjLiSbqfHrC6KrmFX4jfvHbUnDgNqz2N6WPPjfKVshG5kZIHtVBd
         /UcP/CvvaWDnhzsSIwxYGdVltrTcbj1gxg5/gsAML8VYrA+MG3kmQj50/Srz4jxJyWkY
         ZX8UHrczT4v/GTqWFcNkfLq44ZXygGOfjA5T0cfxRBeY6OMfwbsSjdczrGqXCDi4JToN
         qrmDgv7OIMEX755ZeXBvG/hXFIJz0RCGVdwhFNsGonzP8M3qaKwZuljQW4gtYVKed2E9
         vrDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=m+tb1TxSVE7BW4UPuYGNWeOwHBJ8YiWVvNbsVf1UHPo=;
        b=EPJxXEkyCeXlcIJ7a0JTVRXuQXeMUaQATFdFcIlE1YNUrrCkA+18Ac50+RY8btxw3l
         xZxKQGIpWqmXPT8oZ1xoTU0aVGAvCsJiQT/y2bwsIF1m7cqnkPS0hui0cItWCKs048Yj
         81E6JvyrcUzWeQESm8WXvYANUdotb5LgKzwZusbEaNBCNmbbBk4kArBAQxXptFTBZXB3
         LPvxGhZJzpUS5I6O4XXSCYwXwdYG6pgbeS5rpIbZBEy/lsQm2pIoOFE/xeMIaWk/aNSB
         w/ZorbrfZIAgVZOnRVvoHoPnlAai4tqcr6RkkY1VQmJakIq8PyKniwNQMs1qFeIo/Kjo
         U8kw==
X-Gm-Message-State: APjAAAUpNOtn+aZ7QBYLyIdaUHMIQOUdhjCE+QLWwQXkwn+GXlQgNB1l
        oPWUY7dPQN/S+Z8ytyOBcNGpYSloVUFg3w==
X-Google-Smtp-Source: APXvYqxijTKLR7A7QZHo6Ja1SqPYCiytyDsn24weLu6Tf/6lddsGGFpv9longTT1oV26K+CVSvh0qSlnrALwkw==
X-Received: by 2002:a63:d512:: with SMTP id c18mr23175582pgg.397.1560629998758;
 Sat, 15 Jun 2019 13:19:58 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:19:55 -0700
Message-Id: <20190615201955.97598-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] tcp: fix compile error if !CONFIG_SYSCTL
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_tx_skb_cache_key and tcp_rx_skb_cache_key must be available
even if CONFIG_SYSCTL is not set.

Fixes: 0b7d7f6b2208 ("tcp: add tcp_tx_skb_cache sysctl")
Fixes: ede61ca474a0 ("tcp: add tcp_rx_skb_cache sysctl")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/sysctl_net_ipv4.c | 5 -----
 net/ipv4/tcp.c             | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 08a428a7b2749c4f2a03aa6352e44c053596ef75..fa213bd8e233b577114815ca2227f08264e7df06 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -51,11 +51,6 @@ static int comp_sack_nr_max = 255;
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
 
-DEFINE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
-EXPORT_SYMBOL(tcp_rx_skb_cache_key);
-
-DEFINE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
-
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f12d500ec85cf770b0b94cb5e08d16f77e4c126b..f448a288d158c4baa6d8d5ed82c4b129404233a1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -317,6 +317,11 @@ struct tcp_splice_state {
 unsigned long tcp_memory_pressure __read_mostly;
 EXPORT_SYMBOL_GPL(tcp_memory_pressure);
 
+DEFINE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
+EXPORT_SYMBOL(tcp_rx_skb_cache_key);
+
+DEFINE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
+
 void tcp_enter_memory_pressure(struct sock *sk)
 {
 	unsigned long val;
-- 
2.22.0.410.gd8fdbe21b5-goog

