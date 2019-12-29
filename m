Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73BA712BFF3
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 03:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfL2CTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 21:19:05 -0500
Received: from mail4.protonmail.ch ([185.70.40.27]:57252 "EHLO
        mail4.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfL2CTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 21:19:05 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Dec 2019 21:19:01 EST
Date:   Sun, 29 Dec 2019 02:13:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1577585592;
        bh=BvQygDzjfTfoJAmOkZ8QxG5sKjwG7VPAIM0/aaiiLNc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=nUbvahkqOJrJm5Qa/PEtXje8XWTkMkzWoxZvEAguynLG8J0D88iric9B4MTqvjIKD
         A+4K44KffTCiVGqpyVarEGrs64yFivkL8kPPBTbiM4l1XrVdRQ/nYvIS20np0bTxRQ
         lkxDM5PoqDrb0zfU5mYR3jMGh4htazBqpZmmV54U=
To:     David Miller <davem@davemloft.net>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] Improved handling of incorrect IP fragments
Message-ID: <mGT4tZUhbVI4gq_S5IVRL2jaA5f241EsnImGDuVoNpK2rXixwiekd6GeYYGLUdyUm2ZA22CNb8j5wlBbUMjATfsOmEMma2K3REA7nfEgFzk=@protonmail.com>
In-Reply-To: <20191228.115738.611834296697018444.davem@davemloft.net>
References: <NIK8V5mQHWZU7pO9H6W3BjBzlsZ-wjJOcqNEcRaDxLVswAF_ynPFCXOkIRKr-EF4EdDMMZ7Fa3cQEpoqa_Sjt0ZKUMqmZFHYI1FIVwPhJhs=@protonmail.com>
 <20191228.115738.611834296697018444.davem@davemloft.net>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        shortcircuit=no autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In both ip6_frag_queue and ip6_frag_reasm, it is checked whether it is an
Oversized IPv6 packet, which is duplicated. The original code logic will
only be processed in ip6_frag_queue. The code of ip6_frag_reasm will not
be executed. Now change it to only process in ip6_frag_queue and output
the prompt information.

In ip6_frag_queue, set the prob_offset pointer to notify ipv6_frag_rcv
to send the ICMPv6 parameter problem message. The logic is not concise,
I merged the part that sent ICMPv6 messages into ip6_frag_queue.

In the original logic, receiving oversized IPv6 fragments and receiving
IPv6 fragments whose end is not an integral multiple of 8 bytes both
returns -1. This is inconsistent with other incorrect IPv6 fragmentation
processing. For example, in other logic, end =3D=3D offset will goto discar=
d_fq
directly. I think that receiving any incorrect IPv6 fragment means that the
fragment processing has failed as a whole, and the data carried in the
fragments is likely to be wrong. I think we should also execute goto
discard_fq to release this fragments queue.

Goto discard_fq at the end of the label send_param_prob, release the
fragment queue. Since icmpv6_param_prob will call kfree_skb, it will also
be kfree_skb in the label err, which will cause repeated free,
so I added skb_get.

I also made similar changes in IPv4 fragmentation processing.

It is not good to use 65535 values directly,
I added the IPV4_MAX_TOT_LEN macro.

The oversized check in IPv4 fragment processing is in the ip_frag_reasm
of the reassembly fragment. This is too late. The incorrect IP fragment
has been inserted into the fragment queue. I modified it in ip_frag_queue.
I changed the original net_info_ratelimited to net_dbg_ratelimited to make
the debugging information more controllable.

I also modified goto discard_qp directly
when the end is not an integer multiple of 8 bytes.

Signed-off-by: AK Deng <ttttabcd@protonmail.com>
---
 include/net/ip.h       |  2 ++
 net/ipv4/ip_fragment.c | 20 +++++++++----------
 net/ipv6/reassembly.c  | 45 ++++++++++++++++++++----------------------
 3 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 5b317c9f4470..43e9dc51852b 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -34,6 +34,8 @@
 #define IPV4_MAX_PMTU=09=0965535U=09=09/* RFC 2675, Section 5.1 */
 #define IPV4_MIN_MTU=09=0968=09=09=09/* RFC 791 */

