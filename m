Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFA646C82B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 00:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbhLGX1Z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Dec 2021 18:27:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2832 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238289AbhLGX1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:27:25 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7L8bAJ017840
        for <netdev@vger.kernel.org>; Tue, 7 Dec 2021 15:23:54 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3ctf8vgtd7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 15:23:54 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 15:23:53 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E88DE24A7149D; Tue,  7 Dec 2021 15:23:47 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <acme@kernel.org>, <acme@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH v2 bpf-next] perf/bpf_counter: use bpf_map_create instead of bpf_create_map
Date:   Tue, 7 Dec 2021 15:23:40 -0800
Message-ID: <20211207232340.2561471-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: XsAWtn_sZirSO4dSGeUV7YxwmaFScgS3
X-Proofpoint-GUID: XsAWtn_sZirSO4dSGeUV7YxwmaFScgS3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_09,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 clxscore=1034
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112070143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_create_map is deprecated. Replace it with bpf_map_create. Also add a
__weak bpf_map_create() so that when older version of libbpf is linked as
a shared library, it falls back to bpf_create_map().

Fixes: 992c4225419a ("libbpf: Unify low-level map creation APIs w/ new bpf_map_create()")
Signed-off-by: Song Liu <song@kernel.org>

---
Changes v1 => v2:
1. Add weak bpf_map_create(). (Andrii)
---
 tools/perf/util/bpf_counter.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
index c17d4a43ce06..5a97fd7d0a71 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
@@ -307,6 +307,20 @@ static bool bperf_attr_map_compatible(int attr_map_fd)
 		(map_info.value_size == sizeof(struct perf_event_attr_map_entry));
 }
 
+int __weak
+bpf_map_create(enum bpf_map_type map_type,
+	       const char *map_name __maybe_unused,
+	       __u32 key_size,
+	       __u32 value_size,
+	       __u32 max_entries,
+	       const struct bpf_map_create_opts *opts __maybe_unused)
+{
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+	return bpf_create_map(map_type, key_size, value_size, max_entries, 0);
+#pragma GCC diagnostic pop
+}
+
 static int bperf_lock_attr_map(struct target *target)
 {
 	char path[PATH_MAX];
@@ -320,10 +334,10 @@ static int bperf_lock_attr_map(struct target *target)
 	}
 
 	if (access(path, F_OK)) {
-		map_fd = bpf_create_map(BPF_MAP_TYPE_HASH,
+		map_fd = bpf_map_create(BPF_MAP_TYPE_HASH, NULL,
 					sizeof(struct perf_event_attr),
 					sizeof(struct perf_event_attr_map_entry),
-					ATTR_MAP_SIZE, 0);
+					ATTR_MAP_SIZE, NULL);
 		if (map_fd < 0)
 			return -1;
 
-- 
2.30.2

