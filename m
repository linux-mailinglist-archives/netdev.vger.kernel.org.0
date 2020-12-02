Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E417E2CC6F0
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgLBTr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:47:27 -0500
Received: from mx.der-flo.net ([193.160.39.236]:38354 "EHLO mx.der-flo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgLBTr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 14:47:27 -0500
Received: by mx.der-flo.net (Postfix, from userid 110)
        id 77EEF4455D; Wed,  2 Dec 2020 20:46:44 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx.der-flo.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1203:ecb0:3930:1751:4157:4d75:a5e2])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id 8AC7944553;
        Wed,  2 Dec 2020 20:46:31 +0100 (CET)
From:   Florian Lehner <dev@der-flo.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, john.fastabend@gmail.com,
        Florian Lehner <dev@der-flo.net>,
        Stanislav Fomichev <sdf@google.com>,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [PATCH 1/2] selftests/bpf: Print reason when a tester could not run a program
Date:   Wed,  2 Dec 2020 20:45:31 +0100
Message-Id: <20201202194532.12879-2-dev@der-flo.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201202194532.12879-1-dev@der-flo.net>
References: <20201202194532.12879-1-dev@der-flo.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8184d44c9a57 ("selftests/bpf: skip verifier tests for unsupported
program types") added a check to skip unsupported program types. As
bpf_probe_prog_type can change errno, do_single_test should save it before
printing a reason why a supported BPF program type failed to load.

Fixes: 8184d44c9a57 ("selftests/bpf: skip verifier tests for unsupported program types")
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
Signed-off-by: Florian Lehner <dev@der-flo.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 4bfe3aa2cfc4..ceea9409639e 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -936,6 +936,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	int run_errs, run_successes;
 	int map_fds[MAX_NR_MAPS];
 	const char *expected_err;
+	int saved_errno;
 	int fixup_skips;
 	__u32 pflags;
 	int i, err;
@@ -997,6 +998,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	}

 	fd_prog = bpf_load_program_xattr(&attr, bpf_vlog, sizeof(bpf_vlog));
+	saved_errno = errno;

 	/* BPF_PROG_TYPE_TRACING requires more setup and
 	 * bpf_probe_prog_type won't give correct answer
@@ -1013,7 +1015,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	if (expected_ret == ACCEPT || expected_ret == VERBOSE_ACCEPT) {
 		if (fd_prog < 0) {
 			printf("FAIL\nFailed to load prog '%s'!\n",
-			       strerror(errno));
+			       strerror(saved_errno));
 			goto fail_log;
 		}
 #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
--
2.28.0

