Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0846D3C0BA
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 02:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389836AbfFKA45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 20:56:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52614 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388845AbfFKA44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 20:56:56 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5B0j9TZ024424
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 17:56:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=LivXNz16vzgUNvqfPpK+qDX89wmtrxuhnSP3Wutt4S0=;
 b=W1XOtyvXD2krByB1/ygXd1jz1Wj11lUU+EBeWo9p3lq/MbI6N3lrhAW6A6Aq+uWsRe3k
 KHHPuA8OnhDaWwiqRgyNco+AingwPpIkMCktRqCfLBVb2nW09xVSWFOIoLVklZ4I95nq
 Tu2+khL0csNAQ7zZjBCcL6alZinD5F6L+3U= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t1s632c9m-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 17:56:55 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 10 Jun 2019 17:56:54 -0700
Received: by devvm3632.prn2.facebook.com (Postfix, from userid 172007)
        id A49ABD0D72E6; Mon, 10 Jun 2019 17:56:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Hechao Li <hechaol@fb.com>
Smtp-Origin-Hostname: devvm3632.prn2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <kernel-team@fb.com>, Hechao Li <hechaol@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v6 bpf-next 3/3] bpf: use libbpf_num_possible_cpus internally
Date:   Mon, 10 Jun 2019 17:56:52 -0700
Message-ID: <20190611005652.3827331-4-hechaol@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611005652.3827331-1-hechaol@fb.com>
References: <20190611005652.3827331-1-hechaol@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-10_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=699 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the newly added bpf_num_possible_cpus() in bpftool and selftests
and remove duplicate implementations.

Signed-off-by: Hechao Li <hechaol@fb.com>
---
 tools/bpf/bpftool/common.c             | 53 +++-----------------------
 tools/testing/selftests/bpf/bpf_util.h | 37 +++---------------
 2 files changed, 10 insertions(+), 80 deletions(-)

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
diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selftests/bpf/bpf_util.h
index a29206ebbd13..ec219f84e041 100644
--- a/tools/testing/selftests/bpf/bpf_util.h
+++ b/tools/testing/selftests/bpf/bpf_util.h
@@ -6,44 +6,17 @@
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
+#include <libbpf.h> /* libbpf_num_possible_cpus */
 
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
 
-- 
2.17.1

