Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3265B4CA333
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241386AbiCBLQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241433AbiCBLPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:15:55 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA38606EA;
        Wed,  2 Mar 2022 03:14:38 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K7s1G60fNz67nGY;
        Wed,  2 Mar 2022 19:13:22 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 12:14:34 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <revest@chromium.org>,
        <gregkh@linuxfoundation.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 4/9] selftests/bpf: Move sample generation code to ima_test_common()
Date:   Wed, 2 Mar 2022 12:13:59 +0100
Message-ID: <20220302111404.193900-5-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302111404.193900-1-roberto.sassu@huawei.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move sample generator code to ima_test_common() so that the new function
can be called by multiple LSM hooks.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/testing/selftests/bpf/progs/ima.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
index 96060ff4ffc6..b5a0de50d1b4 100644
--- a/tools/testing/selftests/bpf/progs/ima.c
+++ b/tools/testing/selftests/bpf/progs/ima.c
@@ -18,8 +18,7 @@ struct {
 
 char _license[] SEC("license") = "GPL";
 
-SEC("lsm.s/bprm_committed_creds")
-void BPF_PROG(ima, struct linux_binprm *bprm)
+static void ima_test_common(struct file *file)
 {
 	u64 ima_hash = 0;
 	u64 *sample;
@@ -28,7 +27,7 @@ void BPF_PROG(ima, struct linux_binprm *bprm)
 
 	pid = bpf_get_current_pid_tgid() >> 32;
 	if (pid == monitored_pid) {
-		ret = bpf_ima_inode_hash(bprm->file->f_inode, &ima_hash,
+		ret = bpf_ima_inode_hash(file->f_inode, &ima_hash,
 					 sizeof(ima_hash));
 		if (ret < 0 || ima_hash == 0)
 			return;
@@ -43,3 +42,9 @@ void BPF_PROG(ima, struct linux_binprm *bprm)
 
 	return;
 }
+
+SEC("lsm.s/bprm_committed_creds")
+void BPF_PROG(bprm_committed_creds, struct linux_binprm *bprm)
+{
+	ima_test_common(bprm->file);
+}
-- 
2.32.0

