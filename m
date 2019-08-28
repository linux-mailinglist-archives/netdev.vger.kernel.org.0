Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B40A0C05
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfH1VEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:04:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56818 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726986AbfH1VEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:04:13 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7SL3DFi027742
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=JpHIeNTQH+w3VCO646ycX4US8fdIIjlenyDOATzHzFw=;
 b=mL2GMu/zv1hobWa5C4UM7phpe90ooZ2Qz+yKd3kuFEnOLRSgoZ3iNPki8tfX+QxDSh4z
 PR3JrBH8ODFyEDuzV4vTI/k2WplxyBqEO3g87IASt9xKtMMT18oSi+aYSVQqqWGWwWe7
 IVKzYzPIsoRTzvSR8UKb2O/1MeNjl+jdhMk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2untb0j7g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:11 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 14:04:11 -0700
Received: by devvm2868.prn3.facebook.com (Postfix, from userid 125878)
        id 6833DA25D60B; Wed, 28 Aug 2019 14:04:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Julia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm2868.prn3.facebook.com
To:     <rdna@fb.com>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH bpf-next 05/10] tools/bpf: add libbpf_map_type_(from|to)_str helpers
Date:   Wed, 28 Aug 2019 14:03:08 -0700
Message-ID: <5ddd6d7579770845dee4e9261f4eb9f8020d9765.1567024943.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1567024943.git.hex@fb.com>
References: <cover.1567024943.git.hex@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908280205
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to prog_type to string mapping, standardize string representation
of map types by putting commonly used names to libbpf.
The map_type to string mapping is taken from bpftool:
tools/bpf/bpftool/map.c

Signed-off-by: Julia Kartseva <hex@fb.com>
---
 tools/lib/bpf/libbpf.c   | 51 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  4 ++++
 tools/lib/bpf/libbpf.map |  2 ++
 3 files changed, 57 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 946a4d41f223..9c531256888b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -325,6 +325,35 @@ static const char *const prog_type_strs[] = {
 	[BPF_PROG_TYPE_CGROUP_SOCKOPT] = "cgroup_sockopt",
 };
 
+static const char *const map_type_strs[] = {
+	[BPF_MAP_TYPE_UNSPEC] = "unspec",
+	[BPF_MAP_TYPE_HASH] = "hash",
+	[BPF_MAP_TYPE_ARRAY] = "array",
+	[BPF_MAP_TYPE_PROG_ARRAY] = "prog_array",
+	[BPF_MAP_TYPE_PERF_EVENT_ARRAY] = "perf_event_array",
+	[BPF_MAP_TYPE_PERCPU_HASH] = "percpu_hash",
+	[BPF_MAP_TYPE_PERCPU_ARRAY] = "percpu_array",
+	[BPF_MAP_TYPE_STACK_TRACE] = "stack_trace",
+	[BPF_MAP_TYPE_CGROUP_ARRAY] = "cgroup_array",
+	[BPF_MAP_TYPE_LRU_HASH] = "lru_hash",
+	[BPF_MAP_TYPE_LRU_PERCPU_HASH] = "lru_percpu_hash",
+	[BPF_MAP_TYPE_LPM_TRIE] = "lpm_trie",
+	[BPF_MAP_TYPE_ARRAY_OF_MAPS] = "array_of_maps",
+	[BPF_MAP_TYPE_HASH_OF_MAPS] = "hash_of_maps",
+	[BPF_MAP_TYPE_DEVMAP] = "devmap",
+	[BPF_MAP_TYPE_SOCKMAP] = "sockmap",
+	[BPF_MAP_TYPE_CPUMAP] = "cpumap",
+	[BPF_MAP_TYPE_XSKMAP] = "xskmap",
+	[BPF_MAP_TYPE_SOCKHASH] = "sockhash",
+	[BPF_MAP_TYPE_CGROUP_STORAGE] = "cgroup_storage",
+	[BPF_MAP_TYPE_REUSEPORT_SOCKARRAY] = "reuseport_sockarray",
+	[BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE] = "percpu_cgroup_storage",
+	[BPF_MAP_TYPE_QUEUE] = "queue",
+	[BPF_MAP_TYPE_STACK] = "stack",
+	[BPF_MAP_TYPE_SK_STORAGE] = "sk_storage",
+	[BPF_MAP_TYPE_DEVMAP_HASH] = "devmap_hash"
+};
+
 void bpf_program__unload(struct bpf_program *prog)
 {
 	int i;
@@ -4683,6 +4712,28 @@ int libbpf_prog_type_to_str(enum bpf_prog_type type, const char **str)
 	return 0;
 }
 
+int libbpf_map_type_from_str(const char *str, enum bpf_map_type *type)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(map_type_strs); i++)
+		if (map_type_strs[i] && strcmp(map_type_strs[i], str) == 0) {
+			*type = i;
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+int libbpf_map_type_to_str(enum bpf_map_type type, const char **str)
+{
+	if (type < BPF_MAP_TYPE_UNSPEC || type >= ARRAY_SIZE(map_type_strs))
+		return -EINVAL;
+
+	*str = map_type_strs[type];
+	return 0;
+}
+
 static int
 bpf_program__identify_section(struct bpf_program *prog,
 			      enum bpf_prog_type *prog_type,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 6846c488d8a2..90daeb2cdefb 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -135,6 +135,10 @@ LIBBPF_API int libbpf_prog_type_from_str(const char *str,
 					 enum bpf_prog_type *type);
 LIBBPF_API int libbpf_prog_type_to_str(enum bpf_prog_type type,
 				       const char **str);
+/* String representation of map type */
+LIBBPF_API int libbpf_map_type_from_str(const char *str,
+					enum bpf_map_type *type);
+LIBBPF_API int libbpf_map_type_to_str(enum bpf_map_type type, const char **str);
 
 /* Accessors of bpf_program */
 struct bpf_program;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 2ea7c99f1579..e4ecf5414bb7 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -190,4 +190,6 @@ LIBBPF_0.0.5 {
 		bpf_btf_get_next_id;
 		libbpf_prog_type_from_str;
 		libbpf_prog_type_to_str;
+		libbpf_map_type_from_str;
+		libbpf_map_type_to_str;
 } LIBBPF_0.0.4;
-- 
2.17.1

