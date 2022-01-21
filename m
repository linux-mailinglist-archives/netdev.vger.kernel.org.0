Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBFF495AB1
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 08:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378995AbiAUHau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 02:30:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5132 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378983AbiAUHat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 02:30:49 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L05BtS019552
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 23:30:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dCqdu9s+X+WtVUJZK56g6V/cYpOVw7ifi2FIjwnEeXY=;
 b=G//Uj+PDLPxy3EyZnXBwoZeLRHQTvgyEQq1ZAVeBv42mH59987DZmFmoDEp15Xre0ZUG
 83Oobbg24Wg022ohQJRYzCoyOMKZcHQbeA05KEqa5xZQfdZgrWaVck5v0RGliM0gHrSB
 sM8Y/nshQR8VWx6n5FrGdak3qbKLPg/aBOA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqhyvsn56-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 23:30:48 -0800
Received: from twshared3205.02.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 20 Jan 2022 23:30:45 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id C53495BDEC3B; Thu, 20 Jan 2022 23:30:38 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH v3 net-next 2/4] net: Add skb_clear_tstamp() to keep the mono delivery_time
Date:   Thu, 20 Jan 2022 23:30:38 -0800
Message-ID: <20220121073038.4178331-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121073026.4173996-1-kafai@fb.com>
References: <20220121073026.4173996-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2uv_OzutxHpTLYrVdbOhAawyxDo-x5nH
X-Proofpoint-GUID: 2uv_OzutxHpTLYrVdbOhAawyxDo-x5nH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201210047
X-FB-Internal: deliver
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
skb will be delivered locally.  The postponed delivery_time clearing
will be done together in a later patch when the skb->mono_delivery_time
bit will finally be turned on.

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
index b9e20187242a..8de555513b94 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3916,6 +3916,14 @@ static inline void skb_set_delivery_time(struct sk=
_buff *skb, ktime_t kt,
 	/* skb->mono_delivery_time =3D kt && mono; */
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
@@ -4772,7 +4780,7 @@ static inline void skb_set_redirected(struct sk_buf=
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
index 4603b7cd3cd1..4fc53d645a01 100644
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
index 4b873413edc2..0875ab61eb95 100644
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

