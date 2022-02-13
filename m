Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B5A4B3BF7
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 16:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbiBMPKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 10:10:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbiBMPKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 10:10:43 -0500
X-Greylist: delayed 474 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Feb 2022 07:10:35 PST
Received: from mail-m2458.qiye.163.com (mail-m2458.qiye.163.com [220.194.24.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8155BD0D;
        Sun, 13 Feb 2022 07:10:35 -0800 (PST)
Received: from localhost.localdomain (unknown [124.126.138.100])
        by mail-m2458.qiye.163.com (Hmail) with ESMTPA id C67C67400FC;
        Sun, 13 Feb 2022 23:02:37 +0800 (CST)
From:   Tao Liu <thomas.liu@ucloud.cn>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, edumazet@google.com, sridhar.samudrala@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Liu <thomas.liu@ucloud.cn>
Subject: [PATCH] gso: do not skip outer ip header in case of ipip and net_failover
Date:   Sun, 13 Feb 2022 23:02:34 +0800
Message-Id: <20220213150234.31602-1-thomas.liu@ucloud.cn>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRlNSktWGU0dH0gYHU5MTk
        8YVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6P1E6FAw5KjIxTgsDGgM3NAxO
        FB5PCwhVSlVKTU9PTE1PTk5DS09IVTMWGhIXVQ8TFBYaCFUXEg47DhgXFA4fVRgVRVlXWRILWUFZ
        SklPVUpJTVVKSENVSktLWVdZCAFZQUhNTkk3Bg++
X-HM-Tid: 0a7ef39b722f8c17kuqtc67c67400fc
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We encouter a tcp drop issue in our cloud environment. Packet GROed in host
forwards to a VM virtio_net nic with net_failover enabled. VM acts as a
IPVS LB with ipip encapsulation. The full path like:
host gro -> vm virtio_net rx -> net_failover rx -> ipvs fullnat
 -> ipip encap -> net_failover tx -> virtio_net tx

When net_failover transmits a ipip pkt (gso_type = 0x0103), there is no gso
performed because it supports TSO and GSO_IPXIP4. But network_header has
been pointing to inner ip header.

Call Trace:
 tcp4_gso_segment        ------> return NULL
 inet_gso_segment        ------> inner iph, network_header points to
 ipip_gso_segment
 inet_gso_segment        ------> outer iph
 skb_mac_gso_segment

Afterwards virtio_net transmits the pkt, only inner ip header is modified.
And the outer one just keeps untouched. The pkt will be dropped in remote
host. So we need to reset network header if there is no gso performed in
net_failover.

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

Fixes: cb32f511a70b ("ipip: add GSO/TSO support")
Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
---
 net/ipv4/af_inet.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 9c465ba..f8b3f8a 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1425,10 +1425,18 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 static struct sk_buff *ipip_gso_segment(struct sk_buff *skb,
 					netdev_features_t features)
 {
+	struct sk_buff *segs;
+	int nhoff;
+
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_IPXIP4))
 		return ERR_PTR(-EINVAL);
 
-	return inet_gso_segment(skb, features);
+	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	segs = inet_gso_segment(skb, features);
+	if (!segs)
+		skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
+
+	return segs;
 }
 
 struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
-- 
1.8.3.1

