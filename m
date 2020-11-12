Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B9E2B0FE0
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 22:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgKLVNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 16:13:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4434 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727208AbgKLVNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 16:13:36 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACL1eVr025396
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 13:13:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=nsXZ17kaEJBN2aGu20NyWfRc/rJwXe+m3bC2GZFPpIM=;
 b=fipcR2zblFO7Iq4uV1V/dbDhgTkXZ2b3gCcJMtNnfdeR0quNLT2CXjRwlbZrKAEiH93p
 bRRaIPseytP1654h7IkZxgko8BMA0vSb/1Ju5ciitN4q+6heiVHE+O7+R35Mq2CvfEji
 WlOYpSYKWXuAUcF3kBBXvsTuhdUEr6H+DrQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34r5vncnkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 13:13:36 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 13:13:08 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 50A5829469C4; Thu, 12 Nov 2020 13:13:01 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 1/4] bpf: Folding omem_charge() into sk_storage_charge()
Date:   Thu, 12 Nov 2020 13:13:01 -0800
Message-ID: <20201112211301.2586255-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201112211255.2585961-1-kafai@fb.com>
References: <20201112211255.2585961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_12:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=790 suspectscore=13
 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011120123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_storage_charge() is the only user of omem_charge().
This patch simplifies it by folding omem_charge() into
sk_storage_charge().

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/bpf_sk_storage.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index c907f0dc7f87..001eac65e40f 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -15,18 +15,6 @@
=20
 DEFINE_BPF_STORAGE_CACHE(sk_cache);
=20
-static int omem_charge(struct sock *sk, unsigned int size)
-{
-	/* same check as in sock_kmalloc() */
-	if (size <=3D sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
-		atomic_add(size, &sk->sk_omem_alloc);
-		return 0;
-	}
-
-	return -ENOMEM;
-}
-
 static struct bpf_local_storage_data *
 sk_storage_lookup(struct sock *sk, struct bpf_map *map, bool cacheit_loc=
kit)
 {
@@ -316,7 +304,16 @@ BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, =
map, struct sock *, sk)
 static int sk_storage_charge(struct bpf_local_storage_map *smap,
 			     void *owner, u32 size)
 {
-	return omem_charge(owner, size);
+	struct sock *sk =3D (struct sock *)owner;
+
+	/* same check as in sock_kmalloc() */
+	if (size <=3D sysctl_optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
+		atomic_add(size, &sk->sk_omem_alloc);
+		return 0;
+	}
+
+	return -ENOMEM;
 }
=20
 static void sk_storage_uncharge(struct bpf_local_storage_map *smap,
--=20
2.24.1

