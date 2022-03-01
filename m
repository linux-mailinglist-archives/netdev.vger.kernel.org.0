Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CCF4C834D
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiCAFiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbiCAFiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:38:09 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C5624F3C
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:28 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21SMwTTn023010
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=M9eQVFN2mH1U2+vJTtVIVlCo0M/09mhKoFPbozTDCBs=;
 b=M9fhI71hXPhCoiDedRC8ePPwhaTojeuI/Di5b+ZKxC+ng3JKaZc8RwR9cFL+GCgGgIlN
 Ufjbb3Q9fJi8Dbv8uqbNelf4QvG2C+0E7WbMPYX8jVSMJOHe/ORdGls/Fmeh56Dezo0z
 8M1DkCHaVsryzAEXb6ez27FaCTFLTlAC9Qo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3egx7a5yeu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:27 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 21:37:26 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 872987A895F1; Mon, 28 Feb 2022 21:37:15 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v5 net-next 07/13] net: ipv6: Handle delivery_time in ipv6 defrag
Date:   Mon, 28 Feb 2022 21:37:15 -0800
Message-ID: <20220301053715.933829-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301053631.930498-1-kafai@fb.com>
References: <20220301053631.930498-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: zYRvd6dgwrDmdzP5Snr0QMvtKh0WIJkL
X-Proofpoint-ORIG-GUID: zYRvd6dgwrDmdzP5Snr0QMvtKh0WIJkL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_10,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2203010026
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A latter patch will postpone the delivery_time clearing until the stack
knows the skb is being delivered locally (i.e. calling
skb_clear_delivery_time() at ip_local_deliver_finish() for IPv4
and at ip6_input_finish() for IPv6).  That will allow other kernel
forwarding path (e.g. ip[6]_forward) to keep the delivery_time also.

A very similar IPv6 defrag codes have been duplicated in
multiple places: regular IPv6, nf_conntrack, and 6lowpan.

Unlike the IPv4 defrag which is done before ip_local_deliver_finish(),
the regular IPv6 defrag is done after ip6_input_finish().
Thus, no change should be needed in the regular IPv6 defrag
logic because skb_clear_delivery_time() should have been called.

6lowpan also does not need special handling on delivery_time
because it is a non-inet packet_type.

However, cf_conntrack has a case in NF_INET_PRE_ROUTING that needs
to do the IPv6 defrag earlier.  Thus, it needs to save the
mono_delivery_time bit in the inet_frag_queue which is similar
to how it is handled in the previous patch for the IPv4 defrag.

This patch chooses to do it consistently and stores the mono_delivery_tim=
e
in the inet_frag_queue for all cases such that it will be easier
for the future refactoring effort on the IPv6 reasm code.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ieee802154/6lowpan/reassembly.c     | 1 +
 net/ipv6/netfilter/nf_conntrack_reasm.c | 1 +
 net/ipv6/reassembly.c                   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan=
/reassembly.c
index be6f06adefe0..a91283d1e5bf 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -130,6 +130,7 @@ static int lowpan_frag_queue(struct lowpan_frag_queue=
 *fq,
 		goto err;
=20
 	fq->q.stamp =3D skb->tstamp;
+	fq->q.mono_delivery_time =3D skb->mono_delivery_time;
 	if (frag_type =3D=3D LOWPAN_DISPATCH_FRAG1)
 		fq->q.flags |=3D INET_FRAG_FIRST_IN;
=20
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter=
/nf_conntrack_reasm.c
index 5c47be29b9ee..7dd3629dd19e 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -264,6 +264,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, s=
truct sk_buff *skb,
 		fq->iif =3D dev->ifindex;
=20
 	fq->q.stamp =3D skb->tstamp;
+	fq->q.mono_delivery_time =3D skb->mono_delivery_time;
 	fq->q.meat +=3D skb->len;
 	fq->ecn |=3D ecn;
 	if (payload_len > fq->q.max_size)
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 28e44782c94d..ff866f2a879e 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -194,6 +194,7 @@ static int ip6_frag_queue(struct frag_queue *fq, stru=
ct sk_buff *skb,
 		fq->iif =3D dev->ifindex;
=20
 	fq->q.stamp =3D skb->tstamp;
+	fq->q.mono_delivery_time =3D skb->mono_delivery_time;
 	fq->q.meat +=3D skb->len;
 	fq->ecn |=3D ecn;
 	add_frag_mem_limit(fq->q.fqdir, skb->truesize);
--=20
2.30.2

