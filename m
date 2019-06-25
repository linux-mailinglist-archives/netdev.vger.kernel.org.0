Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9B851FA0
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbfFYAN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:13:59 -0400
Received: from mail.us.es ([193.147.175.20]:38082 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729411AbfFYAM5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7BCFCC04B7
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F8DBDA703
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5531DDA702; Tue, 25 Jun 2019 02:12:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 553FCDA703;
        Tue, 25 Jun 2019 02:12:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2C2B44265A2F;
        Tue, 25 Jun 2019 02:12:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 24/26] netfilter: bridge: Fix non-untagged fragment packet
Date:   Tue, 25 Jun 2019 02:12:31 +0200
Message-Id: <20190625001233.22057-25-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

ip netns exec ns1 ip a a dev eth0 10.0.0.7/24
ip netns exec ns2 ip link a link eth0 name vlan type vlan id 200
ip netns exec ns2 ip a a dev vlan 10.0.0.8/24

ip l add dev br0 type bridge vlan_filtering 1
brctl addif br0 veth1
brctl addif br0 veth2

bridge vlan add dev veth1 vid 200 pvid untagged
bridge vlan add dev veth2 vid 200

A two fragment packet sent from ns2 contains the vlan tag 200.  In the
bridge conntrack, this packet will defrag to one skb with fraglist.
When the packet is forwarded to ns1 through veth1, the first skb vlan
tag will be cleared by the "untagged" flags. But the vlan tag in the
second skb is still tagged, so the second fragment ends up with tag 200
to ns1. So if the first fragment packet doesn't contain the vlan tag,
all of the remain should not contain vlan tag.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index b675cd7c1a82..4f5444d2a526 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -331,6 +331,8 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 	}
 	if (data->vlan_present)
 		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci);
+	else if (skb_vlan_tag_present(skb))
+		__vlan_hwaccel_clear_tag(skb);
 
 	skb_copy_to_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
 	skb_reset_mac_header(skb);
-- 
2.11.0

