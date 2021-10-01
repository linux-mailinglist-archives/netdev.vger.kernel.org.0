Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7868C41F737
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355789AbhJAWFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:05:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1936 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355739AbhJAWFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 18:05:10 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 191Lsadc002086
        for <netdev@vger.kernel.org>; Fri, 1 Oct 2021 15:03:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=gyIm/c9R/j4mN/Fp3sNEalbHmdWoRgGhUXOvjKbOEBE=;
 b=p09k1QyL9eZIHZf3iwRETJfJg9FNlwKLlQ36qIKrhwiA3WWNL4Nz89cJD1ekSr/Q33k/
 H4Rh2CKGzpHgDVpC+F0xIjsWaV/vcWBi2ZuBw1fc3p1HXhQcQ/3J/mALPecSJGpYYMaI
 ECDos8ggtcWkmDLwI0weEc2sNiLCkpF+Lko= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3be8e70y4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 15:03:23 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 1 Oct 2021 15:03:22 -0700
Received: by devbig612.frc2.facebook.com (Postfix, from userid 115148)
        id 11BCC312DE4E; Fri,  1 Oct 2021 15:03:19 -0700 (PDT)
From:   Joanne Koong <joannekoong@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kafai@fb.com>, <netdev@vger.kernel.org>, <Kernel-team@fb.com>,
        Joanne Koong <joannekoong@fb.com>
Subject: [PATCH bpf-next v1 1/3] bpf/xdp: Add bpf_load_hdr_opt support for xdp
Date:   Fri, 1 Oct 2021 14:58:56 -0700
Message-ID: <20211001215858.1132715-2-joannekoong@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001215858.1132715-1-joannekoong@fb.com>
References: <20211001215858.1132715-1-joannekoong@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: iidtUjFSHEIer9gFk2h7L6NxdJePuuUK
X-Proofpoint-ORIG-GUID: iidtUjFSHEIer9gFk2h7L6NxdJePuuUK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-01_05,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 clxscore=1011
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110010154
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables XDP programs to use the bpf_load_hdr_opt helper
function to load header options.

The upper 16 bits of "flags" is used to denote the offset to the tcp
header. No other flags are, at this time, used by XDP programs.
In the future, more flags can be included to support other types of
header options.

Much of the logic for loading header options can be shared between
sockops and xdp programs. In net/core/filter.c, this common shared
logic is refactored into a separate function both sockops and xdp
use.

Signed-off-by: Joanne Koong <joannekoong@fb.com>
---
 include/uapi/linux/bpf.h       | 26 ++++++----
 net/core/filter.c              | 88 ++++++++++++++++++++++++++--------
 tools/include/uapi/linux/bpf.h | 26 ++++++----
 3 files changed, 103 insertions(+), 37 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..2a90e9e5088f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4272,21 +4272,28 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
- * long bpf_load_hdr_opt(struct bpf_sock_ops *skops, void *searchby_res,=
 u32 len, u64 flags)
+ * long bpf_load_hdr_opt(void *ctx, void *searchby_res, u32 len, u64 fla=
gs)
  *	Description
- *		Load header option.  Support reading a particular TCP header
- *		option for bpf program (**BPF_PROG_TYPE_SOCK_OPS**).
+ *		Load header option. Support reading a particular TCP header
+ *		option for bpf programs (**BPF_PROG_TYPE_SOCK_OPS** and
+ *		**BPF_PROG_TYPE_XDP**).
  *
- *		If *flags* is 0, it will search the option from the
- *		*skops*\ **->skb_data**.  The comment in **struct bpf_sock_ops**
- *		has details on what skb_data contains under different
- *		*skops*\ **->op**.
+ *		*ctx* is either **struct bpf_sock_ops** for SOCK_OPS programs or
+ *		**struct xdp_md** for XDP programs.
+ *
+ *		For SOCK_OPS programs, if *flags* is 0, it will search the option
+ *		from the *skops*\ **->skb_data**.  The comment in
+ *		**struct bpf_sock_ops** has details on what skb_data contains
+ *		under different *skops*\ **->op**.
+ *
+ *		For XDP programs, the upper 16 bits of **flags** should contain
+ *		the offset to the tcp header.
  *
  *		The first byte of the *searchby_res* specifies the
  *		kind that it wants to search.
  *
  *		If the searching kind is an experimental kind
- *		(i.e. 253 or 254 according to RFC6994).  It also
+ *		(i.e. 253 or 254 according to RFC6994), it also
  *		needs to specify the "magic" which is either
  *		2 bytes or 4 bytes.  It then also needs to
  *		specify the size of the magic by using
