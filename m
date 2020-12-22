Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C242E0F20
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 20:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgLVTy0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Dec 2020 14:54:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11720 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgLVTy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 14:54:26 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BMJo9jc018203
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 11:53:45 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0e866du-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 11:53:45 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Dec 2020 11:53:42 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E0FBB2ECBD59; Tue, 22 Dec 2020 11:53:38 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf] selftests/bpf: work-around EBUSY errors from hashmap update/delete
Date:   Tue, 22 Dec 2020 11:53:37 -0800
Message-ID: <20201222195337.2175297-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_10:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 clxscore=1034 mlxscore=0 phishscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012220144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked") introduced
a possibility of getting EBUSY error on lock contention, which seems to happen
very deterministically in test_maps when running 1024 threads on low-CPU
machine. In libbpf CI case, it's a 2 CPU VM and it's hitting this 100% of the
time. Work around by retrying on EBUSY (and EAGAIN, while we are at it) after
a small sleep. sched_yield() is too agressive and fails even after 20 retries,
so I went with usleep(1) for backoff.

Also log actual error returned to make it easier to see what's going on.

Fixes: 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked")
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/test_maps.c | 46 +++++++++++++++++++++----
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 0ad3e6305ff0..809004f4995f 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1312,22 +1312,56 @@ static void test_map_stress(void)
 #define DO_UPDATE 1
 #define DO_DELETE 0
 
+static int map_update_retriable(int map_fd, const void *key, const void *value,
+				int flags, int attempts)
+{
+	while (bpf_map_update_elem(map_fd, key, value, flags)) {
+		if (!attempts || (errno != EAGAIN && errno != EBUSY))
+			return -errno;
+
+		usleep(1);
+		attempts--;
+	}
+
+	return 0;
+}
+
+static int map_delete_retriable(int map_fd, const void *key, int attempts)
+{
+	while (bpf_map_delete_elem(map_fd, key)) {
+		if (!attempts || (errno != EAGAIN && errno != EBUSY))
+			return -errno;
+
+		usleep(1);
+		attempts--;
+	}
+
+	return 0;
+}
+
 static void test_update_delete(unsigned int fn, void *data)
 {
 	int do_update = ((int *)data)[1];
 	int fd = ((int *)data)[0];
-	int i, key, value;
+	int i, key, value, err;
 
 	for (i = fn; i < MAP_SIZE; i += TASKS) {
 		key = value = i;
 
 		if (do_update) {
-			assert(bpf_map_update_elem(fd, &key, &value,
-						   BPF_NOEXIST) == 0);
-			assert(bpf_map_update_elem(fd, &key, &value,
-						   BPF_EXIST) == 0);
+			err = map_update_retriable(fd, &key, &value, BPF_NOEXIST, 20);
+			if (err)
+				printf("error %d %d\n", err, errno);
+			assert(err == 0);
+			err = map_update_retriable(fd, &key, &value, BPF_EXIST, 20);
+			if (err)
+				printf("error %d %d\n", err, errno);
+			assert(err == 0);
 		} else {
-			assert(bpf_map_delete_elem(fd, &key) == 0);
+			err = map_delete_retriable(fd, &key, 5);
+			if (err)
+				printf("error %d %d\n", err, errno);
+			assert(err == 0);
 		}
 	}
 }
-- 
2.24.1

