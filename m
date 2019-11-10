Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2FAF672E
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 05:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfKJEQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 23:16:32 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41220 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfKJEQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 23:16:32 -0500
Received: by mail-pl1-f193.google.com with SMTP id d29so6077865plj.8
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 20:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vcCx4jLv9xCw7GO6f0YuSvU7mT0mz7ZvAZd46aKr+CU=;
        b=mNypADnLq3jIiWppqwjyr9F8h9EmkMPWHmdfpjAVxtZWk25UUmRco4duyi/YW+NUmq
         ZzTEb4bZc/RF1KhGgz0MMtHEj8CWbjzrgjiYI/ueUOzpXbPuJ40FG4YFe76MN7s/vJpq
         91aMar2VlLttX7X86boioQOOkcZJU/MeZ2sj1Tv6ZtSHSHfXVMn63WMxK/7ZRf1k5+Ij
         XlMgKqT+5/e0YGRg+ZKiHSFV0RLh6vNFxN1wo48+s2EK55D3yrscV/LJ3+KMCWmt9Il/
         ffJofIZx3i5pykmkG8RQfoQ6GGLM7+jP9HTIwvGEqRcm3ibfCXzSgHUa0QyXzWcD12vd
         pn+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vcCx4jLv9xCw7GO6f0YuSvU7mT0mz7ZvAZd46aKr+CU=;
        b=PN3hxslJL35MRNhFeVQwz6sX/E078HWl096Ja4fu/551hYqUQ/dOpq9PW5E8yej9MJ
         2S3IhiguWPukJyALX35fp3GdzvTLt8gQgK7m0LeDmlDQRRZbJWTQIPZ3QYJQuYOiUK0N
         UZUKhkZ9YU9bxaYC0HCbbhTV13e08crZ0gtTkv3Yj/tF2fUmUXnsLlkm5tq9Pa3fbyOh
         ptFnWXJZWLYeVX8A1MkT+j4mW9zOjuqClAjBc2Ts1yRrhYau/mxmix5veyoka8cF1966
         dkQ9vpW+9fsTbFqckA6FHhBFVNKm+oFFZmwdHP6Lsb2gaVt2V3go0Sys2lV9wm2QppBX
         NHcw==
X-Gm-Message-State: APjAAAUJ/XszwjOTwShQGeObQdIQ+udDmM1w76KVQU3+0HLN1/B4uVw6
        dP4Lzu9LzRimTq82niGF/8lqU1PB
X-Google-Smtp-Source: APXvYqwHltaQgfIoD81KgIPAxChpWL45z4/sW62eZ99v/LJnVKKEueqrMmvyjybRpVjvI5XdhaigVQ==
X-Received: by 2002:a17:902:6184:: with SMTP id u4mr19345361plj.85.1573359391007;
        Sat, 09 Nov 2019 20:16:31 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y16sm12054770pfo.62.2019.11.09.20.16.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 20:16:30 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] lwtunnel: change to use nla_parse_nested on new options
Date:   Sun, 10 Nov 2019 12:16:22 +0800
Message-Id: <78f1826a019e62b19a435a1498114274fb34223c.1573359382.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the new options added in kernel, all should always use strict
parsing from the beginning with nla_parse_nested(), instead of
nla_parse_nested_deprecated().

Fixes: b0a21810bd5e ("lwtunnel: add options setting and dumping for erspan")
Fixes: edf31cbb1502 ("lwtunnel: add options setting and dumping for vxlan")
Fixes: 4ece47787077 ("lwtunnel: add options setting and dumping for geneve")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index d4f84bf..ee71e76 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -257,8 +257,8 @@ static int ip_tun_parse_opts_geneve(struct nlattr *attr,
 	struct nlattr *tb[LWTUNNEL_IP_OPT_GENEVE_MAX + 1];
 	int data_len, err;
 
-	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_OPT_GENEVE_MAX,
-					  attr, geneve_opt_policy, extack);
+	err = nla_parse_nested(tb, LWTUNNEL_IP_OPT_GENEVE_MAX, attr,
+			       geneve_opt_policy, extack);
 	if (err)
 		return err;
 
@@ -294,8 +294,8 @@ static int ip_tun_parse_opts_vxlan(struct nlattr *attr,
 	struct nlattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
 	int err;
 
-	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_OPT_VXLAN_MAX,
-					  attr, vxlan_opt_policy, extack);
+	err = nla_parse_nested(tb, LWTUNNEL_IP_OPT_VXLAN_MAX, attr,
+			       vxlan_opt_policy, extack);
 	if (err)
 		return err;
 
@@ -320,8 +320,8 @@ static int ip_tun_parse_opts_erspan(struct nlattr *attr,
 	struct nlattr *tb[LWTUNNEL_IP_OPT_ERSPAN_MAX + 1];
 	int err;
 
-	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_OPT_ERSPAN_MAX,
-					  attr, erspan_opt_policy, extack);
+	err = nla_parse_nested(tb, LWTUNNEL_IP_OPT_ERSPAN_MAX, attr,
+			       erspan_opt_policy, extack);
 	if (err)
 		return err;
 
@@ -362,8 +362,8 @@ static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 	if (!attr)
 		return 0;
 
-	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_OPTS_MAX, attr,
-					  ip_opts_policy, extack);
+	err = nla_parse_nested(tb, LWTUNNEL_IP_OPTS_MAX, attr,
+			       ip_opts_policy, extack);
 	if (err)
 		return err;
 
-- 
2.1.0

