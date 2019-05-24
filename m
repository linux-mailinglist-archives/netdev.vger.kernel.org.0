Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C7E297F7
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 14:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391465AbfEXMZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 08:25:08 -0400
Received: from mx0b-00191d01.pphosted.com ([67.231.157.136]:34796 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391347AbfEXMZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 08:25:08 -0400
X-Greylist: delayed 15501 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2019 08:25:07 EDT
Received: from pps.filterd (m0049462.ppops.net [127.0.0.1])
        by m0049462.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x4O8524X044296;
        Fri, 24 May 2019 04:06:19 -0400
Received: from alpi155.enaf.aldc.att.com (sbcsmtp7.sbc.com [144.160.229.24])
        by m0049462.ppops.net-00191d01. with ESMTP id 2sp9a1kxj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 May 2019 04:06:18 -0400
Received: from enaf.aldc.att.com (localhost [127.0.0.1])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id x4O86Hua015848;
        Fri, 24 May 2019 04:06:18 -0400
Received: from zlp27128.vci.att.com (zlp27128.vci.att.com [135.66.87.50])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id x4O86B9n015800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 24 May 2019 04:06:11 -0400
Received: from zlp27128.vci.att.com (zlp27128.vci.att.com [127.0.0.1])
        by zlp27128.vci.att.com (Service) with ESMTP id 267A5400B575;
        Fri, 24 May 2019 08:06:11 +0000 (GMT)
Received: from mlpi432.sfdc.sbc.com (unknown [144.151.223.11])
        by zlp27128.vci.att.com (Service) with ESMTP id 0C8D9400B574;
        Fri, 24 May 2019 08:06:11 +0000 (GMT)
Received: from sfdc.sbc.com (localhost [127.0.0.1])
        by mlpi432.sfdc.sbc.com (8.14.5/8.14.5) with ESMTP id x4O86A2e009907;
        Fri, 24 May 2019 04:06:10 -0400
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by mlpi432.sfdc.sbc.com (8.14.5/8.14.5) with ESMTP id x4O861hq009561;
        Fri, 24 May 2019 04:06:01 -0400
Received: from debian10.local (unknown [10.156.48.137])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id 1C95C360044;
        Fri, 24 May 2019 01:05:58 -0700 (PDT)
From:   George Wilkie <gwilkie@vyatta.att-mail.com>
To:     David Ahern <dsahern@gmail.com>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] vrf: local route leaking
Date:   Fri, 24 May 2019 09:05:51 +0100
Message-Id: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-24_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905240055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If have an interface in vrf A:

  10.10.2.0/24 dev ens9 proto kernel scope link src 10.10.2.2
  local 10.10.2.2 dev ens9 proto kernel scope host src 10.10.2.2

and want to leak it into vrf B, it is not sufficient to leak just
the interface route:

  ip route add 10.10.2.0/24 vrf B dev ens9

as traffic arriving into vrf B that is destined for 10.10.2.2 will
not arrive - it will be sent to the ens9 interface and nobody will
respond to the ARP.

In order to handle the traffic locally, the local route must also
be leaked to vrf B:

  ip route add local 10.10.2.2 vrf B dev ens9

However, that still doesn't work as the traffic is processed in
the context of the input vrf B and does not find a socket that is
bound to the destination vrf A.

Add a new vector to l3mdev_ops for receiving a local packet.
This checks if the local interface is enslaved to a different vrf
than the input interface, and if so, updates the skb so that it
will be handled by a socket in the vrf associated with the local
interface.
For ipv4, the local interface is obtained from the fib result in
the RTN_LOCAL route lookup path.
For ipv6, the local interface is obtained from the skb_dst in
ip6_input.

Signed-off-by: George Wilkie <gwilkie@vyatta.att-mail.com>
---
 drivers/net/vrf.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/net/l3mdev.h | 41 +++++++++++++++++++++++++++++++++++++++++
 net/ipv4/route.c     |  2 ++
 net/ipv6/ip6_input.c |  1 +
 4 files changed, 87 insertions(+)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index cf7e6a92e73c..719e10f7761b 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1106,6 +1106,48 @@ static struct dst_entry *vrf_link_scope_lookup(const struct net_device *dev,
 }
 #endif
 
