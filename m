Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD1B32E41D
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhCEJC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:02:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhCEJCJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:02:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AADE864EDF;
        Fri,  5 Mar 2021 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614934928;
        bh=uhnQF/fGZmUHpT2bc3mEC0JD08Io4Y7ZL5tPjw52pyM=;
        h=Date:From:To:Cc:Subject:From;
        b=JOcuQeofZgz29Nbg0OiVeHqm72PedTFdoWlDAYiAsUrSR16eeeXNjb90gOqeJ+zaA
         3LRBZCJp9up00olZDSaL0n3KJI8JdzVSWjoV7Z+HGDfzOHOp74L4L5fPzJY2uoJnVS
         H2bn/CSoS2TMHH6t5SeyviWkjs0Q98XT+JEdjrqeyXDbXltXbVs1F0UKr9s0QQtdiD
         RcYl6KT7+RXV+vafnNsEvdyMUeT6fRNxAT3c+HE1Z96egwjZsyWvfX/qPp02trh28L
         Ox0Y/YY0gr3rqk8G0URqjnz7CltF0f1zvql441u1xfPpDrXKu3dn2zv6EyMPcSxzPa
         zx01XpneYQx5Q==
Date:   Fri, 5 Mar 2021 03:02:05 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] ipv4: Fix fall-through warnings for Clang
Message-ID: <20210305090205.GA139036@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/ipv4/ah4.c           | 1 +
 net/ipv4/esp4.c          | 1 +
 net/ipv4/fib_semantics.c | 1 +
 net/ipv4/ip_vti.c        | 1 +
 net/ipv4/ipcomp.c        | 1 +
 5 files changed, 5 insertions(+)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 36ed85bf2ad5..fab0958c41be 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -450,6 +450,7 @@ static int ah4_err(struct sk_buff *skb, u32 info)
 	case ICMP_DEST_UNREACH:
 		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
 			return 0;
+		break;
 	case ICMP_REDIRECT:
 		break;
 	default:
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 4b834bbf95e0..6cb3ecad04b8 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -982,6 +982,7 @@ static int esp4_err(struct sk_buff *skb, u32 info)
 	case ICMP_DEST_UNREACH:
 		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
 			return 0;
+		break;
 	case ICMP_REDIRECT:
 		break;
 	default:
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index a632b66bc13a..4c0c33e4710d 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1874,6 +1874,7 @@ static int call_fib_nh_notifiers(struct fib_nh *nh,
 		    (nh->fib_nh_flags & RTNH_F_DEAD))
 			return call_fib4_notifiers(dev_net(nh->fib_nh_dev),
 						   event_type, &info.info);
+		break;
 	default:
 		break;
 	}
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 31c6c6d99d5e..eb560eecee08 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -351,6 +351,7 @@ static int vti4_err(struct sk_buff *skb, u32 info)
 	case ICMP_DEST_UNREACH:
 		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
 			return 0;
+		break;
 	case ICMP_REDIRECT:
 		break;
 	default:
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index b42683212c65..bbb56f5e06dd 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -31,6 +31,7 @@ static int ipcomp4_err(struct sk_buff *skb, u32 info)
 	case ICMP_DEST_UNREACH:
 		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
 			return 0;
+		break;
 	case ICMP_REDIRECT:
 		break;
 	default:
-- 
2.27.0

