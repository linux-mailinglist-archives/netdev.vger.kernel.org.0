Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2694811C244
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfLLBfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:35:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31286 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727443AbfLLBfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 20:35:52 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBC1YVj4014553
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:35:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=5uVyFbxWLn+DjEMtv7vHngj4BpQRkPrQTgKPpt8tp7A=;
 b=Zg9L3DvYu5UhRgVtNC8ZPd0gGUV6lzNp2KM5Tnf44Ewzp7WA8FaGnsHvlQ05WwjDy384
 A9o15JjC7wY96tYwGxXrkm9rri8IkTIeOTk+jmyld5wjM864lKMFKH8Ye7irvZaFwEda
 NhlaKdiig1eFTDtS3K+CQWVF9Yoeeoikuv0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu2gf2p7y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:35:51 -0800
Received: from intmgw005.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 11 Dec 2019 17:35:50 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B85592EC1A0E; Wed, 11 Dec 2019 17:35:49 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/4] libbpf: extract and generalize CPU mask parsing logic
Date:   Wed, 11 Dec 2019 17:35:48 -0800
Message-ID: <20191212013548.1690564-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=25 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxlogscore=933 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912120004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This logic is re-used for parsing a set of online CPUs. Having it as an
isolated piece of code working with input string makes it conveninent to test
this logic as well. While refactoring, also improve the robustness of original
implementation.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c          | 125 +++++++++++++++++++++-----------
 tools/lib/bpf/libbpf_internal.h |   2 +
 2 files changed, 86 insertions(+), 41 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3f09772192f1..b761d8636026 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6521,61 +6521,104 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
 	}
 }
 
-int libbpf_num_possible_cpus(void)
+int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz)
 {
-	static const char *fcpu = "/sys/devices/system/cpu/possible";
-	int len = 0, n = 0, il = 0, ir = 0;
-	unsigned int start = 0, end = 0;
-	int tmp_cpus = 0;
-	static int cpus;
-	char buf[128];
-	int error = 0;
-	int fd = -1;
+	int err = 0, n, len, start, end = -1;
+	bool *tmp;
 
-	tmp_cpus = READ_ONCE(cpus);
-	if (tmp_cpus > 0)
-		return tmp_cpus;
+	*mask = NULL;
+	*mask_sz = 0;
+
+	/* Each sub string separated by ',' has format \d+-\d+ or \d+ */
+	while (*s) {
+		if (*s == ',' || *s == '\n') {
+			s++;
+			continue;
+		}
+		n = sscanf(s, "%d%n-%d%n", &start, &len, &end, &len);
+		if (n <= 0 || n > 2) {
+			pr_warn("Failed to get CPU range %s: %d\n", s, n);
+			err = -EINVAL;
+			goto cleanup;
+		} else if (n == 1) {
+			end = start;
+		}
+		if (start < 0 || start > end) {
+			pr_warn("Invalid CPU range [%d,%d] in %s\n",
+				start, end, s);
+			err = -EINVAL;
+			goto cleanup;
+		}
+		tmp = realloc(*mask, end + 1);
+		if (!tmp) {
+			err = -ENOMEM;
+			goto cleanup;
+		}
+		*mask = tmp;
+		memset(tmp + *mask_sz, 0, start - *mask_sz);
+		memset(tmp + start, 1, end - start + 1);
+		*mask_sz = end + 1;
+		s += len;
+	}
+	if (!*mask_sz) {
+		pr_warn("Empty CPU range\n");
+		return -EINVAL;
+	}
+	return 0;
+cleanup:
+	free(*mask);
+	*mask = NULL;
+	return err;
+}
+
+int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
+{
+	int fd, err = 0, len;
+	char buf[128];
 
 	fd = open(fcpu, O_RDONLY);
 	if (fd < 0) {
-		error = errno;
-		pr_warn("Failed to open file %s: %s\n", fcpu, strerror(error));
-		return -error;
+		err = -errno;
+		pr_warn("Failed to open cpu mask file %s: %d\n", fcpu, err);
+		return err;
 	}
 	len = read(fd, buf, sizeof(buf));
 	close(fd);
 	if (len <= 0) {
-		error = len ? errno : EINVAL;
-		pr_warn("Failed to read # of possible cpus from %s: %s\n",
-			fcpu, strerror(error));
-		return -error;
+		err = len ? -errno : -EINVAL;
+		pr_warn("Failed to read cpu mask from %s: %d\n", fcpu, err);
+		return err;
 	}
-	if (len == sizeof(buf)) {
-		pr_warn("File %s size overflow\n", fcpu);
-		return -EOVERFLOW;
+	if (len >= sizeof(buf)) {
+		pr_warn("CPU mask is too big in file %s\n", fcpu);
+		return -E2BIG;
 	}
 	buf[len] = '\0';
 
-	for (ir = 0, tmp_cpus = 0; ir <= len; ir++) {
-		/* Each sub string separated by ',' has format \d+-\d+ or \d+ */
-		if (buf[ir] == ',' || buf[ir] == '\0') {
-			buf[ir] = '\0';
-			n = sscanf(&buf[il], "%u-%u", &start, &end);
-			if (n <= 0) {
-				pr_warn("Failed to get # CPUs from %s\n",
-					&buf[il]);
-				return -EINVAL;
-			} else if (n == 1) {
-				end = start;
-			}
-			tmp_cpus += end - start + 1;
-			il = ir + 1;
-		}
-	}
-	if (tmp_cpus <= 0) {
-		pr_warn("Invalid #CPUs %d from %s\n", tmp_cpus, fcpu);
-		return -EINVAL;
+	return parse_cpu_mask_str(buf, mask, mask_sz);
+}
+
+int libbpf_num_possible_cpus(void)
+{
+	static const char *fcpu = "/sys/devices/system/cpu/possible";
+	static int cpus;
+	int err, n, i, tmp_cpus;
+	bool *mask;
+
+	tmp_cpus = READ_ONCE(cpus);
+	if (tmp_cpus > 0)
+		return tmp_cpus;
+
+	err = parse_cpu_mask_file(fcpu, &mask, &n);
+	if (err)
+		return err;
+
+	tmp_cpus = 0;
+	for (i = 0; i < n; i++) {
+		if (mask[i])
+			tmp_cpus++;
 	}
+	free(mask);
 
 	WRITE_ONCE(cpus, tmp_cpus);
 	return tmp_cpus;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 97ac17a64a58..f4f10715db40 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -95,6 +95,8 @@ static inline bool libbpf_validate_opts(const char *opts,
 #define OPTS_GET(opts, field, fallback_value) \
 	(OPTS_HAS(opts, field) ? (opts)->field : fallback_value)
 
+int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz);
+int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz);
 int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
 			 const char *str_sec, size_t str_len);
 
-- 
2.17.1

