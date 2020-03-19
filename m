Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD718C3EE
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 00:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCSXuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 19:50:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23304 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726827AbgCSXuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 19:50:07 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02JNKtPT017018
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 16:50:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=8v7pZ3n9S96rO9KtgZK7nQiuPJusepMrl+LEXw5DkJs=;
 b=Ig2MFHDHRgUTESFIJA8U+iKdxCGYyWory9rWiGAxZ9qITfD4prfCiXTnUxIHI5DEkKhP
 rgwxBoYE+Fyly13g3nNctxNTkrWyD77Z4GiHOQ/SJktv8J6vBCWYeyfFNQPCVEJmm9mu
 awdugBWsmEm6Yg8Z2/abIC2p1iPwUjd9vsc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2yugve9j2w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 16:50:05 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 19 Mar 2020 16:50:04 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 2BE892942DAE; Thu, 19 Mar 2020 16:50:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/2] bpf: Add bpf_sk_storage support to bpf_tcp_ca
Date:   Thu, 19 Mar 2020 16:50:02 -0700
Message-ID: <20200319235002.2939713-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319234955.2933540-1-kafai@fb.com>
References: <20200319234955.2933540-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxlogscore=846
 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=13 mlxscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190094
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds bpf_sk_storage_get() and bpf_sk_storage_delete()
helper to the bpf_tcp_ca's struct_ops.  That would allow
bpf-tcp-cc to:
1) share sk private data with other bpf progs.
2) use bpf_sk_storage as a private storage for a bpf-tcp-cc
   if the existing icsk_ca_priv is not big enough.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/bpf_tcp_ca.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 574972bc7299..0fd8bfde2448 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -7,6 +7,7 @@
 #include <linux/btf.h>
 #include <linux/filter.h>
 #include <net/tcp.h>
+#include <net/bpf_sk_storage.h>
 
 static u32 optional_ops[] = {
 	offsetof(struct tcp_congestion_ops, init),
@@ -27,6 +28,27 @@ static u32 unsupported_ops[] = {
 static const struct btf_type *tcp_sock_type;
 static u32 tcp_sock_id, sock_id;
 
+static int btf_sk_storage_get_ids[5];
+static struct bpf_func_proto btf_sk_storage_get_proto __read_mostly;
+
+static int btf_sk_storage_delete_ids[5];
+static struct bpf_func_proto btf_sk_storage_delete_proto __read_mostly;
+
+static void convert_sk_func_proto(struct bpf_func_proto *to, int *to_btf_ids,
+				  const struct bpf_func_proto *from)
+{
+	int i;
+
+	*to = *from;
+	to->btf_id = to_btf_ids;
+	for (i = 0; i < ARRAY_SIZE(to->arg_type); i++) {
+		if (to->arg_type[i] == ARG_PTR_TO_SOCKET) {
+			to->arg_type[i] = ARG_PTR_TO_BTF_ID;
+			to->btf_id[i] = tcp_sock_id;
+		}
+	}
+}
+
 static int bpf_tcp_ca_init(struct btf *btf)
 {
 	s32 type_id;
@@ -42,6 +64,13 @@ static int bpf_tcp_ca_init(struct btf *btf)
 	tcp_sock_id = type_id;
 	tcp_sock_type = btf_type_by_id(btf, tcp_sock_id);
 
+	convert_sk_func_proto(&btf_sk_storage_get_proto,
+			      btf_sk_storage_get_ids,
+			      &bpf_sk_storage_get_proto);
+	convert_sk_func_proto(&btf_sk_storage_delete_proto,
+			      btf_sk_storage_delete_ids,
+			      &bpf_sk_storage_delete_proto);
+
 	return 0;
 }
 
@@ -167,6 +196,10 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 	switch (func_id) {
 	case BPF_FUNC_tcp_send_ack:
 		return &bpf_tcp_send_ack_proto;
+	case BPF_FUNC_sk_storage_get:
+		return &btf_sk_storage_get_proto;
+	case BPF_FUNC_sk_storage_delete:
+		return &btf_sk_storage_delete_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
-- 
2.17.1

