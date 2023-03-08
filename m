Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057E96B1206
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCHTbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCHTbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:31:12 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D2CCF0C5;
        Wed,  8 Mar 2023 11:31:05 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pZzV8-0003rV-0Z; Wed, 08 Mar 2023 20:31:02 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Xin Long <lucien.xin@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH net-next 6/9] netfilter: use nf_ip6_check_hbh_len in nf_ct_skb_network_trim
Date:   Wed,  8 Mar 2023 20:30:30 +0100
Message-Id: <20230308193033.13965-7-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308193033.13965-1-fw@strlen.de>
References: <20230308193033.13965-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

For IPv6 Jumbo packets, the ipv6_hdr(skb)->payload_len is always 0,
and its real payload_len ( > 65535) is saved in hbh exthdr. With 0
length for the jumbo packets, all data and exthdr will be trimmed
in nf_ct_skb_network_trim().

This patch is to call nf_ip6_check_hbh_len() to get real pkt_len
of the IPv6 packet, similar to br_validate_ipv6().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ovs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index 52b776bdf526..068e9489e1c2 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -6,6 +6,7 @@
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/ipv6_frag.h>
 #include <net/ip.h>
+#include <linux/netfilter_ipv6.h>
 
 /* 'skb' should already be pulled to nh_ofs. */
 int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
@@ -120,8 +121,14 @@ int nf_ct_skb_network_trim(struct sk_buff *skb, int family)
 		len = skb_ip_totlen(skb);
 		break;
 	case NFPROTO_IPV6:
-		len = sizeof(struct ipv6hdr)
-			+ ntohs(ipv6_hdr(skb)->payload_len);
+		len = ntohs(ipv6_hdr(skb)->payload_len);
+		if (ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP) {
+			int err = nf_ip6_check_hbh_len(skb, &len);
+
+			if (err)
+				return err;
+		}
+		len += sizeof(struct ipv6hdr);
 		break;
 	default:
 		len = skb->len;
-- 
2.39.2

