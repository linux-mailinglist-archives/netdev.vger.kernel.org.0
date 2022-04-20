Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85B75092B0
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 00:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356336AbiDTW2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 18:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355930AbiDTW2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 18:28:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBD3403FC;
        Wed, 20 Apr 2022 15:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650493517; x=1682029517;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I/fyyemIfL8f6DzsdezVEl00OqqrHn4zb2LgLSArq5c=;
  b=k2buzFNUt/a3NkFL5o+rWApztitiemezP028XNMcoBzkBuCru3iKAn85
   mBu/2+yCZHbkQ5aF2WEvNK+qXfC/PSLggcl7KCuXIj/a4CJ57k+DZhhtA
   v/BPfOHVUSUawwd42mJW0S7AlyKJ4eInOJzwgNtKXZf0/gUKkCtW0pR7W
   L2K8Y8txK2l9BohmNkXnAA46pU9ZMoe+E52Q41mgQReiOmrqB2VEfAAoc
   FPfPd2cYFoacaACguCu+/cUoTkHrER1RLkk4jHR7+OHTiS0i32CoLb5XE
   RzBqyb47NLeYvInuzQ6jKUIKLNsVf6DKLgb2PV6jYkczrvigBQ1TZuDxa
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="289277598"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="289277598"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:25:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="555422598"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.100.38])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:25:16 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next 4/7] selftests: bpf: test bpf_skc_to_mptcp_sock
Date:   Wed, 20 Apr 2022 15:24:56 -0700
Message-Id: <20220420222459.307649-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com>
References: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 MAINTAINERS                                   |  1 +
 .../testing/selftests/bpf/bpf_mptcp_helpers.h | 14 ++++++++
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 36 +++++++++++++++----
 .../testing/selftests/bpf/progs/mptcp_sock.c  | 22 +++++++++---
 4 files changed, 62 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_mptcp_helpers.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 01fbdb0e0180..f31fa73266f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13764,6 +13764,7 @@ F:	include/net/mptcp.h
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
index 0d65fb889d03..5cfaec4e7245 100644
--- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -3,6 +3,7 @@
 
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
+#include "bpf_mptcp_helpers.h"
 
 char _license[] SEC("license") = "GPL";
 __u32 _version SEC("version") = 1;
@@ -24,6 +25,7 @@ int _sockops(struct bpf_sock_ops *ctx)
 {
 	struct mptcp_storage *storage;
 	struct bpf_tcp_sock *tcp_sk;
+	struct mptcp_sock *msk;
 	int op = (int)ctx->op;
 	struct bpf_sock *sk;
 
@@ -38,11 +40,21 @@ int _sockops(struct bpf_sock_ops *ctx)
 	if (!tcp_sk)
 		return 1;
 
-	storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
-				     BPF_SK_STORAGE_GET_F_CREATE);
-	if (!storage)
-		return 1;
-
+	if (!tcp_sk->is_mptcp) {
+		storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
+					     BPF_SK_STORAGE_GET_F_CREATE);
+		if (!storage)
+			return 1;
+	} else {
+		msk = bpf_skc_to_mptcp_sock(sk);
+		if (!msk)
+			return 1;
+
+		storage = bpf_sk_storage_get(&socket_storage_map, msk, 0,
+					     BPF_SK_STORAGE_GET_F_CREATE);
+		if (!storage)
+			return 1;
+	}
 	storage->invoked++;
 	storage->is_mptcp = tcp_sk->is_mptcp;
 
-- 
2.36.0

