Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A171B19FA
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgDTXNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbgDTXNz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:13:55 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D62A21D79;
        Mon, 20 Apr 2020 23:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587424434;
        bh=IJoblJrKmdPBE7qDj3flqI5r1dSjI70VvE8SNpNW+wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQiP9/cowrrI0iHJRRy0qoU4IKzQeTMJ9xPQ+hM9uEEiki1ei64CHogB/rSqOfTDN
         ylnu8FqCmaxsnv02/kMyWE1aRLvZIepoTJfWTLPHCGuemWUBsCIpeC7JlC4MSqdfaE
         nU8djT1qS4O2TcUoHvLfc7LtDrpzd/Ufn/wP1QM0=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, trev@larock.ca,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 1/2] xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish
Date:   Mon, 20 Apr 2020 17:13:51 -0600
Message-Id: <20200420231352.50855-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200420231352.50855-1-dsahern@kernel.org>
References: <20200420231352.50855-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

IPSKB_XFRM_TRANSFORMED and IP6SKB_XFRM_TRANSFORMED are skb flags set by
xfrm code to tell other skb handlers that the packet has been passed
through the xfrm output functions. Simplify the code and just always
set them rather than conditionally based on netfilter enabled thus
making the flag available for other users.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/xfrm4_output.c | 2 --
 net/ipv6/xfrm6_output.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
index 89ba7c87de5d..30ddb9dc9398 100644
--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -58,9 +58,7 @@ int xfrm4_output_finish(struct sock *sk, struct sk_buff *skb)
 {
 	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 
-#ifdef CONFIG_NETFILTER
 	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
-#endif
 
 	return xfrm_output(sk, skb);
 }
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index fbe51d40bd7e..e34167f790e6 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -111,9 +111,7 @@ int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb)
 {
 	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 
-#ifdef CONFIG_NETFILTER
 	IP6CB(skb)->flags |= IP6SKB_XFRM_TRANSFORMED;
-#endif
 
 	return xfrm_output(sk, skb);
 }
-- 
2.20.1

