Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644C7646DA
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfGJNO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:14:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42548 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJNO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 09:14:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so1243129pgb.9;
        Wed, 10 Jul 2019 06:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VLGpVWCepPkViNPlTkxuFahJxt3WaXWMIUHUVNkKRfo=;
        b=A+0BwmK4oAsgVef3DhVlqKulKgYebIo9OKP8qfDYLkZlxPiAd3yrKqrRq6NvoDvV/I
         PH6wpAD9Su78O/ZS4ZU44XGzJWftifeY/yJwIzzlS3BjZUvKlJ2K5cU4tgN1FJbpJ3cr
         GXjzau9lJ4+cwNLR/FZC/4ZtpbvuX9csG3Y502W0686CNEnuD7hZxTqQSXtYm7GSwpj8
         utIQZ7EF0Pe5Mv20VbwEDZRrQ5vW3Sg367cCB1gO9QgBvQ9lQW0HROudGouXaUsVEhFj
         qyxUkNSjmQ8QQRq3nSsyucroBhlvPWtGim/Can6mINjW4drLd2Npo3g2w/MnKZmPtLBq
         BxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VLGpVWCepPkViNPlTkxuFahJxt3WaXWMIUHUVNkKRfo=;
        b=pYs7NQ7CeHdlTclfHflJ0isWLCfuOROWt55VBeelSQdYEmBXY3C5rINr4j6tniP8ST
         TJV42mgy071vx2immjxIB9K4hZTWBaMntU+NkP+UYZ0mURj8wmJJ5Gew3l5sn5iPvlCn
         vLOho5n+6VpwU/YdlIKFiNClLgh10wscYij54sAabfL0KD9ZfFkA/aoSjn/J8OI8R4JG
         wsq5gsrYbzdcNQ234JINUi3vv4jgTYkCRsnbi6xfRIU4M6GqtGZXUzRy8F2TVEa9/+Kd
         Vw9H2OYGZ29pbcLZFllMq5xu6EH0LRweh/PlaE/waff1V7afnuytaCqhb53TJkDHKG9x
         G6XA==
X-Gm-Message-State: APjAAAX6C2n+IoztkIPZDBVsFDGt3kLhq/hutUwCJacIbqVO4N7CSTzd
        9RHKNSvagfI/pqMdzJ76tCEjDpMighic+Q==
X-Google-Smtp-Source: APXvYqxzWYXUwjttKWD0MSuruhNwge1FOyOY/bWZc4n43lF4RblamDYxNzK6ccAh/vcxymQNvyfCXA==
X-Received: by 2002:a17:90a:220a:: with SMTP id c10mr7084689pje.33.1562764465081;
        Wed, 10 Jul 2019 06:14:25 -0700 (PDT)
Received: from localhost.localdomain ([116.66.213.65])
        by smtp.gmail.com with ESMTPSA id x25sm489273pfa.90.2019.07.10.06.14.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 06:14:24 -0700 (PDT)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        yangxingwu <xingwu.yang@gmail.com>
Subject: [PATCH] ipv6: Use ipv6_authlen for len
Date:   Wed, 10 Jul 2019 21:14:10 +0800
Message-Id: <20190710131410.75825-1-xingwu.yang@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The length of AH header is computed manually as (hp->hdrlen+2)<<2.
However, in include/linux/ipv6.h, a macro named ipv6_authlen is
already defined for exactly the same job. This commit replaces
the manual computation code with the macro.

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
---
 net/ipv6/ah6.c                          | 4 ++--
 net/ipv6/exthdrs_core.c                 | 2 +-
 net/ipv6/ip6_tunnel.c                   | 2 +-
 net/ipv6/netfilter/ip6t_ah.c            | 2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c    | 2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c | 2 +-
 net/ipv6/netfilter/nf_log_ipv6.c        | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 68b9e92..626c64b 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -464,7 +464,7 @@ static void ah6_input_done(struct crypto_async_request *base, int err)
 	struct ah_data *ahp = x->data;
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
 	int hdr_len = skb_network_header_len(skb);
-	int ah_hlen = (ah->hdrlen + 2) << 2;
+	int ah_hlen = ipv6_authlen(ah);
 
 	if (err)
 		goto out;
@@ -546,7 +546,7 @@ static int ah6_input(struct xfrm_state *x, struct sk_buff *skb)
 	ahash = ahp->ahash;
 
 	nexthdr = ah->nexthdr;
-	ah_hlen = (ah->hdrlen + 2) << 2;
+	ah_hlen = ipv6_authlen(ah);
 
 	if (ah_hlen != XFRM_ALIGN8(sizeof(*ah) + ahp->icv_full_len) &&
 	    ah_hlen != XFRM_ALIGN8(sizeof(*ah) + ahp->icv_trunc_len))
diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index 11a43ee..b358f1a 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -266,7 +266,7 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 		} else if (nexthdr == NEXTHDR_AUTH) {
 			if (flags && (*flags & IP6_FH_F_AUTH) && (target < 0))
 				break;
-			hdrlen = (hp->hdrlen + 2) << 2;
+			hdrlen = ipv6_authlen(hp);
 		} else
 			hdrlen = ipv6_optlen(hp);
 
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index b80fde1..3134fbb 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -416,7 +416,7 @@ __u16 ip6_tnl_parse_tlv_enc_lim(struct sk_buff *skb, __u8 *raw)
 				break;
 			optlen = 8;
 		} else if (nexthdr == NEXTHDR_AUTH) {
-			optlen = (hdr->hdrlen + 2) << 2;
+			optlen = ipv6_authlen(hdr);
 		} else {
 			optlen = ipv6_optlen(hdr);
 		}
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 0228ff3..4e15a14 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -55,7 +55,7 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		return false;
 	}
 
-	hdrlen = (ah->hdrlen + 2) << 2;
+	hdrlen = ipv6_authlen(ah);
 
 	pr_debug("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
 	pr_debug("RES %04X ", ah->reserved);
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index fd439f8..0fc6326 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -71,7 +71,7 @@
 		if (nexthdr == NEXTHDR_FRAGMENT)
 			hdrlen = 8;
 		else if (nexthdr == NEXTHDR_AUTH)
-			hdrlen = (hp->hdrlen + 2) << 2;
+			hdrlen = ipv6_authlen(hp);
 		else
 			hdrlen = ipv6_optlen(hp);
 
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 84322ce..16de015 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -421,7 +421,7 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 		if (skb_copy_bits(skb, start, &hdr, sizeof(hdr)))
 			BUG();
 		if (nexthdr == NEXTHDR_AUTH)
-			hdrlen = (hdr.hdrlen+2)<<2;
+			hdrlen = ipv6_authlen(&hdr);
 		else
 			hdrlen = ipv6_optlen(&hdr);
 
diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
index 549c511..f53bd8f 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -155,7 +155,7 @@ static void dump_ipv6_packet(struct net *net, struct nf_log_buf *m,
 
 			}
 
-			hdrlen = (hp->hdrlen+2)<<2;
+			hdrlen = ipv6_authlen(hp);
 			break;
 		case IPPROTO_ESP:
 			if (logflags & NF_LOG_IPOPT) {
-- 
1.8.3.1

