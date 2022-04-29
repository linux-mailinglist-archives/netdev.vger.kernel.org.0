Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364825157CA
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381241AbiD2WFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381215AbiD2WFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:05:32 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54745DC5B0;
        Fri, 29 Apr 2022 15:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651269732; x=1682805732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kqffaK3daxbD22vmQV/99UWXGn1rJCRY5uMKADdtxY0=;
  b=MmzHbVF+ue3RJjxCYhhAbuve1EdBmrx1E4Xx4R2mavbRdkuGng1bfjUT
   DelCoIeyIttsJURE9exv1cW94vD2m254K16hluQ2lmYR3s4UKKvgNLg/v
   ZLjNBf4520312m79ZCTQibqYYGnp/Q2+NEhoEaUDgthjNCG3Mw1XH8yeQ
   Xg8Bj8SoSAhiqxQ+ZWCfK+PYFtE2bkDfHR6ziEvdWhv532c9X5Uemiltw
   5Nf6kYlK8bTWvwa1pTGQo8pma3QAFr1206GnGh6iXpAHEi308W8cwRP2Y
   l9eDliGWleOVXKJuewjeu3CSXZ7Mp9d5TDuItEjU/ROE7ry1I0v2QJbI8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="266609692"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="266609692"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 15:02:09 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="582419801"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.217.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 15:02:09 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v2 5/8] selftests: bpf: test bpf_skc_to_mptcp_sock
Date:   Fri, 29 Apr 2022 15:02:01 -0700
Message-Id: <20220429220204.353225-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429220204.353225-1-mathew.j.martineau@linux.intel.com>
References: <20220429220204.353225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch extends the MPTCP test base, to test the new helper
bpf_skc_to_mptcp_sock().

Define struct mptcp_sock in bpf_tcp_helpers.h, use bpf_skc_to_mptcp_sock
to get the msk socket in progs/mptcp_sock.c and store the infos in
socket_storage_map.

Get the infos from socket_storage_map in prog_tests/mptcp.c. Add a new
function verify_msk() to verify the infos of MPTCP socket, and rename
verify_sk() to verify_tsk() to verify TCP socket only.

v2: Add CONFIG_MPTCP check for clearer error messages

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 MAINTAINERS                                   |  1 +
 .../testing/selftests/bpf/bpf_mptcp_helpers.h | 14 ++++++++
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 36 +++++++++++++++----
 .../testing/selftests/bpf/progs/mptcp_sock.c  | 24 ++++++++++---
 4 files changed, 65 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_mptcp_helpers.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 359afc617b92..d48d3cb6abbc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13780,6 +13780,7 @@ F:	include/net/mptcp.h
 F:	include/trace/events/mptcp.h
 F:	include/uapi/linux/mptcp.h
 F:	net/mptcp/
+F:	tools/testing/selftests/bpf/bpf_mptcp_helpers.h
 F:	tools/testing/selftests/bpf/*/*mptcp*.c
 F:	tools/testing/selftests/net/mptcp/
 
diff --git a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
new file mode 100644
index 000000000000..18da4cc65e89
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2022, SUSE. */
+
+#ifndef __BPF_MPTCP_HELPERS_H
+#define __BPF_MPTCP_HELPERS_H
+
+#include "bpf_tcp_helpers.h"
+
+struct mptcp_sock {
+	struct inet_connection_sock	sk;
+
+} __attribute__((preserve_access_index));
+
+#endif
diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index cd548bb2828f..4b40bbdaf91f 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -10,14 +10,12 @@ struct mptcp_storage {
 	__u32 is_mptcp;
 };
 
-static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 is_mptcp)
+static int verify_tsk(int map_fd, int client_fd)
 {
+	char *msg = "plain TCP socket";
 	int err = 0, cfd = client_fd;
 	struct mptcp_storage val;
 
-	if (is_mptcp == 1)
-		return 0;
-
 	if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
 		perror("Failed to read socket storage");
 		return -1;
@@ -38,6 +36,32 @@ static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 is_mptcp)
 	return err;
 }
 
+static int verify_msk(int map_fd, int client_fd)
+{
+	char *msg = "MPTCP subflow socket";
+	int err = 0, cfd = client_fd;
+	struct mptcp_storage val;
+
+	if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
+		perror("Failed to read socket storage");
+		return -1;
+	}
+
+	if (val.invoked != 1) {
+		log_err("%s: unexpected invoked count %d != 1",
+			msg, val.invoked);
+		err++;
+	}
+
+	if (val.is_mptcp != 1) {
+		log_err("%s: unexpected bpf_tcp_sock.is_mptcp %d != 1",
+			msg, val.is_mptcp);
+		err++;
+	}
+
+	return err;
+}
+
 static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 {
 	int client_fd, prog_fd, map_fd, err;
@@ -88,8 +112,8 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 		goto out;
 	}
 
-	err += is_mptcp ? verify_sk(map_fd, client_fd, "MPTCP subflow socket", 1) :
-			  verify_sk(map_fd, client_fd, "plain TCP socket", 0);
+	err += is_mptcp ? verify_msk(map_fd, client_fd) :
+			  verify_tsk(map_fd, client_fd);
 
 	close(client_fd);
 
diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
index 0d65fb889d03..7b6a25e37de8 100644
--- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -3,9 +3,11 @@
 
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
+#include "bpf_mptcp_helpers.h"
 
 char _license[] SEC("license") = "GPL";
 __u32 _version SEC("version") = 1;
+extern bool CONFIG_MPTCP __kconfig;
 
 struct mptcp_storage {
 	__u32 invoked;
@@ -24,6 +26,7 @@ int _sockops(struct bpf_sock_ops *ctx)
 {
 	struct mptcp_storage *storage;
 	struct bpf_tcp_sock *tcp_sk;
+	struct mptcp_sock *msk;
 	int op = (int)ctx->op;
 	struct bpf_sock *sk;
 
@@ -38,11 +41,24 @@ int _sockops(struct bpf_sock_ops *ctx)
 	if (!tcp_sk)
 		return 1;
 
-	storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
-				     BPF_SK_STORAGE_GET_F_CREATE);
-	if (!storage)
-		return 1;
+	if (!tcp_sk->is_mptcp) {
+		storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
+					     BPF_SK_STORAGE_GET_F_CREATE);
+		if (!storage)
+			return 1;
+	} else {
+		if (!CONFIG_MPTCP)
+			return 1;
+
+		msk = bpf_skc_to_mptcp_sock(sk);
+		if (!msk)
+			return 1;
 
+		storage = bpf_sk_storage_get(&socket_storage_map, msk, 0,
+					     BPF_SK_STORAGE_GET_F_CREATE);
+		if (!storage)
+			return 1;
+	}
 	storage->invoked++;
 	storage->is_mptcp = tcp_sk->is_mptcp;
 
-- 
2.36.0