@@ -4309,7 +4316,7 @@ union bpf_attr {
  *		*len* must be at least 2 bytes which is the minimal size
  *		of a header option.
  *
- *		Supported flags:
+ *		Supported flags for **SOCK_OPS** programs:
  *
  *		* **BPF_LOAD_HDR_OPT_TCP_SYN** to search from the
  *		  saved_syn packet or the just-received syn packet.
@@ -6018,6 +6025,7 @@ enum {
=20
 enum {
 	BPF_LOAD_HDR_OPT_TCP_SYN =3D (1ULL << 0),
+	BPF_LOAD_HDR_OPT_TCP_OFFSET_SHIFT =3D 48,
 };
=20
 /* args[0] value during BPF_SOCK_OPS_HDR_OPT_LEN_CB and
diff --git a/net/core/filter.c b/net/core/filter.c
index 4bace37a6a44..7d12a03ee81f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6904,19 +6904,19 @@ static const u8 *bpf_search_tcp_opt(const u8 *op,=
 const u8 *opend,
 	return ERR_PTR(-ENOMSG);
 }
=20
-BPF_CALL_4(bpf_sock_ops_load_hdr_opt, struct bpf_sock_ops_kern *, bpf_so=
ck,
-	   void *, search_res, u32, len, u64, flags)
+static int bpf_load_hdr_opt(const u8 *op, const u8 *opend, void *search_=
res,
+			    u32 len)
 {
-	bool eol, load_syn =3D flags & BPF_LOAD_HDR_OPT_TCP_SYN;
-	const u8 *op, *opend, *magic, *search =3D search_res;
 	u8 search_kind, search_len, copy_len, magic_len;
+	const u8 *magic, *search =3D search_res;
+	bool eol;
 	int ret;
=20
 	/* 2 byte is the minimal option len except TCPOPT_NOP and
 	 * TCPOPT_EOL which are useless for the bpf prog to learn
 	 * and this helper disallow loading them also.
 	 */
-	if (len < 2 || flags & ~BPF_LOAD_HDR_OPT_TCP_SYN)
+	if (len < 2)
 		return -EINVAL;
=20
 	search_kind =3D search[0];
@@ -6939,6 +6939,67 @@ BPF_CALL_4(bpf_sock_ops_load_hdr_opt, struct bpf_s=
ock_ops_kern *, bpf_sock,
 		magic_len =3D 0;
 	}
=20
+	op =3D bpf_search_tcp_opt(op, opend, search_kind, magic, magic_len,
+				&eol);
+
+	if (IS_ERR(op))
+		return PTR_ERR(op);
+
+	copy_len =3D op[1];
+	ret =3D copy_len;
+	if (copy_len > len) {
+		ret =3D -ENOSPC;
+		copy_len =3D len;
+	}
+
+	memcpy(search_res, op, copy_len);
+	return ret;
+}
+
+BPF_CALL_4(bpf_xdp_load_hdr_opt, struct xdp_buff *, xdp,
+	   void *, search_res, u32, len, u64, flags)
+{
+	const void *op, *opend;
+	struct tcphdr *th;
+
+	/* The upper 16 bits of flags contain the offset to the tcp header.
+	 * No other bits should be set.
+	 */
+	if (flags & 0xffffffffffff)
+		return -EINVAL;
+
+	th =3D xdp->data + (flags >> BPF_LOAD_HDR_OPT_TCP_OFFSET_SHIFT);
+	op =3D (void *)th + sizeof(struct tcphdr);
+	if (unlikely(op > xdp->data_end))
+		return -EINVAL;
+
+	opend =3D (void *)th + th->doff * 4;
+	if (unlikely(opend > xdp->data_end))
+		return -EINVAL;
+
+	return bpf_load_hdr_opt(op, opend, search_res, len);
+}
+
+static const struct bpf_func_proto bpf_xdp_load_hdr_opt_proto =3D {
+	.func		=3D bpf_xdp_load_hdr_opt,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_CTX,
+	.arg2_type	=3D ARG_PTR_TO_MEM,
+	.arg3_type	=3D ARG_CONST_SIZE,
+	.arg4_type	=3D ARG_ANYTHING,
+};
+
+BPF_CALL_4(bpf_sock_ops_load_hdr_opt, struct bpf_sock_ops_kern *, bpf_so=
ck,
+	   void *, search_res, u32, len, u64, flags)
+{
+	bool load_syn =3D flags & BPF_LOAD_HDR_OPT_TCP_SYN;
+	const u8 *op, *opend;
+	int ret;
+
+	if (flags & ~BPF_LOAD_HDR_OPT_TCP_SYN)
+		return -EINVAL;
+
 	if (load_syn) {
 		ret =3D bpf_sock_ops_get_syn(bpf_sock, TCP_BPF_SYN, &op);
 		if (ret < 0)
@@ -6956,20 +7017,7 @@ BPF_CALL_4(bpf_sock_ops_load_hdr_opt, struct bpf_s=
ock_ops_kern *, bpf_sock,
 		op =3D bpf_sock->skb->data + sizeof(struct tcphdr);
 	}
=20
-	op =3D bpf_search_tcp_opt(op, opend, search_kind, magic, magic_len,
-				&eol);
-	if (IS_ERR(op))
-		return PTR_ERR(op);
-
-	copy_len =3D op[1];
-	ret =3D copy_len;
-	if (copy_len > len) {
-		ret =3D -ENOSPC;
-		copy_len =3D len;
-	}
-
-	memcpy(search_res, op, copy_len);
-	return ret;
+	return bpf_load_hdr_opt(op, opend, search_res, len);
 }
=20
 static const struct bpf_func_proto bpf_sock_ops_load_hdr_opt_proto =3D {
@@ -7488,6 +7536,8 @@ xdp_func_proto(enum bpf_func_id func_id, const stru=
ct bpf_prog *prog)
 		return &bpf_tcp_check_syncookie_proto;
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
+	case BPF_FUNC_load_hdr_opt:
+		return &bpf_xdp_load_hdr_opt_proto;
 #endif
 	default:
 		return bpf_sk_base_func_proto(func_id);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 6fc59d61937a..2a90e9e5088f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4272,21 +4272,28 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
- * long bpf_load_hdr_opt(struct bpf_sock_ops *skops, void *searchby_res,=
 u32 len, u64 flags)
+ * long bpf_load_hdr_opt(void *ctx, void *searchby_res, u32 len, u64 fla=
gs)
  *	Description
- *		Load header option.  Support reading a particular TCP header
- *		option for bpf program (**BPF_PROG_TYPE_SOCK_OPS**).
+ *		Load header option. Support reading a particular TCP header
+ *		option for bpf programs (**BPF_PROG_TYPE_SOCK_OPS** and
+ *		**BPF_PROG_TYPE_XDP**).
  *
- *		If *flags* is 0, it will search the option from the
- *		*skops*\ **->skb_data**.  The comment in **struct bpf_sock_ops**
- *		has details on what skb_data contains under different
- *		*skops*\ **->op**.
+ *		*ctx* is either **struct bpf_sock_ops** for SOCK_OPS programs or
+ *		**struct xdp_md** for XDP programs.
+ *
+ *		For SOCK_OPS programs, if *flags* is 0, it will search the option
+ *		from the *skops*\ **->skb_data**.  The comment in
+ *		**struct bpf_sock_ops** has details on what skb_data contains
+ *		under different *skops*\ **->op**.
+ *
+ *		For XDP programs, the upper 16 bits of **flags** should contain
+ *		the offset to the tcp header.
  *
  *		The first byte of the *searchby_res* specifies the
  *		kind that it wants to search.
  *
  *		If the searching kind is an experimental kind
- *		(i.e. 253 or 254 according to RFC6994).  It also
+ *		(i.e. 253 or 254 according to RFC6994), it also
  *		needs to specify the "magic" which is either
  *		2 bytes or 4 bytes.  It then also needs to
  *		specify the size of the magic by using
@@ -4309,7 +4316,7 @@ union bpf_attr {
  *		*len* must be at least 2 bytes which is the minimal size
  *		of a header option.
  *
- *		Supported flags:
+ *		Supported flags for **SOCK_OPS** programs:
  *
  *		* **BPF_LOAD_HDR_OPT_TCP_SYN** to search from the
  *		  saved_syn packet or the just-received syn packet.
@@ -6018,6 +6025,7 @@ enum {
=20
 enum {
 	BPF_LOAD_HDR_OPT_TCP_SYN =3D (1ULL << 0),
+	BPF_LOAD_HDR_OPT_TCP_OFFSET_SHIFT =3D 48,
 };
=20
 /* args[0] value during BPF_SOCK_OPS_HDR_OPT_LEN_CB and
--=20
2.30.2

