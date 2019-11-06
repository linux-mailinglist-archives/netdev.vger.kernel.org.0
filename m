Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C542F119F
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 10:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfKFJBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 04:01:25 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42821 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfKFJBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 04:01:25 -0500
Received: by mail-pf1-f195.google.com with SMTP id s5so10099636pfh.9
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 01:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=7zaXUeyYeqjm9zfcwYMl9HUeKfD8wJnAkfI9bU5rCrg=;
        b=PQlrk3xblKz9Lph5JRbAP3rLRQJS+6L7KKPcVvx+Ghllm4PoUdyVjhed3vQadWE7Wp
         kPgzPeBI+rEAfhOz/8fGp+wX7nMTwf/5PKaxIOH62OnHL5XfnNcY3XIhbtm7ETRxix7g
         +2Gjq0s23Ex4NfgaphRwnNhFPz54gTVfZAWtq1yOVF/5DWX93FSsAgeIJKDKgOqA+cda
         tREGnWPWnaqGExeq6IAcyT1gUcSLpN3ZDs5FXc7cOQqcvrb8Z9xjjgiT1EWEqZUYcAM2
         GdNFlVYeRDqDJ2TeJlgaRSwXQuue6jg/BlFBID4KEgyewiuKf7pZ9qQsseisxLkuWwwI
         yU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=7zaXUeyYeqjm9zfcwYMl9HUeKfD8wJnAkfI9bU5rCrg=;
        b=dLNskTAE5pTfK623V59tqTfDqTEsSd++Ezi13jAj5XN1hEpj53cMXP8khMi91oDR5/
         SghP8P2CFiS4qJLBEoSAVY1OUMTN8BjVaIOP1gx+MdwHIQwzRbcfvXsFvZvKBHvsKPlf
         iV0ziPAvtXsFRf4fjpmifvy5AQfKq9qmZU6c1BXao2ofXR0wwwil1BrjqmbsaWM3ZRuZ
         PR0pwfNDyerkbRTWdsRqsQsHdVXk15ap+VXjrBS9vZAi6S4xffOXW/rXFQtXbWFKVH+8
         YCRYRZ1tvXwT++9gW+LorvRaDGo8+HfqLh03ETNASqxg0QjATnnN55qYlN+ddsynYGBy
         4RmA==
X-Gm-Message-State: APjAAAVbm2Uh/TA/rOD6NRs7+tGm7eSBccvmW76/GB5xWUR1oDojJuLp
        6xrArzeH5o3xuicrxT435RLUn4Xz
X-Google-Smtp-Source: APXvYqxu3KaoPySZA6KXP6hf/OaZoIVr2EiRJOd26wjpk5gOqidhzi/dwi91zmfdjmGC/PudrF7XJA==
X-Received: by 2002:aa7:92c9:: with SMTP id k9mr1930969pfa.155.1573030884132;
        Wed, 06 Nov 2019 01:01:24 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a145sm17887241pfa.7.2019.11.06.01.01.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 01:01:23 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        u9012063@gmail.com
Subject: [PATCH net-next 1/5] lwtunnel: add options process for arp request
Date:   Wed,  6 Nov 2019 17:01:03 +0800
Message-Id: <aeac8e3758555d75a9026ffdba985d95301552a0.1573030805.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without options copied to the dst tun_info in iptunnel_metadata_reply()
called by arp_process for handling arp_request, the generated arp_reply
packet may be dropped or sent out with wrong options for some tunnels
like erspan and vxlan, and the traffic will break.

Fixes: 63d008a4e9ee ("ipv4: send arp replies to the correct tunnel")
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