+#define IPV4_MAX_TOT_LEN=09=0965535
+
 extern unsigned int sysctl_fib_sync_mem;
 extern unsigned int sysctl_fib_sync_mem_min;
 extern unsigned int sysctl_fib_sync_mem_max;
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index cfeb8890f94e..baee3383d0ac 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -300,6 +300,12 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buf=
f *skb)
 =09end =3D offset + skb->len - skb_network_offset(skb) - ihl;
 =09err =3D -EINVAL;

+=09if ((unsigned int)end + ihl > IPV4_MAX_TOT_LEN) {
+=09=09net_dbg_ratelimited("ip_frag_queue: Oversized IP packet from %pI4, e=
nd =3D %d\n",
+=09=09=09=09    &qp->q.key.v4.saddr, end);
+=09=09goto discard_qp;
+=09}
+
 =09/* Is this the final fragment? */
 =09if ((flags & IP_MF) =3D=3D 0) {
 =09=09/* If we already have some bits beyond end
@@ -311,11 +317,10 @@ static int ip_frag_queue(struct ipq *qp, struct sk_bu=
ff *skb)
 =09=09qp->q.flags |=3D INET_FRAG_LAST_IN;
 =09=09qp->q.len =3D end;
 =09} else {
-=09=09if (end&7) {
-=09=09=09end &=3D ~7;
-=09=09=09if (skb->ip_summed !=3D CHECKSUM_UNNECESSARY)
-=09=09=09=09skb->ip_summed =3D CHECKSUM_NONE;
-=09=09}
+=09=09/* Check if the fragment is rounded to 8 bytes. */
+=09=09if (end & 0x7)
+=09=09=09goto discard_qp;
+
 =09=09if (end > qp->q.len) {
 =09=09=09/* Some bits beyond end -> corruption. */
 =09=09=09if (qp->q.flags & INET_FRAG_LAST_IN)
@@ -423,8 +428,6 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff=
 *skb,

 =09len =3D ip_hdrlen(skb) + qp->q.len;
 =09err =3D -E2BIG;
-=09if (len > 65535)
-=09=09goto out_oversize;

 =09inet_frag_reasm_finish(&qp->q, skb, reasm_data,
 =09=09=09       ip_frag_coalesce_ok(qp));
@@ -462,9 +465,6 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff=
 *skb,
 out_nomem:
 =09net_dbg_ratelimited("queue_glue: no memory for gluing queue %p\n", qp);
 =09err =3D -ENOMEM;
-=09goto out_fail;
-out_oversize:
-=09net_info_ratelimited("Oversized IP packet from %pI4\n", &qp->q.key.v4.s=
addr);
 out_fail:
 =09__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
 =09return err;
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 1f5d4d196dcc..302bf6c26c45 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -102,13 +102,13 @@ fq_find(struct net *net, __be32 id, const struct ipv6=
hdr *hdr, int iif)
 }

 static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
-=09=09=09  struct frag_hdr *fhdr, int nhoff,
-=09=09=09  u32 *prob_offset)
+=09=09=09  struct frag_hdr *fhdr, int nhoff)
 {
 =09struct net *net =3D dev_net(skb_dst(skb)->dev);
 =09int offset, end, fragsize;
 =09struct sk_buff *prev_tail;
 =09struct net_device *dev;
+=09u32 prob_offset =3D 0;
 =09int err =3D -ENOENT;
 =09u8 ecn;

@@ -121,11 +121,10 @@ static int ip6_frag_queue(struct frag_queue *fq, stru=
ct sk_buff *skb,
 =09=09=09((u8 *)(fhdr + 1) - (u8 *)(ipv6_hdr(skb) + 1)));

 =09if ((unsigned int)end > IPV6_MAXPLEN) {
-=09=09*prob_offset =3D (u8 *)&fhdr->frag_off - skb_network_header(skb);
-=09=09/* note that if prob_offset is set, the skb is freed elsewhere,
-=09=09 * we do not free it here.
-=09=09 */
-=09=09return -1;
+=09=09prob_offset =3D (u8 *)&fhdr->frag_off - skb_network_header(skb);
+=09=09net_dbg_ratelimited("ip6_frag_queue: Oversized IPv6 packet from %pI6=
c, end =3D %d\n",
+=09=09=09=09    &fq->q.key.v6.saddr, end);
+=09=09goto send_param_prob;
 =09}

 =09ecn =3D ip6_frag_ecn(ipv6_hdr(skb));
@@ -155,8 +154,8 @@ static int ip6_frag_queue(struct frag_queue *fq, struct=
 sk_buff *skb,
 =09=09=09/* RFC2460 says always send parameter problem in
 =09=09=09 * this case. -DaveM
 =09=09=09 */
-=09=09=09*prob_offset =3D offsetof(struct ipv6hdr, payload_len);
-=09=09=09return -1;
+=09=09=09prob_offset =3D offsetof(struct ipv6hdr, payload_len);
+=09=09=09goto send_param_prob;
 =09=09}
 =09=09if (end > fq->q.len) {
 =09=09=09/* Some bits beyond end -> corruption. */
@@ -236,6 +235,18 @@ static int ip6_frag_queue(struct frag_queue *fq, struc=
t sk_buff *skb,
 err:
 =09kfree_skb(skb);
 =09return err;
+send_param_prob:
+=09=09__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
+=09=09=09=09IPSTATS_MIB_INHDRERRORS);
+=09=09/* icmpv6_param_prob() calls kfree_skb(skb),
+=09=09 * and the label err also calls kfree_skb(skb),
+=09=09 * so skb_get(skb) here increases the reference count
+=09=09 * to avoid duplicate release
+=09=09 */
+=09=09skb_get(skb);
+=09=09icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, prob_offset);
+=09=09err =3D -1;
+=09=09goto discard_fq;
 }

 /*
@@ -267,8 +278,6 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct=
 sk_buff *skb,
 =09payload_len =3D ((skb->data - skb_network_header(skb)) -
 =09=09       sizeof(struct ipv6hdr) + fq->q.len -
 =09=09       sizeof(struct frag_hdr));
-=09if (payload_len > IPV6_MAXPLEN)
-=09=09goto out_oversize;

 =09/* We have to remove fragment header from datagram and to relocate
 =09 * header in order to calculate ICV correctly. */
