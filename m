Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5430F1D5D4A
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 02:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgEPAk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 20:40:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15898 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727805AbgEPAk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 20:40:27 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04G0ZeWd011390
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 17:40:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=tVFu8qef+B9U3NpS42uoEd9ioQ9gOfDj5dMAO7KW3LE=;
 b=C7WCJU6SGL0xGDIfigxv0EfX31a9I29eHVjNyKDhVJ8wfqGRPzFIt/Owyxow06HrjOnn
 ZVs5M0G01MYIuqEL6ZORltMIcqwNosU41qbQALgdE9iD/B5b6WbHZHm+QO6qaZ0HdC2i
 0QRGESuONC2AC0DjDoLwcnY3VjK/ba1dZq8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x7d2nh-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 17:40:26 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 15 May 2020 17:40:24 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0DE6A2EC39B6; Fri, 15 May 2020 17:40:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH 5.4 1/2] libbpf: Extract and generalize CPU mask parsing logic
Date:   Fri, 15 May 2020 17:40:16 -0700
Message-ID: <20200516004018.3500869-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 cotscore=-2147483648 lowpriorityscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005160003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 6803ee25f0ead1e836808acb14396bb9a9849113 upstream

This logic is re-used for parsing a set of online CPUs. Having it as an
isolated piece of code working with input string makes it conveninent to =
test
this logic as well. While refactoring, also improve the robustness of ori=
ginal
implementation.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191212013548.1690564-1-andriin@fb.com
---
 tools/lib/bpf/libbpf.c          | 126 +++++++++++++++++++++-----------
 tools/lib/bpf/libbpf_internal.h |   2 +
 2 files changed, 86 insertions(+), 42 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b6403712c2f4..281cc65276e0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5905,62 +5905,104 @@ void bpf_program__bpil_offs_to_addr(struct bpf_p=
rog_info_linear *info_linear)
 	}
 }
=20
-int libbpf_num_possible_cpus(void)
+int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz)
 {
-	static const char *fcpu =3D "/sys/devices/system/cpu/possible";
-	int len =3D 0, n =3D 0, il =3D 0, ir =3D 0;
-	unsigned int start =3D 0, end =3D 0;
-	int tmp_cpus =3D 0;
-	static int cpus;
-	char buf[128];
-	int error =3D 0;
-	int fd =3D -1;
+	int err =3D 0, n, len, start, end =3D -1;
+	bool *tmp;
=20
-	tmp_cpus =3D READ_ONCE(cpus);
-	if (tmp_cpus > 0)
-		return tmp_cpus;
+	*mask =3D NULL;
+	*mask_sz =3D 0;
+
+	/* Each sub string separated by ',' has format \d+-\d+ or \d+ */
+	while (*s) {
+		if (*s =3D=3D ',' || *s =3D=3D '\n') {
+			s++;
+			continue;
+		}
+		n =3D sscanf(s, "%d%n-%d%n", &start, &len, &end, &len);
+		if (n <=3D 0 || n > 2) {
+			pr_warning("Failed to get CPU range %s: %d\n", s, n);
+			err =3D -EINVAL;
+			goto cleanup;
+		} else if (n =3D=3D 1) {
+			end =3D start;
+		}
+		if (start < 0 || start > end) {
+			pr_warning("Invalid CPU range [%d,%d] in %s\n",
+				   start, end, s);
+			err =3D -EINVAL;
+			goto cleanup;
+		}
+		tmp =3D realloc(*mask, end + 1);
+		if (!tmp) {
+			err =3D -ENOMEM;
+			goto cleanup;
+		}
+		*mask =3D tmp;
+		memset(tmp + *mask_sz, 0, start - *mask_sz);
+		memset(tmp + start, 1, end - start + 1);
+		*mask_sz =3D end + 1;
+		s +=3D len;
+	}
+	if (!*mask_sz) {
+		pr_warning("Empty CPU range\n");
+		return -EINVAL;
+	}
+	return 0;
+cleanup:
+	free(*mask);
+	*mask =3D NULL;
+	return err;
+}
+
+int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
+{
+	int fd, err =3D 0, len;
+	char buf[128];
=20
 	fd =3D open(fcpu, O_RDONLY);
 	if (fd < 0) {
-		error =3D errno;
-		pr_warning("Failed to open file %s: %s\n",
-			   fcpu, strerror(error));
-		return -error;
+		err =3D -errno;
+		pr_warning("Failed to open cpu mask file %s: %d\n", fcpu, err);
+		return err;
 	}
 	len =3D read(fd, buf, sizeof(buf));
 	close(fd);
 	if (len <=3D 0) {
-		error =3D len ? errno : EINVAL;
-		pr_warning("Failed to read # of possible cpus from %s: %s\n",
-			   fcpu, strerror(error));
-		return -error;
+		err =3D len ? -errno : -EINVAL;
+		pr_warning("Failed to read cpu mask from %s: %d\n", fcpu, err);
+		return err;
 	}
-	if (len =3D=3D sizeof(buf)) {
-		pr_warning("File %s size overflow\n", fcpu);
-		return -EOVERFLOW;
+	if (len >=3D sizeof(buf)) {
+		pr_warning("CPU mask is too big in file %s\n", fcpu);
+		return -E2BIG;
 	}
 	buf[len] =3D '\0';
=20
-	for (ir =3D 0, tmp_cpus =3D 0; ir <=3D len; ir++) {
-		/* Each sub string separated by ',' has format \d+-\d+ or \d+ */
-		if (buf[ir] =3D=3D ',' || buf[ir] =3D=3D '\0') {
-			buf[ir] =3D '\0';
-			n =3D sscanf(&buf[il], "%u-%u", &start, &end);
-			if (n <=3D 0) {
-				pr_warning("Failed to get # CPUs from %s\n",
-					   &buf[il]);
-				return -EINVAL;
-			} else if (n =3D=3D 1) {
-				end =3D start;
-			}
-			tmp_cpus +=3D end - start + 1;
-			il =3D ir + 1;
-		}
-	}
-	if (tmp_cpus <=3D 0) {
-		pr_warning("Invalid #CPUs %d from %s\n", tmp_cpus, fcpu);
-		return -EINVAL;
+	return parse_cpu_mask_str(buf, mask, mask_sz);
+}
+
+int libbpf_num_possible_cpus(void)
+{
+	static const char *fcpu =3D "/sys/devices/system/cpu/possible";
+	static int cpus;
+	int err, n, i, tmp_cpus;
+	bool *mask;
+
+	tmp_cpus =3D READ_ONCE(cpus);
+	if (tmp_cpus > 0)
+		return tmp_cpus;
+
+	err =3D parse_cpu_mask_file(fcpu, &mask, &n);
+	if (err)
+		return err;
+
+	tmp_cpus =3D 0;
+	for (i =3D 0; i < n; i++) {
+		if (mask[i])
+			tmp_cpus++;
 	}
+	free(mask);
=20
 	WRITE_ONCE(cpus, tmp_cpus);
 	return tmp_cpus;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index 98216a69c32f..92940ae26ada 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -63,6 +63,8 @@ do {				\
 #define pr_info(fmt, ...)	__pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
 #define pr_debug(fmt, ...)	__pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
=20
+int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz);
+int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz);
 int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
 			 const char *str_sec, size_t str_len);
=20
--=20
2.24.1

