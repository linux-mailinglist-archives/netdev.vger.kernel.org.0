Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C5C217CD1
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 03:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgGHBxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 21:53:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1448 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729215AbgGHBxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 21:53:41 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0681oxmj022189
        for <netdev@vger.kernel.org>; Tue, 7 Jul 2020 18:53:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=uKe0Rqu/r8EUcwlq4+3OEpaNXECRyxw+e5bKJErRnsE=;
 b=QzcRe1DjlYYJE49Zv+h3nRyY6vgkOSynIKD4hps+eg57QBz2XmLSq8rz7oCtJPbRBBPS
 2uhPIAs2q5HR7Vw5naC3BaHHUUoxBR1aLdjhXAfDUX45L5pcX5LW3q7mbvlJuBG8FJP+
 Udbkl8NQga+bHnhwIdsgMnUgs01Zx8MV+KM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 324tug2v52-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 18:53:41 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 18:53:39 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 65EA52EC39F5; Tue,  7 Jul 2020 18:53:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Matthew Lim <matthewlim@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 5/6] libbpf: handle missing BPF_OBJ_GET_INFO_BY_FD gracefully in perf_buffer
Date:   Tue, 7 Jul 2020 18:53:17 -0700
Message-ID: <20200708015318.3827358-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200708015318.3827358-1-andriin@fb.com>
References: <20200708015318.3827358-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_15:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 priorityscore=1501 lowpriorityscore=0 suspectscore=9 clxscore=1015
 spamscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

perf_buffer__new() is relying on BPF_OBJ_GET_INFO_BY_FD availability for =
few
sanity checks. OBJ_GET_INFO for maps is actually much more recent feature=
 than
perf_buffer support itself, so this causes unnecessary problems on old ke=
rnels
before BPF_OBJ_GET_INFO_BY_FD was added.

This patch makes those sanity checks optional and just assumes best if co=
mmand
is not supported. If user specified something incorrectly (e.g., wrong ma=
p
type), kernel will reject it later anyway, except user won't get a nice
explanation as to why it failed. This seems like a good trade off for
supporting perf_buffer on old kernels.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b4f50d12f51f..6f86b57a7e24 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8587,7 +8587,7 @@ static struct perf_buffer *__perf_buffer__new(int m=
ap_fd, size_t page_cnt,
 					      struct perf_buffer_params *p)
 {
 	const char *online_cpus_file =3D "/sys/devices/system/cpu/online";
-	struct bpf_map_info map =3D {};
+	struct bpf_map_info map;
 	char msg[STRERR_BUFSIZE];
 	struct perf_buffer *pb;
 	bool *online =3D NULL;
@@ -8600,19 +8600,28 @@ static struct perf_buffer *__perf_buffer__new(int=
 map_fd, size_t page_cnt,
 		return ERR_PTR(-EINVAL);
 	}
=20
+	/* best-effort sanity checks */
+	memset(&map, 0, sizeof(map));
 	map_info_len =3D sizeof(map);
 	err =3D bpf_obj_get_info_by_fd(map_fd, &map, &map_info_len);
 	if (err) {
 		err =3D -errno;
-		pr_warn("failed to get map info for map FD %d: %s\n",
-			map_fd, libbpf_strerror_r(err, msg, sizeof(msg)));
-		return ERR_PTR(err);
-	}
-
-	if (map.type !=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY) {
-		pr_warn("map '%s' should be BPF_MAP_TYPE_PERF_EVENT_ARRAY\n",
-			map.name);
-		return ERR_PTR(-EINVAL);
+		/* if BPF_OBJ_GET_INFO_BY_FD is supported, will return
+		 * -EBADFD, -EFAULT, or -E2BIG on real error
+		 */
+		if (err !=3D -EINVAL) {
+			pr_warn("failed to get map info for map FD %d: %s\n",
+				map_fd, libbpf_strerror_r(err, msg, sizeof(msg)));
+			return ERR_PTR(err);
+		}
+		pr_debug("failed to get map info for FD %d; API not supported? Ignorin=
g...\n",
+			 map_fd);
+	} else {
+		if (map.type !=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY) {
+			pr_warn("map '%s' should be BPF_MAP_TYPE_PERF_EVENT_ARRAY\n",
+				map.name);
+			return ERR_PTR(-EINVAL);
+		}
 	}
=20
 	pb =3D calloc(1, sizeof(*pb));
@@ -8644,7 +8653,7 @@ static struct perf_buffer *__perf_buffer__new(int m=
ap_fd, size_t page_cnt,
 			err =3D pb->cpu_cnt;
 			goto error;
 		}
-		if (map.max_entries < pb->cpu_cnt)
+		if (map.max_entries && map.max_entries < pb->cpu_cnt)
 			pb->cpu_cnt =3D map.max_entries;
 	}
=20
--=20
2.24.1

