Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954DB20B7A1
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgFZRzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:55:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19980 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726337AbgFZRzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:55:24 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QHsukv019446
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:55:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=znNTPRNyXLzzPQruPP5HgKBxQ3n/j1DseZqoGcyxpv4=;
 b=pQKT8OsA9ZQUZo4TMaiSxNtXk9pnbYlkv6GXDEdHFp1ElQERSWI/zf5lBQsaQZ7WlYYZ
 QdPVXWAM/BsiGTzHFkwEk7i7x+nsFeJ+V8S059VcptlQAiiNUWEqWPKrSzThem08D/bE
 ATF2bllztCxLaGJ8MCCV2vq9Dwg5GK+Btzk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1exn06-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:55:23 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 10:55:21 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id B05D92942E38; Fri, 26 Jun 2020 10:55:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 03/10] bpf: sock_ops: Change some members of sock_ops_kern from u32 to u8
Date:   Fri, 26 Jun 2020 10:55:20 -0700
Message-ID: <20200626175520.1460850-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626175501.1459961-1-kafai@fb.com>
References: <20200626175501.1459961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 cotscore=-2147483648 spamscore=0 mlxlogscore=737 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=13 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A latter patch needs to add a few pointers and a few u8 to
sock_ops_kern.  Hence, this patch saves some spaces by moving
some of the existing members from u32 to u8 so that the latter
patch can still fit everything in a cacheline.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h |  4 ++--
 net/core/filter.c      | 15 ++++++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 259377723603..aae52cbda670 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1236,13 +1236,13 @@ struct bpf_sock_addr_kern {
=20
 struct bpf_sock_ops_kern {
 	struct	sock *sk;
-	u32	op;
 	union {
 		u32 args[4];
 		u32 reply;
 		u32 replylong[4];
 	};
-	u32	is_fullsock;
+	u8	op;
+	u8	is_fullsock;
 	u64	temp;			/* temp and everything after is not
 					 * initialized to 0 before calling
 					 * the BPF program. New fields that
diff --git a/net/core/filter.c b/net/core/filter.c
index 19dbcc8448d8..1dd07972c5c7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8355,17 +8355,22 @@ static u32 sock_ops_convert_ctx_access(enum bpf_a=
ccess_type type,
 		return insn - insn_buf;
=20
 	switch (si->off) {
-	case offsetof(struct bpf_sock_ops, op) ...
+	case offsetof(struct bpf_sock_ops, op):
+		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_ops_kern,
+						       op),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sock_ops_kern, op));
+		break;
+
+	case offsetof(struct bpf_sock_ops, replylong[0]) ...
 	     offsetof(struct bpf_sock_ops, replylong[3]):
-		BUILD_BUG_ON(sizeof_field(struct bpf_sock_ops, op) !=3D
-			     sizeof_field(struct bpf_sock_ops_kern, op));
 		BUILD_BUG_ON(sizeof_field(struct bpf_sock_ops, reply) !=3D
 			     sizeof_field(struct bpf_sock_ops_kern, reply));
 		BUILD_BUG_ON(sizeof_field(struct bpf_sock_ops, replylong) !=3D
 			     sizeof_field(struct bpf_sock_ops_kern, replylong));
 		off =3D si->off;
-		off -=3D offsetof(struct bpf_sock_ops, op);
-		off +=3D offsetof(struct bpf_sock_ops_kern, op);
+		off -=3D offsetof(struct bpf_sock_ops, replylong[0]);
+		off +=3D offsetof(struct bpf_sock_ops_kern, replylong[0]);
 		if (type =3D=3D BPF_WRITE)
 			*insn++ =3D BPF_STX_MEM(BPF_W, si->dst_reg, si->src_reg,
 					      off);
--=20
2.24.1

