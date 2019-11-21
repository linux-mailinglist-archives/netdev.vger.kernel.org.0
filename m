Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9777E105014
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfKUKLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:11:36 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36751 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUKLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:11:36 -0500
Received: by mail-pf1-f195.google.com with SMTP id b19so1433986pfd.3
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=b2LU2W8lCaEUzu5PHVMRy//yUORICz2EPrpsy5x3r4A=;
        b=d5RE6bV56lwyKqfKNRu2d2o9LZx7birtXpCPaxzvQLPZz8AjVv4Q6aW9dH+XaFH0bp
         Pppl+MtUnCZRW12nSLqrKF3PwUDDSZztkcFkJjMQQ11HWIOvivwItqoF8TVIWO3OY4eN
         4tC9d0pYhtdhvi6Gb0CXY+zdDqAmD5uMbpWeZyW0k+mPudOwpCVY1VkvBoRAbjb34TT6
         v5jgwmkDaRwSHvj4zlFBJNroXA1F3B0hOKAb4ppeUGm+K2muVbCLl1W71yzyg89HaiqZ
         pJixGOX+SSM/75oWkqRGdBwX+ppIOhJz9oapWUmCu3cQ2VVVvqeB57Xo+WDMDQBjtMtq
         DIqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b2LU2W8lCaEUzu5PHVMRy//yUORICz2EPrpsy5x3r4A=;
        b=YOK0nCr3frIQM5FXyXleldymRzAcMaSnkImMIciDKKJK5frBllPdUY2+Wf64TsdOUd
         EfEZXSWG87Dq6ImjZHiqQDQGnsmFH9Avm+FUD3Bykg+gNL1kSTH5ckGm4mc8mEsDZbue
         LiXi/BHnGm15EeDKz2b+7fBrYMcvPkdVSktSmmCBYqUP6BJ+FNAz5X8ZgRBVCx8CnI0D
         qyaJX9+TxLAQODUNFtfhXhflOpixF2SqflRGAzDpjk0p3pOcd0QFGrMF3Yu1Ebn/DEyU
         D7Z9FMbMAEFDrmEul4x3/4hGLKZHQ3uTK5Krwf98C7JDz0ChqQFrlI5Kz+GmJUoz8heA
         Gc7Q==
X-Gm-Message-State: APjAAAWJrNDbuGIqsY9NBrJE/H619KCZUjo5IaethBm2bc3K/AXXTguE
        dy6EuPweOSSprLkWcu1KUPptnxna
X-Google-Smtp-Source: APXvYqxgHW+V+U9XzIiD+kGM/47fwSSohEV9RqvrOFCY/t3H2yyRmgONefPVjIVD4DTRSSD+3vZS7w==
X-Received: by 2002:a62:6458:: with SMTP id y85mr9756826pfb.133.1574331095250;
        Thu, 21 Nov 2019 02:11:35 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s11sm2339369pgo.85.2019.11.21.02.11.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:11:34 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next] lwtunnel: be STRICT to validate the new LWTUNNEL_IP(6)_OPTS
Date:   Thu, 21 Nov 2019 18:11:27 +0800
Message-Id: <1993c1c08a6e3e278afeb173e4f4584eea5e14aa.1574331087.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LWTUNNEL_IP(6)_OPTS are the new items in ip(6)_tun_policy, which
are parsed by nla_parse_nested_deprecated(). We should check it
strictly by setting .strict_start_type = LWTUNNEL_IP(6)_OPTS.

This patch also adds missing LWTUNNEL_IP6_OPTS in ip6_tun_policy.

Fixes: 4ece47787077 ("lwtunnel: add options setting and dumping for geneve")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 45405d2..0a7eaad 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -215,6 +215,7 @@ void ip_tunnel_get_stats64(struct net_device *dev,
 EXPORT_SYMBOL_GPL(ip_tunnel_get_stats64);
 
 static const struct nla_policy ip_tun_policy[LWTUNNEL_IP_MAX + 1] = {
+	[LWTUNNEL_IP_UNSPEC]	= { .strict_start_type = LWTUNNEL_IP_OPTS },
 	[LWTUNNEL_IP_ID]	= { .type = NLA_U64 },
 	[LWTUNNEL_IP_DST]	= { .type = NLA_U32 },
 	[LWTUNNEL_IP_SRC]	= { .type = NLA_U32 },
@@ -700,12 +701,14 @@ static const struct lwtunnel_encap_ops ip_tun_lwt_ops = {
 };
 
 static const struct nla_policy ip6_tun_policy[LWTUNNEL_IP6_MAX + 1] = {
+	[LWTUNNEL_IP6_UNSPEC]	= { .strict_start_type = LWTUNNEL_IP6_OPTS },
 	[LWTUNNEL_IP6_ID]		= { .type = NLA_U64 },
 	[LWTUNNEL_IP6_DST]		= { .len = sizeof(struct in6_addr) },
 	[LWTUNNEL_IP6_SRC]		= { .len = sizeof(struct in6_addr) },
 	[LWTUNNEL_IP6_HOPLIMIT]		= { .type = NLA_U8 },
 	[LWTUNNEL_IP6_TC]		= { .type = NLA_U8 },
 	[LWTUNNEL_IP6_FLAGS]		= { .type = NLA_U16 },
+	[LWTUNNEL_IP6_OPTS]		= { .type = NLA_NESTED },
 };
 
 static int ip6_tun_build_state(struct nlattr *attr,
-- 
2.1.0

