Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F9F23B0C3
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgHCXLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:11:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729205AbgHCXLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:11:08 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 073MolF2013734
        for <netdev@vger.kernel.org>; Mon, 3 Aug 2020 16:11:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=1ujo6eMuF+9KbdpXujYgVna6biexRCf5aN/ftEu70Go=;
 b=FDDJZQ3XDKI+tZqQLkv7bZRPy96/+j13cD3JasX7GcxUvD+yZxZ1DFGizkn221eDKDkH
 VbO8epbnXnY3y+CRHFZtxuJsaoTY3ck+JQxJ/4PzKoyFkYZTdxzMh9GD4V1yh2qtaiNU
 ibQtJ2lP6Mh6zg9LLDtUlf/fsyhcEGc//jE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32nrnny2xv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:11:08 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 16:11:07 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 992472943872; Mon,  3 Aug 2020 16:11:04 -0700 (PDT)
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
Subject: [RFC PATCH v4 bpf-next 08/12] bpf: sock_ops: Change some members of sock_ops_kern from u32 to u8
Date:   Mon, 3 Aug 2020 16:11:04 -0700
Message-ID: <20200803231104.2684437-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200803231013.2681560-1-kafai@fb.com>
References: <20200803231013.2681560-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_15:2020-08-03,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 suspectscore=13 phishscore=0 mlxscore=0 mlxlogscore=734
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A later patch needs to add a few pointers and a few u8 to
sock_ops_kern.  Hence, this patch saves some spaces by moving
some of the existing members from u32 to u8 so that the later
patch can still fit everything in a cacheline.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h |  4 ++--
 net/core/filter.c      | 15 ++++++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 0a355b005bf4..c427dfa5f908 100644
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
index 0a1bf520c55d..4adfc90b221e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8406,17 +8406,22 @@ static u32 sock_ops_convert_ctx_access(enum bpf_a=
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

