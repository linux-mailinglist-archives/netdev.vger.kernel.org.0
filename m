Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A448DCFD68
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfJHPRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:17:08 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:44927 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJHPRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:17:07 -0400
Received: by mail-pf1-f170.google.com with SMTP id q21so10921669pfn.11
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 08:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ju4v0j5I8a964WsXJvwWlrPN7b5/7cqSPxev5tpwgLg=;
        b=BML3RsqbW/Nqo5xpoXhu2S2kVvFqSwcuTmC7F8nOjqChOQtWMawCU0RCUCh6a2J4z5
         QzA03vRZU3o/TIZTIcss1xSBf+YcJAcrkg2A+ol4WwaXXAX1DJvHnzGBSO+Vk7t4nHpN
         wtEOrXQhXnf9MMo5ofuMCBJdG3XcCf/URK5zugvGZWdNoEfiiodS5PlzbRgvUwB86ryi
         hoLl/K7Q/NUiHbLcfcmVHFQeEcWnbDMrbgzj5seB3PVNkr2kXse8V8qbCnbkbzf+2otv
         uylsqrH6wgfZMW5SitmsuuyGQr3laJMND18kcEskx8iBs0y/Akbvx4HnTechWxMyfb4J
         +Z+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ju4v0j5I8a964WsXJvwWlrPN7b5/7cqSPxev5tpwgLg=;
        b=XxSQ8j7nS8alzHp4ka0GOfgm3koQv174vA2na5BgOAmdhOF/otkqqdcF/mqCn03iAo
         cx/WJ7k0HFwzdRI2fuVdNjnhRprElDibNddZ2ep77qoAUW2SXRYLGlIYrS0EOoVMvoYc
         kYGz2KYCBGCHEuKcGT18cT77wjrmAvjwtkFvWQjmOPKhaVzVzvzAV7YOsWdwIe4X/4Fm
         CbQ68Z5kL66yIJ7s/w3uqehMzDr5a4qbAdcOIYDqcNOBXjbDkS5CU5b+24TGFWud2Y9i
         kWIZAPltD9D0dpwWSPRpNQsItfRV4e+iMOvRGgu7A/iMqVof+8ldXGSilb0OYxq6XRwd
         LlRg==
X-Gm-Message-State: APjAAAXMzkxmhBlbUc6GbkteDJWoSClmuJqen00+rCZfa6IWLdxex4yl
        ZaeB4lXN4LbPMlOrgrG2dmH9tFLN
X-Google-Smtp-Source: APXvYqyYcaKKq5Lbd8jqva+v8YLSixSB6xMIiR69O+54nMLp8xEWTSjYPYShHvyAVviM1Jl//rcEDA==
X-Received: by 2002:a63:9742:: with SMTP id d2mr36087310pgo.356.1570547826797;
        Tue, 08 Oct 2019 08:17:06 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p68sm24947508pfp.9.2019.10.08.08.17.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:17:06 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCHv2 net-next 5/6] erspan: fix the tun_info options_len check
Date:   Tue,  8 Oct 2019 23:16:15 +0800
Message-Id: <ad3f4008718a8c90e6c779d30723936934dd85c1.1570547676.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b870b739bf2819134a3de9f2a19132d978109e7a.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
 <d29fbb1833cea0e9aff96317b9e49f230ca6d3dc.1570547676.git.lucien.xin@gmail.com>
 <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
 <db1089611398f17980ddfb54568c95837928e5a9.1570547676.git.lucien.xin@gmail.com>
 <b870b739bf2819134a3de9f2a19132d978109e7a.1570547676.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
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
index 52690bb..b5e1f5e 100644
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
index d5779d6..116987d 100644
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

