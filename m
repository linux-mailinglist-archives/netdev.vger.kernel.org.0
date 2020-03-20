Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B5418D2B6
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgCTPVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:21:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63844 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727257AbgCTPVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:21:34 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KFLSc5028882
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 08:21:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=CXPTbcbcgBFOkEDNCa+UkTbTYyvOUFripwTy7c+rVLk=;
 b=bp/mZsVIxycD0/XSWbMIPk8FNaaaTfTsn9meJCU4zcsgRTZ/8qbCQj6776+3Yt3JrSuN
 GKhO3zUAaZge9nWxDoM/B1VShKPO/WRPZrsTujC9xEIOgrNgH9URTMHndHwkqSdJoNqm
 AipAtKXkR/DjTk+JFOl6xOXiOhEgFWoVb0g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yv6hqf3f8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 08:21:33 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 08:21:09 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 7A88D29410F6; Fri, 20 Mar 2020 08:21:01 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/2] bpf: Add bpf_sk_storage support to bpf_tcp_ca
Date:   Fri, 20 Mar 2020 08:21:01 -0700
Message-ID: <20200320152101.2169498-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320152055.2169341-1-kafai@fb.com>
References: <20200320152055.2169341-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_05:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=13 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 mlxlogscore=861 impostorscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200064
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

Acked-by: Yonghong Song <yhs@fb.com>
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

