Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9789A165785
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 07:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgBTGXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 01:23:12 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42175 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgBTGXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 01:23:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so1383173pfz.9
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 22:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8qayNiEk6Ez597Hfv2WXjhuGkwTEv6woGfUiEMCan8o=;
        b=WzZKvPCluiNn0EYIb2cJH7gk/Iwu48zGyL51qi6o50wqyXa0MHNh4UN34IwELQE+tL
         4Yf/ExFaaZn8+jAbh6sW6rHSPTd19fobn/13Icre1F6EvGp00V+hJxevsi2emcp19IVo
         QZCPxOy+/BZyRoUge1gQVhsmVL2dZWqhQh+Bk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8qayNiEk6Ez597Hfv2WXjhuGkwTEv6woGfUiEMCan8o=;
        b=YV59Tb0BTVMk6R0bLgsm2W7bHy15fcOJNxzFi2Bv3gRBlLz1Ys2k/0AOAHhNdg9U/M
         rJUOtQ6TVCYMg+i3W1dRZnK5YXi2soIBS8lEg6pB6UaTruoIn1HTgYthNLjXvm4zMoEI
         41kv57DmgObfTha39wAq/j70jfbJCL5mL8X7Zjn9WjZoFGeN23iY7MBMk8O9ED4ASYNE
         nTdI5knSfBX4qTGmjJwQMPPewF5lyi79G1QYESLdi7W+r64TrTapkJ/r9c2JtZrIsDN2
         9cBwC0/yQjn3m45dLke+iu75lQSHiBLw+QzCTXHG9ABzBl5B8tBzEw7br9TW774wJOIp
         kVow==
X-Gm-Message-State: APjAAAWbf2vYEz7uSHVVp9K8kjX/sFqbnUu/nUgq1/TF7OYMN7hw1xRz
        PgePxTAMiOa1ASCQX/ADTIDQyA==
X-Google-Smtp-Source: APXvYqxbFRQZq8cdLNzYWY9l0+FHpSJxlK3/FtLPNTsPI/zF7OARbBHjOSE/cwPT1SKoTZGUBiiXxg==
X-Received: by 2002:a63:fe0a:: with SMTP id p10mr30850982pgh.96.1582179789982;
        Wed, 19 Feb 2020 22:23:09 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i11sm1763457pjg.0.2020.02.19.22.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 22:23:09 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Alexander Potapenko <glider@google.com>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ip6_gre: Distribute switch variables for initialization
Date:   Wed, 19 Feb 2020 22:23:07 -0800
Message-Id: <20200220062307.68986-1-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variables declared in a switch statement before any case statements
cannot be automatically initialized with compiler instrumentation (as
they are not part of any execution flow). With GCC's proposed automatic
stack variable initialization feature, this triggers a warning (and they
don't get initialized). Clang's automatic stack variable initialization
(via CONFIG_INIT_STACK_ALL=y) doesn't throw a warning, but it also
doesn't initialize such variables[1]. Note that these warnings (or silent
skipping) happen before the dead-store elimination optimization phase,
so even when the automatic initializations are later elided in favor of
direct initializations, the warnings remain.

To avoid these problems, move such variables into the "case" where
they're used or lift them up into the main function body.

net/ipv6/ip6_gre.c: In function ‘ip6gre_err’:
net/ipv6/ip6_gre.c:440:32: warning: statement will never be executed [-Wswitch-unreachable]
  440 |   struct ipv6_tlv_tnl_enc_lim *tel;
      |                                ^~~

net/ipv6/ip6_tunnel.c: In function ‘ip6_tnl_err’:
net/ipv6/ip6_tunnel.c:520:32: warning: statement will never be executed [-Wswitch-unreachable]
  520 |   struct ipv6_tlv_tnl_enc_lim *tel;
      |                                ^~~

[1] https://bugs.llvm.org/show_bug.cgi?id=44916

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ipv6/ip6_gre.c    |    8 +++++---
 net/ipv6/ip6_tunnel.c |   13 +++++++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 55bfc5149d0c..781ca8c07a0d 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -437,8 +437,6 @@ static int ip6gre_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		return -ENOENT;
 
 	switch (type) {
-		struct ipv6_tlv_tnl_enc_lim *tel;
-		__u32 teli;
 	case ICMPV6_DEST_UNREACH:
 		net_dbg_ratelimited("%s: Path to destination invalid or inactive!\n",
 				    t->parms.name);
@@ -452,7 +450,10 @@ static int ip6gre_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			break;
 		}
 		return 0;
-	case ICMPV6_PARAMPROB:
+	case ICMPV6_PARAMPROB: {
+		struct ipv6_tlv_tnl_enc_lim *tel;
+		__u32 teli;
+
 		teli = 0;
 		if (code == ICMPV6_HDR_FIELD)
 			teli = ip6_tnl_parse_tlv_enc_lim(skb, skb->data);
@@ -468,6 +469,7 @@ static int ip6gre_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 					    t->parms.name);
 		}
 		return 0;
+	}
 	case ICMPV6_PKT_TOOBIG:
 		ip6_update_pmtu(skb, net, info, 0, 0, sock_net_uid(net, NULL));
 		return 0;
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 5d65436ad5ad..4703b09808d0 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -517,8 +517,6 @@ ip6_tnl_err(struct sk_buff *skb, __u8 ipproto, struct inet6_skb_parm *opt,
 	err = 0;
 
 	switch (*type) {
-		struct ipv6_tlv_tnl_enc_lim *tel;
-		__u32 mtu, teli;
 	case ICMPV6_DEST_UNREACH:
 		net_dbg_ratelimited("%s: Path to destination invalid or inactive!\n",
 				    t->parms.name);
@@ -531,7 +529,10 @@ ip6_tnl_err(struct sk_buff *skb, __u8 ipproto, struct inet6_skb_parm *opt,
 			rel_msg = 1;
 		}
 		break;
-	case ICMPV6_PARAMPROB:
+	case ICMPV6_PARAMPROB: {
+		struct ipv6_tlv_tnl_enc_lim *tel;
+		__u32 teli;
+
 		teli = 0;
 		if ((*code) == ICMPV6_HDR_FIELD)
 			teli = ip6_tnl_parse_tlv_enc_lim(skb, skb->data);
@@ -548,7 +549,10 @@ ip6_tnl_err(struct sk_buff *skb, __u8 ipproto, struct inet6_skb_parm *opt,
 					    t->parms.name);
 		}
 		break;
-	case ICMPV6_PKT_TOOBIG:
+	}
+	case ICMPV6_PKT_TOOBIG: {
+		__u32 mtu;
+
 		ip6_update_pmtu(skb, net, htonl(*info), 0, 0,
 				sock_net_uid(net, NULL));
 		mtu = *info - offset;
@@ -562,6 +566,7 @@ ip6_tnl_err(struct sk_buff *skb, __u8 ipproto, struct inet6_skb_parm *opt,
 			rel_msg = 1;
 		}
 		break;
+	}
 	case NDISC_REDIRECT:
 		ip6_redirect(skb, net, skb->dev->ifindex, 0,
 			     sock_net_uid(net, NULL));

