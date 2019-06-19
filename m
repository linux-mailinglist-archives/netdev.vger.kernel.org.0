Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B063F4BBBE
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfFSOfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:35:12 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:21298 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfFSOfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 10:35:12 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id CF80C5C1319;
        Wed, 19 Jun 2019 22:35:07 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf-next] netfilter: bridge: Fix non-untagged fragment packet
Date:   Wed, 19 Jun 2019 22:35:07 +0800
Message-Id: <1560954907-20071-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPSkpCQkJCT0tDTElKQllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ODY6MSo*CDgwIhcOEhoYCigX
        TzkaCQlVSlVKTk1LQk5PQktMQklCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJTEk3Bg++
X-HM-Tid: 0a6b7029acd92087kuqycf80c5c1319
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

A two fragment packets send from ns2 contained with vlan tag 200.
In the bridge conntrack, packet will defrag to one skb with fraglist.
When the packet forward to ns1 through veth1, the first skb vlan tag
will be cleared for "untagged" flags. But the vlan tag in the second
skb still tagged, which lead the second fragment send with tag 200 to
ns1.
So if the first fragment packet don't contain vlan tag, all of the
remain should not contain vlan tag..

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index b675cd7..4f5444d 100644
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
1.8.3.1

