Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06DA4BBABF
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 15:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbiBROg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 09:36:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiBROg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 09:36:26 -0500
Received: from mail-m2838.qiye.163.com (mail-m2838.qiye.163.com [103.74.28.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F63E281989;
        Fri, 18 Feb 2022 06:35:50 -0800 (PST)
Received: from localhost.localdomain (unknown [124.126.138.100])
        by mail-m2838.qiye.163.com (Hmail) with ESMTPA id 3CD763C00E8;
        Fri, 18 Feb 2022 22:35:34 +0800 (CST)
From:   Tao Liu <thomas.liu@ucloud.cn>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Liu <thomas.liu@ucloud.cn>
Subject: [PATCH net v3] gso: do not skip outer ip header in case of ipip and net_failover
Date:   Fri, 18 Feb 2022 22:35:24 +0800
Message-Id: <20220218143524.61642-1-thomas.liu@ucloud.cn>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUJNTx5WQx4aH05MShhJHk
        IYVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRQ6HDo5TDI4EQ1WODo0NRoz
        DB8aCjNVSlVKTU9OSkJPQkhPT05IVTMWGhIXVQ8TFBYaCFUXEg47DhgXFA4fVRgVRVlXWRILWUFZ
        SklPVUpJTVVKSENVSktLWVdZCAFZQU9KTUk3Bg++
X-HM-Tid: 0a7f0d4278268420kuqw3cd763c00e8
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We encounter a tcp drop issue in our cloud environment. Packet GROed in
host forwards to a VM virtio_net nic with net_failover enabled. VM acts
as a IPVS LB with ipip encapsulation. The full path like:
host gro -> vm virtio_net rx -> net_failover rx -> ipvs fullnat
 -> ipip encap -> net_failover tx -> virtio_net tx

When net_failover transmits a ipip pkt (gso_type = 0x0103, which means
SKB_GSO_TCPV4, SKB_GSO_DODGY and SKB_GSO_IPXIP4), there is no gso
did because it supports TSO and GSO_IPXIP4. But network_header points to
inner ip header.

Call Trace:
 tcp4_gso_segment        ------> return NULL
 inet_gso_segment        ------> inner iph, network_header points to
 ipip_gso_segment
 inet_gso_segment        ------> outer iph
 skb_mac_gso_segment

Afterwards virtio_net transmits the pkt, only inner ip header is modified.
And the outer one just keeps unchanged. The pkt will be dropped in remote
host.

Call Trace:
 inet_gso_segment        ------> inner iph, outer iph is skipped
 skb_mac_gso_segment
 __skb_gso_segment
 validate_xmit_skb
 validate_xmit_skb_list
 sch_direct_xmit
 __qdisc_run
 __dev_queue_xmit        ------> virtio_net
 dev_hard_start_xmit
 __dev_queue_xmit        ------> net_failover
 ip_finish_output2
 ip_output
 iptunnel_xmit
 ip_tunnel_xmit
 ipip_tunnel_xmit        ------> ipip
 dev_hard_start_xmit
 __dev_queue_xmit
 ip_finish_output2
 ip_output
 ip_forward
 ip_rcv
 __netif_receive_skb_one_core
 netif_receive_skb_internal
 napi_gro_receive
 receive_buf
 virtnet_poll
 net_rx_action

The root cause of this issue is specific with the rare combination of
SKB_GSO_DODGY and a tunnel device that adds an SKB_GSO_ tunnel option.
SKB_GSO_DODGY is set from external virtio_net. We need to reset network
header when callbacks.gso_segment() returns NULL.

This patch also includes ipv6_gso_segment(), considering SIT, etc.

Fixes: cb32f511a70b ("ipip: add GSO/TSO support")
Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
---
 net/ipv4/af_inet.c     | 5 ++++-
 net/ipv6/ip6_offload.c | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 9c465ba..72fde28 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1376,8 +1376,11 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 	}
 
 	ops = rcu_dereference(inet_offloads[proto]);
-	if (likely(ops && ops->callbacks.gso_segment))
+	if (likely(ops && ops->callbacks.gso_segment)) {
 		segs = ops->callbacks.gso_segment(skb, features);
+		if (!segs)
+			skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
+	}
 
 	if (IS_ERR_OR_NULL(segs))
 		goto out;
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index b29e9ba..5f577e2 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -114,6 +114,8 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 	if (likely(ops && ops->callbacks.gso_segment)) {
 		skb_reset_transport_header(skb);
 		segs = ops->callbacks.gso_segment(skb, features);
+		if (!segs)
+			skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
 	}
 
 	if (IS_ERR_OR_NULL(segs))
-- 
1.8.3.1

