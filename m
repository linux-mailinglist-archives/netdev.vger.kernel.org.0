Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6F277C9E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgIYAEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:04:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8512 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726859AbgIYAEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:04:23 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P01loi001314
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=smNZyPgJA8sF2PGC1SnLR/pUOeMLwmfagtm4spQYGns=;
 b=Y1KR0b6yWNT3qeCsrdhy59PuE2smM94BMpTYkas6ULwd8TyoloxO4PMZTqKqOOZ1n256
 NDM0iW1yrzcd6POoUlJ0AUaJ61tGAbMozwhefZAKteea00lBfGAdw26LRFkF7Dj8G/jZ
 p5w+r6QKvoRAp8OFnXeDKfEO66TuCpfa7TM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp84n7b-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:23 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 17:04:11 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 0EFA72946606; Thu, 24 Sep 2020 17:04:09 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 05/13] bpf: Change bpf_tcp_*_syncookie to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
Date:   Thu, 24 Sep 2020 17:04:09 -0700
Message-ID: <20200925000409.3856725-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=13
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009240174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the bpf_tcp_*_syncookie() to take
ARG_PTR_TO_BTF_ID_SOCK_COMMON such that they will work with the pointer
returned by the bpf_skc_to_*() helpers also.

Acked-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/uapi/linux/bpf.h       | 4 ++--
 net/core/filter.c              | 8 ++++----
 tools/include/uapi/linux/bpf.h | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0ec6dbeb17a5..69b9e30375bc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2692,7 +2692,7 @@ union bpf_attr {
  *		result is from *reuse*\ **->socks**\ [] using the hash of the
  *		tuple.
  *
- * long bpf_tcp_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_=
len, struct tcphdr *th, u32 th_len)
+ * long bpf_tcp_check_syncookie(void *sk, void *iph, u32 iph_len, struct=
 tcphdr *th, u32 th_len)
  * 	Description
  * 		Check whether *iph* and *th* contain a valid SYN cookie ACK for
  * 		the listening socket in *sk*.
@@ -2878,7 +2878,7 @@ union bpf_attr {
  *
  *		**-EAGAIN** if bpf program can try again.
  *
- * s64 bpf_tcp_gen_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len=
, struct tcphdr *th, u32 th_len)
+ * s64 bpf_tcp_gen_syncookie(void *sk, void *iph, u32 iph_len, struct tc=
phdr *th, u32 th_len)
  *	Description
  *		Try to issue a SYN cookie for the packet with corresponding
  *		IP/TCP headers, *iph* and *th*, on the listening socket in *sk*.
diff --git a/net/core/filter.c b/net/core/filter.c
index 06d397eeef2a..1d88e9b498eb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6086,7 +6086,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, =
sk, void *, iph, u32, iph_len
 	u32 cookie;
 	int ret;
=20
-	if (unlikely(th_len < sizeof(*th)))
+	if (unlikely(!sk || th_len < sizeof(*th)))
 		return -EINVAL;
=20
 	/* sk_listener() allows TCP_NEW_SYN_RECV, which makes no sense here. */
@@ -6139,7 +6139,7 @@ static const struct bpf_func_proto bpf_tcp_check_sy=
ncookie_proto =3D {
 	.gpl_only	=3D true,
 	.pkt_access	=3D true,
 	.ret_type	=3D RET_INTEGER,
-	.arg1_type	=3D ARG_PTR_TO_SOCK_COMMON,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg2_type	=3D ARG_PTR_TO_MEM,
 	.arg3_type	=3D ARG_CONST_SIZE,
 	.arg4_type	=3D ARG_PTR_TO_MEM,
@@ -6153,7 +6153,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk=
, void *, iph, u32, iph_len,
 	u32 cookie;
 	u16 mss;
=20
-	if (unlikely(th_len < sizeof(*th) || th_len !=3D th->doff * 4))
+	if (unlikely(!sk || th_len < sizeof(*th) || th_len !=3D th->doff * 4))
 		return -EINVAL;
=20
 	if (sk->sk_protocol !=3D IPPROTO_TCP || sk->sk_state !=3D TCP_LISTEN)
@@ -6208,7 +6208,7 @@ static const struct bpf_func_proto bpf_tcp_gen_sync=
ookie_proto =3D {
 	.gpl_only	=3D true, /* __cookie_v*_init_sequence() is GPL */
 	.pkt_access	=3D true,
 	.ret_type	=3D RET_INTEGER,
-	.arg1_type	=3D ARG_PTR_TO_SOCK_COMMON,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg2_type	=3D ARG_PTR_TO_MEM,
 	.arg3_type	=3D ARG_CONST_SIZE,
 	.arg4_type	=3D ARG_PTR_TO_MEM,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 0ec6dbeb17a5..69b9e30375bc 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2692,7 +2692,7 @@ union bpf_attr {
  *		result is from *reuse*\ **->socks**\ [] using the hash of the
  *		tuple.
  *
- * long bpf_tcp_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_=
len, struct tcphdr *th, u32 th_len)
+ * long bpf_tcp_check_syncookie(void *sk, void *iph, u32 iph_len, struct=
 tcphdr *th, u32 th_len)
  * 	Description
  * 		Check whether *iph* and *th* contain a valid SYN cookie ACK for
  * 		the listening socket in *sk*.
@@ -2878,7 +2878,7 @@ union bpf_attr {
  *
  *		**-EAGAIN** if bpf program can try again.
  *
- * s64 bpf_tcp_gen_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len=
, struct tcphdr *th, u32 th_len)
+ * s64 bpf_tcp_gen_syncookie(void *sk, void *iph, u32 iph_len, struct tc=
phdr *th, u32 th_len)
  *	Description
  *		Try to issue a SYN cookie for the packet with corresponding
  *		IP/TCP headers, *iph* and *th*, on the listening socket in *sk*.
--=20
2.24.1