+static void vrf_ip6_local_rcv(struct net_device *vrf_dev, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (vrf_dev) {
+		skb->dev = vrf_dev;
+		skb->skb_iif = vrf_dev->ifindex;
+		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
+		vrf_rx_stats(vrf_dev, skb->len);
+	} else {
+		/* Moving from VRF to global */
+		IP6CB(skb)->flags &= ~IP6SKB_L3SLAVE;
+	}
+#endif
+}
+
+static void vrf_ip_local_rcv(struct net_device *vrf_dev, struct sk_buff *skb)
+{
+	if (vrf_dev) {
+		skb->dev = vrf_dev;
+		skb->skb_iif = vrf_dev->ifindex;
+		IPCB(skb)->flags |= IPSKB_L3SLAVE;
+		vrf_rx_stats(vrf_dev, skb->len);
+	} else {
+		/* Moving from VRF to global */
+		IPCB(skb)->flags &= ~IPSKB_L3SLAVE;
+	}
+}
+
+/* called with rcu lock held */
+static void vrf_local_rcv(struct net_device *vrf_dev, struct sk_buff *skb,
+			  u16 proto)
+{
+	switch (proto) {
+	case AF_INET:
+		vrf_ip_local_rcv(vrf_dev, skb);
+		break;
+	case AF_INET6:
+		vrf_ip6_local_rcv(vrf_dev, skb);
+		break;
+	}
+}
+
 static const struct l3mdev_ops vrf_l3mdev_ops = {
 	.l3mdev_fib_table	= vrf_fib_table,
 	.l3mdev_l3_rcv		= vrf_l3_rcv,
@@ -1113,6 +1155,7 @@ static const struct l3mdev_ops vrf_l3mdev_ops = {
 #if IS_ENABLED(CONFIG_IPV6)
 	.l3mdev_link_scope_lookup = vrf_link_scope_lookup,
 #endif
+	.l3mdev_local_rcv	= vrf_local_rcv,
 };
 
 static void vrf_get_drvinfo(struct net_device *dev,
diff --git a/include/net/l3mdev.h b/include/net/l3mdev.h
index 5175fd63cd82..d1008437a769 100644
--- a/include/net/l3mdev.h
+++ b/include/net/l3mdev.h
@@ -24,6 +24,8 @@
  * @l3mdev_l3_out:    Hook in L3 output path
  *
  * @l3mdev_link_scope_lookup: IPv6 lookup for linklocal and mcast destinations
+ *
+ * @l3mdev_local_rcv: Hook in local receive path
  */
 
 struct l3mdev_ops {
@@ -37,6 +39,8 @@ struct l3mdev_ops {
 	/* IPv6 ops */
 	struct dst_entry * (*l3mdev_link_scope_lookup)(const struct net_device *dev,
 						 struct flowi6 *fl6);
+	void (*l3mdev_local_rcv)(struct net_device *dev, struct sk_buff *skb,
+				 u16 proto);
 };
 
 #ifdef CONFIG_NET_L3_MASTER_DEV
@@ -203,6 +207,35 @@ struct sk_buff *l3mdev_ip6_out(struct sock *sk, struct sk_buff *skb)
 {
 	return l3mdev_l3_out(sk, skb, AF_INET6);
 }
+
+static inline
+void l3mdev_local_rcv(struct net_device *dev, struct sk_buff *skb, u16 proto)
+{
+	struct net_device *l3mdev1 = l3mdev_master_dev_rcu(skb->dev);
+	struct net_device *l3mdev2 = l3mdev_master_dev_rcu(dev);
+
+	/* local device enslaved to a different L3 master from input device */
+	if (l3mdev1 != l3mdev2) {
+		if (l3mdev1 && l3mdev1->l3mdev_ops->l3mdev_local_rcv)
+			l3mdev1->l3mdev_ops->l3mdev_local_rcv(l3mdev2, skb,
+							      proto);
+		else if (l3mdev2 && l3mdev2->l3mdev_ops->l3mdev_local_rcv)
+			l3mdev2->l3mdev_ops->l3mdev_local_rcv(l3mdev2, skb,
+							      proto);
+	}
+}
+
+static inline
+void l3mdev_ip_local_rcv(struct net_device *dev, struct sk_buff *skb)
+{
+	return l3mdev_local_rcv(dev, skb, AF_INET);
+}
+
+static inline
+void l3mdev_ip6_local_rcv(struct net_device *dev, struct sk_buff *skb)
+{
+	return l3mdev_local_rcv(dev, skb, AF_INET6);
+}
 #else
 
 static inline int l3mdev_master_ifindex_rcu(const struct net_device *dev)
@@ -294,6 +327,14 @@ static inline
 void l3mdev_update_flow(struct net *net, struct flowi *fl)
 {
 }
+static inline
+void l3mdev_ip_local_rcv(struct net_device *fib_dev, struct sk_buff *skb)
+{
+}
+static inline
+void l3mdev_ip6_local_rcv(struct net_device *fib_dev, struct sk_buff *skb)
+{
+}
 #endif
 
 #endif /* _NET_L3MDEV_H_ */
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 11ddc276776e..c91b8ab06b86 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2070,6 +2070,8 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 					  0, dev, in_dev, &itag);
 		if (err < 0)
 			goto martian_source;
+
+		l3mdev_ip_local_rcv(res->fi->fib_dev, skb);
 		goto local_input;
 	}
 
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index b50b1af1f530..4def37f73363 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -448,6 +448,7 @@ static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *sk
 
 int ip6_input(struct sk_buff *skb)
 {
+	l3mdev_ip6_local_rcv(skb_dst(skb)->dev, skb);
 	return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN,
 		       dev_net(skb->dev), NULL, skb, skb->dev, NULL,
 		       ip6_input_finish);
-- 
2.20.1

