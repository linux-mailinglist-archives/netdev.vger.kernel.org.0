Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23243B1E94
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFWQZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWQZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 12:25:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A32BD6024A;
        Wed, 23 Jun 2021 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624465411;
        bh=zfwLz/mguuik77IdHK0mP879fNS8YvrpV1yEGPiQ3/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=JQmxHJbtFb0N10DSoZ9EtIuXlhhbFpKUl5xRo5Fn1cSOb11vU4TY8Bz99Np7zhS3Z
         r4xbcGbz6z8k5wSWbbGY3vL+DtaYgIbJR1YWrMgQ32oYi17Y4AYtUR0/wi39+814iG
         AOsx/zS7jD8g5Cnayn93Ut81USAxkvnXapLGhwz+nAXOxS5DSHt+EGsOn0/mazl57s
         XDjKocvimzN63/xYanWtprR3ZeyquphNneWBeCfRwD6SNI3/DEXghBGex9pHgLIdO2
         9lrzQOMDYRnQZDtVaubmLeGBEEoDf8lNZLL1btMlPo7Z5ESPHj461gKNai1l4lryF2
         c48kFmjtL5DVA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        Jakub Kicinski <kuba@kernel.org>, Dave Jones <dsj@fb.com>
Subject: [PATCH net-next v3] net: ip: avoid OOM kills with large UDP sends over loopback
Date:   Wed, 23 Jun 2021 09:23:28 -0700
Message-Id: <20210623162328.2197645-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave observed number of machines hitting OOM on the UDP send
path. The workload seems to be sending large UDP packets over
loopback. Since loopback has MTU of 64k kernel will try to
allocate an skb with up to 64k of head space. This has a good
chance of failing under memory pressure. What's worse if
the message length is <32k the allocation may trigger an
OOM killer.

This is entirely avoidable, we can use an skb with page frags.

af_unix solves a similar problem by limiting the head
length to SKB_MAX_ALLOC. This seems like a good and simple
approach. It means that UDP messages > 16kB will now
use fragments if underlying device supports SG, if extra
allocator pressure causes regressions in real workloads
we can switch to trying the large allocation first and
falling back.

Reported-by: Dave Jones <dsj@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/ip_output.c  | 4 +++-
 net/ipv6/ip6_output.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c3efc7d658f6..790dd28fd198 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1077,7 +1077,9 @@ static int __ip_append_data(struct sock *sk,
 			if ((flags & MSG_MORE) &&
 			    !(rt->dst.dev->features&NETIF_F_SG))
 				alloclen = mtu;
-			else if (!paged)
+			else if (!paged &&
+				 (fraglen + hh_len + 15 < SKB_MAX_ALLOC ||
+				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
 			else {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4f9ebcf7f6..ae8dbd6cdab1 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1585,7 +1585,9 @@ static int __ip6_append_data(struct sock *sk,
 			if ((flags & MSG_MORE) &&
 			    !(rt->dst.dev->features&NETIF_F_SG))
 				alloclen = mtu;
-			else if (!paged)
+			else if (!paged &&
+				 (fraglen + hh_len < SKB_MAX_ALLOC ||
+				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
 			else {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
-- 
2.31.1

