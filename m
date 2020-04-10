Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE36C1A4B1F
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 22:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgDJU0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 16:26:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11794 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbgDJU0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 16:26:22 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03AK4eTd006618
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 13:26:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=AmOehHkFe47Up9j/G32cYOeOo1Sg880vEf55YJzV1n8=;
 b=mK7Jo6FPBLdHvOdSjp9Pcda8D+k359IJJc7WDaZ0+VGpGJ3A2artxTWfd26Jmjn5qrmz
 drX7/mH8Zdhgoq3fwhnxV+a+LMmf/4mEeZ81essjGo2inNRWX/PdceJPE4fhf1PQcoI+
 XVHO+XEUWDpryCQ5a5UJMQMuC9rVt+Af3RQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3091n49kca-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 13:26:21 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 13:26:20 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 11F492EC2343; Fri, 10 Apr 2020 13:26:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf 2/2] selftests/bpf: validate frozen map contents stays frozen
Date:   Fri, 10 Apr 2020 13:26:13 -0700
Message-ID: <20200410202613.3679837-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200410202613.3679837-1-andriin@fb.com>
References: <20200410202613.3679837-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_08:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=9 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 mlxlogscore=853
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that frozen and mmap()'ed BPF map can't be mprotect()'ed as writable=
 or
executable memory. Also validate that "downgrading" from writable to read=
-only
doesn't screw up internal writable count accounting for the purposes of m=
ap
freezing.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/mmap.c | 62 ++++++++++++++++++-
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testin=
g/selftests/bpf/prog_tests/mmap.c
index 16a814eb4d64..56d80adcf4bd 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -19,15 +19,16 @@ void test_mmap(void)
 	const size_t map_sz =3D roundup_page(sizeof(struct map_data));
 	const int zero =3D 0, one =3D 1, two =3D 2, far =3D 1500;
 	const long page_size =3D sysconf(_SC_PAGE_SIZE);
-	int err, duration =3D 0, i, data_map_fd;
+	int err, duration =3D 0, i, data_map_fd, data_map_id, tmp_fd;
 	struct bpf_map *data_map, *bss_map;
 	void *bss_mmaped =3D NULL, *map_mmaped =3D NULL, *tmp1, *tmp2;
 	struct test_mmap__bss *bss_data;
+	struct bpf_map_info map_info;
+	__u32 map_info_sz =3D sizeof(map_info);
 	struct map_data *map_data;
 	struct test_mmap *skel;
 	__u64 val =3D 0;
=20
-
 	skel =3D test_mmap__open_and_load();
 	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
 		return;
@@ -36,6 +37,14 @@ void test_mmap(void)
 	data_map =3D skel->maps.data_map;
 	data_map_fd =3D bpf_map__fd(data_map);
=20
+	/* get map's ID */
+	memset(&map_info, 0, map_info_sz);
+	err =3D bpf_obj_get_info_by_fd(data_map_fd, &map_info, &map_info_sz);
+	if (CHECK(err, "map_get_info", "failed %d\n", errno))
+		goto cleanup;
+	data_map_id =3D map_info.id;
+
+	/* mmap BSS map */
 	bss_mmaped =3D mmap(NULL, bss_sz, PROT_READ | PROT_WRITE, MAP_SHARED,
 			  bpf_map__fd(bss_map), 0);
 	if (CHECK(bss_mmaped =3D=3D MAP_FAILED, "bss_mmap",
@@ -98,6 +107,10 @@ void test_mmap(void)
 		  "data_map freeze succeeded: err=3D%d, errno=3D%d\n", err, errno))
 		goto cleanup;
=20
+	err =3D mprotect(map_mmaped, map_sz, PROT_READ);
+	if (CHECK(err, "mprotect_ro", "mprotect to r/o failed %d\n", errno))
+		goto cleanup;
+
 	/* unmap R/W mapping */
 	err =3D munmap(map_mmaped, map_sz);
 	map_mmaped =3D NULL;
@@ -111,6 +124,12 @@ void test_mmap(void)
 		map_mmaped =3D NULL;
 		goto cleanup;
 	}
+	err =3D mprotect(map_mmaped, map_sz, PROT_WRITE);
+	if (CHECK(!err, "mprotect_wr", "mprotect() succeeded unexpectedly!\n"))
+		goto cleanup;
+	err =3D mprotect(map_mmaped, map_sz, PROT_EXEC);
+	if (CHECK(!err, "mprotect_ex", "mprotect() succeeded unexpectedly!\n"))
+		goto cleanup;
 	map_data =3D map_mmaped;
=20
 	/* map/unmap in a loop to test ref counting */
@@ -197,6 +216,45 @@ void test_mmap(void)
 	CHECK_FAIL(map_data->val[far] !=3D 3 * 321);
=20
 	munmap(tmp2, 4 * page_size);
+
+	tmp1 =3D mmap(NULL, map_sz, PROT_READ, MAP_SHARED, data_map_fd, 0);
+	if (CHECK(tmp1 =3D=3D MAP_FAILED, "last_mmap", "failed %d\n", errno))
+		goto cleanup;
+
+	test_mmap__destroy(skel);
+	skel =3D NULL;
+	CHECK_FAIL(munmap(bss_mmaped, bss_sz));
+	bss_mmaped =3D NULL;
+	CHECK_FAIL(munmap(map_mmaped, map_sz));
+	map_mmaped =3D NULL;
+
+	/* map should be still held by active mmap */
+	tmp_fd =3D bpf_map_get_fd_by_id(data_map_id);
+	if (CHECK(tmp_fd < 0, "get_map_by_id", "failed %d\n", errno)) {
+		munmap(tmp1, map_sz);
+		goto cleanup;
+	}
+	close(tmp_fd);
+
+	/* this should release data map finally */
+	munmap(tmp1, map_sz);
+
+	/* we need to wait for RCU grace period */
+	for (i =3D 0; i < 10000; i++) {
+		__u32 id =3D data_map_id - 1;
+		if (bpf_map_get_next_id(id, &id) || id > data_map_id)
+			break;
+		usleep(1);
+	}
+
+	/* should fail to get map FD by non-existing ID */
+	tmp_fd =3D bpf_map_get_fd_by_id(data_map_id);
+	if (CHECK(tmp_fd >=3D 0, "get_map_by_id_after",
+		  "unexpectedly succeeded %d\n", tmp_fd)) {
+		close(tmp_fd);
+		goto cleanup;
+	}
+
 cleanup:
 	if (bss_mmaped)
 		CHECK_FAIL(munmap(bss_mmaped, bss_sz));
--=20
2.24.1

