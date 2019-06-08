Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED70139A1D
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 04:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfFHCTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 22:19:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56276 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729127AbfFHCTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 22:19:30 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x582JSvD030663
        for <netdev@vger.kernel.org>; Fri, 7 Jun 2019 19:19:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=JAPCKA0R8tL6UkusETQOmWNXdhzvUUva1T6aCN6wi/E=;
 b=qLZbpXc+ASIpLpnXiYlPfW5/3t2iCOOFvryxqeMV0uE9g2YYatqrxzBzJcjTebc5HDuy
 RF/fnMMgynMjEEuPEyIJxN5ZoekfmEddDfyqIuiF3dmuAoHiGgX46oHZVmMfD/h0LwXX
 pmKiUZj0fhU+tGVa+cewWHXSc/GCq38Kwpo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t00xjresc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 19:19:29 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 7 Jun 2019 19:19:27 -0700
Received: by devvm3632.prn2.facebook.com (Postfix, from userid 172007)
        id 59AF5CE318F8; Fri,  7 Jun 2019 19:19:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Hechao Li <hechaol@fb.com>
Smtp-Origin-Hostname: devvm3632.prn2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <kernel-team@fb.com>, Hechao Li <hechaol@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 2/2] bpf: use libbpf_num_possible_cpus
Date:   Fri, 7 Jun 2019 19:19:25 -0700
Message-ID: <20190608021925.4060095-3-hechaol@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608021925.4060095-1-hechaol@fb.com>
References: <20190608021925.4060095-1-hechaol@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080015
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the newly added bpf_num_possible_cpus() in bpftool and selftests
and remove duplicate implementations.

This patch also removed bpf_util.h from some test BPF programs
since it is a userspace utility.

Signed-off-by: Hechao Li <hechaol@fb.com>
---
 tools/bpf/bpftool/common.c                    | 53 ++-----------------
 tools/testing/selftests/bpf/bpf_endian.h      |  1 +
 tools/testing/selftests/bpf/bpf_util.h        | 37 ++-----------
 .../selftests/bpf/progs/sockmap_parse_prog.c  |  1 -
 .../bpf/progs/sockmap_tcp_msg_prog.c          |  2 +-
 .../bpf/progs/sockmap_verdict_prog.c          |  1 -
 .../selftests/bpf/progs/test_sysctl_prog.c    |  5 +-
 7 files changed, 16 insertions(+), 84 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index f7261fad45c1..5215e0870bcb 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -21,6 +21,7 @@
 #include <sys/vfs.h>
 
 #include <bpf.h>
+#include <libbpf.h> /* libbpf_num_possible_cpus */
 
 #include "main.h"
 
