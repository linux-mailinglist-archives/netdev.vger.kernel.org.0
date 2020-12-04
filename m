Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A137F2CF3DA
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgLDSUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:20:08 -0500
Received: from mx.der-flo.net ([193.160.39.236]:40128 "EHLO mx.der-flo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgLDSUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 13:20:07 -0500
Received: by mx.der-flo.net (Postfix, from userid 110)
        id C97BF4458E; Fri,  4 Dec 2020 19:19:25 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx.der-flo.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1205:34c2:d100:56f5:35da:21bf:c38d])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id C49F744581;
        Fri,  4 Dec 2020 19:19:21 +0100 (CET)
From:   Florian Lehner <dev@der-flo.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, john.fastabend@gmail.com,
        Florian Lehner <dev@der-flo.net>,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [PATCH 2/2] selftests/bpf: Avoid errno clobbering
Date:   Fri,  4 Dec 2020 19:18:28 +0100
Message-Id: <20201204181828.11974-3-dev@der-flo.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204181828.11974-1-dev@der-flo.net>
References: <20201204181828.11974-1-dev@der-flo.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print a message when the returned error is about a program type being
not supported or because of permission problems.
These messages are expected if the program to test was actually
executed.

Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
Signed-off-by: Florian Lehner <dev@der-flo.net>
---
 tools/testing/selftests/bpf/test_verifier.c | 27 +++++++++++++++++----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index ceea9409639e..777a81404fdb 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -875,19 +875,36 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
 	__u8 tmp[TEST_DATA_LEN << 2];
 	__u32 size_tmp = sizeof(tmp);
 	uint32_t retval;
-	int err;
+	int err, saved_errno;
 
 	if (unpriv)
 		set_admin(true);
 	err = bpf_prog_test_run(fd_prog, 1, data, size_data,
 				tmp, &size_tmp, &retval, NULL);
+	saved_errno = errno;
+
 	if (unpriv)
 		set_admin(false);
-	if (err && errno != 524/*ENOTSUPP*/ && errno != EPERM) {
-		printf("Unexpected bpf_prog_test_run error ");
-		return err;
+
+	if (err) {
+		switch (saved_errno) {
+		case 524/*ENOTSUPP*/:
+			printf("Did not run the program (not supported) ");
+			return 0;
+		case EPERM:
+			if (unpriv) {
+				printf("Did not run the program (no permission) ");
+				return 0;
+			}
+			/* fallthrough; */
+		default:
+			printf("FAIL: Unexpected bpf_prog_test_run error (%s) ",
+				strerror(saved_errno));
+			return err;
+		}
 	}
-	if (!err && retval != expected_val &&
+
+	if (retval != expected_val &&
 	    expected_val != POINTER_VALUE) {
 		printf("FAIL retval %d != %d ", retval, expected_val);
 		return 1;
-- 
2.28.0

