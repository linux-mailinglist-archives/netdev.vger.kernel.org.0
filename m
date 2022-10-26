Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB1B60D99C
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 05:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiJZDUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 23:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiJZDU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 23:20:28 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052B331EFC;
        Tue, 25 Oct 2022 20:20:23 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mxv9h3HnszpVxl;
        Wed, 26 Oct 2022 11:16:56 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 11:20:21 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <Robert.Olsson@data.slu.se>,
        <ja@ssi.bg>
Subject: [PATCH net] ipv4: fix source address and gateway mismatch under multiple default gateways
Date:   Wed, 26 Oct 2022 11:20:17 +0800
Message-ID: <20221026032017.3675060-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found a problem that source address doesn't match with selected gateway
under multiple default gateways. The reproducer is as following:

Setup in client as following:

$ ip link add link eth2 dev eth2.71 type vlan id 71
$ ip link add link eth2 dev eth2.72 type vlan id 72
$ ip addr add 192.168.71.41/24 dev eth2.71
$ ip addr add 192.168.72.41/24 dev eth2.72
$ ip link set eth2.71 up
$ ip link set eth2.72 up
$ route add -net default gw 192.168.71.1 dev eth2.71
$ route add -net default gw 192.168.72.1 dev eth2.72

Add a nameserver configuration in the following file:
$ cat /etc/resolv.conf
nameserver 8.8.8.8

Setup in peer server as following:

$ ip link add link eth2 dev eth2.71 type vlan id 71
$ ip link add link eth2 dev eth2.72 type vlan id 72
$ ip addr add 192.168.71.1/24 dev eth2.71
$ ip addr add 192.168.72.1/24 dev eth2.72
$ ip link set eth2.71 up
$ ip link set eth2.72 up

Use the following command trigger DNS packet in client:
$ ping www.baidu.com

Capture packets with tcpdump in client when ping:
$ tcpdump -i eth2 -vne
...
20:30:22.996044 52:54:00:20:23:a9 > 52:54:00:d2:4f:e3, ethertype 802.1Q (0x8100), length 77: vlan 71, p 0, ethertype IPv4, (tos 0x0, ttl 64, id 25407, offset 0, flags [DF], proto UDP (17), length 59)
    192.168.72.41.42666 > 8.8.8.8.domain: 58562+ A? www.baidu.com. (31)
...

We get the problem that IPv4 saddr "192.168.72.41" do not match with
selected VLAN device "eth2.71".

In above scenario, the process does __ip_route_output_key() twice in
ip_route_connect(), the two processes have chosen different default gateway,
and the last choice is not the best.

Add flowi4->saddr and fib_nh_common->nhc_gw.ipv4 matching consideration in
fib_select_default() to fix that.

Fixes: 19baf839ff4a ("[IPV4]: Add LC-Trie FIB lookup algorithm.")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/ipv4/fib_semantics.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index e9a7f70a54df..8bd94875a009 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2046,6 +2046,7 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 	int order = -1, last_idx = -1;
 	struct fib_alias *fa, *fa1 = NULL;
 	u32 last_prio = res->fi->fib_priority;
+	u8 prefix, max_prefix = 0;
 	dscp_t last_dscp = 0;
 
 	hlist_for_each_entry_rcu(fa, fa_head, fa_list) {
@@ -2078,6 +2079,11 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 		if (!nhc->nhc_gw_family || nhc->nhc_scope != RT_SCOPE_LINK)
 			continue;
 
+		prefix = __ffs(flp->saddr ^ nhc->nhc_gw.ipv4);
+		if (prefix < max_prefix)
+			continue;
+		max_prefix = max_t(u8, prefix, max_prefix);
+
 		fib_alias_accessed(fa);
 
 		if (!fi) {
-- 
2.25.1

