Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81932AE4CB
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgKKARN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKKARM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:17:12 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2482C0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 16:17:12 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id x13so387463pfa.9
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 16:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1jWuCO6gezRCsHJCeIWwfLImcLt+uN7Xse8K4/jnFdk=;
        b=XZ9Y3h0Hjxz0n8T+goBfQZDjyOivbUVNCksSSy5evGxTi0NoQ7Gl+j8GReDqsnbkDs
         tkAPlISrii7fxmeE7zbVsYk+XiauWMTckBJENqQHZzGeGu8VAMeIwf1zDMg7zGj6vyVx
         nxh5Tf8rWViGT54inCyi62GwS7EXkAlWDLGz/GQjvUJb5oKJRsaB1diPgc4D0ffH42BW
         xTlGJDN2dzw0ToWPTQeK/dITM7VjcaWTqAx8s/Ow2bVhZcMyt768NpYf2mMDzvs+R1HN
         zGgmHn60jeSeS+Vphyo6KG4x57heNoW+hXiruspi1qaHs7BHH8eRvh2V2Ltq0JmomUDk
         3Jmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1jWuCO6gezRCsHJCeIWwfLImcLt+uN7Xse8K4/jnFdk=;
        b=fVzBnDVhPjDRRoQsEuEpgNUfpYaPLiReP0bCKTREt1HyrwyC4dsdk7pZCaIuKW2vXy
         7PIHTZT8ZKTNi0ICyy6/JoqXY55vGn6cZmswXOnHqPJx9YADxHLNEoZ5NVnx4Z4UP4kd
         lCWIwRgwDPf3LVyyOpZf1EA6w/oSrdMlzOa+igbB0abCEOvyP/XxxxwJAzbt9z0wabhq
         uExiMEcT9m3AJpJxG4F7YEZi/yWTwqJeVzS82mRnKTmKd2C/Pbkqj9B6b69jW7NXaGgq
         AVK/OukPRHGqc+4A6WAwJRqzkdbvJ7/mC3JDWDty0o7ws1126jbXSfG1Zu9L1/beacYT
         LAkw==
X-Gm-Message-State: AOAM533EgwHyZSs/AJ8/17930ikRi+hB6l2UxnyVB+Ueg9uCBieiIAoO
        e2IBoRd8IGBNg5YwhGPwrGD8BjK4JKA=
X-Google-Smtp-Source: ABdhPJxP5pxgiv9+NLFRZjKhwgi3wKEZwZQhDLe/ZXSUJN3RqBuZrcTm9fMPLWle7QyZj2B50hzkuw==
X-Received: by 2002:a63:751e:: with SMTP id q30mr9207223pgc.294.1605053832174;
        Tue, 10 Nov 2020 16:17:12 -0800 (PST)
Received: from vm-main.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id d68sm274384pfc.135.2020.11.10.16.17.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 16:17:11 -0800 (PST)
From:   Yi-Hung Wei <yihung.wei@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, pieter.jansenvanvuuren@netronome.com,
        netdev@vger.kernel.org
Cc:     Yi-Hung Wei <yihung.wei@gmail.com>
Subject: [PATCH] ip_tunnels: Set tunnel option flag when tunnel metadata is present
Date:   Tue, 10 Nov 2020 16:16:40 -0800
Message-Id: <1605053800-74072-1-git-send-email-yihung.wei@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we may set the tunnel option flag when the size of metadata
is zero.  For example, we set TUNNEL_GENEVE_OPT in the receive function
no matter the geneve option is present or not.  As this may result in
issues on the tunnel flags consumers, this patch fixes the issue.

Related discussion:
* https://lore.kernel.org/netdev/1604448694-19351-1-git-send-email-yihung.wei@gmail.com/T/#u

Fixes: 256c87c17c53 ("net: check tunnel option type in tunnel flags")
Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
---
 drivers/net/geneve.c     | 3 +--
 include/net/ip_tunnels.h | 7 ++++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index d07008a818df..1426bfc009bc 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -224,8 +224,7 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 	if (ip_tunnel_collect_metadata() || gs->collect_md) {
 		__be16 flags;
 
-		flags = TUNNEL_KEY | TUNNEL_GENEVE_OPT |
-			(gnvh->oam ? TUNNEL_OAM : 0) |
+		flags = TUNNEL_KEY | (gnvh->oam ? TUNNEL_OAM : 0) |
 			(gnvh->critical ? TUNNEL_CRIT_OPT : 0);
 
 		tun_dst = udp_tun_rx_dst(skb, geneve_get_sk_family(gs), flags,
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 02ccd32542d0..61620677b034 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -478,9 +478,11 @@ static inline void ip_tunnel_info_opts_set(struct ip_tunnel_info *info,
 					   const void *from, int len,
 					   __be16 flags)
 {
-	memcpy(ip_tunnel_info_opts(info), from, len);
 	info->options_len = len;
-	info->key.tun_flags |= flags;
+	if (len > 0) {
+		memcpy(ip_tunnel_info_opts(info), from, len);
+		info->key.tun_flags |= flags;
+	}
 }
 
 static inline struct ip_tunnel_info *lwt_tun_info(struct lwtunnel_state *lwtstate)
@@ -526,7 +528,6 @@ static inline void ip_tunnel_info_opts_set(struct ip_tunnel_info *info,
 					   __be16 flags)
 {
 	info->options_len = 0;
-	info->key.tun_flags |= flags;
 }
 
 #endif /* CONFIG_INET */
-- 
2.7.4

