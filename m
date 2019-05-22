Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D4F271A3
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 23:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbfEVV3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 17:29:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56564 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730247AbfEVV3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 17:29:44 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MLCoNi010264
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 14:29:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=oWJf7cQOKKWH9XnWp98rNtUGVh0Vr3ojGQm1Eckr864=;
 b=ObCODhVoYkE0fermI/ngGHncdOj/bZ1KJQvPtXO2lKwAVeEw6AFn7ZID7mrDK7NNawrn
 oHhfgH2ugS5NmzQo9SUt1wvg3N7fYyT1KGxD4286inJN6ALGsKfW9/INq5CBKWUBZCZa
 MPFP6mHMxSdJy7EvSD54mtQj5lhrnvw8cQ0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn8rt9f58-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 14:29:43 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 14:29:41 -0700
Received: by devvm2643.prn2.facebook.com (Postfix, from userid 111017)
        id 65B671251A29C; Wed, 22 May 2019 14:29:39 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm2643.prn2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        <kernel-team@fb.com>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 4/4] selftests/bpf: add auto-detach test
Date:   Wed, 22 May 2019 14:29:32 -0700
Message-ID: <20190522212932.2646247-5-guro@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190522212932.2646247-1-guro@fb.com>
References: <20190522212932.2646247-1-guro@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=38 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=350 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a kselftest to cover bpf auto-detachment functionality.
The test creates a cgroup, associates some resources with it,
attaches a couple of bpf programs and deletes the cgroup.

Then it checks that bpf programs are going away in 5 seconds.

Expected output:
  $ ./test_cgroup_attach
  #override:PASS
  #multi:PASS
  #autodetach:PASS
  test_cgroup_attach:PASS

On a kernel without auto-detaching:
  $ ./test_cgroup_attach
  #override:PASS
  #multi:PASS
  #autodetach:FAIL
  test_cgroup_attach:FAIL

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 .../selftests/bpf/test_cgroup_attach.c        | 108 +++++++++++++++++-
 1 file changed, 107 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_cgroup_attach.c b/tools/testing/selftests/bpf/test_cgroup_attach.c
index 93d4fe295e7d..36441fd0f392 100644
--- a/tools/testing/selftests/bpf/test_cgroup_attach.c
+++ b/tools/testing/selftests/bpf/test_cgroup_attach.c
@@ -456,9 +456,115 @@ static int test_multiprog(void)
 	return rc;
 }
 
+static int test_autodetach(void)
+{
+	__u32 prog_cnt = 4, attach_flags;
+	int allow_prog[2] = {0};
+	__u32 prog_ids[2] = {0};
+	int cg = 0, i, rc = -1;
+	void *ptr = NULL;
+	int attempts;
+
+
+	for (i = 0; i < ARRAY_SIZE(allow_prog); i++) {
+		allow_prog[i] = prog_load_cnt(1, 1 << i);
+		if (!allow_prog[i])
+			goto err;
+	}
+
+	if (setup_cgroup_environment())
+		goto err;
+
+	/* create a cgroup, attach two programs and remember their ids */
+	cg = create_and_get_cgroup("/cg_autodetach");
+	if (cg < 0)
+		goto err;
+
+	if (join_cgroup("/cg_autodetach"))
+		goto err;
+
+	for (i = 0; i < ARRAY_SIZE(allow_prog); i++) {
+		if (bpf_prog_attach(allow_prog[i], cg, BPF_CGROUP_INET_EGRESS,
+				    BPF_F_ALLOW_MULTI)) {
+			log_err("Attaching prog[%d] to cg:egress", i);
+			goto err;
+		}
+	}
+
+	/* make sure that programs are attached and run some traffic */
+	assert(bpf_prog_query(cg, BPF_CGROUP_INET_EGRESS, 0, &attach_flags,
+			      prog_ids, &prog_cnt) == 0);
+	assert(system(PING_CMD) == 0);
+
+	/* allocate some memory (4Mb) to pin the original cgroup */
+	ptr = malloc(4 * (1 << 20));
+	if (!ptr)
+		goto err;
+
+	/* close programs and cgroup fd */
+	for (i = 0; i < ARRAY_SIZE(allow_prog); i++) {
+		close(allow_prog[i]);
+		allow_prog[i] = 0;
+	}
+
+	close(cg);
+	cg = 0;
+
+	/* leave the cgroup and remove it. don't detach programs */
+	cleanup_cgroup_environment();
+
+	/* programs must stay pinned by the allocated memory */
+	for (i = 0; i < ARRAY_SIZE(prog_ids); i++) {
+		int fd = bpf_prog_get_fd_by_id(prog_ids[i]);
+
+		if (fd < 0)
+			goto err;
+		close(fd);
+	}
+
+	/* wait for the asynchronous auto-detachment.
+	 * wait for no more than 5 sec and give up.
+	 */
+	for (i = 0; i < ARRAY_SIZE(prog_ids); i++) {
+		for (attempts = 5; attempts >= 0; attempts--) {
+			int fd = bpf_prog_get_fd_by_id(prog_ids[i]);
+
+			if (fd < 0)
+				break;
+
+			/* don't leave the fd open */
+			close(fd);
+
+			if (!attempts)
+				goto err;
+
+			sleep(1);
+		}
+	}
+
+	rc = 0;
+err:
+	for (i = 0; i < ARRAY_SIZE(allow_prog); i++)
+		if (allow_prog[i] > 0)
+			close(allow_prog[i]);
+	if (cg)
+		close(cg);
+	free(ptr);
+	cleanup_cgroup_environment();
+	if (!rc)
+		printf("#autodetach:PASS\n");
+	else
+		printf("#autodetach:FAIL\n");
+	return rc;
+}
+
 int main(int argc, char **argv)
 {
-	int (*tests[])(void) = {test_foo_bar, test_multiprog};
+	int (*tests[])(void) = {
+		test_foo_bar,
+		test_multiprog,
+		test_autodetach,
+	};
 	int errors = 0;
 	int i;
 
-- 
2.20.1

