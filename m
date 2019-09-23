Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC643BB737
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 16:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731105AbfIWOxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 10:53:03 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:37385 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbfIWOxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 10:53:03 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Sep 2019 10:53:02 EDT
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 46271643;
        Mon, 23 Sep 2019 14:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=yyymxKdabkTqYObyJhZGJkfA+vU=; b=j1H39S7dE4Mp4+0YGsvk
        RHmhWaANn0VLxXbjt6ayCpqFzg0UrAP3zQ1DdCEfCO8DjpYEzwCWqo18Tys3u7qH
        Mw3sd08/jjGus1O8x6UbsDWWVbZ0xlFSDb5OOsQq1dAlriT+lxXbW0lqloc51CkI
        yTd304TZKnXYrca7sSRu+xc7aKspeUBMjUPuXHrb+e/tqBspt7lPP+X9Zhxjfzd7
        qMIm3o69SlZiIl2NlhAXsecrWqrhF2PrNhOUPm983e1+G9khhRSi2n+gAbRU2+hV
        7xRXm0uLAwHH45EGrG+dkUlleXj6MB/WgZJuYp9qHQdrJ4bK9LeZK21uoKIwca9q
        Mg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 561504fe (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Sep 2019 14:00:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] ipv6: Properly check reference count flag before taking reference
Date:   Mon, 23 Sep 2019 16:46:12 +0200
Message-Id: <20190923144612.29668-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

People are reporting that WireGuard experiences erratic crashes on 5.3,
and bisected it down to 7d30a7f6424e. Casually flipping through that
commit I noticed that a flag is checked using `|` instead of `&`, which in
this current case, means that a reference is never incremented, which
would result in the use-after-free users are seeing. This commit changes
the `|` to the proper `&` test.

Cc: stable@vger.kernel.org
Fixes: 7d30a7f6424e ("Merge branch 'ipv6-avoid-taking-refcnt-on-dst-during-route-lookup'")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv6/ip6_fib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 87f47bc55c5e..6e2af411cd9c 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -318,7 +318,7 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
 	if (rt->dst.error == -EAGAIN) {
 		ip6_rt_put_flags(rt, flags);
 		rt = net->ipv6.ip6_null_entry;
-		if (!(flags | RT6_LOOKUP_F_DST_NOREF))
+		if (!(flags & RT6_LOOKUP_F_DST_NOREF))
 			dst_hold(&rt->dst);
 	}
 
-- 
2.21.0

