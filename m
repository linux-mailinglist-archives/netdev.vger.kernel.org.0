Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DF0F11A0
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 10:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbfKFJBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 04:01:33 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41781 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfKFJBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 04:01:33 -0500
Received: by mail-pf1-f196.google.com with SMTP id p26so18347594pfq.8
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 01:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=wOXR3ANFzvx3LTTV/Amm0Y+9Ul2KdlaA1D5ryRe+3wk=;
        b=V0NHM60UWRWSIMZrzdiD10L3PgUoYlLqnm2VLYtc9zpkl24kDzFV+hccYpS11GyAzf
         OP4QPvCWBPHJ4YRwU1ycVj1+dDoUGs5+ICF+XHwue6FlSjw+HtYZhm7VNm0LCni1AOam
         u0aGvy/bI3CXcRgG6HZ4+MTJy53mv8s+gZOwtVJheXn9/OYKRHWfHd8SbhS3I54dPmjc
         zKwI6uL03+B7a0O0Z9izKsqEv1l5vg3pdr1Hu9Wzi/M0lRJFNo7OacoOrVIh76BkZTP/
         CTBAWyixEBQ5oMZWQ1UAQ395oJSimhKA22cHnxrdTurOirQ39enpmtEnB9uyGVy2zKbH
         Hp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=wOXR3ANFzvx3LTTV/Amm0Y+9Ul2KdlaA1D5ryRe+3wk=;
        b=UnBOg6o71hViPai3VpD1bUrVQMLBl6MyS4t4y5uOtHQmk/D3z8hC7Y5ICjMKR/WR/A
         gQdjNq7PrnpVJJ/zfmiggzRX+I2KcljqAjymreStM2pvigoxsEFjfF1rHrhwmB653u11
         V3dhQ+vjzmdVT+rHKydDAiNNYpvh3un1YHbGZEIQ2gvh9VP1Rl8wAYEgU7m0+3oGz9hN
         6IkzDvwljabjj3mu4BMnUVY3GeB6r/q00T7EOsu1bGnH34+nULT//R0r5v+EWK/dCBJ7
         RyhmNCao1gwmYN1VibeUvhRxOP55ZFJL9rTRCl6BZZE6tUed+iysrsC2IKm1uGMqkBSw
         DyUQ==
X-Gm-Message-State: APjAAAVnpISDFdLIFMetKRN5R0ok7GeAdMo9uyOkETI8EOkOKeObJ0zY
        6aFuy0WgjsavbATu3c60OPrORvNw
X-Google-Smtp-Source: APXvYqwN9a8S1FQmRuxjywfTz43+zwNRDWlNE5//CvHcXcsSlvNlztow/ZKBmXtjwrprZPdlqPOY0Q==
X-Received: by 2002:a62:2942:: with SMTP id p63mr2038050pfp.110.1573030892552;
        Wed, 06 Nov 2019 01:01:32 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j25sm21090572pfi.113.2019.11.06.01.01.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 01:01:31 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        u9012063@gmail.com
Subject: [PATCH net-next 2/5] lwtunnel: add options process for cmp_encap
Date:   Wed,  6 Nov 2019 17:01:04 +0800
Message-Id: <205adb4659c05108760ef058275fd44b8a907da4.1573030805.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <aeac8e3758555d75a9026ffdba985d95301552a0.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
 <aeac8e3758555d75a9026ffdba985d95301552a0.1573030805.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When comparing two tun_info, dst_cache member should have been skipped,
as dst_cache is a per cpu pointer and they are always different values
even in two tun_info with the same keys.

So this patch is to skip dst_cache member and compare the key, mode and
options_len only. For the future opts setting support, also to compare
options.

Fixes: 2d79849903e0 ("lwtunnel: ip tunnel: fix multiple routes with different encap")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 10f0848..c0b5bad 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -315,8 +315,14 @@ static int ip_tun_encap_nlsize(struct lwtunnel_state *lwtstate)
 
 static int ip_tun_cmp_encap(struct lwtunnel_state *a, struct lwtunnel_state *b)
 {
-	return memcmp(lwt_tun_info(a), lwt_tun_info(b),
-		      sizeof(struct ip_tunnel_info));
+	struct ip_tunnel_info *info_a = lwt_tun_info(a);
+	struct ip_tunnel_info *info_b = lwt_tun_info(b);
+
+	return memcmp(info_a, info_b, sizeof(info_a->key)) ||
+	       info_a->mode != info_b->mode ||
+	       info_a->options_len != info_b->options_len ||
+	       memcmp(ip_tunnel_info_opts(info_a),
+		      ip_tunnel_info_opts(info_b), info_a->options_len);
 }
 
 static const struct lwtunnel_encap_ops ip_tun_lwt_ops = {
-- 
2.1.0

