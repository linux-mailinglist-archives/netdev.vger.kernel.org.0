Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB6B4C834A
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiCAFiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiCAFh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:37:58 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A3875202
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:14 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21SMwh3B020160
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2x/nBiUS6InGQfgOunfdEXrfkF38AVl3WtUh7K8yhaQ=;
 b=HazPfTJcEMAY2eUXduOh8G+cxwJyhMcg2bEYNvD533qRuVJesbx3IGRDHbLpsZeIPGiG
 HnYrLFsuCoJLi8ELcPePoMRI37wDjdJ8+z2sybPeXBdm2QgcsGMpcqk6vAmiLhShnk1N
 V2I8NCBY0WNOET0z06C8NAFGqbWIqh+LvRg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3egx7hp00u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:13 -0800
Received: from twshared33837.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 21:37:12 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 43C6F7A895B6; Mon, 28 Feb 2022 21:37:09 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v5 net-next 06/13] net: ip: Handle delivery_time in ip defrag
Date:   Mon, 28 Feb 2022 21:37:09 -0800
Message-ID: <20220301053709.933219-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301053631.930498-1-kafai@fb.com>
References: <20220301053631.930498-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: eAdD9fSOAUvhXbYUYH0fNcDMU7mumtdx
X-Proofpoint-ORIG-GUID: eAdD9fSOAUvhXbYUYH0fNcDMU7mumtdx
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_10,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 bulkscore=0 phishscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010026
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

A latter patch will postpone the delivery_time clearing until the stack
knows the skb is being delivered locally.  That will allow other kernel
forwarding path (e.g. ip[6]_forward) to keep the delivery_time also.

An earlier attempt was to do skb_clear_delivery_time() in
ip_local_deliver() and ip6_input().  The discussion [0] requested
to move it one step later into ip_local_deliver_finish()
and ip6_input_finish() so that the delivery_time can be kept
for the ip_vs forwarding path also.

To do that, this patch also needs to take care of the (rcv) timestamp
usecase in ip_is_fragment().  It needs to expect delivery_time in
the skb->tstamp, so it needs to save the mono_delivery_time bit in
inet_frag_queue such that the delivery_time (if any) can be restored
in the final defragmented skb.

[Note that it will only happen when the locally generated skb is looping
 from egress to ingress over a virtual interface (e.g. veth, loopback...),
 skb->tstamp may have the delivery time before it is known that it will
 be delivered locally and received by another sk.]

[0]: https://lore.kernel.org/netdev/ca728d81-80e8-3767-d5e-d44f6ad96e43@ssi=
.bg/

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/inet_frag.h  | 1 +
 net/ipv4/inet_fragment.c | 1 +
 net/ipv4/ip_fragment.c   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 63540be0fc34..8ad0c1d6d024 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -90,6 +90,7 @@ struct inet_frag_queue {
 	ktime_t			stamp;
 	int			len;
 	int			meat;
+	__u8			mono_delivery_time;
 	__u8			flags;
 	u16			max_size;
 	struct fqdir		*fqdir;
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
--=20
2.30.2

