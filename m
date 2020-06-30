Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E71A20FFFA
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgF3WTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:19:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41758 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbgF3WTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:19:06 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UMJ1GN027166
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:19:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=8AUQoL8VZdPMjrzGs9W0ynOrf4sulTk8NHwCUowyXxk=;
 b=STK6u+OCujBJfTYwfD1AXXrcDcAPep1ugBBjLcJ4WgrSzTkf4Y4EckaciuH0DwdcNEBE
 ci1cjxws2t9VHlSh6gaDhqQV+JcmUHizZbqjKpuh8H4evyDrps1e+Oo4gj1VceqF8emv
 DJmw/22X9xmCaT4ptbU5iHaLEYFIEiu8hJc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xp39cfdt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:19:06 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 15:18:37 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 0FAA6294379D; Tue, 30 Jun 2020 15:18:33 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH net] ipv4: tcp: Fix SO_MARK in RST and ACK packet
Date:   Tue, 30 Jun 2020 15:18:33 -0700
Message-ID: <20200630221833.740761-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 phishscore=0 cotscore=-2147483648 malwarescore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=1 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=853 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When testing a recent kernel (5.6 in our case), the skb->mark of the
IPv4 TCP RST pkt does not carry the mark from sk->sk_mark.  It is
discovered by the bpf@tc that depends on skb->mark to work properly.
The same bpf prog has been working in the earlier kernel version.
After reverting commit c6af0c227a22 ("ip: support SO_MARK cmsg"),
the skb->mark is set and seen by bpf@tc properly.

We have noticed that in IPv4 TCP RST but it should also
happen to the ACK based on tcp_v4_send_ack() is also depending
on ip_send_unicast_reply().

This patch tries to fix it by initializing the ipc.sockc.mark to
fl4.flowi4_mark.

Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/ip_output.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 090d3097ee15..033512f719ec 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1703,6 +1703,7 @@ void ip_send_unicast_reply(struct sock *sk, struct =
sk_buff *skb,
 	sk->sk_bound_dev_if =3D arg->bound_dev_if;
 	sk->sk_sndbuf =3D sysctl_wmem_default;
 	sk->sk_mark =3D fl4.flowi4_mark;
+	ipc.sockc.mark =3D fl4.flowi4_mark;
 	err =3D ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base=
,
 			     len, 0, &ipc, &rt, MSG_DONTWAIT);
 	if (unlikely(err)) {
--=20
2.24.1

