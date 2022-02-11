Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A420D4B1F0D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347616AbiBKHM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:12:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347594AbiBKHM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:12:56 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E88910A4
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:12:56 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ANrS2k025979
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:12:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=HwB36yUzMIbq/eK7sxBobUtZt2V8qtQlQAh/HWHriW8=;
 b=Z2IcAksZXAxAqkCvW+8yqwSPE3RBib9tuhx/QGBwLi8Ohkso17Z/ZbxAK41OpkhhY1//
 H/Itzo9RjsDO6vNy3/+MbXRuie0IDF/xPtqciSoutxDb0JL+Yv6mO+EfEcobP60iK1sW
 xHGmgONhSUwzTiT22EoREDoO94ni1jZ7VXU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e59rpu6sk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:12:55 -0800
Received: from twshared22811.39.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 23:12:53 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id DA06E6C7572C; Thu, 10 Feb 2022 23:12:44 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4 net-next 2/8] net: Add skb_clear_tstamp() to keep the mono delivery_time
Date:   Thu, 10 Feb 2022 23:12:44 -0800
Message-ID: <20220211071244.886294-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220211071232.885225-1-kafai@fb.com>
References: <20220211071232.885225-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jUp8dwXeM9ctf2jvOGyqMP1dWd58kPLy
X-Proofpoint-GUID: jUp8dwXeM9ctf2jvOGyqMP1dWd58kPLy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 suspectscore=0 mlxscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202110040
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, skb->tstamp is reset to 0 whenever the skb is forwarded.

If skb->tstamp has the mono delivery_time, clearing it can hurt
the performance when it finally transmits out to fq@phy-dev.

The earlier patch added a skb->mono_delivery_time bit to
flag the skb->tstamp carrying the mono delivery_time.

This patch adds skb_clear_tstamp() helper which keeps
the mono delivery_time and clear everything else.

The delivery_time clearing is postponed until the stack knows the
skb will be delivered locally.  It will be done in a later patch.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 drivers/net/loopback.c           |  2 +-
 include/linux/skbuff.h           | 10 +++++++++-
 net/bridge/br_forward.c          |  2 +-
 net/core/filter.c                |  6 +++---
 net/core/skbuff.c                |  2 +-
 net/ipv4/ip_forward.c            |  2 +-
 net/ipv6/ip6_output.c            |  2 +-
 net/netfilter/ipvs/ip_vs_xmit.c  |  6 +++---
 net/netfilter/nf_dup_netdev.c    |  2 +-
 net/netfilter/nf_flow_table_ip.c |  4 ++--
 net/netfilter/nft_fwd_netdev.c   |  2 +-
 net/openvswitch/vport.c          |  2 +-
 net/xfrm/xfrm_interface.c        |  2 +-
 13 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index ed0edf5884ef..70a38fa09299 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -74,7 +74,7 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 	skb_tx_timestamp(skb);
=20
 	/* do not fool net_timestamp_check() with various clock bases */
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
=20
 	skb_orphan(skb);
=20
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 32c793de3801..07e618f8b41a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3938,6 +3938,14 @@ static inline void skb_set_delivery_time(struct sk=
_buff *skb, ktime_t kt,
 	skb->mono_delivery_time =3D 0;
 }
=20
+static inline void skb_clear_tstamp(struct sk_buff *skb)
+{
+	if (skb->mono_delivery_time)
+		return;
+
+	skb->tstamp =3D 0;
+}
+
 static inline u8 skb_metadata_len(const struct sk_buff *skb)
 {
 	return skb_shinfo(skb)->meta_len;
@@ -4794,7 +4802,7 @@ static inline void skb_set_redirected(struct sk_buf=
f *skb, bool from_ingress)
 #ifdef CONFIG_NET_REDIRECT
 	skb->from_ingress =3D from_ingress;
 	if (skb->from_ingress)
-		skb->tstamp =3D 0;
+		skb_clear_tstamp(skb);
 #endif
 }
=20
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index ec646656dbf1..02bb620d3b8d 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -62,7 +62,7 @@ EXPORT_SYMBOL_GPL(br_dev_queue_push_xmit);
=20
 int br_forward_finish(struct net *net, struct sock *sk, struct sk_buff *=
skb)
 {
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
 	return NF_HOOK(NFPROTO_BRIDGE, NF_BR_POST_ROUTING,
 		       net, sk, skb, NULL, skb->dev,
 		       br_dev_queue_push_xmit);
diff --git a/net/core/filter.c b/net/core/filter.c
index f497ca7a16d2..a2d712be4985 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2107,7 +2107,7 @@ static inline int __bpf_tx_skb(struct net_device *d=
ev, struct sk_buff *skb)
 	}
