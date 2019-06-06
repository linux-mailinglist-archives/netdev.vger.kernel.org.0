Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80ED937D57
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 21:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfFFTjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 15:39:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57106 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbfFFTjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 15:39:55 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56Jbtnu000661
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 12:39:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=2vhxn1Z5C6mcXvCbtZO7iykmxbEzJx5ZYlgxEecbM+E=;
 b=Mek0zok6cLKVpECPRGgFvMapc9BpMQSmqRJwjlZHbHlT76HtwZWIVVEK1c2rDV9b82KH
 JTofqleIfwTvXrqx+gs+sX/TT5tmS63kYMzIAe1jsu4zlm+4rHxDjuWpyC5WTGw2nzlr
 iTtQ4E2UfQCCpLTaUB6c2FHULmtswgeaLDg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy6mj0p97-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 12:39:53 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 12:39:51 -0700
Received: by devvm3632.prn2.facebook.com (Postfix, from userid 172007)
        id 6F749CCF256C; Thu,  6 Jun 2019 12:39:49 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Hechao Li <hechaol@fb.com>
Smtp-Origin-Hostname: devvm3632.prn2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, Hechao Li <hechaol@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 1/2] bpf: add a new API libbpf_num_possible_cpus()
Date:   Thu, 6 Jun 2019 12:39:26 -0700
Message-ID: <20190606193927.2489147-2-hechaol@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606193927.2489147-1-hechaol@fb.com>
References: <20190606193927.2489147-1-hechaol@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=729 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060131
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding a new API libbpf_num_possible_cpus() that helps user with
per-CPU map operations.

Signed-off-by: Hechao Li <hechaol@fb.com>
---
 tools/lib/bpf/libbpf.c   | 57 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   | 16 +++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 74 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ba89d9727137..06497c8a3372 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3827,3 +3827,60 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
 					     desc->array_offset, addr);
 	}
 }
+
+int libbpf_num_possible_cpus(void)
+{
+	static const char *fcpu = "/sys/devices/system/cpu/possible";
+	int len = 0, n = 0, il = 0, ir = 0;
+	unsigned int start = 0, end = 0;
+	static int cpus;
+	char buf[128];
+	int error = 0;
+	int fd = -1;
+
+	if (cpus > 0)
+		return cpus;
+
+	fd = open(fcpu, O_RDONLY);
+	if (fd < 0) {
+		error = errno;
+		pr_warning("Failed to open file %s: %s\n",
+			   fcpu, strerror(error));
+		return -error;
+	}
+	len = read(fd, buf, sizeof(buf));
+	close(fd);
+	if (len <= 0) {
+		error = errno;
+		pr_warning("Failed to read # of possible cpus from %s: %s\n",
+			   fcpu, strerror(error));
+		return -error;
+	}
+	if (len == sizeof(buf)) {
+		pr_warning("File %s size overflow\n", fcpu);
+		return -EOVERFLOW;
+	}
+	buf[len] = '\0';
+
+	for (ir = 0, cpus = 0; ir <= len; ir++) {
+		/* Each sub string separated by ',' has format \d+-\d+ or \d+ */
+		if (buf[ir] == ',' || buf[ir] == '\0') {
+			buf[ir] = '\0';
+			n = sscanf(&buf[il], "%u-%u", &start, &end);
+			if (n <= 0) {
+				pr_warning("Failed to get # CPUs from %s\n",
+					   &buf[il]);
+				return -EINVAL;
+			} else if (n == 1) {
+				end = start;
+			}
+			cpus += end - start + 1;
+			il = ir + 1;
+		}
+	}
+	if (cpus <= 0) {
+		pr_warning("Invalid #CPUs %d from %s\n", cpus, fcpu);
+		return -EINVAL;
+	}
+	return cpus;
+}
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 1af0d48178c8..f5e82eb2e5d4 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -454,6 +454,22 @@ bpf_program__bpil_addr_to_offs(struct bpf_prog_info_linear *info_linear);
 LIBBPF_API void
 bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear);
 
+/*
+ * A helper function to get the number of possible CPUs before looking up
+ * per-CPU maps. Negative errno is returned on failure.
+ *
+ * Example usage:
+ *
+ *     int ncpus = libbpf_num_possible_cpus();
+ *     if (ncpus <= 0) {
+ *          // error handling
+ *     }
+ *     long values[ncpus];
+ *     bpf_map_lookup_elem(per_cpu_map_fd, key, values);
+ *
+ */
+LIBBPF_API int libbpf_num_possible_cpus(void);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 46dcda89df21..2c6d835620d2 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -172,4 +172,5 @@ LIBBPF_0.0.4 {
 		btf_dump__new;
 		btf__parse_elf;
 		bpf_object__load_xattr;
+		libbpf_num_possible_cpus;
 } LIBBPF_0.0.3;
-- 
2.17.1

