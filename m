Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2E965B539
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 17:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbjABQkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 11:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbjABQkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 11:40:39 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A77871139;
        Mon,  2 Jan 2023 08:40:38 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 6/7] netfilter: ipset: fix hash:net,port,net hang with /0 subnet
Date:   Mon,  2 Jan 2023 17:40:24 +0100
Message-Id: <20230102164025.125995-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230102164025.125995-1-pablo@netfilter.org>
References: <20230102164025.125995-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

The hash:net,port,net set type supports /0 subnets. However, the patch
commit 5f7b51bf09baca8e titled "netfilter: ipset: Limit the maximal range
of consecutive elements to add/delete" did not take into account it and
resulted in an endless loop. The bug is actually older but the patch
5f7b51bf09baca8e brings it out earlier.

Handle /0 subnets properly in hash:net,port,net set types.

Fixes: 5f7b51bf09ba ("netfilter: ipset: Limit the maximal range of consecutive elements to add/delete")
Reported-by: Марк Коренберг <socketpair@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_netportnet.c | 40 ++++++++++----------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 19bcdb3141f6..005a7ce87217 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -173,17 +173,26 @@ hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
+static u32
+hash_netportnet4_range_to_cidr(u32 from, u32 to, u8 *cidr)
+{
+	if (from == 0 && to == UINT_MAX) {
+		*cidr = 0;
+		return to;
+	}
+	return ip_set_range_to_cidr(from, to, cidr);
+}
+
 static int
 hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netportnet4 *h = set->data;
+	struct hash_netportnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2, ipn;
-	u64 n = 0, m = 0;
+	u32 ip2_from = 0, ip2_to = 0, ip2, i = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -285,19 +294,6 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
-		n++;
-	} while (ipn++ < ip_to);
-	ipn = ip2_from;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
-		m++;
-	} while (ipn++ < ip2_to);
-
-	if (n*m*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
@@ -310,13 +306,19 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	do {
 		e.ip[0] = htonl(ip);
-		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
+		ip = hash_netportnet4_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
 			do {
+				i++;
 				e.ip[1] = htonl(ip2);
-				ip2 = ip_set_range_to_cidr(ip2, ip2_to,
-							   &e.cidr[1]);
+				if (i > IPSET_MAX_RANGE) {
+					hash_netportnet4_data_next(&h->next,
+								   &e);
+					return -ERANGE;
+				}
+				ip2 = hash_netportnet4_range_to_cidr(ip2,
+							ip2_to, &e.cidr[1]);
 				ret = adtfn(set, &e, &ext, &ext, flags);
 				if (ret && !ip_set_eexist(ret, flags))
 					return ret;
-- 
2.30.2

