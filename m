Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1846DC272
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 03:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjDJBqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 21:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjDJBqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 21:46:50 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7096D3C16
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 18:46:22 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PvsHM1KP6zKrkK;
        Mon, 10 Apr 2023 09:45:19 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 09:45:29 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: [PATCH net v2] ipv4: Fix potential uninit variable access buf in __ip_make_skb()
Date:   Mon, 10 Apr 2023 09:45:26 +0800
Message-ID: <20230410014526.4035442-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like commit ea30388baebc ("ipv6: Fix an uninit variable access bug in
__ip6_make_skb()"). icmphdr does not in skb linear region under the
scenario of SOCK_RAW socket. Access icmp_hdr(skb)->type directly will
trigger the uninit variable access bug.

Use a local variable icmp_type to carry the correct value in different
scenarios.

Fixes: 96793b482540 ("[IPV4]: Add ICMPMsgStats MIB (RFC 4293)")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
v2:
  - Use sk->sk_type not sk->sk_socket->type.
---
 net/ipv4/ip_output.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 4e4e308c3230..21507c9ce0fc 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1570,9 +1570,15 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	cork->dst = NULL;
 	skb_dst_set(skb, &rt->dst);
 
-	if (iph->protocol == IPPROTO_ICMP)
-		icmp_out_count(net, ((struct icmphdr *)
-			skb_transport_header(skb))->type);
+	if (iph->protocol == IPPROTO_ICMP) {
+		u8 icmp_type;
+
+		if (sk->sk_type == SOCK_RAW && !inet_sk(sk)->hdrincl)
+			icmp_type = fl4->fl4_icmp_type;
+		else
+			icmp_type = icmp_hdr(skb)->type;
+		icmp_out_count(net, icmp_type);
+	}
 
 	ip_cork_release(cork);
 out:
-- 
2.25.1

