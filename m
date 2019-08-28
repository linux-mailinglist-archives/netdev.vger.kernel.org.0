Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE6BA0C0F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfH1VEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:04:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56918 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727090AbfH1VET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:04:19 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7SKxveH025668
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=hGNB+Ir5jkBVB/3Ds+4h1CKVWEctBOogQTO+Yiul1gE=;
 b=jnKHszvcvDzVrXVsbXPLxF2R/HGEatpnvOSWRqrPXKExu327YNeFZrO07Ta9kxzPXTzB
 84/N4Z83dDnm6iIMy4h88ieqhUmamLVedZ6oNkB+ZZfnUas36ONud6CzJKXBRj4EBiaR
 y7EOUC5uOBl7ABg+DCH4+29+5YDydin70To= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2une6kmtmn-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:18 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 14:04:14 -0700
Received: by devvm2868.prn3.facebook.com (Postfix, from userid 125878)
        id 635D9A25D62C; Wed, 28 Aug 2019 14:04:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Julia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm2868.prn3.facebook.com
To:     <rdna@fb.com>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH bpf-next 06/10] tools/bpf: add libbpf_attach_type_(from|to)_str
Date:   Wed, 28 Aug 2019 14:03:09 -0700
Message-ID: <5af82a599a3e886b48e89a47579ad331b7954ee0.1567024943.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1567024943.git.hex@fb.com>
References: <cover.1567024943.git.hex@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 spamscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908280205
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Standardize string representation of attach types by putting commonly used
names to libbpf.
The attach_type to string mapping is taken from bpftool:
tools/bpf/bpftool/cgroup.c
tools/bpf/bpftool/prog.c

Signed-off-by: Julia Kartseva <hex@fb.com>
---
 tools/lib/bpf/libbpf.c   | 50 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  5 ++++
 tools/lib/bpf/libbpf.map |  2 ++
 3 files changed, 57 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9c531256888b..b5b07493655f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -354,6 +354,32 @@ static const char *const map_type_strs[] = {
 	[BPF_MAP_TYPE_DEVMAP_HASH] = "devmap_hash"
 };
 
+static const char *const attach_type_strs[] = {
+	[BPF_CGROUP_INET_INGRESS] = "ingress",
+	[BPF_CGROUP_INET_EGRESS] = "egress",
+	[BPF_CGROUP_INET_SOCK_CREATE] = "sock_create",
+	[BPF_CGROUP_SOCK_OPS] = "sock_ops",
+	[BPF_SK_SKB_STREAM_PARSER] = "stream_parser",
+	[BPF_SK_SKB_STREAM_VERDICT] = "stream_verdict",
+	[BPF_CGROUP_DEVICE] = "device",
+	[BPF_SK_MSG_VERDICT] = "msg_verdict",
+	[BPF_CGROUP_INET4_BIND] = "bind4",
+	[BPF_CGROUP_INET6_BIND] = "bind6",
+	[BPF_CGROUP_INET4_CONNECT] = "connect4",
+	[BPF_CGROUP_INET6_CONNECT] = "connect6",
+	[BPF_CGROUP_INET4_POST_BIND] = "post_bind4",
+	[BPF_CGROUP_INET6_POST_BIND] = "post_bind6",
+	[BPF_CGROUP_UDP4_SENDMSG] = "sendmsg4",
+	[BPF_CGROUP_UDP6_SENDMSG] = "sendmsg6",
+	[BPF_LIRC_MODE2] = "lirc_mode2",
+	[BPF_FLOW_DISSECTOR] = "flow_dissector",
+	[BPF_CGROUP_SYSCTL] = "sysctl",
+	[BPF_CGROUP_UDP4_RECVMSG] = "recvmsg4",
+	[BPF_CGROUP_UDP6_RECVMSG] = "recvmsg6",
+	[BPF_CGROUP_GETSOCKOPT] = "getsockopt",
+	[BPF_CGROUP_SETSOCKOPT] = "setsockopt"
+};
+
 void bpf_program__unload(struct bpf_program *prog)
 {
 	int i;
@@ -4734,6 +4760,30 @@ int libbpf_map_type_to_str(enum bpf_map_type type, const char **str)
 	return 0;
 }
 
+int libbpf_attach_type_from_str(const char *str, enum bpf_attach_type *type)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(attach_type_strs); i++)
+		if (attach_type_strs[i] &&
+		    strcmp(attach_type_strs[i], str) == 0) {
+			*type = i;
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+int libbpf_attach_type_to_str(enum bpf_attach_type type, const char **str)
+{
+	if (type < BPF_CGROUP_INET_INGRESS ||
+	    type >= ARRAY_SIZE(attach_type_strs))
+		return -EINVAL;
+
+	*str = attach_type_strs[type];
+	return 0;
+}
+
 static int
 bpf_program__identify_section(struct bpf_program *prog,
 			      enum bpf_prog_type *prog_type,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 90daeb2cdefb..0ad941951b0d 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -139,6 +139,11 @@ LIBBPF_API int libbpf_prog_type_to_str(enum bpf_prog_type type,
 LIBBPF_API int libbpf_map_type_from_str(const char *str,
 					enum bpf_map_type *type);
 LIBBPF_API int libbpf_map_type_to_str(enum bpf_map_type type, const char **str);
+/* String representation of attach type */
+LIBBPF_API int libbpf_attach_type_from_str(const char *str,
+					   enum bpf_attach_type *type);
+LIBBPF_API int libbpf_attach_type_to_str(enum bpf_attach_type type,
+					 const char **str);
 
 /* Accessors of bpf_program */
 struct bpf_program;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index e4ecf5414bb7..d87a6dc8a71f 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -192,4 +192,6 @@ LIBBPF_0.0.5 {
 		libbpf_prog_type_to_str;
 		libbpf_map_type_from_str;
 		libbpf_map_type_to_str;
+		libbpf_attach_type_from_str;
+		libbpf_attach_type_to_str;
 } LIBBPF_0.0.4;
-- 
2.17.1