=20
 	skb->dev =3D dev;
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
=20
 	dev_xmit_recursion_inc();
 	ret =3D dev_queue_xmit(skb);
@@ -2176,7 +2176,7 @@ static int bpf_out_neigh_v6(struct net *net, struct=
 sk_buff *skb,
 	}
=20
 	skb->dev =3D dev;
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
=20
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
 		skb =3D skb_expand_head(skb, hh_len);
@@ -2274,7 +2274,7 @@ static int bpf_out_neigh_v4(struct net *net, struct=
 sk_buff *skb,
 	}
=20
 	skb->dev =3D dev;
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
=20
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
 		skb =3D skb_expand_head(skb, hh_len);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0118f0afaa4f..3e3da8fdf8f5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5350,7 +5350,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xne=
t)
=20
 	ipvs_reset(skb);
 	skb->mark =3D 0;
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
 }
 EXPORT_SYMBOL_GPL(skb_scrub_packet);
=20
diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 00ec819f949b..92ba3350274b 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -79,7 +79,7 @@ static int ip_forward_finish(struct net *net, struct so=
ck *sk, struct sk_buff *s
 	if (unlikely(opt->optlen))
 		ip_forward_options(skb);
=20
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
 	return dst_output(net, sk, skb);
 }
=20
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 55665f3f7a77..9fc1b08cf622 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -440,7 +440,7 @@ static inline int ip6_forward_finish(struct net *net,=
 struct sock *sk,
 	}
 #endif
=20
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
 	return dst_output(net, sk, skb);
 }
=20
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_x=
mit.c
index d2e5a8f644b8..029171379884 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -610,7 +610,7 @@ static inline int ip_vs_tunnel_xmit_prepare(struct sk=
_buff *skb,
 		nf_reset_ct(skb);
 		skb_forward_csum(skb);
 		if (skb->dev)
-			skb->tstamp =3D 0;
+			skb_clear_tstamp(skb);
 	}
 	return ret;
 }
@@ -652,7 +652,7 @@ static inline int ip_vs_nat_send_or_cont(int pf, stru=
ct sk_buff *skb,
 	if (!local) {
 		skb_forward_csum(skb);
 		if (skb->dev)
-			skb->tstamp =3D 0;
+			skb_clear_tstamp(skb);
 		NF_HOOK(pf, NF_INET_LOCAL_OUT, cp->ipvs->net, NULL, skb,
 			NULL, skb_dst(skb)->dev, dst_output);
 	} else
@@ -674,7 +674,7 @@ static inline int ip_vs_send_or_cont(int pf, struct s=
k_buff *skb,
 		ip_vs_drop_early_demux_sk(skb);
 		skb_forward_csum(skb);
 		if (skb->dev)
-			skb->tstamp =3D 0;
+			skb_clear_tstamp(skb);
 		NF_HOOK(pf, NF_INET_LOCAL_OUT, cp->ipvs->net, NULL, skb,
 			NULL, skb_dst(skb)->dev, dst_output);
 	} else
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.=
c
index a579e59ee5c5..7873bd1389c3 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -19,7 +19,7 @@ static void nf_do_netdev_egress(struct sk_buff *skb, st=
ruct net_device *dev)
 		skb_push(skb, skb->mac_len);
=20
 	skb->dev =3D dev;
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
 	dev_queue_xmit(skb);
 }
=20
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
index 889cf88d3dba..f1d387129f02 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -376,7 +376,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *s=
kb,
 	nf_flow_nat_ip(flow, skb, thoff, dir, iph);
=20
 	ip_decrease_ttl(iph);
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
=20
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
@@ -611,7 +611,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff =
*skb,
 	nf_flow_nat_ipv6(flow, skb, dir, ip6h);
=20
 	ip6h->hop_limit--;
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
=20
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netde=
v.c
index fa9301ca6033..4b2b0946c0b6 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -140,7 +140,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr =
*expr,
 		return;
=20
 	skb->dev =3D dev;
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
 	neigh_xmit(neigh_table, dev, addr, skb);
 out:
 	regs->verdict.code =3D verdict;
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index cf2ce5812489..82a74f998966 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -507,7 +507,7 @@ void ovs_vport_send(struct vport *vport, struct sk_bu=
ff *skb, u8 mac_proto)
 	}
=20
 	skb->dev =3D vport->dev;
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
 	vport->ops->send(skb);
 	return;
=20
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 57448fc519fc..4991e99ced9a 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -190,7 +190,7 @@ static void xfrmi_dev_uninit(struct net_device *dev)
=20
 static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
 {
-	skb->tstamp =3D 0;
+	skb_clear_tstamp(skb);
 	skb->pkt_type =3D PACKET_HOST;
 	skb->skb_iif =3D 0;
 	skb->ignore_df =3D 0;
--=20
2.30.2

