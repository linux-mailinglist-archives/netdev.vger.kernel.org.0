Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E7A1BD19F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgD2BV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:21:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22702 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726181AbgD2BV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:21:28 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1KtxJ025134
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=2wjHdsFA1VpS0UZc8mVL6131J0ce6JfymBqRzhfDSrY=;
 b=o4LhDh0K8ROouw8hlGQ6Sad5N/3q1/FuwyEYsvx3QSse2thx4V+30ZIi0SleAGn5lefB
 UbQ+FTXwEEdiMXGxLo+NZD3tcpIMT6YT5VK6ClYhJRJHGW0WUA6m8KGzbeWpIDZCsJb9
 WiFVn5vI0H7NqMg9opgWfPLrLqf5PkjbHzA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57qbbp2-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:27 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:21:25 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B99FD2EC30E4; Tue, 28 Apr 2020 18:21:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 05/11] selftests/bpf: fix memory leak in test selector
Date:   Tue, 28 Apr 2020 18:21:05 -0700
Message-ID: <20200429012111.277390-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429012111.277390-1-andriin@fb.com>
References: <20200429012111.277390-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=25
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Free test selector substrings, which were strdup()'ed.

Fixes: b65053cd94f4 ("selftests/bpf: Add whitelist/blacklist of test name=
s to test_progs")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/sel=
ftests/bpf/test_progs.c
index b521e0a512b6..86d0020c9eec 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -420,6 +420,18 @@ static int libbpf_print_fn(enum libbpf_print_level l=
evel,
 	return 0;
 }
=20
+static void free_str_set(const struct str_set *set)
+{
+	int i;
+
+	if (!set)
+		return;
+
+	for (i =3D 0; i < set->cnt; i++)
+		free((void *)set->strs[i]);
+	free(set->strs);
+}
+
 static int parse_str_list(const char *s, struct str_set *set)
 {
 	char *input, *state =3D NULL, *next, **tmp, **strs =3D NULL;
@@ -756,11 +768,11 @@ int main(int argc, char **argv)
 	fprintf(stdout, "Summary: %d/%d PASSED, %d SKIPPED, %d FAILED\n",
 		env.succ_cnt, env.sub_succ_cnt, env.skip_cnt, env.fail_cnt);
=20
-	free(env.test_selector.blacklist.strs);
-	free(env.test_selector.whitelist.strs);
+	free_str_set(&env.test_selector.blacklist);
+	free_str_set(&env.test_selector.whitelist);
 	free(env.test_selector.num_set);
-	free(env.subtest_selector.blacklist.strs);
-	free(env.subtest_selector.whitelist.strs);
+	free_str_set(&env.subtest_selector.blacklist);
+	free_str_set(&env.subtest_selector.whitelist);
 	free(env.subtest_selector.num_set);
=20
 	return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
--=20
2.24.1

