Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48FFFD867C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390991AbfJPDaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:30:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26290 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389388AbfJPDaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:30:13 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G3UCWF017192
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:30:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=yyfctYuvmYXkots3Jg3Z8Cn8OulDY1k0HKGvHoC1UtA=;
 b=ex67WJeKaSGlWqiV+a0GS5JJPKjsVXqgIdJzkx4wO61deCl6azEpCnnpQkxGKNWJ2Pdi
 WjBI6nXZ+clX+cOcp3KK/KijaotKOLTUcjFVAQNEhSrdrOCy3bctro9qhoNrh4QIMNkI
 mSoayJ+dEfxPa4e6RNrJsFY0ymmUsAZ1BmQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnf1wkn0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:30:11 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 15 Oct 2019 20:29:55 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 082AD861998; Tue, 15 Oct 2019 20:29:54 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 1/6] selftests/bpf: teach test_progs to cd into subdir
Date:   Tue, 15 Oct 2019 20:29:44 -0700
Message-ID: <20191016032949.1445888-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016032949.1445888-1-andriin@fb.com>
References: <20191016032949.1445888-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_01:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=8 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160030
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are building a bunch of "flavors" of test_progs, e.g., w/ alu32 flag
for Clang when building BPF object. test_progs setup is relying on
having all the BPF object files and extra resources to be available in
current working directory, though. But we actually build all these files
into a separate sub-directory. Next set of patches establishes
convention of naming "flavored" test_progs (and test runner binaries in
general) as test_progs-flavor (e.g., test_progs-alu32), for each such
extra flavor. This patch teaches test_progs binary to automatically
detect its own extra flavor based on its argv[0], and if present, to
change current directory to a flavor-specific subdirectory.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 33 +++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index af75a1c7a458..c7e52f4194e2 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -306,7 +306,7 @@ void *spin_lock_thread(void *arg)
 }
 
 /* extern declarations for test funcs */
-#define DEFINE_TEST(name) extern void test_##name();
+#define DEFINE_TEST(name) extern void test_##name(void);
 #include <prog_tests/tests.h>
 #undef DEFINE_TEST
 
@@ -518,6 +518,33 @@ static void stdio_restore(void)
 #endif
 }
 
+/*
+ * Determine if test_progs is running as a "flavored" test runner and switch
+ * into corresponding sub-directory to load correct BPF objects.
+ *
+ * This is done by looking at executable name. If it contains "-flavor"
+ * suffix, then we are running as a flavored test runner.
+ */
+int cd_flavor_subdir(const char *exec_name)
+{
+	/* General form of argv[0] passed here is:
+	 * some/path/to/test_progs[-flavor], where -flavor part is optional.
+	 * First cut out "test_progs[-flavor]" part, then extract "flavor"
+	 * part, if it's there.
+	 */
+	const char *flavor = strrchr(exec_name, '/');
+
+	if (!flavor)
+		return 0;
+	flavor++;
+	flavor = strrchr(flavor, '-');
+	if (!flavor)
+		return 0;
+	flavor++;
+	printf("Switching to flavor '%s' subdirectory...\n", flavor);
+	return chdir(flavor);
+}
+
 int main(int argc, char **argv)
 {
 	static const struct argp argp = {
@@ -531,6 +558,10 @@ int main(int argc, char **argv)
 	if (err)
 		return err;
 
+	err = cd_flavor_subdir(argv[0]);
+	if (err)
+		return err;
+
 	libbpf_set_print(libbpf_print_fn);
 
 	srand(time(NULL));
-- 
2.17.1

