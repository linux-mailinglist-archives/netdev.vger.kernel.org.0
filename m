Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A1E634940
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbiKVV2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbiKVV2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:28:20 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD3392A425;
        Tue, 22 Nov 2022 13:28:19 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/3] netfilter: ipset: regression in ip_set_hash_ip.c
Date:   Tue, 22 Nov 2022 22:28:12 +0100
Message-Id: <20221122212814.63177-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221122212814.63177-1-pablo@netfilter.org>
References: <20221122212814.63177-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishwanath Pai <vpai@akamai.com>

This patch introduced a regression: commit 48596a8ddc46 ("netfilter:
ipset: Fix adding an IPv4 range containing more than 2^31 addresses")

The variable e.ip is passed to adtfn() function which finally adds the
ip address to the set. The patch above refactored the for loop and moved
e.ip = htonl(ip) to the end of the for loop.

What this means is that if the value of "ip" changes between the first
assignement of e.ip and the forloop, then e.ip is pointing to a
different ip address than "ip".

Test case:
$ ipset create jdtest_tmp hash:ip family inet hashsize 2048 maxelem 100000
$ ipset add jdtest_tmp 10.0.1.1/31
ipset v6.21.1: Element cannot be added to the set: it's already added

The value of ip gets updated inside the  "else if (tb[IPSET_ATTR_CIDR])"
block but e.ip is still pointing to the old value.

Fixes: 48596a8ddc46 ("netfilter: ipset: Fix adding an IPv4 range containing more than 2^31 addresses")
Reviewed-by: Joshua Hunt <johunt@akamai.com>
Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_ip.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index dd30c03d5a23..75d556d71652 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -151,18 +151,16 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
 		return -ERANGE;
 
-	if (retried) {
+	if (retried)
 		ip = ntohl(h->next.ip);
-		e.ip = htonl(ip);
-	}
 	for (; ip <= ip_to;) {
+		e.ip = htonl(ip);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
 
 		ip += hosts;
-		e.ip = htonl(ip);
-		if (e.ip == 0)
+		if (ip == 0)
 			return 0;
 
 		ret = 0;
-- 
2.30.2

