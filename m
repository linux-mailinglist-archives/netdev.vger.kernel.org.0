Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E71219845
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgGIGL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:11:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17980 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgGIGL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:11:29 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0696BSbl015741
        for <netdev@vger.kernel.org>; Wed, 8 Jul 2020 23:11:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=uWSAMp70PZHYGb756iFfbytUuRbDUQDnsIqdDn20Em0=;
 b=LlnY58VJFWjhBy/NHnNzMVvBlhy7XDpmQ659zggoDkL6Gah//4IaIgY8ezJkOISNwH/7
 OtjpJijFvjw05pH1ruJYhKMx7jEtFEO8rrUaO/N460Rdz15/+nFLL+xesVZR6MTrLNfh
 XGyMxqdzyUT60/HEraWty7gKktjo7m6i93E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 325jyytwt2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 23:11:28 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 8 Jul 2020 23:11:14 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3D2FB2945AE1; Wed,  8 Jul 2020 23:11:04 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf 1/2] bpf: net: Avoid copying sk_user_data of reuseport_array during sk_clone
Date:   Wed, 8 Jul 2020 23:11:04 -0700
Message-ID: <20200709061104.4018798-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200709061057.4018499-1-kafai@fb.com>
References: <20200709061057.4018499-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_01:2020-07-08,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 mlxlogscore=947 priorityscore=1501 adultscore=0 spamscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=38
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It makes little sense for copying sk_user_data of reuseport_array during
sk_clone_lock().  This patch reuses the SK_USER_DATA_NOCOPY bit introduce=
d in
commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data pointer on clone if=
 tagged").
It is used to mark the sk_user_data is not supposed to be copied to its c=
lone.

Although the cloned sk's sk_user_data will not be used/freed in
bpf_sk_reuseport_detach(), this change can still allow the cloned
sk's sk_user_data to be used by some other means.

Freeing the reuseport_array's sk_user_data does not require a rcu grace
period.  Thus, the existing rcu_assign_sk_user_data_nocopy() is not
used.

Fixes: 5dc4c4b7d4e8 ("bpf: Introduce BPF_MAP_TYPE_REUSEPORT_SOCKARRAY")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/reuseport_array.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 21cde24386db..a95bc8d7e812 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -20,11 +20,14 @@ static struct reuseport_array *reuseport_array(struct=
 bpf_map *map)
 /* The caller must hold the reuseport_lock */
 void bpf_sk_reuseport_detach(struct sock *sk)
 {
-	struct sock __rcu **socks;
+	uintptr_t sk_user_data;
=20
 	write_lock_bh(&sk->sk_callback_lock);
-	socks =3D sk->sk_user_data;
-	if (socks) {
+	sk_user_data =3D (uintptr_t)sk->sk_user_data;
+	if (sk_user_data) {
+		struct sock __rcu **socks;
+
+		socks =3D (void *)(sk_user_data & SK_USER_DATA_PTRMASK);
 		WRITE_ONCE(sk->sk_user_data, NULL);
 		/*
 		 * Do not move this NULL assignment outside of
@@ -252,6 +255,7 @@ int bpf_fd_reuseport_array_update_elem(struct bpf_map=
 *map, void *key,
 	struct sock *free_osk =3D NULL, *osk, *nsk;
 	struct sock_reuseport *reuse;
 	u32 index =3D *(u32 *)key;
+	uintptr_t sk_user_data;
 	struct socket *socket;
 	int err, fd;
=20
@@ -305,7 +309,8 @@ int bpf_fd_reuseport_array_update_elem(struct bpf_map=
 *map, void *key,
 	if (err)
 		goto put_file_unlock;
=20
-	WRITE_ONCE(nsk->sk_user_data, &array->ptrs[index]);
+	sk_user_data =3D (uintptr_t)&array->ptrs[index] | SK_USER_DATA_NOCOPY;
+	WRITE_ONCE(nsk->sk_user_data, (void *)sk_user_data);
 	rcu_assign_pointer(array->ptrs[index], nsk);
 	free_osk =3D osk;
 	err =3D 0;
--=20
2.24.1

