Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3A460F4E1
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiJ0KZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbiJ0KZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:25:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D332D742;
        Thu, 27 Oct 2022 03:24:55 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MyhWM2Vkcz15M45;
        Thu, 27 Oct 2022 18:19:59 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 18:24:53 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <herbert@gondor.apana.org.au>
Subject: [PATCH net] ipv6/gro: fix an out of bounds memory bug in ipv6_gro_receive()
Date:   Thu, 27 Oct 2022 18:24:49 +0800
Message-ID: <20221027102449.926410-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 packets without NEXTHDR_NONE extension header can make continuous
__skb_pull() until pskb_may_pull() failed in ipv6_gso_pull_exthdrs().
That results in a big value of skb_gro_offset(), and after __skb_push()
in ipv6_gro_receive(), skb->data will less than skb->head, an out of
bounds memory bug occurs. That will trigger the problem as following:

==================================================================
BUG: KASAN: use-after-free in eth_type_trans+0x100/0x260
...
Call trace:
 dump_backtrace+0xd8/0x130
 show_stack+0x1c/0x50
 dump_stack_lvl+0x64/0x7c
 print_address_description.constprop.0+0xbc/0x2e8
 print_report+0x100/0x1e4
 kasan_report+0x80/0x120
 __asan_load8+0x78/0xa0
 eth_type_trans+0x100/0x260
 napi_gro_frags+0x164/0x550
 tun_get_user+0xda4/0x1270
 tun_chr_write_iter+0x74/0x130
 do_iter_readv_writev+0x130/0x1ec
 do_iter_write+0xbc/0x1e0
 vfs_writev+0x13c/0x26c

Add comparison between skb->data - skb_gro_offset() and skb->head
and exception handler before __skb_push() to fix the bug.

Fixes: 86911732d399 ("gro: Avoid copying headers of unmerged packets")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/ipv6/ip6_offload.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 3ee345672849..6659ccf25387 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -237,6 +237,10 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 		proto = ipv6_gso_pull_exthdrs(skb, proto);
 		skb_gro_pull(skb, -skb_transport_offset(skb));
 		skb_reset_transport_header(skb);
+		if (unlikely(skb_headroom(skb) < skb_gro_offset(skb))) {
+			kfree_skb(skb);
+			return ERR_PTR(-EINPROGRESS);
+		}
 		__skb_push(skb, skb_gro_offset(skb));
 
 		ops = rcu_dereference(inet6_offloads[proto]);
-- 
2.25.1

