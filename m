Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E3056227
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 08:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfFZGMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 02:12:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15584 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbfFZGMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 02:12:52 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5Q686hj025551
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 23:12:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=0BpgaC9tmhPMCaDRLWkpfAWzGAwdWqXSSv6PFLKRVHQ=;
 b=jjj06Udl1XFoDdXK/fDAKoskykDt7ZwFD6qEh3e266o4Zc9g+qbtxscfWC/dRj7aEy3+
 YwA9iLh9C9JXuWvX5XH6lRvT0NYvxLTH5puWEUz4I7KqN96/ZhW/C0WlEMi++3ujYqmU
 Dr32sQBMPtWJhTokU/ZdgYTgjNAgogK4/tk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tbpv82m5v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 23:12:51 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Jun 2019 23:12:50 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2DEBE861896; Tue, 25 Jun 2019 23:12:48 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 2/3] libbpf: auto-set PERF_EVENT_ARRAY size to number of CPUs
Date:   Tue, 25 Jun 2019 23:12:34 -0700
Message-ID: <20190626061235.602633-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626061235.602633-1-andriin@fb.com>
References: <20190626061235.602633-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260074
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For BPF_MAP_TYPE_PERF_EVENT_ARRAY typically correct size is number of
possible CPUs. This is impossible to specify at compilation time. This
change adds automatic setting of PERF_EVENT_ARRAY size to number of
system CPUs, unless non-zero size is specified explicitly. This allows
to adjust size for advanced specific cases, while providing convenient
and logical defaults.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c74cc535902a..8f2b8a081ba7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2114,6 +2114,7 @@ static int
 bpf_object__create_maps(struct bpf_object *obj)
 {
 	struct bpf_create_map_attr create_attr = {};
+	int nr_cpus = 0;
 	unsigned int i;
 	int err;
 
@@ -2136,7 +2137,21 @@ bpf_object__create_maps(struct bpf_object *obj)
 		create_attr.map_flags = def->map_flags;
 		create_attr.key_size = def->key_size;
 		create_attr.value_size = def->value_size;
-		create_attr.max_entries = def->max_entries;
+		if (def->type == BPF_MAP_TYPE_PERF_EVENT_ARRAY &&
+		    !def->max_entries) {
+			if (!nr_cpus)
+				nr_cpus = libbpf_num_possible_cpus();
+			if (nr_cpus < 0) {
+				pr_warning("failed to determine number of system CPUs: %d\n",
+					   nr_cpus);
+				return nr_cpus;
+			}
+			pr_debug("map '%s': setting size to %d\n",
+				 map->name, nr_cpus);
+			create_attr.max_entries = nr_cpus;
+		} else {
+			create_attr.max_entries = def->max_entries;
+		}
 		create_attr.btf_fd = 0;
 		create_attr.btf_key_type_id = 0;
 		create_attr.btf_value_type_id = 0;
-- 
2.17.1

