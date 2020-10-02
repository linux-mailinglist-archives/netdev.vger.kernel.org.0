Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7921B280BFC
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgJBBex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:34:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61406 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387483AbgJBBew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:34:52 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0921UQs4005502
        for <netdev@vger.kernel.org>; Thu, 1 Oct 2020 18:34:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kob+z2U1tgvtzcnBe8MBDHJ4GU2ZoQeli/HSA7zA9xA=;
 b=KPsChf+DH4As+15lI2hyOZAqnc6K2UFCWQqtgcwiQ/wsVqpxoCXZASthWGeYJbKgW66f
 l2XExYZbvZNMyMkguIhsetD9nY5TSJ1rZqwHk9XSPYxfgJCD5bwRamMm2qy+JMiZgDRN
 wAu61kdga9+WLdiuPyuyH8KoSPOm4tmtBUQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33v6v4fggx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 18:34:51 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 18:34:50 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A44552945DB0; Thu,  1 Oct 2020 18:34:48 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next 1/2] bpf: tcp: Do not limit cb_flags when creating child sk from listen sk
Date:   Thu, 1 Oct 2020 18:34:48 -0700
Message-ID: <20201002013448.2542025-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201002013442.2541568-1-kafai@fb.com>
References: <20201002013442.2541568-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_10:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=801 phishscore=0
 suspectscore=13 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010020006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 0813a841566f ("bpf: tcp: Allow bpf prog to write and parse TCP=
 header option")
unnecessarily introduced bpf_skops_init_child() which limited the child
sk from inheriting all bpf_sock_ops_cb_flags of the listen sk.  That
breaks existing user expectation.

This patch removes the bpf_skops_init_child() and just allows
sock_copy() to do its job to copy everything from listen sk to
the child sk.

Fixes: 0813a841566f ("bpf: tcp: Allow bpf prog to write and parse TCP hea=
der option")
Reported-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/tcp.h        | 33 ---------------------------------
 net/ipv4/tcp_minisocks.c |  1 -
 2 files changed, 34 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3601dea931a6..d4ef5bf94168 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2228,34 +2228,6 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_p=
sock *psock,
 #endif /* CONFIG_NET_SOCK_MSG */
=20
 #ifdef CONFIG_CGROUP_BPF
-/* Copy the listen sk's HDR_OPT_CB flags to its child.
- *
- * During 3-Way-HandShake, the synack is usually sent from
- * the listen sk with the HDR_OPT_CB flags set so that
- * bpf-prog will be called to write the BPF hdr option.
- *
- * In fastopen, the child sk is used to send synack instead
- * of the listen sk.  Thus, inheriting the HDR_OPT_CB flags
- * from the listen sk gives the bpf-prog a chance to write
- * BPF hdr option in the synack pkt during fastopen.
- *
- * Both fastopen and non-fastopen child will inherit the
- * HDR_OPT_CB flags to keep the bpf-prog having a consistent
- * behavior when deciding to clear this cb flags (or not)
- * during the PASSIVE_ESTABLISHED_CB.
- *
- * In the future, other cb flags could be inherited here also.
- */
-static inline void bpf_skops_init_child(const struct sock *sk,
-					struct sock *child)
-{
-	tcp_sk(child)->bpf_sock_ops_cb_flags =3D
-		tcp_sk(sk)->bpf_sock_ops_cb_flags &
-		(BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG |
-		 BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG |
-		 BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG);
-}
-
 static inline void bpf_skops_init_skb(struct bpf_sock_ops_kern *skops,
 				      struct sk_buff *skb,
 				      unsigned int end_offset)
@@ -2264,11 +2236,6 @@ static inline void bpf_skops_init_skb(struct bpf_s=
ock_ops_kern *skops,
 	skops->skb_data_end =3D skb->data + end_offset;
 }
 #else
-static inline void bpf_skops_init_child(const struct sock *sk,
-					struct sock *child)
-{
-}
-
 static inline void bpf_skops_init_skb(struct bpf_sock_ops_kern *skops,
 				      struct sk_buff *skb,
 				      unsigned int end_offset)
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 56c306e3cd2f..495dda2449fe 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -548,7 +548,6 @@ struct sock *tcp_create_openreq_child(const struct so=
ck *sk,
 	newtp->fastopen_req =3D NULL;
 	RCU_INIT_POINTER(newtp->fastopen_rsk, NULL);
=20
-	bpf_skops_init_child(sk, newsk);
 	tcp_bpf_clone(sk, newsk);
=20
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_PASSIVEOPENS);
--=20
2.24.1

