Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200C626ABEF
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgIOSaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:30:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20136 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728068AbgIOSaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:30:16 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FIJBCX013924
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:30:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=NsQ7h/XnKhl3Izio8nb4VLBC0WdywdRtn0ET+jvqZ5M=;
 b=bOl3pDj9Pph4Tjkrc3zTn92/5DVHdcE6Q6i8HkXBdnBP63FcJBmT2aWFDvChglh8/YoJ
 nwuVmav7GAV+KMyjqhUwM782VQkPd3bhxDyphMNfcS2aJEmu07qUqmIIUOVfGQLKB1fx
 baqE9e+RR8YBwHL9iSsmmInpiFB8DmNtcYc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33guums9as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:30:08 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 11:30:07 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 293072946053; Tue, 15 Sep 2020 11:29:59 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf] bpf: bpf_skc_to_* casting helpers require a NULL check on sk
Date:   Tue, 15 Sep 2020 11:29:59 -0700
Message-ID: <20200915182959.241101-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_12:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=862 phishscore=0 adultscore=0
 suspectscore=13 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009150147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_skc_to_* type casting helpers are available to
BPF_PROG_TYPE_TRACING.  The traced PTR_TO_BTF_ID may be NULL.
For example, the skb->sk may be NULL.  Thus, these casting helpers
need to check "!sk" also and this patch fixes them.

Fixes: 0d4fad3e57df ("bpf: Add bpf_skc_to_udp6_sock() helper")
Fixes: 478cfbdf5f13 ("bpf: Add bpf_skc_to_{tcp, tcp_timewait, tcp_request=
}_sock() helpers")
Fixes: af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/filter.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2d62c25e0395..23e8ded0ec97 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9522,7 +9522,7 @@ BPF_CALL_1(bpf_skc_to_tcp6_sock, struct sock *, sk)
 	 * trigger an explicit type generation here.
 	 */
 	BTF_TYPE_EMIT(struct tcp6_sock);
-	if (sk_fullsock(sk) && sk->sk_protocol =3D=3D IPPROTO_TCP &&
+	if (sk && sk_fullsock(sk) && sk->sk_protocol =3D=3D IPPROTO_TCP &&
 	    sk->sk_family =3D=3D AF_INET6)
 		return (unsigned long)sk;
=20
@@ -9540,7 +9540,7 @@ const struct bpf_func_proto bpf_skc_to_tcp6_sock_pr=
oto =3D {
=20
 BPF_CALL_1(bpf_skc_to_tcp_sock, struct sock *, sk)
 {
-	if (sk_fullsock(sk) && sk->sk_protocol =3D=3D IPPROTO_TCP)
+	if (sk && sk_fullsock(sk) && sk->sk_protocol =3D=3D IPPROTO_TCP)
 		return (unsigned long)sk;
=20
 	return (unsigned long)NULL;
@@ -9558,12 +9558,12 @@ const struct bpf_func_proto bpf_skc_to_tcp_sock_p=
roto =3D {
 BPF_CALL_1(bpf_skc_to_tcp_timewait_sock, struct sock *, sk)
 {
 #ifdef CONFIG_INET
-	if (sk->sk_prot =3D=3D &tcp_prot && sk->sk_state =3D=3D TCP_TIME_WAIT)
+	if (sk && sk->sk_prot =3D=3D &tcp_prot && sk->sk_state =3D=3D TCP_TIME_=
WAIT)
 		return (unsigned long)sk;
 #endif
=20
 #if IS_BUILTIN(CONFIG_IPV6)
-	if (sk->sk_prot =3D=3D &tcpv6_prot && sk->sk_state =3D=3D TCP_TIME_WAIT=
)
+	if (sk && sk->sk_prot =3D=3D &tcpv6_prot && sk->sk_state =3D=3D TCP_TIM=
E_WAIT)
 		return (unsigned long)sk;
 #endif
=20
@@ -9582,12 +9582,12 @@ const struct bpf_func_proto bpf_skc_to_tcp_timewa=
it_sock_proto =3D {
 BPF_CALL_1(bpf_skc_to_tcp_request_sock, struct sock *, sk)
 {
 #ifdef CONFIG_INET
-	if (sk->sk_prot =3D=3D &tcp_prot  && sk->sk_state =3D=3D TCP_NEW_SYN_RE=
CV)
+	if (sk && sk->sk_prot =3D=3D &tcp_prot && sk->sk_state =3D=3D TCP_NEW_S=
YN_RECV)
 		return (unsigned long)sk;
 #endif
=20
 #if IS_BUILTIN(CONFIG_IPV6)
-	if (sk->sk_prot =3D=3D &tcpv6_prot && sk->sk_state =3D=3D TCP_NEW_SYN_R=
ECV)
+	if (sk && sk->sk_prot =3D=3D &tcpv6_prot && sk->sk_state =3D=3D TCP_NEW=
_SYN_RECV)
 		return (unsigned long)sk;
 #endif
=20
@@ -9609,7 +9609,7 @@ BPF_CALL_1(bpf_skc_to_udp6_sock, struct sock *, sk)
 	 * trigger an explicit type generation here.
 	 */
 	BTF_TYPE_EMIT(struct udp6_sock);
-	if (sk_fullsock(sk) && sk->sk_protocol =3D=3D IPPROTO_UDP &&
+	if (sk && sk_fullsock(sk) && sk->sk_protocol =3D=3D IPPROTO_UDP &&
 	    sk->sk_type =3D=3D SOCK_DGRAM && sk->sk_family =3D=3D AF_INET6)
 		return (unsigned long)sk;
=20
--=20
2.24.1

