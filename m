Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA8AB3529
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbfIPHKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:10:40 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34320 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730496AbfIPHKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:10:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so19299185pgc.1
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=6UOTCT6L20QawTCFFkbc+L5P1iwCrcK+DGZ/w8YiO30=;
        b=Jw27tbr2dbCPHp6sSWmwFgq35RD1VVnYJSr6pXalMHZrQAK1tvJ9vAWN8hEgeHmp+b
         TEto8OsYpW6FZEmegb/QQJsdU1nVVll28N1uRv0239Yb5gzl/dOsRae1VE8fE9krJh14
         oFinCfaVBh6miuin420FfXUf7ihutVIz1Ah8+iBrkvRSE2cn1uIH3Tr+vK391Wa0ffQ9
         MooAWlZA9q8BRj3IX8s4EzesEmLK1Q8mmGDdeIuxQqadhCwYafYw/zPo/SNh9ZoENwSy
         ZuqUsTjY4mTdupa10bgWLNNA+0k6LK3j59REY0+VojP354TQwpIvypRtSUv7XGHmM9Oy
         qazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=6UOTCT6L20QawTCFFkbc+L5P1iwCrcK+DGZ/w8YiO30=;
        b=nsA3YKO4pB7u+XpfmOn50rxZCshEjHrs4x6exXuOYfR4R81JaVfjb5CdpOguc6ljPe
         LoovRjvbss7dFHBMkC/E6EhIcpQmGLRKPTJOzoAJBE7Yvr8Z7rtndXauIK0mg6F+f1ox
         lEoFgIBldHMS/2DIvLUCLgqJTkhXfjh+OmgzkSJRYMx4uXrqR0VxuQoExiZQnw287oHe
         VCJhGStPI4cZT3k1XDU5NiYeOMKiLcLsgFkVmOZNRHlSfcFiZzNPhhvC9OOE3JJZz9MF
         j+R9L3diRUOPvnj7qJaPVroJorl04Gl40zTTLV3RrXatfLX+HSTrczqSufLkA7zmuvCB
         BYPw==
X-Gm-Message-State: APjAAAUptDw1fftovfp+ts/Q8qHlWumXxGqy6dpACcknE8N2wbhxzl6L
        yMRalR7k7X8xsz92QcrZrpaKeWPD+RY=
X-Google-Smtp-Source: APXvYqwPdJwKTjErJxN9VEMWOiAGAYS9B89OrPBMhYp0Xha7hZxapuYGX3D4NecvUrhSm1ptjyabEw==
X-Received: by 2002:a62:ce8a:: with SMTP id y132mr31111276pfg.9.1568617837241;
        Mon, 16 Sep 2019 00:10:37 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 74sm69583737pfy.78.2019.09.16.00.10.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 00:10:36 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCH net-next 1/6] lwtunnel: add options process for arp request
Date:   Mon, 16 Sep 2019 15:10:15 +0800
Message-Id: <ec8435ca550a364b793bd8f307d6c2751931e684.1568617721.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without options copied to the dst tun_info in iptunnel_metadata_reply()
called by arp_process for handling arp_request, the generated arp_reply
packet may be dropped or sent out with wrong options for some tunnels
like erspan and vxlan, and the traffic will break.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 1452a97..10f0848 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -126,15 +126,14 @@ struct metadata_dst *iptunnel_metadata_reply(struct metadata_dst *md,
 
 	if (!md || md->type != METADATA_IP_TUNNEL ||
 	    md->u.tun_info.mode & IP_TUNNEL_INFO_TX)
-
 		return NULL;
 
-	res = metadata_dst_alloc(0, METADATA_IP_TUNNEL, flags);
+	src = &md->u.tun_info;
+	res = metadata_dst_alloc(src->options_len, METADATA_IP_TUNNEL, flags);
 	if (!res)
 		return NULL;
 
 	dst = &res->u.tun_info;
-	src = &md->u.tun_info;
 	dst->key.tun_id = src->key.tun_id;
 	if (src->mode & IP_TUNNEL_INFO_IPV6)
 		memcpy(&dst->key.u.ipv6.dst, &src->key.u.ipv6.src,
@@ -143,6 +142,8 @@ struct metadata_dst *iptunnel_metadata_reply(struct metadata_dst *md,
 		dst->key.u.ipv4.dst = src->key.u.ipv4.src;
 	dst->key.tun_flags = src->key.tun_flags;
 	dst->mode = src->mode | IP_TUNNEL_INFO_TX;
+	ip_tunnel_info_opts_set(dst, ip_tunnel_info_opts(src),
+				src->options_len, 0);
 
 	return res;
 }
-- 
2.1.0

