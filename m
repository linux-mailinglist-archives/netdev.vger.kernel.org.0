Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E55F219846
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgGIGLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:11:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47490 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgGIGLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:11:30 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06968oYO001051
        for <netdev@vger.kernel.org>; Wed, 8 Jul 2020 23:11:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=1mOYUP3p9l9wcQtvCkS2V2xZ09Ny/LcRNNc/FMDSKkw=;
 b=HUc+zgjjdcwMu51Kunl5t3xDBsqgkV729WW+ewKt4hmyH1ho9/QD4CR1+kh7bdTbPwHL
 Aalw03/F+V2QPoUfcDAg9iWlJld8XK1CnoPKtKZhAKaYMzcep6mOrkBSHC+M1FAMKri0
 T5HTckZ1LC8zOtm/M4j+6x6KMF4/8lymZS8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 325k2cauag-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 23:11:29 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 8 Jul 2020 23:11:11 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 80F532945AE1; Wed,  8 Jul 2020 23:11:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, James Chapman <jchapman@katalix.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf 2/2] bpf: net: Avoid incorrect bpf_sk_reuseport_detach call
Date:   Wed, 8 Jul 2020 23:11:10 -0700
Message-ID: <20200709061110.4019316-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200709061057.4018499-1-kafai@fb.com>
References: <20200709061057.4018499-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_01:2020-07-08,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=3 bulkscore=0 impostorscore=0
 mlxlogscore=693 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_sk_reuseport_detach is currently called when sk->sk_user_data
is not NULL.  It is incorrect because sk->sk_user_data may not be
managed by the bpf's reuseport_array.  It has been reported in [1] that,
the bpf_sk_reuseport_detach() which is called from udp_lib_unhash() has
corrupted the sk_user_data managed by l2tp.

This patch solves it by using another bit (defined as SK_USER_DATA_BPF)
of the sk_user_data pointer value.  It marks that a sk_user_data is
managed/owned by BPF.

The patch depends on a PTRMASK introduced in
commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data pointer on clone if=
 tagged").

[ Note: sk->sk_user_data is used by bpf's reuseport_array only when a sk =
is
  added to the bpf's reuseport_array.
  i.e. doing setsockopt(SO_REUSEPORT) and having "sk->sk_reuseport =3D=3D=
 1"
  alone will not stop sk->sk_user_data being used by other means. ]

[1]: https://lore.kernel.org/netdev/20200706121259.GA20199@katalix.com/

Reported-by: James Chapman <jchapman@katalix.com>
Cc: James Chapman <jchapman@katalix.com>
Fixes: 5dc4c4b7d4e8 ("bpf: Introduce BPF_MAP_TYPE_REUSEPORT_SOCKARRAY")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/sock.h           | 3 ++-
 kernel/bpf/reuseport_array.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 3428619faae4..1183507df95b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -533,7 +533,8 @@ enum sk_pacing {
  * be copied.
  */
 #define SK_USER_DATA_NOCOPY	1UL
-#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY)
+#define SK_USER_DATA_BPF	2UL	/* Managed by BPF */
+#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF)
=20
 /**
  * sk_user_data_is_nocopy - Test if sk_user_data pointer must not be cop=
ied
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index a95bc8d7e812..cae9d505e04a 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -24,7 +24,7 @@ void bpf_sk_reuseport_detach(struct sock *sk)
=20
 	write_lock_bh(&sk->sk_callback_lock);
 	sk_user_data =3D (uintptr_t)sk->sk_user_data;
-	if (sk_user_data) {
+	if (sk_user_data & SK_USER_DATA_BPF) {
 		struct sock __rcu **socks;
=20
 		socks =3D (void *)(sk_user_data & SK_USER_DATA_PTRMASK);
@@ -309,7 +309,8 @@ int bpf_fd_reuseport_array_update_elem(struct bpf_map=
 *map, void *key,
 	if (err)
 		goto put_file_unlock;
=20
-	sk_user_data =3D (uintptr_t)&array->ptrs[index] | SK_USER_DATA_NOCOPY;
+	sk_user_data =3D (uintptr_t)&array->ptrs[index] | SK_USER_DATA_NOCOPY |
+		SK_USER_DATA_BPF;
 	WRITE_ONCE(nsk->sk_user_data, (void *)sk_user_data);
 	rcu_assign_pointer(array->ptrs[index], nsk);
 	free_osk =3D osk;
--=20
2.24.1

