Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930DA1287CD
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 07:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLUG0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 01:26:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726583AbfLUG0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 01:26:20 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBL6Oi7a028955
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=pKwuNVuScutXuSo2aBow+k8ITvz/MmcFeSEYZRyzLOc=;
 b=URyZ4CaR+NIhwtML53XTW74Pa+zyvgTj5zPFDTe/op8dRYM3ZvZ3xMGoWHpafdgBBLbL
 USG6i+6k2Fzxg+5V9JKgAEvvQs0g02o1luhGlOepEFGEXnu62ZOser+lYF1BLeXlAosK
 7gQ52FUmhkQFaXFkwHFtr7KiaDx6TpH2N+0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x11nsuah3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:19 -0800
Received: from intmgw005.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 20 Dec 2019 22:26:17 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 777322946127; Fri, 20 Dec 2019 22:26:13 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 08/11] bpf: Add BPF_FUNC_tcp_send_ack helper
Date:   Fri, 20 Dec 2019 22:26:13 -0800
Message-ID: <20191221062613.1183582-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191221062556.1182261-1-kafai@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-21_01:2019-12-17,2019-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 suspectscore=13 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912210054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to send out a tcp-ack.  It will be used in the later
bpf_dctcp implementation that requires to send out an ack
when the CE state changed.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/uapi/linux/bpf.h | 11 ++++++++++-
 net/ipv4/bpf_tcp_ca.c    | 24 +++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 38059880963e..2d6a2e572f56 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2837,6 +2837,14 @@ union bpf_attr {
  * 	Return
  * 		On success, the strictly positive length of the string,	including
  * 		the trailing NUL character. On error, a negative value.
+ *
+ * int bpf_tcp_send_ack(void *tp, u32 rcv_nxt)
+ *	Description
+ *		Send out a tcp-ack. *tp* is the in-kernel struct tcp_sock.
+ *		*rcv_nxt* is the ack_seq to be sent out.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2954,7 +2962,8 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),	\
+	FN(tcp_send_ack),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 1114339ee57d..b90e2ec2ee2b 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -144,11 +144,33 @@ static int bpf_tcp_ca_btf_struct_access(struct bpf_verifier_log *log,
 	return NOT_INIT;
 }
 
+BPF_CALL_2(bpf_tcp_send_ack, struct tcp_sock *, tp, u32, rcv_nxt)
+{
+	/* bpf_tcp_ca prog cannot have NULL tp */
+	__tcp_send_ack((struct sock *)tp, rcv_nxt);
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_tcp_send_ack_proto = {
+	.func		= bpf_tcp_send_ack,
+	.gpl_only	= false,
+	/* In case we want to report error later */
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_ANYTHING,
+	.btf_id		= &tcp_sock_id,
+};
+
 static const struct bpf_func_proto *
 bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 			  const struct bpf_prog *prog)
 {
-	return bpf_base_func_proto(func_id);
+	switch (func_id) {
+	case BPF_FUNC_tcp_send_ack:
+		return &bpf_tcp_send_ack_proto;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
 }
 
 static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {
-- 
2.17.1

