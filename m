Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678AC4CAF30
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242623AbiCBT5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242593AbiCBT5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:57:16 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8AED763A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:56:30 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 222JMowo011154
        for <netdev@vger.kernel.org>; Wed, 2 Mar 2022 11:56:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=YZh7Lt4/K+gMdsbfAzuoWK/X9ZYx2nS+p0o7fF2LUvA=;
 b=Z/CxP4PnulxAPO/Rmp9wYmxk4YAo7bmGlgVNk0lPbrr6TN5PW3cTZUm5j9p2qg/5EHKM
 6JB9RPi4GbJC6Vxr+DZgWm+idafajwD8Qi8GvS51ivGV7ZvtQx/QYfA0AhgUnCgdxPdk
 wg84znBbGYilhnICLZIyRvOllxbnu3Wp0RY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ejaqwtak7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:56:30 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 11:56:29 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3A11D7BD36FF; Wed,  2 Mar 2022 11:56:22 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v6 net-next 10/13] net: Postpone skb_clear_delivery_time() until knowing the skb is delivered locally
Date:   Wed, 2 Mar 2022 11:56:22 -0800
Message-ID: <20220302195622.3483941-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220302195519.3479274-1-kafai@fb.com>
References: <20220302195519.3479274-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: zhMCSPWPlPre4E2C9Z9R1NT_1agWMZbd
X-Proofpoint-ORIG-GUID: zhMCSPWPlPre4E2C9Z9R1NT_1agWMZbd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020085
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patches handled the delivery_time in the ingress path
before the routing decision is made.  This patch can postpone clearing
delivery_time in a skb until knowing it is delivered locally and also
set the (rcv) timestamp if needed.  This patch moves the
skb_clear_delivery_time() from dev.c to ip_local_deliver_finish()
and ip6_input_finish().

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/dev.c       | 8 ++------
 net/ipv4/ip_input.c  | 1 +
 net/ipv6/ip6_input.c | 1 +
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0fc02cf32476..3ff686cc8c84 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5193,10 +5193,8 @@ static int __netif_receive_skb_core(struct sk_buff=
 **pskb, bool pfmemalloc,
 			goto out;
 	}
=20
-	if (skb_skip_tc_classify(skb)) {
-		skb_clear_delivery_time(skb);
+	if (skb_skip_tc_classify(skb))
 		goto skip_classify;
-	}
=20
 	if (pfmemalloc)
 		goto skip_taps;
@@ -5225,14 +5223,12 @@ static int __netif_receive_skb_core(struct sk_buf=
f **pskb, bool pfmemalloc,
 			goto another_round;
 		if (!skb)
 			goto out;
-		skb_clear_delivery_time(skb);
=20
 		nf_skip_egress(skb, false);
 		if (nf_ingress(skb, &pt_prev, &ret, orig_dev) < 0)
 			goto out;
-	} else
+	}
 #endif
-		skb_clear_delivery_time(skb);
 	skb_reset_redirect(skb);
 skip_classify:
 	if (pfmemalloc && !skb_pfmemalloc_protocol(skb))
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index d94f9f7e60c3..95f7bb052784 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -226,6 +226,7 @@ void ip_protocol_deliver_rcu(struct net *net, struct =
sk_buff *skb, int protocol)
=20
 static int ip_local_deliver_finish(struct net *net, struct sock *sk, str=
uct sk_buff *skb)
 {
+	skb_clear_delivery_time(skb);
 	__skb_pull(skb, skb_network_header_len(skb));
=20
 	rcu_read_lock();
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index d4b1e2c5aa76..5b5ea35635f9 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -459,6 +459,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct=
 sk_buff *skb, int nexthdr,
=20
 static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_=
buff *skb)
 {
+	skb_clear_delivery_time(skb);
 	rcu_read_lock();
 	ip6_protocol_deliver_rcu(net, skb, 0, false);
 	rcu_read_unlock();
--=20
2.30.2

