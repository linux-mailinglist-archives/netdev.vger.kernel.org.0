Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04018CFD62
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfJHPQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:16:35 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:38017 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfJHPQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:16:34 -0400
Received: by mail-pf1-f174.google.com with SMTP id h195so10954986pfe.5
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 08:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=6UOTCT6L20QawTCFFkbc+L5P1iwCrcK+DGZ/w8YiO30=;
        b=Xfi4VP/qFI794ItAAI6MXc8CkYBesqG0lk/dgdEoaSVB60FkVss4uGbE2ZkrjP4PN8
         Pt2ljDzaXWf5bw3EBy8tlyPe1i2J1Y3O24q/zZrDXWy5A+E+uiW4TxmlCGn5qy+3AW14
         UISzhr4BBX+h+S5Z+J5RHh6qTmiw0CLaETbz1AYmQ9GhtdHiUTX6qB5dTLBlEF0JXfPO
         7u86AUFth/WVolv2YSeRsbCjKmDCQOBfLs+twodfgMH6m9k2Sr+kCkeao1UulgnehfwR
         MKoLGLmuhsOds4N7yBjLVWUMNpDVPu3Y2LtxTbvEWkbiayjpDBAcVi0/TmxDURp26DKl
         +K+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=6UOTCT6L20QawTCFFkbc+L5P1iwCrcK+DGZ/w8YiO30=;
        b=H2/FVksz6gvPA67sy0+yPNleBTwXHnRz1wAvYUbf06Hx3prCZnibOmDW+j7QS4xZbH
         nXvqbqceHaqwWLxmdKzyVyHKL1tCtZ+sV5lnJem6EuJJVdD4WG3Fh6cmx3miT2utLDrx
         JwL0SYw5aQ9K/Ou8RWdie3swvhEFfVGue706UPJMnjrpr8S8LawZjBXOYTw6+8xgmVM1
         b+RSO946/E2irFHLpNDJa430UzBaonDiZnGtUrRmmNBlfTM2ou0sZZLwFN0Gtbub04/W
         rmmZqS8XMHNbKH9kYXEJ8hz7rKKaqNOMYj36XTwaKo1+xSVCafki/av/chl1AfbU1GMG
         x4UQ==
X-Gm-Message-State: APjAAAUAfC7POYcRT64nFFqBmil/oyTnjxH9qbMCge6CMKnaYjhgwh+e
        iHga6m8Pi7QIP04xSoT1v5xzviXF
X-Google-Smtp-Source: APXvYqyw+7tP6WoTfgFIhw/oMyIS0m+cttbFDuSmKNeyEErV7VWGoXN8NKhqK6Rh+dMS3vvOBKeG+Q==
X-Received: by 2002:a62:62c6:: with SMTP id w189mr39736408pfb.235.1570547792825;
        Tue, 08 Oct 2019 08:16:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d5sm1924001pjw.31.2019.10.08.08.16.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:16:32 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCHv2 net-next 1/6] lwtunnel: add options process for arp request
Date:   Tue,  8 Oct 2019 23:16:11 +0800
Message-Id: <d29fbb1833cea0e9aff96317b9e49f230ca6d3dc.1570547676.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
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

