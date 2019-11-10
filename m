Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B189CF6733
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 05:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfKJE0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 23:26:32 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34148 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfKJE0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 23:26:32 -0500
Received: by mail-pf1-f195.google.com with SMTP id n13so7909802pff.1
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 20:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aM2pV6LEIUurowIf45Rdn61257fFOhs7fKuErQEX19g=;
        b=cxfR77FLwlsvEGttuI6fDvs39bVgcegK5r1QCTcUzpjWGG/MetbLVEDTrjKFzAPb8f
         UoXhZ/RNERHHuHFVIZAhQikBSQQFMrqoF8yDCKOJrdjN7BuDOe9ALL98vAbHUO3Gjl8v
         0vTA7yyr8TzWj2fuc1M2Yharq/JstHtTAGCReSSPST5ievVl03WbKyduHgGubBvI5Sj0
         R0P5NwbIbpI2IbQabnYBf0bAFT20W+ce5WpBbVy7zmuS6rvhYNCUlwyJb2yTG2GrvLN9
         o1mvFuAiD5IknvwqarwhKhodLQPC32gGUmm69FYfy+ST3x3Xo4g37UF7AVlLH1GTkGFa
         6Wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aM2pV6LEIUurowIf45Rdn61257fFOhs7fKuErQEX19g=;
        b=H3o1JCYOooSk0vsQ7TrAARZr7jVPdi1w6dzcnQX9bWVzchf/+xaqRerj5sc+XXUkr2
         iPvQNy809mU6jj+fQL/72M46yz4FDqUE6vGpPvo9NXWB6qOA5VQiT/Xu40bRehS1IOlC
         DXjMMj6TyZoSui1aTJuUwnahd4137eEAboKUh6TKA7lqywOHokGqzfjYRKunk0zgLLkp
         bOGVQbtTJqFm6Mnezpr+2kugYwYqGhd5aNgUTmsmRhwhgRyh+rDjogJM8kLhCvk/YTl2
         YzYOROJQAFaj+QgCH7uVqdogZWZv4BJNfvK+4MSD7Oo32nndJ/LKmmpgb54veTLZc+jb
         84Dg==
X-Gm-Message-State: APjAAAVaR3Gl35q6iItl0FMSyEZC3Vr1ANejDhgiWmx/nf149143xD32
        AahR+/1yf8EZYBivPt9HcEOA3yij
X-Google-Smtp-Source: APXvYqyvYH4cS2V0OSvZQLghYyVWnNTABEs0kt9ZzKGfuOEmozZCuE1no45hRGeu3DTzmKyJ8aF8ZQ==
X-Received: by 2002:a63:d70f:: with SMTP id d15mr21917748pgg.424.1573359989548;
        Sat, 09 Nov 2019 20:26:29 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y11sm13429516pfq.1.2019.11.09.20.26.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 20:26:28 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, David Ahern <dsahern@gmail.com>,
        Thomas Graf <tgraf@suug.ch>, Jiri Benc <jbenc@redhat.com>
Subject: [PATCH net-next] lwtunnel: ignore any TUNNEL_OPTIONS_PRESENT flags set by users
Date:   Sun, 10 Nov 2019 12:26:21 +0800
Message-Id: <8f830b0757f1c24aaebe19c771f274913174d6a5.1573359981.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TUNNEL_OPTIONS_PRESENT (TUNNEL_GENEVE_OPT|TUNNEL_VXLAN_OPT|
TUNNEL_ERSPAN_OPT) flags should be set only according to
tb[LWTUNNEL_IP_OPTS], which is done in ip_tun_parse_opts().

When setting info key.tun_flags, the TUNNEL_OPTIONS_PRESENT
bits in tb[LWTUNNEL_IP(6)_FLAGS] passed from users should
be ignored.

While at it, replace all (TUNNEL_GENEVE_OPT|TUNNEL_VXLAN_OPT|
TUNNEL_ERSPAN_OPT) with 'TUNNEL_OPTIONS_PRESENT'.

Fixes: 3093fbe7ff4b ("route: Per route IP tunnel metadata via lightweight tunnel")
Fixes: 32a2b002ce61 ("ipv6: route: per route IP tunnel metadata via lightweight tunnel")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index e444cd1..c724fb3 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -451,7 +451,9 @@ static int ip_tun_build_state(struct nlattr *attr,
 		tun_info->key.tos = nla_get_u8(tb[LWTUNNEL_IP_TOS]);
 
 	if (tb[LWTUNNEL_IP_FLAGS])
-		tun_info->key.tun_flags |= nla_get_be16(tb[LWTUNNEL_IP_FLAGS]);
+		tun_info->key.tun_flags |=
+				(nla_get_be16(tb[LWTUNNEL_IP_FLAGS]) &
+				 ~TUNNEL_OPTIONS_PRESENT);
 
 	tun_info->mode = IP_TUNNEL_INFO_TX;
 	tun_info->options_len = opt_len;
@@ -550,8 +552,7 @@ static int ip_tun_fill_encap_opts(struct sk_buff *skb, int type,
 	struct nlattr *nest;
 	int err = 0;
 
-	if (!(tun_info->key.tun_flags &
-	      (TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)))
+	if (!(tun_info->key.tun_flags & TUNNEL_OPTIONS_PRESENT))
 		return 0;
 
 	nest = nla_nest_start_noflag(skb, type);
@@ -596,8 +597,7 @@ static int ip_tun_opts_nlsize(struct ip_tunnel_info *info)
 {
 	int opt_len;
 
-	if (!(info->key.tun_flags &
-	      (TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)))
+	if (!(info->key.tun_flags & TUNNEL_OPTIONS_PRESENT))
 		return 0;
 
 	opt_len = nla_total_size(0);		/* LWTUNNEL_IP_OPTS */
@@ -718,7 +718,9 @@ static int ip6_tun_build_state(struct nlattr *attr,
 		tun_info->key.tos = nla_get_u8(tb[LWTUNNEL_IP6_TC]);
 
 	if (tb[LWTUNNEL_IP6_FLAGS])
-		tun_info->key.tun_flags |= nla_get_be16(tb[LWTUNNEL_IP6_FLAGS]);
+		tun_info->key.tun_flags |=
+				(nla_get_be16(tb[LWTUNNEL_IP6_FLAGS]) &
+				 ~TUNNEL_OPTIONS_PRESENT);
 
 	tun_info->mode = IP_TUNNEL_INFO_TX | IP_TUNNEL_INFO_IPV6;
 	tun_info->options_len = opt_len;
-- 
2.1.0

