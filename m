Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE904B1F13
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347600AbiBKHNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:13:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347598AbiBKHNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:13:09 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808F11111
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:06 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ANrI5h013553
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NkytTpRrUG56ut/EYoku5/SNA6tMzAT7dNYLvc4tjn0=;
 b=cPcXD175TTVNoUBzfADiQ2vHrsqNZMuVYDE4p5KM4JHQh176hNnLm9MQZy9t3VtDqhU2
 0KBxdbRYpySazcM3J7qydycJQznyK/uV2cU3X/4qjJbRes6GsolVTZK3oV+PrejO8cUD
 0wltAGiLIhJLKwFD2LrwBfROGDwlMwimIvo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e58e1kxj6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:05 -0800
Received: from twshared12416.02.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 23:13:04 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 7575D6C75963; Thu, 10 Feb 2022 23:12:57 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4 net-next 4/8] net: Postpone skb_clear_delivery_time() until knowing the skb is delivered locally
Date:   Thu, 10 Feb 2022 23:12:57 -0800
Message-ID: <20220211071257.888905-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220211071232.885225-1-kafai@fb.com>
References: <20220211071232.885225-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: -jRb_ll-KXHlM7IFSwR-Si_ynJjtXLLH
X-Proofpoint-ORIG-GUID: -jRb_ll-KXHlM7IFSwR-Si_ynJjtXLLH
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202110039
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

This patch postpones the delivery_time clearing until the stack knows
the skb is being delivered locally.  That will allow other kernel
forwarding path (e.g. ip[6]_forward) to keep the delivery_time also.

An earlier attempt was to do skb_clear_delivery_time() in
ip_local_deliver() and ip6_input().  The discussion [0] requested to
move it one step later into ip_local_deliver_finish()
and ip6_input_finish() so that the delivery_time can be kept
for the ip_vs forwarding path also.  To do that, this patch also
needs to take care of the (rcv) timestamp usecase in ip_is_fragment().
It needs to expect delivery_time in the skb->tstamp, so it needs to
save the mono_delivery_time bit in inet_frag_queue such that the
delivery_time (if any) can be restored in the final defragmented skb.

The ipv6 defrag is done in ip6_protocol_deliver_rcu() when figuring
out how to handle nexthdr and IPPROTO_FRAGMENT (44) is one of the
ipv6 extension header.  ip6_protocol_deliver_rcu() is after
ip6_input_finish() where the skb_clear_delivery_time() has
already been done, so change is not needed.

[0]: https://lore.kernel.org/netdev/ca728d81-80e8-3767-d5e-d44f6ad96e43@ssi=
.bg/

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/inet_frag.h  | 1 +
 net/core/dev.c           | 1 -
 net/ipv4/inet_fragment.c | 1 +
 net/ipv4/ip_fragment.c   | 1 +
 net/ipv4/ip_input.c      | 1 +
 net/ipv6/ip6_input.c     | 1 +
 6 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 63540be0fc34..c0e517f31d82 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -90,6 +90,7 @@ struct inet_frag_queue {
 	ktime_t			stamp;
 	int			len;
 	int			meat;
+	bool			mono_delivery_time;
 	__u8			flags;
 	u16			max_size;
 	struct fqdir		*fqdir;
diff --git a/net/core/dev.c b/net/core/dev.c
index f41707ab2fb9..041cef7473fd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5222,7 +5222,6 @@ static int __netif_receive_skb_core(struct sk_buff **=
pskb, bool pfmemalloc,
 			goto out;
 	}
 #endif
-	skb_clear_delivery_time(skb);
 	skb_reset_redirect(skb);
 skip_classify:
 	if (pfmemalloc && !skb_pfmemalloc_protocol(skb))
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 341096807100..63948f6aeca0 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -572,6 +572,7 @@ void inet_frag_reasm_finish(struct inet_frag_queue *q, =
struct sk_buff *head,
 	skb_mark_not_on_list(head);
 	head->prev =3D NULL;
 	head->tstamp =3D q->stamp;
+	head->mono_delivery_time =3D q->mono_delivery_time;
 }
 EXPORT_SYMBOL(inet_frag_reasm_finish);
=20
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index fad803d2d711..fb153569889e 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -349,6 +349,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff=
 *skb)
 		qp->iif =3D dev->ifindex;
=20
 	qp->q.stamp =3D skb->tstamp;
+	qp->q.mono_delivery_time =3D skb->mono_delivery_time;
 	qp->q.meat +=3D skb->len;
 	qp->ecn |=3D ecn;
 	add_frag_mem_limit(qp->q.fqdir, skb->truesize);
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index d94f9f7e60c3..95f7bb052784 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -226,6 +226,7 @@ void ip_protocol_deliver_rcu(struct net *net, struct sk=
_buff *skb, int protocol)
=20
 static int ip_local_deliver_finish(struct net *net, struct sock *sk, struc=
t sk_buff *skb)
 {
+	skb_clear_delivery_time(skb);
 	__skb_pull(skb, skb_network_header_len(skb));
=20
 	rcu_read_lock();
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index d4b1e2c5aa76..5b5ea35635f9 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -459,6 +459,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct s=
k_buff *skb, int nexthdr,
=20
 static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_bu=
ff *skb)
 {
+	skb_clear_delivery_time(skb);
 	rcu_read_lock();
 	ip6_protocol_deliver_rcu(net, skb, 0, false);
 	rcu_read_unlock();
--=20
2.30.2

