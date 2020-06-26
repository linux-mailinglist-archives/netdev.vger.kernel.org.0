Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E4620B7AF
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgFZR4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:56:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbgFZR4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:56:05 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QHtLdw023876
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:56:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kMpkHAoNoXcS35j6GdLuqJ6103rO+lrTGIWE9rdBsr4=;
 b=WTwL9b7LJ5KAvg7iBr7TJneY3F1s7HqcikHAPhoLSi/MZrXBKYexmdwvOxcI9b8QSq43
 6Mx1UCp2NtBAyC670Cjz0KdJQdtP4XygXkHTuR2X+8SEdgXvxTxhw/Rm6wk1UxYnTyDy
 QWbNlKm1pYkd4kfuHjYMVK6L1+Cvw84OOj8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0m6nxx-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:56:05 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 10:55:49 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id EA3EF2942E38; Fri, 26 Jun 2020 10:55:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 07/10] bpf: selftests: Restore netns after each test
Date:   Fri, 26 Jun 2020 10:55:45 -0700
Message-ID: <20200626175545.1462191-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626175501.1459961-1-kafai@fb.com>
References: <20200626175501.1459961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=38 mlxlogscore=779
 clxscore=1015 priorityscore=1501 mlxscore=0 cotscore=-2147483648
 malwarescore=0 spamscore=0 impostorscore=0 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is common for networking tests creating its netns and making its own
setting under this new netns (e.g. changing tcp sysctl).  If the test
forgot to restore to the original netns, it would affect the
result of other tests.

This patch saves the original netns at the beginning and then restores it
after every test.  Since the restore "setns()" is not expensive, it does =
it
on all tests without tracking if a test has created a new netns or not.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 21 +++++++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/sel=
ftests/bpf/test_progs.c
index 54fa5fa688ce..b521ce366381 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -121,6 +121,24 @@ static void reset_affinity() {
 	}
 }
=20
+static void save_netns(void)
+{
+	env.saved_netns_fd =3D open("/proc/self/ns/net", O_RDONLY);
+	if (env.saved_netns_fd =3D=3D -1) {
+		perror("open(/proc/self/ns/net)");
+		exit(-1);
+	}
+}
+
+static void restore_netns(void)
+{
+	if (setns(env.saved_netns_fd, CLONE_NEWNET) =3D=3D -1) {
+		stdio_restore();
+		perror("setns(CLONE_NEWNS)");
+		exit(-1);
+	}
+}
+
 void test__end_subtest()
 {
 	struct prog_test_def *test =3D env.test;
@@ -643,6 +661,7 @@ int main(int argc, char **argv)
 		return -1;
 	}
=20
+	save_netns();
 	stdio_hijack();
 	for (i =3D 0; i < prog_test_cnt; i++) {
 		struct prog_test_def *test =3D &prog_test_defs[i];
@@ -673,6 +692,7 @@ int main(int argc, char **argv)
 			test->error_cnt ? "FAIL" : "OK");
=20
 		reset_affinity();
+		restore_netns();
 		if (test->need_cgroup_cleanup)
 			cleanup_cgroup_environment();
 	}
@@ -686,6 +706,7 @@ int main(int argc, char **argv)
 	free_str_set(&env.subtest_selector.blacklist);
 	free_str_set(&env.subtest_selector.whitelist);
 	free(env.subtest_selector.num_set);
+	close(env.saved_netns_fd);
=20
 	return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
 }
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/sel=
ftests/bpf/test_progs.h
index f4503c926aca..b80924603918 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -78,6 +78,8 @@ struct test_env {
 	int sub_succ_cnt; /* successful sub-tests */
 	int fail_cnt; /* total failed tests + sub-tests */
 	int skip_cnt; /* skipped tests */
+
+	int saved_netns_fd;
 };
=20
 extern struct test_env env;
--=20
2.24.1

