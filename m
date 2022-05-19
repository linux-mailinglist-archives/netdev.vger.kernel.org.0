Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6C252E088
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343609AbiESXab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245079AbiESXa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:30:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B955B108A9E;
        Thu, 19 May 2022 16:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653003024; x=1684539024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yL57FAH7UrgJbVY5BNbdOK3sEJquq2+jOQ3e/t7En0s=;
  b=dkchTyz6rWba8jDlG9HfHWOoAn0jgjrQa4V8KSXOGgP7aVl0k3Avougs
   WEKWDxYRpNrs80xc8PhQRBTt5yivdGVtR+NMBX5mb0lYHFzwtUQb01dv9
   Nz4lDbkMAFmiULB+qeG6qkhsJsc+eySTTVOzC6wZjkUp9+8p1ir4cdbDq
   T3RGD6ZUG9FZAu6yCs1qwCT0Tj5ZZCMPkLjr0nsVClg4UXPDRlYrFQjWW
   mH7glqqfLvbJ5YA66RlKvZAC0NHOBG1kHUQneKtYihNlQB7HW3TK3+VOK
   7aQnBO6Zrzj5GjyJa4URLwkJ3r52WjLuDEbJnUlRsCH7/e8//e89lViUe
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272547200"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272547200"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570491197"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.132.179])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v5 4/7] selftests/bpf: test bpf_skc_to_mptcp_sock
Date:   Thu, 19 May 2022 16:30:13 -0700
Message-Id: <20220519233016.105670-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
References: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

v4:
 - use ASSERT_* instead of CHECK_FAIL (Andrii)
 - drop bpf_mptcp_helpers.h (Andrii)

v5:
 - some 'ASSERT_*' were replaced in the next commit by mistake.
 - Drop CONFIG_MPTCP (Martin)
 - Use ASSERT_EQ (Andrii)

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  5 ++++
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 27 ++++++++++++++-----
 .../testing/selftests/bpf/progs/mptcp_sock.c  | 19 ++++++++++---
 3 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
index 22e0c8849a17..90fecafc493d 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -226,4 +226,9 @@ static __always_inline bool tcp_cc_eq(const char *a, const char *b)
 extern __u32 tcp_slow_start(struct tcp_sock *tp, __u32 acked) __ksym;
 extern void tcp_cong_avoid_ai(struct tcp_sock *tp, __u32 w, __u32 acked) __ksym;
 
+struct mptcp_sock {
+	struct inet_connection_sock	sk;
+
+} __attribute__((preserve_access_index));
+
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index 7874d8264836..6f333e3aba9c 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -12,14 +12,11 @@ struct mptcp_storage {
 	__u32 is_mptcp;
 };
 
-static int verify_sk(int map_fd, int client_fd, __u32 is_mptcp)
+static int verify_tsk(int map_fd, int client_fd)
 {
 	int err, cfd = client_fd;
 	struct mptcp_storage val;
 
-	if (is_mptcp == 1)
-		return 0;
-
 	err = bpf_map_lookup_elem(map_fd, &cfd, &val);
 	if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
 		return err;
@@ -33,6 +30,24 @@ static int verify_sk(int map_fd, int client_fd, __u32 is_mptcp)
 	return err;
 }
 
+static int verify_msk(int map_fd, int client_fd)
+{
+	int err, cfd = client_fd;
+	struct mptcp_storage val;
+
+	err = bpf_map_lookup_elem(map_fd, &cfd, &val);
+	if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
+		return err;
+
+	if (!ASSERT_EQ(val.invoked, 1, "unexpected invoked count"))
+		err++;
+
+	if (!ASSERT_EQ(val.is_mptcp, 1, "unexpected is_mptcp"))
+		err++;
+
+	return err;
+}
+
 static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 {
 	int client_fd, prog_fd, map_fd, err;
@@ -64,8 +79,8 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 		goto out;
 	}
 
-	err += is_mptcp ? verify_sk(map_fd, client_fd, 1) :
-			  verify_sk(map_fd, client_fd, 0);
+	err += is_mptcp ? verify_msk(map_fd, client_fd) :
+			  verify_tsk(map_fd, client_fd);
 
 	close(client_fd);
 
diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
index bc09dba0b078..dc73b3fbb50b 100644
--- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -24,6 +24,7 @@ SEC("sockops")
 int _sockops(struct bpf_sock_ops *ctx)
 {
 	struct mptcp_storage *storage;
+	struct mptcp_sock *msk;
 	int op = (int)ctx->op;
 	struct tcp_sock *tsk;
 	struct bpf_sock *sk;
@@ -41,11 +42,21 @@ int _sockops(struct bpf_sock_ops *ctx)
 		return 1;
 
 	is_mptcp = bpf_core_field_exists(tsk->is_mptcp) ? tsk->is_mptcp : 0;
-	storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
-				     BPF_SK_STORAGE_GET_F_CREATE);
-	if (!storage)
-		return 1;
+	if (!is_mptcp) {
+		storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
+					     BPF_SK_STORAGE_GET_F_CREATE);
+		if (!storage)
+			return 1;
+	} else {
+		msk = bpf_skc_to_mptcp_sock(sk);
+		if (!msk)
+			return 1;
 
+		storage = bpf_sk_storage_get(&socket_storage_map, msk, 0,
+					     BPF_SK_STORAGE_GET_F_CREATE);
+		if (!storage)
+			return 1;
+	}
 	storage->invoked++;
 	storage->is_mptcp = is_mptcp;
 
-- 
2.36.1

