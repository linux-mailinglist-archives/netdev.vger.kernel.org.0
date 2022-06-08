Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F52E542EF1
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 13:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbiFHLPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 07:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237554AbiFHLPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 07:15:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F72280B11;
        Wed,  8 Jun 2022 04:15:10 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LJ4Jb24NMz6802B;
        Wed,  8 Jun 2022 19:10:23 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 8 Jun 2022 13:15:07 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 2/3] selftests/bpf: Add test_progs opts for sign-file and kernel priv key + cert
Date:   Wed, 8 Jun 2022 13:12:20 +0200
Message-ID: <20220608111221.373833-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220608111221.373833-1-roberto.sassu@huawei.com>
References: <20220608111221.373833-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the logs of the eBPF CI, built kernel and tests are copied to
a virtual machine to run there.

Since a test for a new helper to verify PKCS#7 signatures requires to sign
data to be verified, extend test_progs to store in the test_env data
structure (accessible by individual tests) the path of sign-file and of the
kernel private key and cert.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/testing/selftests/bpf/test_progs.c | 12 ++++++++++++
 tools/testing/selftests/bpf/test_progs.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index c639f2e56fc5..90ce2c06a15e 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -707,6 +707,8 @@ enum ARG_KEYS {
 	ARG_TEST_NAME_GLOB_DENYLIST = 'd',
 	ARG_NUM_WORKERS = 'j',
 	ARG_DEBUG = -1,
+	ARG_SIGN_FILE = 'S',
+	ARG_KERNEL_PRIV_CERT = 'C',
 };
 
 static const struct argp_option opts[] = {
@@ -732,6 +734,10 @@ static const struct argp_option opts[] = {
 	  "Number of workers to run in parallel, default to number of cpus." },
 	{ "debug", ARG_DEBUG, NULL, 0,
 	  "print extra debug information for test_progs." },
+	{ "sign-file", ARG_SIGN_FILE, "PATH", 0,
+	  "sign-file path " },
+	{ "kernel-priv-cert", ARG_KERNEL_PRIV_CERT, "PATH", 0,
+	  "kernel private key and cert path " },
 	{},
 };
 
@@ -862,6 +868,12 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 	case ARG_DEBUG:
 		env->debug = true;
 		break;
+	case ARG_SIGN_FILE:
+		env->sign_file_path = arg;
+		break;
+	case ARG_KERNEL_PRIV_CERT:
+		env->kernel_priv_cert_path = arg;
+		break;
 	case ARGP_KEY_ARG:
 		argp_usage(state);
 		break;
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 5fe1365c2bb1..9a860a59f06a 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -123,6 +123,9 @@ struct test_env {
 	pid_t *worker_pids; /* array of worker pids */
 	int *worker_socks; /* array of worker socks */
 	int *worker_current_test; /* array of current running test for each worker */
+
+	const char *sign_file_path; /* sign-file path */
+	const char *kernel_priv_cert_path; /* kernel priv key and cert path */
 };
 
 #define MAX_LOG_TRUNK_SIZE 8192
-- 
2.25.1

