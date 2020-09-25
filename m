Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45044277CA0
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgIYAEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:04:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6052 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726738AbgIYAEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:04:22 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P03QWm012160
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=m3EElDGVBeDykz5YO2ptQIrCZ8jfoAlwcCiCWG9mgA4=;
 b=hw+kih2Yxaqqw+ObDlyhDqQZcUVctW87ZM/3AEoTJmp0m2WI34gQZKQuArMtLmpnpSFX
 r0Vxp8QjGqCzx86rPD9wsLrrGBJywNLnb73nK4cAolcD0Tjt84aYIbZdnou2vh3IwlJK
 UUFyKHL9HSQEmfRsYidaZs+y/ptlEfiMSKA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp54tb6-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:22 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 17:04:16 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 494152946606; Thu, 24 Sep 2020 17:04:15 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 06/13] bpf: Change bpf_sk_assign to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
Date:   Thu, 24 Sep 2020 17:04:15 -0700
Message-ID: <20200925000415.3857374-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=13 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the bpf_sk_assign() to take
ARG_PTR_TO_BTF_ID_SOCK_COMMON such that they will work with the pointer
returned by the bpf_skc_to_*() helpers also.

The bpf_sk_lookup_assign() is taking ARG_PTR_TO_SOCKET_"OR_NULL".  Meanin=
g
it specifically takes a literal NULL.  ARG_PTR_TO_BTF_ID_SOCK_COMMON
does not allow a literal NULL, so another ARG type is required
for this purpose and another follow-up patch can be used if
there is such need.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/uapi/linux/bpf.h       | 2 +-
 net/core/filter.c              | 4 ++--
 tools/include/uapi/linux/bpf.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 69b9e30375bc..2d6519a2ed77 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3107,7 +3107,7 @@ union bpf_attr {
  * 	Return
  * 		The id is returned or 0 in case the id could not be retrieved.
  *
- * long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flag=
s)
+ * long bpf_sk_assign(struct sk_buff *skb, void *sk, u64 flags)
  *	Description
  *		Helper is overloaded depending on BPF program type. This
  *		description applies to **BPF_PROG_TYPE_SCHED_CLS** and
diff --git a/net/core/filter.c b/net/core/filter.c
index 1d88e9b498eb..af88935e24b1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6217,7 +6217,7 @@ static const struct bpf_func_proto bpf_tcp_gen_sync=
ookie_proto =3D {
=20
 BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64,=
 flags)
 {
-	if (flags !=3D 0)
+	if (!sk || flags !=3D 0)
 		return -EINVAL;
 	if (!skb_at_tc_ingress(skb))
 		return -EOPNOTSUPP;
@@ -6241,7 +6241,7 @@ static const struct bpf_func_proto bpf_sk_assign_pr=
oto =3D {
 	.gpl_only	=3D false,
 	.ret_type	=3D RET_INTEGER,
 	.arg1_type      =3D ARG_PTR_TO_CTX,
-	.arg2_type      =3D ARG_PTR_TO_SOCK_COMMON,
+	.arg2_type      =3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg3_type	=3D ARG_ANYTHING,
 };
=20
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 69b9e30375bc..2d6519a2ed77 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3107,7 +3107,7 @@ union bpf_attr {
  * 	Return
  * 		The id is returned or 0 in case the id could not be retrieved.
  *
- * long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flag=
s)
+ * long bpf_sk_assign(struct sk_buff *skb, void *sk, u64 flags)
  *	Description
  *		Helper is overloaded depending on BPF program type. This
  *		description applies to **BPF_PROG_TYPE_SCHED_CLS** and
--=20
2.24.1

