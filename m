Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4177E1BDE3
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 21:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfEMT2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 15:28:23 -0400
Received: from bond.m7n.se ([46.246.28.121]:40412 "EHLO bond.m7n.se"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbfEMT2X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 15:28:23 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 May 2019 15:28:21 EDT
Received: from [IPv6:2001:470:de6f:1301:944b:9ce7:73d9:fb6b] (unknown [IPv6:2001:470:de6f:1301:944b:9ce7:73d9:fb6b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by bond.m7n.se (Postfix) with ESMTPSA id 42EF86003966
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 19:22:50 +0000 (UTC)
From:   Mikael Magnusson <mikael.kernel@lists.m7n.se>
Subject: IPv6 PMTU discovery fails with source-specific routing
To:     netdev@vger.kernel.org
Message-ID: <71e7331f-d528-430e-f880-e995ff53d362@lists.m7n.se>
Date:   Mon, 13 May 2019 21:22:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------0B0F4DE3E75A3197017BB370"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------0B0F4DE3E75A3197017BB370
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello list,

I think I have found a regression in 4.15+ kernels. IPv6 PMTU discovery 
doesn't seem to work with source-specific routing (AKA source-address 
dependent routing, SADR).

I made a test script (see attachment). It sets up a test environment 
with three network namespaces (a, b and c) using SADR. The link between 
b and c is configured with MTU 1280. It then runs a ping test with large 
packets.

I have tested a couple of kernels on Ubuntu 19.04 with the following 
results.

mainline 4.14.117-0414117-generic SUCCESS
ubuntu   4.15.0-1036-oem          FAIL
mainline 5.1.0-050100-generic     FAIL

The mainline kernels are from 
https://kernel.ubuntu.com/~kernel-ppa/mainline/, and the other from the 
Ubuntu 19.04 repository.

I have attached a patch against 5.1 which seems to fix the problem in 
the test case.

It's bug #1788623 in Ubuntu: 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1788623

/Mikael

--------------0B0F4DE3E75A3197017BB370
Content-Type: text/x-patch;
 name="0001-net-ipv6-route-Fix-PMTU-for-source-specific-routes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-net-ipv6-route-Fix-PMTU-for-source-specific-routes.patc";
 filename*1="h"

From 4dd6d3e00663ec1749d8c6cf8139a2e255c7a797 Mon Sep 17 00:00:00 2001
From: Mikael Magnusson <mikma@users.sourceforge.net>
Date: Wed, 8 May 2019 22:06:44 +0000
Subject: [PATCH] net/ipv6/route: Fix PMTU for source-specific routes

---
 net/ipv6/route.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0520aca3354b..63d678588ec9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1197,13 +1197,13 @@ static struct rt6_info *ip6_rt_cache_alloc(struct fib6_info *ort,
 		if (ort->fib6_dst.plen != 128 &&
 		    ipv6_addr_equal(&ort->fib6_dst.addr, daddr))
 			rt->rt6i_flags |= RTF_ANYCAST;
+	}
 #ifdef CONFIG_IPV6_SUBTREES
-		if (rt->rt6i_src.plen && saddr) {
-			rt->rt6i_src.addr = *saddr;
-			rt->rt6i_src.plen = 128;
-		}
-#endif
+	if (rt->rt6i_src.plen && saddr) {
+		rt->rt6i_src.addr = *saddr;
+		rt->rt6i_src.plen = 128;
 	}
+#endif
 
 	return rt;
 }
-- 
2.17.1



--------------0B0F4DE3E75A3197017BB370
Content-Type: application/x-shellscript;
 name="pmtu-ns.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="pmtu-ns.sh"

IyEvYmluL3NoCgpzZXQgLWUKCmFkZF9ucygpIHsKCWlwIG5ldG5zIGFkZCAkMQoJbnMgJDEg
c3lzY3RsIC13IG5ldC5pcHY2LmNvbmYuYWxsLmFjY2VwdF9kYWQ9MCA+L2Rldi9udWxsCglu
cyAkMSBzeXNjdGwgLXcgbmV0LmlwdjYuY29uZi5kZWZhdWx0LmFjY2VwdF9kYWQ9MCA+L2Rl
di9udWxsCn0KCmRlbF9ucygpIHsKCWlwIG5ldG5zIGRlbCAkMQp9CgphZGRfbGluaygpIHsK
CWlwIGxpbmsgYWRkICJ2ZXRoJDEkMiIgdHlwZSB2ZXRoIHBlZXIgbmFtZSAidmV0aCQyJDEi
CglpcCBsaW5rIHNldCBtdHUgJDMgZGV2ICJ2ZXRoJDEkMiIKCWlwIGxpbmsgc2V0IG10dSAk
MyBkZXYgInZldGgkMiQxIgoJaXAgbGluayBzZXQgbmV0bnMgJDEgZGV2ICJ2ZXRoJDEkMiIg
CglpcCBsaW5rIHNldCBuZXRucyAkMiBkZXYgInZldGgkMiQxIgoJbnMgJDEgaXAgbGluayBz
ZXQgdXAgZGV2ICJ2ZXRoJDEkMiIKCW5zICQyIGlwIGxpbmsgc2V0IHVwIGRldiAidmV0aCQy
JDEiCn0KCmFkZF9pcCgpIHsKCW5zICQxIGlwIGFkZHIgYWRkICQyIGRldiAkMwp9Cgpkb19y
b3V0ZSgpIHsKCW5zICQxIGlwIHJvdXRlICQyICQzIHZpYSAkNAp9CgphZGRfcm91dGUoKSB7
Cglkb19yb3V0ZSAkMSBhZGQgJDIgJDMKfQoKZGVsX3JvdXRlKCkgewoJZG9fcm91dGUgJDEg
ZGVsICQyICQzCn0KCmFkZF9yb3V0ZV9zYWRyKCkgewoJbnMgJDEgaXAgcm91dGUgYWRkICQy
IGZyb20gJDQgdmlhICQzCn0KCm5zKCkgewoJbG9jYWwgbj0kMQoJc2hpZnQKCWlwIG5ldG5z
IGV4ZWMgJG4gIiRAIgp9Cgp0ZXN0X3BpbmcoKSB7CgkjIFRyaWdnZXIgUE1UVQoJbnMgYSBw
aW5nIC1jIDEgLXMgMjAwMCBmZDAxOjpjID4vZGV2L251bGx8fCB0cnVlCgoJIyBUZXN0IHBp
bmcKCWlmIG5zIGEgcGluZyAtYyAxIC1zIDIwMDAgZmQwMTo6YyA+L2Rldi9udWxsOyB0aGVu
CgkJZWNobyAiJDFTVUNDRVNTIgoJZWxzZQoJCWVjaG8gIiQxRkFJTCIKCWZpCn0KCmRlbF9u
cyBhIHx8IHRydWUKZGVsX25zIGIgfHwgdHJ1ZQpkZWxfbnMgYyB8fCB0cnVlCgphZGRfbnMg
YQphZGRfbnMgYgphZGRfbnMgYwoKbnMgYiBzeXNjdGwgLXcgbmV0LmlwdjYuY29uZi5hbGwu
Zm9yd2FyZGluZz0xID4vZGV2L251bGwKCmFkZF9saW5rIGEgYiAxNTAwCmFkZF9saW5rIGIg
YyAxMjgwCgphZGRfaXAgYSBmZDAwOjphLzY0IHZldGhhYgphZGRfaXAgYiBmZDAwOjpiLzY0
IHZldGhiYQphZGRfaXAgYiBmZDAxOjpiLzY0IHZldGhiYwphZGRfaXAgYyBmZDAxOjpjLzY0
IHZldGhjYgoKYWRkX3JvdXRlIGMgZmQwMDo6LzY0IGZkMDE6OmIKCiNhZGRfcm91dGUgYSBm
ZDAwOjovOCBmZDAwOjpiCiN0ZXN0X3BpbmcgIk5vIFNBRFI6ICIKI2RlbF9yb3V0ZSBhIGZk
MDA6Oi84IGZkMDA6OmIKCmFkZF9yb3V0ZV9zYWRyIGEgZmQwMDo6LzggZmQwMDo6YiBmZDAw
OjovNjQKdGVzdF9waW5nICJTQURSOiAgICAiCgo=
--------------0B0F4DE3E75A3197017BB370--
