Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9C6272EA
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfEVXVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:21:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54900 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729654AbfEVXU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:20:58 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4MNIEvZ013613
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:20:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=JUaLacIUau6Nx5Fy096Qj5WLvuTqbFiSOX145LGNSQQ=;
 b=ptDXiR7wa+4uVhOvQ12HJ6+z51vxeKRfqVeLtOGJn2gqxR2BUGgIQR/JjgcrdijsM4VL
 RpdsgE2HkaucgJ+Gn48beB9pI0t+WKdMcCR76Wd2lzAgstIXwKVsTt4l3jPBM1I5m7zR
 iG1g7o6LF/9Aat57JCp3KhM83LRXpUUvFHo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2sn5ta2e04-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:20:57 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 16:20:55 -0700
Received: by devvm2643.prn2.facebook.com (Postfix, from userid 111017)
        id EFAFE12526D4E; Wed, 22 May 2019 16:20:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm2643.prn2.facebook.com
To:     Alexei Starovoitov <ast@kernel.org>, <bpf@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, <kernel-team@fb.com>,
        <cgroups@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Date:   Wed, 22 May 2019 16:20:51 -0700
Message-ID: <20190522232051.2938491-5-guro@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190522232051.2938491-1-guro@fb.com>
References: <20190522232051.2938491-1-guro@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=500 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220162
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
 .../selftests/bpf/test_cgroup_attach.c        | 99 ++++++++++++++++++-
 1 file changed, 98 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_cgroup_attach.c b/tools/testing/selftests/bpf/test_cgroup_attach.c
index 93d4fe295e7d..bc5bd0f1728e 100644
--- a/tools/testing/selftests/bpf/test_cgroup_attach.c
+++ b/tools/testing/selftests/bpf/test_cgroup_attach.c
@@ -456,9 +456,106 @@ static int test_multiprog(void)
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

