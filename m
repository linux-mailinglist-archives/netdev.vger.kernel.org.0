Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D703EE74DC
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 16:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390700AbfJ1PTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 11:19:45 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33074 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731176AbfJ1PTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 11:19:45 -0400
Received: by mail-pf1-f194.google.com with SMTP id c184so7103301pfb.0
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 08:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=W1FPmdrzWD6qpzHzG9E7nqJ3eyviefD/NYmviz7UxRY=;
        b=jF/ZiEr6w+N55EY1Qt82XDJY6cd+PNsHUvQ/4h0LCMv2UhhTg3Cbyj38cASUshgqEt
         7/gzCkCyGwYablKeSYcLVhGknjflbHlTQKwKFHiklaOGk/wed6v0GWO9UyHq1gMPBaHA
         rm5k45LrArjHif8eiB9r0jU11MuoWF2igivoso1ZrUMWmMALcEDrwvS2vBns4MOWof2b
         EnUUt7F8n9lI4JDtU3S4AD4O805uCrkRPNyJfNnRzvZ/Vz4QclukphpkDhteJZT1up3I
         rxZDj+Y3wmWV93GsGnnPHMNvZBhkhar4W+2lL17vA/UrM844Q6wgSkVU6c+z00AFDike
         uisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W1FPmdrzWD6qpzHzG9E7nqJ3eyviefD/NYmviz7UxRY=;
        b=SifHs+ufOGvNMz6y64o4e50diPONunIBVp8UXbbX0bNbqihLslgpc7mH7O9nmn244H
         Zec+3/JOqMcBqZnyvlyFxtGII37N1eatOZvrYTUH99TxVZNRSbi2jQV0KbI1qixjJi3a
         Jdq4Os5uyvSnXoxHTyQvPFMPaJw/tNbnyAWBf8vW08K//e69IyLvfsMKNJMvJu7ZeRMe
         8f+tvffn4wv4G0miHI7vL8kkCPTeRjA6kt/TfEvei+LbKoZgm3TvDnjIIxEvxXLvCdJm
         F9/62qe6Dqr6Also58J7dUHIN7GCD0Kkpd1JzN3W+/Wc1MnIuSNd/rMrmFyFLI9XC+Sg
         1C8A==
X-Gm-Message-State: APjAAAUFXd+BRw4R9/F78VOMBlNHhHL87uAOJ1rd+Mwx8lfRSy7iX0mU
        5osQ9nXj3TKvrQIFvcMNv+uXXRl2
X-Google-Smtp-Source: APXvYqz7sYyxihOQLOZ4/X+wYmFhX2t1Z4t64eZcri2VLhpbBubOJfRpH4UHSQgq0fQ1vGPHA2euhA==
X-Received: by 2002:a63:3281:: with SMTP id y123mr11571974pgy.252.1572275983870;
        Mon, 28 Oct 2019 08:19:43 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 37sm10276787pgv.32.2019.10.28.08.19.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 08:19:43 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, William Tu <u9012063@gmail.com>
Subject: [PATCH net] erspan: fix the tun_info options_len check for erspan
Date:   Mon, 28 Oct 2019 23:19:35 +0800
Message-Id: <82c8c015ff19bbd5eb9679b5ce01915037d3cd94.1572275975.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for !md doens't really work for ip_tunnel_info_opts(info) which
only does info + 1. Also to avoid out-of-bounds access on info, it should
ensure options_len is not less than erspan_metadata in both erspan_xmit()
and ip6erspan_tunnel_xmit().

Fixes: 1a66a836da ("gre: add collect_md mode to ERSPAN tunnel")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_gre.c  | 4 ++--
 net/ipv6/ip6_gre.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 52690bb..10636fb 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -509,9 +509,9 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	key = &tun_info->key;
 	if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
 		goto err_free_skb;
-	md = ip_tunnel_info_opts(tun_info);
-	if (!md)
+	if (tun_info->options_len < sizeof(*md))
 		goto err_free_skb;
+	md = ip_tunnel_info_opts(tun_info);
 
 	/* ERSPAN has fixed 8 byte GRE header */
 	version = md->version;
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 787d9f2..923034c 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -980,9 +980,9 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		dsfield = key->tos;
 		if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
 			goto tx_err;
-		md = ip_tunnel_info_opts(tun_info);
-		if (!md)
+		if (tun_info->options_len < sizeof(*md))
 			goto tx_err;
+		md = ip_tunnel_info_opts(tun_info);
 
 		tun_id = tunnel_id_to_key32(key->tun_id);
 		if (md->version == 1) {
-- 
2.1.0

