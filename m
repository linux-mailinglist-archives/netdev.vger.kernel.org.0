Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3579B3538
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbfIPHLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:11:11 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45835 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfIPHLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:11:11 -0400
Received: by mail-pl1-f196.google.com with SMTP id x3so16477258plr.12
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=5ilzAvOO8GVQbmHSUWM4xC4qpQ7lP8MltccZQ342TDA=;
        b=iq430/nzJjFfGWZK2C/wdF5gDoNcEZyVXoc/xxkRET6RP/U9sLSeYAXyab8lUYBV0l
         P531DMLosWUcXyousaeKTkkBGtVruvFaVGXHmP8Qjly+CY0fpG3WSdW0J0KdLAj4eUSS
         evIvhvR8vxErjR1Q5dWBpvncgxjSk3dUhg0aeyghcDuaEm3G56aPJiHNX0P2VTGf950U
         bjE23HzoBLphsWkHJBwSqfppxgRl6J+YzlAOdQUp1i/QXw+9vt+yzUUW//s59v1hzWSa
         AchOMNJ9GpCG9KY1bobqv6BZG3oU9fYcpeuEPp50MKU3qtSRywd0/MjLR6phFti594/P
         Ru6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=5ilzAvOO8GVQbmHSUWM4xC4qpQ7lP8MltccZQ342TDA=;
        b=rbSOdjAd4G01tS/vqI/FLWMHwcx3aG3+jZKFOVEe/JEqz/ri6Q0Kq2O+vYrf/i7svl
         83ZgnwnUEmQfOpyDx6hpBgzaBdVOeaF4kGDZO2P2VKfP6ekk1bn8iBVCTJUZJJxGkv64
         h9SkW6GE/nbajDsAb3ooJoIYlu4bTPrMb4tsr1PHic1JKyeb4kG6WfjRflOhg4Esnnl1
         PUIkPQsu8tmZHLZjQyd17QC48nqKu4iIZR0Mr/RDnaAHgC0HKivkiGFwa76RO2a+5Miq
         3gAKn4w8TZ5YxzYzEq9Cw+JoI0qiJAo/pt+Pp2+1xNwQYdZxN4+hYSKyKihriE2qKUAm
         IgkQ==
X-Gm-Message-State: APjAAAXhPMjyEpiriJN/O0XHw+LCqSar6D97UDifq3wG+QOyhTT+LGmq
        5QIFLPQi5qn/P/8ssUVZiaBCJgC8Egc=
X-Google-Smtp-Source: APXvYqzEdLaYzl0v/7W7R6PkBma8dwKZSNgpR9LPId/ZlUH0hY4Xmdek8mcTa0tD3axeq1xyR+jSag==
X-Received: by 2002:a17:902:b20a:: with SMTP id t10mr255387plr.277.1568617870482;
        Mon, 16 Sep 2019 00:11:10 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x9sm22426271pje.27.2019.09.16.00.11.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 00:11:09 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCH net-next 5/6] erspan: fix the tun_info options_len check
Date:   Mon, 16 Sep 2019 15:10:19 +0800
Message-Id: <df4d06219243295fba75ab6361f0d750a135b7cc.1568617721.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7d552d01b82edf9523288030dc03f467aee92912.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
 <ec8435ca550a364b793bd8f307d6c2751931e684.1568617721.git.lucien.xin@gmail.com>
 <c8ce746cdbfe59ef332997e1ad87e88af49aac5b.1568617721.git.lucien.xin@gmail.com>
 <25b60ddb9a54413e20d5a55e9e03454c82e4561d.1568617721.git.lucien.xin@gmail.com>
 <7d552d01b82edf9523288030dc03f467aee92912.1568617721.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for !md doens't really work for ip_tunnel_info_opts(info) which
only does info + 1. Also to avoid out-of-bounds access on info, it should
ensure options_len is not less than erspan_metadata in both erspan_xmit()
and ip6erspan_tunnel_xmit().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_gre.c  | 4 ++--
 net/ipv6/ip6_gre.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index a53a543..df7149c 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -509,9 +509,9 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	key = &tun_info->key;
 	if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
 		goto err_free_skb;
-	md = ip_tunnel_info_opts(tun_info);
-	if (!md)
+	if (sizeof(*md) > tun_info->options_len)
 		goto err_free_skb;
+	md = ip_tunnel_info_opts(tun_info);
 
 	/* ERSPAN has fixed 8 byte GRE header */
 	version = md->version;
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index dd2d0b96..4aba9e0 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -980,9 +980,9 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		dsfield = key->tos;
 		if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
 			goto tx_err;
-		md = ip_tunnel_info_opts(tun_info);
-		if (!md)
+		if (sizeof(*md) > tun_info->options_len)
 			goto tx_err;
+		md = ip_tunnel_info_opts(tun_info);
 
 		tun_id = tunnel_id_to_key32(key->tun_id);
 		if (md->version == 1) {
-- 
2.1.0

