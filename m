Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B53526D14
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 00:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384895AbiEMWsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 18:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384863AbiEMWsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 18:48:39 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15E652B0A;
        Fri, 13 May 2022 15:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652482117; x=1684018117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AI+iLl0CdYRnbsKkyMDDmzOGsATE3q4/Dmj+lbPscS0=;
  b=fULrR4q6lrwm0XXK8crRJDdVOF1RqaQGWHhESzJi8hYfvHwbGW1ClrPq
   z98+U4ATmA/9vHECgHAfNiqyyi0AfgORaiAJ2TaYjiRTXyHi3dwZM0/Jl
   SGywInImRfdS22SDej8/I+d7AuYMK3/UixiB4vJQ2NOKtBbASXNfrdtw9
   n11UrDMdFVBXqpr86hSjQ1vAy4r+Y2iMaoRa/Z+43CDFam9AogyNHAXRT
   VzqstIHehsjCb5cypdvWLPidQEe0Vg3qt3cLP3lW0Chq+P4hSOkf3xONl
   lmrytIceNl6BPQjwXrxiT7qza4FSGVuNcWs1DpjRpY0FM8rmTpiSFqoPG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="270101180"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="270101180"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 15:48:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="815588252"
Received: from clakshma-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.160.121])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 15:48:34 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v4 4/7] selftests/bpf: test bpf_skc_to_mptcp_sock
Date:   Fri, 13 May 2022 15:48:24 -0700
Message-Id: <20220513224827.662254-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  5 +++
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 45 ++++++++++++++-----
 .../testing/selftests/bpf/progs/mptcp_sock.c  | 23 ++++++++--
 3 files changed, 58 insertions(+), 15 deletions(-)

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
index cb0389ca8690..02e7fd8918e6 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -11,14 +11,12 @@ struct mptcp_storage {
 	__u32 is_mptcp;
 };
 
-static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 is_mptcp)
+static int verify_tsk(int map_fd, int client_fd)
 {
+	char *msg = "plain TCP socket";
 	int err, cfd = client_fd;
 	struct mptcp_storage val;
 
-	if (is_mptcp == 1)
-		return 0;
-
 	err = bpf_map_lookup_elem(map_fd, &cfd, &val);
 	if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
 		return err;
@@ -38,6 +36,31 @@ static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 is_mptcp)
 	return err;
 }
 
+static int verify_msk(int map_fd, int client_fd)
+{
+	char *msg = "MPTCP subflow socket";
+	int err, cfd = client_fd;
+	struct mptcp_storage val;
+
+	err = bpf_map_lookup_elem(map_fd, &cfd, &val);
+	if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
+		return err;
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
@@ -88,8 +111,8 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 		goto out;
 	}
 
-	err += is_mptcp ? verify_sk(map_fd, client_fd, "MPTCP subflow socket", 1) :
-			  verify_sk(map_fd, client_fd, "plain TCP socket", 0);
+	err += is_mptcp ? verify_msk(map_fd, client_fd) :
+			  verify_tsk(map_fd, client_fd);
 
 	close(client_fd);
 
@@ -103,25 +126,25 @@ void test_base(void)
 	int server_fd, cgroup_fd;
 
 	cgroup_fd = test__join_cgroup("/mptcp");
-	if (CHECK_FAIL(cgroup_fd < 0))
+	if (!ASSERT_GE(cgroup_fd, 0, "test__join_cgroup"))
 		return;
 
 	/* without MPTCP */
 	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
-	if (CHECK_FAIL(server_fd < 0))
+	if (!ASSERT_GE(server_fd, 0, "start_server"))
 		goto with_mptcp;
 
-	CHECK_FAIL(run_test(cgroup_fd, server_fd, false));
+	ASSERT_OK(run_test(cgroup_fd, server_fd, false), "run_test tcp");
 
 	close(server_fd);
 
 with_mptcp:
 	/* with MPTCP */
 	server_fd = start_mptcp_server(AF_INET, NULL, 0, 0);
-	if (CHECK_FAIL(server_fd < 0))
+	if (!ASSERT_GE(server_fd, 0, "start_mptcp_server"))
 		goto close_cgroup_fd;
 
-	CHECK_FAIL(run_test(cgroup_fd, server_fd, true));
+	ASSERT_OK(run_test(cgroup_fd, server_fd, true), "run_test mptcp");
 
 	close(server_fd);
 
diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
index bc09dba0b078..3feb7ff578e2 100644
--- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -7,6 +7,7 @@
 #include "bpf_tcp_helpers.h"
 
 char _license[] SEC("license") = "GPL";
+extern bool CONFIG_MPTCP __kconfig;
 
 struct mptcp_storage {
 	__u32 invoked;
@@ -24,6 +25,7 @@ SEC("sockops")
 int _sockops(struct bpf_sock_ops *ctx)
 {
 	struct mptcp_storage *storage;
+	struct mptcp_sock *msk;
 	int op = (int)ctx->op;
 	struct tcp_sock *tsk;
 	struct bpf_sock *sk;
@@ -41,11 +43,24 @@ int _sockops(struct bpf_sock_ops *ctx)
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
 	storage->is_mptcp = is_mptcp;
 
-- 
2.36.1