@@ -303,9 +312,6 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct=
 sk_buff *skb,
 =09fq->q.last_run_head =3D NULL;
 =09return 1;

-out_oversize:
-=09net_dbg_ratelimited("ip6_frag_reasm: payload len =3D %d\n", payload_len=
);
-=09goto out_fail;
 out_oom:
 =09net_dbg_ratelimited("ip6_frag_reasm: no memory for reassembly\n");
 out_fail:
@@ -354,23 +360,14 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 =09iif =3D skb->dev ? skb->dev->ifindex : 0;
 =09fq =3D fq_find(net, fhdr->identification, hdr, iif);
 =09if (fq) {
-=09=09u32 prob_offset =3D 0;
 =09=09int ret;
-
 =09=09spin_lock(&fq->q.lock);

 =09=09fq->iif =3D iif;
-=09=09ret =3D ip6_frag_queue(fq, skb, fhdr, IP6CB(skb)->nhoff,
-=09=09=09=09     &prob_offset);
+=09=09ret =3D ip6_frag_queue(fq, skb, fhdr, IP6CB(skb)->nhoff);

 =09=09spin_unlock(&fq->q.lock);
 =09=09inet_frag_put(&fq->q);
-=09=09if (prob_offset) {
-=09=09=09__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
-=09=09=09=09=09IPSTATS_MIB_INHDRERRORS);
-=09=09=09/* icmpv6_param_prob() calls kfree_skb(skb) */
-=09=09=09icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, prob_offset);
-=09=09}
 =09=09return ret;
 =09}

--
2.24.0