@@ -439,57 +440,13 @@ unsigned int get_page_size(void)
 
 unsigned int get_possible_cpus(void)
 {
-	static unsigned int result;
-	char buf[128];
-	long int n;
-	char *ptr;
-	int fd;
-
-	if (result)
-		return result;
-
-	fd = open("/sys/devices/system/cpu/possible", O_RDONLY);
-	if (fd < 0) {
-		p_err("can't open sysfs possible cpus");
-		exit(-1);
-	}
-
-	n = read(fd, buf, sizeof(buf));
-	if (n < 2) {
-		p_err("can't read sysfs possible cpus");
-		exit(-1);
-	}
-	close(fd);
+	int cpus = libbpf_num_possible_cpus();
 
-	if (n == sizeof(buf)) {
-		p_err("read sysfs possible cpus overflow");
+	if (cpus < 0) {
+		p_err("Can't get # of possible cpus: %s", strerror(-cpus));
 		exit(-1);
 	}
-
-	ptr = buf;
-	n = 0;
-	while (*ptr && *ptr != '\n') {
-		unsigned int a, b;
-
-		if (sscanf(ptr, "%u-%u", &a, &b) == 2) {
-			n += b - a + 1;
-
-			ptr = strchr(ptr, '-') + 1;
-		} else if (sscanf(ptr, "%u", &a) == 1) {
-			n++;
-		} else {
-			assert(0);
-		}
-
-		while (isdigit(*ptr))
-			ptr++;
-		if (*ptr == ',')
-			ptr++;
-	}
-
-	result = n;
-
-	return result;
+	return cpus;
 }
 
 static char *
diff --git a/tools/testing/selftests/bpf/bpf_endian.h b/tools/testing/selftests/bpf/bpf_endian.h
index b25595ea4a78..05f036df8a4c 100644
--- a/tools/testing/selftests/bpf/bpf_endian.h
+++ b/tools/testing/selftests/bpf/bpf_endian.h
@@ -2,6 +2,7 @@
 #ifndef __BPF_ENDIAN__
 #define __BPF_ENDIAN__
 
+#include <linux/stddef.h>
 #include <linux/swab.h>
 
 /* LLVM's BPF target selects the endianness of the CPU
diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selftests/bpf/bpf_util.h
index a29206ebbd13..6231eafd4a5a 100644
--- a/tools/testing/selftests/bpf/bpf_util.h
+++ b/tools/testing/selftests/bpf/bpf_util.h
@@ -6,44 +6,17 @@
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
+#include <libbpf.h>
 
 static inline unsigned int bpf_num_possible_cpus(void)
 {
-	static const char *fcpu = "/sys/devices/system/cpu/possible";
-	unsigned int start, end, possible_cpus = 0;
-	char buff[128];
-	FILE *fp;
-	int len, n, i, j = 0;
+	int possible_cpus = libbpf_num_possible_cpus();
 
-	fp = fopen(fcpu, "r");
-	if (!fp) {
-		printf("Failed to open %s: '%s'!\n", fcpu, strerror(errno));
+	if (possible_cpus < 0) {
+		printf("Failed to get # of possible cpus: '%s'!\n",
+		       strerror(-possible_cpus));
 		exit(1);
 	}
-
-	if (!fgets(buff, sizeof(buff), fp)) {
-		printf("Failed to read %s!\n", fcpu);
-		exit(1);
-	}
-
-	len = strlen(buff);
-	for (i = 0; i <= len; i++) {
-		if (buff[i] == ',' || buff[i] == '\0') {
-			buff[i] = '\0';
-			n = sscanf(&buff[j], "%u-%u", &start, &end);
-			if (n <= 0) {
-				printf("Failed to retrieve # possible CPUs!\n");
-				exit(1);
-			} else if (n == 1) {
-				end = start;
-			}
-			possible_cpus += end - start + 1;
-			j = i + 1;
-		}
-	}
-
-	fclose(fp);
-
 	return possible_cpus;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
index ed3e4a551c57..9390e0244259 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
@@ -1,6 +1,5 @@
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
-#include "bpf_util.h"
 #include "bpf_endian.h"
 
 int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
index 65fbfdb6cd3a..e80484d98a1a 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
@@ -1,6 +1,6 @@
 #include <linux/bpf.h>
+
 #include "bpf_helpers.h"
-#include "bpf_util.h"
 #include "bpf_endian.h"
 
 int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
index bdc22be46f2e..d85c874ef25e 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
@@ -1,6 +1,5 @@
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
-#include "bpf_util.h"
 #include "bpf_endian.h"
 
 int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
index a295cad805d7..5cbbff416998 100644
--- a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
+++ b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
@@ -8,7 +8,6 @@
 #include <linux/bpf.h>
 
 #include "bpf_helpers.h"
-#include "bpf_util.h"
 
 /* Max supported length of a string with unsigned long in base 10 (pow2 - 1). */
 #define MAX_ULONG_STR_LEN 0xF
@@ -16,6 +15,10 @@
 /* Max supported length of sysctl value string (pow2). */
 #define MAX_VALUE_STR_LEN 0x40
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#endif
+
 static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
 {
 	char tcp_mem_name[] = "net/ipv4/tcp_mem";
-- 
2.17.1

