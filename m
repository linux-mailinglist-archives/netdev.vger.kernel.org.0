Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067601D8F43
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgESFif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:38:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38982 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728286AbgESFif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 01:38:35 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04J5ZeNr027556
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 22:38:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=00xUswIbeRJGH5jsv7eXa569UtJ4s0JBcChANTcbHQo=;
 b=ZmrHplqIAx6Hnv+Z8CcgoSSn8NxJVoYXBf68HR45ElThLss6SAjTt40o8mPt2t2ZjVSN
 BWJkAnujEf9mrjO6OD/ykEF4t15u4dac8eX6bgNajzjh3xegLexfSz5NID/MpZUZcPkd
 xMtTksPVGaU+KkCrM58QoIS2qRGcot8ctT0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3130eun271-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 22:38:34 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 18 May 2020 22:38:33 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 723AB2EC35C1; Mon, 18 May 2020 22:38:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Jann Horn <jannh@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: prevent mmap()'ing read-only maps as writable
Date:   Mon, 18 May 2020 22:38:24 -0700
Message-ID: <20200519053824.1089415-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_01:2020-05-15,2020-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=685
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 cotscore=-2147483648 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed in [0], it's dangerous to allow mapping BPF map, that's mean=
t to
be frozen and is read-only on BPF program side, because that allows user-=
space
to actually store a writable view to the page even after it is frozen. Th=
is is
exacerbated by BPF verifier making a strong assumption that contents of s=
uch
frozen map will remain unchanged. To prevent this, disallow mapping
BPF_F_RDONLY_PROG mmap()'able BPF maps as writable, ever.

  [0] https://lore.kernel.org/bpf/CAEf4BzYGWYhXdp6BJ7_=3D9OQPJxQpgug080MM=
jdSB72i9R+5c6g@mail.gmail.com/

Suggested-by: Jann Horn <jannh@google.com>
Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/syscall.c                          | 17 ++++++++++++++---
 tools/testing/selftests/bpf/prog_tests/mmap.c | 13 ++++++++++++-
 tools/testing/selftests/bpf/progs/test_mmap.c |  8 ++++++++
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2843bbba9ca1..874bd247d527 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -623,9 +623,20 @@ static int bpf_map_mmap(struct file *filp, struct vm=
_area_struct *vma)
=20
 	mutex_lock(&map->freeze_mutex);
=20
-	if ((vma->vm_flags & VM_WRITE) && map->frozen) {
-		err =3D -EPERM;
-		goto out;
+	if (vma->vm_flags & VM_WRITE) {
+		if (map->frozen) {
+			err =3D -EPERM;
+			goto out;
+		}
+		/* map is meant to be read-only, so do not allow mapping as
+		 * writable, because it's possible to leak a writable page=20
+		 * reference and allows user-space to still modify it after
+		 * freezing, while verifier will assume contents do not change
+		 */
+		if (map->map_flags & BPF_F_RDONLY_PROG) {
+			err =3D -EACCES;
+			goto out;
+		}
 	}
=20
 	/* set default open/close callbacks */
diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testin=
g/selftests/bpf/prog_tests/mmap.c
index 6b9dce431d41..43d0b5578f46 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -19,7 +19,7 @@ void test_mmap(void)
 	const size_t map_sz =3D roundup_page(sizeof(struct map_data));
 	const int zero =3D 0, one =3D 1, two =3D 2, far =3D 1500;
 	const long page_size =3D sysconf(_SC_PAGE_SIZE);
-	int err, duration =3D 0, i, data_map_fd, data_map_id, tmp_fd;
+	int err, duration =3D 0, i, data_map_fd, data_map_id, tmp_fd, rdmap_fd;
 	struct bpf_map *data_map, *bss_map;
 	void *bss_mmaped =3D NULL, *map_mmaped =3D NULL, *tmp1, *tmp2;
 	struct test_mmap__bss *bss_data;
@@ -37,6 +37,17 @@ void test_mmap(void)
 	data_map =3D skel->maps.data_map;
 	data_map_fd =3D bpf_map__fd(data_map);
=20
+	rdmap_fd =3D bpf_map__fd(skel->maps.rdonly_map);
+	tmp1 =3D mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, rdmap_fd,=
 0);
+	if (CHECK(tmp1 !=3D MAP_FAILED, "rdonly_write_mmap", "unexpected succes=
s\n")) {
+		munmap(tmp1, 4096);
+		goto cleanup;
+	}
+	/* now double-check if it's mmap()'able at all */
+	tmp1 =3D mmap(NULL, 4096, PROT_READ, MAP_SHARED, rdmap_fd, 0);
+	if (CHECK(tmp1 =3D=3D MAP_FAILED, "rdonly_read_mmap", "failed: %d\n", e=
rrno))
+		goto cleanup;
+
 	/* get map's ID */
 	memset(&map_info, 0, map_info_sz);
 	err =3D bpf_obj_get_info_by_fd(data_map_fd, &map_info, &map_info_sz);
diff --git a/tools/testing/selftests/bpf/progs/test_mmap.c b/tools/testin=
g/selftests/bpf/progs/test_mmap.c
index 6239596cd14e..4eb42cff5fe9 100644
--- a/tools/testing/selftests/bpf/progs/test_mmap.c
+++ b/tools/testing/selftests/bpf/progs/test_mmap.c
@@ -7,6 +7,14 @@
=20
 char _license[] SEC("license") =3D "GPL";
=20
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 4096);
+	__uint(map_flags, BPF_F_MMAPABLE | BPF_F_RDONLY_PROG);
+	__type(key, __u32);
+	__type(value, char);
+} rdonly_map SEC(".maps");
+
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__uint(max_entries, 512 * 4); /* at least 4 pages of data */
--=20
2.24.1

