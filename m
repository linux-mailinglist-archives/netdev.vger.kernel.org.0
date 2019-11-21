Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFDE105030
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKUKPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:15:01 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:45245 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfKUKPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:15:01 -0500
Received: by mail-pj1-f67.google.com with SMTP id m71so1241028pjb.12
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RrA2LM/A/2Ub0qhDOVFJmsNWagKqKbWx3P7AQAnFQgc=;
        b=I9GVnazcpm3kHBYS9beG+HdIiSVNIv0ECGKSmkcaCsAXMzFzjD5Kw6d+eXkkBfJIbc
         NUmNun+99QiNN9sx8kaIGayHUlinvAJihDJwESZ3azEIAxp82EEc88cSW5QPTbpJShjf
         AEg2OUJG9goHHeck/SJUtKFRdAa/T9QzSl9RS53i5kRxntqKkFdeglTRXZ7YeLVP+Jw9
         vipn4B3f8HbIGZtHNDmABeZgGgxEcUSYOhWqXYJNTCfmJv/ij2MsoZgSYc3dmggWwef6
         vySwZJp5douyQDcrJATmwRVwlhTcaqkW9iDxNOLeevuoRXQt9eH7KOFkmycYaWpxyAEA
         9+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RrA2LM/A/2Ub0qhDOVFJmsNWagKqKbWx3P7AQAnFQgc=;
        b=PtOQgNv4BqO6bAkNnCkgcjGa4SC2RcOujWaGRQwdzd+4ei9rteZvArYe7YHJHnB39D
         OCaJ16+uHvi5A5iv7fjfq3RFMW9oVmub9Gym6T/qmC1S3vN2BLwn1KzKlpsnpvqzNh+t
         Z6S1n4E3hlOxhDMiGCUk67SW2B5QWT9Gy/GhNg2OQwEWuBNuwKLUYwN/zOt8S+XV9t1D
         6zgrbbUjp4QrtE3XK13YasDkBBHFzyidoilH57/tDyf4Y2rWNhOVmSLsFrJfHi+40M5p
         mo4v1ze/CHQwpJLZNYxuYv+8jlZfkZ/AL4snOp4O5QXczo6DMbd04InN2Prm53pyfJjT
         sL2w==
X-Gm-Message-State: APjAAAVusBF3NWg7nBZepCzQGXabyPHfvv9Tn8Ea4jQCP+Nr1OM1zI0U
        1B0mnqH/JoxCIXZ2r1Uw7H3aDYWD
X-Google-Smtp-Source: APXvYqxASHubd4fanYdvOcP3Wz/V47otiBklYVmSZnpAS4WZUQ473TDZNKqOaN0b9CcMZEaK8BkYZg==
X-Received: by 2002:a17:902:ac84:: with SMTP id h4mr8088094plr.328.1574331298770;
        Thu, 21 Nov 2019 02:14:58 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d8sm2719488pfo.47.2019.11.21.02.14.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:14:57 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next] lwtunnel: check erspan options before allocating tun_info
Date:   Thu, 21 Nov 2019 18:14:50 +0800
Message-Id: <b82b4b953ffc3a7053076bdfd20d5a62e07d5ad3.1574331290.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Jakub suggested on another patch, it's better to do the check
on erspan options before allocating memory.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 0a7eaad..47f8b94 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -321,6 +321,7 @@ static int ip_tun_parse_opts_erspan(struct nlattr *attr,
 {
 	struct nlattr *tb[LWTUNNEL_IP_OPT_ERSPAN_MAX + 1];
 	int err;
+	u8 ver;
 
 	err = nla_parse_nested(tb, LWTUNNEL_IP_OPT_ERSPAN_MAX, attr,
 			       erspan_opt_policy, extack);
@@ -330,24 +331,31 @@ static int ip_tun_parse_opts_erspan(struct nlattr *attr,
 	if (!tb[LWTUNNEL_IP_OPT_ERSPAN_VER])
 		return -EINVAL;
 
+	ver = nla_get_u8(tb[LWTUNNEL_IP_OPT_ERSPAN_VER]);
+	if (ver == 1) {
+		if (!tb[LWTUNNEL_IP_OPT_ERSPAN_INDEX])
+			return -EINVAL;
+	} else if (ver == 2) {
+		if (!tb[LWTUNNEL_IP_OPT_ERSPAN_DIR] ||
+		    !tb[LWTUNNEL_IP_OPT_ERSPAN_HWID])
+			return -EINVAL;
+	} else {
+		return -EINVAL;
+	}
+
 	if (info) {
 		struct erspan_metadata *md =
 			ip_tunnel_info_opts(info) + opts_len;
 
-		attr = tb[LWTUNNEL_IP_OPT_ERSPAN_VER];
-		md->version = nla_get_u8(attr);
-
-		if (md->version == 1 && tb[LWTUNNEL_IP_OPT_ERSPAN_INDEX]) {
+		md->version = ver;
+		if (ver == 1) {
 			attr = tb[LWTUNNEL_IP_OPT_ERSPAN_INDEX];
 			md->u.index = nla_get_be32(attr);
-		} else if (md->version == 2 && tb[LWTUNNEL_IP_OPT_ERSPAN_DIR] &&
-			   tb[LWTUNNEL_IP_OPT_ERSPAN_HWID]) {
+		} else {
 			attr = tb[LWTUNNEL_IP_OPT_ERSPAN_DIR];
 			md->u.md2.dir = nla_get_u8(attr);
 			attr = tb[LWTUNNEL_IP_OPT_ERSPAN_HWID];
 			set_hwid(&md->u.md2, nla_get_u8(attr));
-		} else {
-			return -EINVAL;
 		}
 
 		info->key.tun_flags |= TUNNEL_ERSPAN_OPT;
-- 
2.1.0

