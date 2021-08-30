Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312143FB2FC
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhH3JRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:17:50 -0400
Received: from out1.migadu.com ([91.121.223.63]:16849 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235042AbhH3JRt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 05:17:49 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1630315014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RnZU/eiz4GTpQlhOPHQMTWd/YBLjcRvYkWNaDFjlT3A=;
        b=VnMxU5RoF+peuR8YKJyyKmseBGFc2tMlgVknNtQfxcdL35EElLiQ6HuwsDnEYucS9SfTrq
        DN56XFvLbhnpnYSJcaZUGLhysScqHkKHFCQzhCPNWvaQEKAXccyxYVxCA8AD23HoZAcynF
        8/tUBZjRzov70oVngtpWi2lGKbLmFCE=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next] net: ipv4: Fix the warning for dereference
Date:   Mon, 30 Aug 2021 17:16:40 +0800
Message-Id: <20210830091640.14739-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a if statements to avoid the warning.

Dan Carpenter report:
The patch faf482ca196a: "net: ipv4: Move ip_options_fragment() out of
loop" from Aug 23, 2021, leads to the following Smatch complaint:

    net/ipv4/ip_output.c:833 ip_do_fragment()
    warn: variable dereferenced before check 'iter.frag' (see line 828)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: faf482ca196a ("net: ipv4: Move ip_options_fragment() out of loop")
Link: https://lore.kernel.org/netdev/20210830073802.GR7722@kadam/T/#t
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/ipv4/ip_output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 9a8f05d5476e..9bca57ef8b83 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -825,7 +825,9 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 		/* Everything is OK. Generate! */
 		ip_fraglist_init(skb, iph, hlen, &iter);
-		ip_options_fragment(iter.frag);
+
+		if (iter.frag)
+			ip_options_fragment(iter.frag);
 
 		for (;;) {
 			/* Prepare header of the next frame,
-- 
2.32.0

