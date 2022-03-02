Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5976D4CAF28
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242202AbiCBT46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242508AbiCBT45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:56:57 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B860D95FC
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:56:13 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 222JMmki000707
        for <netdev@vger.kernel.org>; Wed, 2 Mar 2022 11:56:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TcoIBw/j3fHRM3iVBlutiQf4sDdmWXY15o6ZwxC0PoI=;
 b=XfiSE9QfIi4ZdvUm4+ptXE12ezCj0dVuFYOa13x6baM09tFwf5ov/NDye8XFmM8COwOB
 C1XYKoLHvASALjAEgAC/TZOEk6RJpyINY59LmehMpaN74FbRxAnuBYkdCdIbIjK6LCDC
 JLtOMBKnGTrwiojHjZXXPNCpsJUSuSYGZJ8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ej7jgvgjj-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:56:12 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 11:56:07 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 115107BD35B9; Wed,  2 Mar 2022 11:55:57 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v6 net-next 06/13] net: ip: Handle delivery_time in ip defrag
Date:   Wed, 2 Mar 2022 11:55:57 -0800
Message-ID: <20220302195557.3481523-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220302195519.3479274-1-kafai@fb.com>
References: <20220302195519.3479274-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: bib_HCXT-QH41xLn_84sHlIMQ4pxhKBo
X-Proofpoint-ORIG-GUID: bib_HCXT-QH41xLn_84sHlIMQ4pxhKBo
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020085
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
 include/net/inet_frag.h  | 2 ++
 net/ipv4/inet_fragment.c | 1 +
 net/ipv4/ip_fragment.c   | 1 +
 3 files changed, 4 insertions(+)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 63540be0fc34..911ad930867d 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -70,6 +70,7 @@ struct frag_v6_compare_key {
  * @stamp: timestamp of the last received fragment
  * @len: total length of the original datagram
  * @meat: length of received fragments so far
+ * @mono_delivery_time: stamp has a mono delivery time (EDT)
  * @flags: fragment queue flags
  * @max_size: maximum received fragment size
  * @fqdir: pointer to struct fqdir
@@ -90,6 +91,7 @@ struct inet_frag_queue {
 	ktime_t			stamp;
 	int			len;
 	int			meat;
+	u8			mono_delivery_time;
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

