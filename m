Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DBC57C07F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiGTXIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiGTXIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:00 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E78231B78E;
        Wed, 20 Jul 2022 16:07:59 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 01/18] netfilter: conntrack: use fallthrough to cleanup
Date:   Thu, 21 Jul 2022 01:07:37 +0200
Message-Id: <20220720230754.209053-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720230754.209053-1-pablo@netfilter.org>
References: <20220720230754.209053-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

These cases all use the same function. we can simplify the code through
fallthrough.

$ size net/netfilter/nf_conntrack_core.o

        text	   data	    bss	    dec	    hex	filename
before  81601	  81430	    768	 163799	  27fd7	net/netfilter/nf_conntrack_core.o
after   80361	  81430	    768	 162559	  27aff	net/netfilter/nf_conntrack_core.o

Arch: aarch64
Gcc : gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 082a2fd8d85b..363c3e8f9d1b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -329,20 +329,18 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 		return gre_pkt_to_tuple(skb, dataoff, net, tuple);
 #endif
 	case IPPROTO_TCP:
-	case IPPROTO_UDP: /* fallthrough */
-		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
+	case IPPROTO_UDP:
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
 	case IPPROTO_UDPLITE:
-		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
 #endif
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 	case IPPROTO_SCTP:
-		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	case IPPROTO_DCCP:
-		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
 #endif
+		/* fallthrough */
+		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
 	default:
 		break;
 	}
-- 
2.30.2

