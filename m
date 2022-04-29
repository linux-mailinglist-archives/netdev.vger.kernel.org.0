Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9765157C9
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381265AbiD2WFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381235AbiD2WFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:05:32 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9F3DC59A;
        Fri, 29 Apr 2022 15:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651269732; x=1682805732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5iPMySKUpf93N23lqTMqnVufH1GUMnK0ljO1C+LsgqY=;
  b=YCEuXGDZGwrJ8I1+RHprq9bUjbDn+eaW2cvSkozYAyRUFelg3dgbguiz
   Qy92CSM18FyPt31UR1YzN/yRz8DnI00Avkk+S0N96RmeU9d2f2CLXI+O4
   oL1c3T279/Gh+cJqKyq9oQ4064XAXyeWHa6gJkcCJM/eDq9MH0syYEdYu
   o32pYdhxjn42s9FYejNXaTPHmBGau9EwRpQytPfiM4VPcwBSmGk/g6e3J
   S3qHVwx3jEKryw/laQaInHkeEoe2StL5BllyZZgPSy3RmOsbx31kHbFQY
   /W+NzrJk0OYGrd2h5ydmBn9AhgMcDjyiiUs4X41auNgVxnzrYbAKy5meS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="266609694"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="266609694"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 15:02:10 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="582419802"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.217.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 15:02:09 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v2 6/8] selftests: bpf: verify token of struct mptcp_sock
Date:   Fri, 29 Apr 2022 15:02:02 -0700
Message-Id: <20220429220204.353225-7-mathew.j.martineau@linux.intel.com>
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

This patch verifies the struct member token of struct mptcp_sock. Add a
new function get_msk_token() to parse the msk token from the output of
the command 'ip mptcp monitor', and verify it in verify_msk().

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/bpf/bpf_mptcp_helpers.h |  1 +
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 66 +++++++++++++++++++
 .../testing/selftests/bpf/progs/mptcp_sock.c  |  5 ++
 3 files changed, 72 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
index 18da4cc65e89..87e15810997d 100644
--- a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
@@ -9,6 +9,7 @@
 struct mptcp_sock {
 	struct inet_connection_sock	sk;
 
+	__u32		token;
 } __attribute__((preserve_access_index));
 
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index 4b40bbdaf91f..c5d96ba81e04 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -8,8 +8,11 @@
 struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
+	__u32 token;
 };
 
+static char monitor_log_path[64];
+
 static int verify_tsk(int map_fd, int client_fd)
 {
 	char *msg = "plain TCP socket";
@@ -36,11 +39,58 @@ static int verify_tsk(int map_fd, int client_fd)
 	return err;
 }
 
+/*
+ * Parse the token from the output of 'ip mptcp monitor':
+ *
+ * [       CREATED] token=3ca933d3 remid=0 locid=0 saddr4=127.0.0.1 ...
+ * [       CREATED] token=2ab57040 remid=0 locid=0 saddr4=127.0.0.1 ...
+ */
+static __u32 get_msk_token(void)
+{
+	char *prefix = "[       CREATED] token=";
+	char buf[BUFSIZ] = {};
+	__u32 token = 0;
+	ssize_t len;
+	int fd;
+
+	sync();
+
+	fd = open(monitor_log_path, O_RDONLY);
+	if (CHECK_FAIL(fd < 0)) {
+		log_err("Failed to open %s", monitor_log_path);
+		return token;
+	}
+
+	len = read(fd, buf, sizeof(buf));
+	if (CHECK_FAIL(len < 0)) {
+		log_err("Failed to read %s", monitor_log_path);
+		goto err;
+	}
+
+	if (strncmp(buf, prefix, strlen(prefix))) {
+		log_err("Invalid prefix %s", buf);
+		goto err;
+	}
+
+	token = strtol(buf + strlen(prefix), NULL, 16);
+
+err:
+	close(fd);
+	return token;
+}
+
 static int verify_msk(int map_fd, int client_fd)
 {
 	char *msg = "MPTCP subflow socket";
 	int err = 0, cfd = client_fd;
 	struct mptcp_storage val;
+	__u32 token;
+
+	token = get_msk_token();
+	if (token <= 0) {
+		log_err("Unexpected token %x", token);
+		return -1;
+	}
 
 	if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
 		perror("Failed to read socket storage");
@@ -59,6 +109,12 @@ static int verify_msk(int map_fd, int client_fd)
 		err++;
 	}
 
+	if (val.token != token) {
+		log_err("Unexpected mptcp_sock.token %x != %x",
+			val.token, token);
+		err++;
+	}
+
 	return err;
 }
 
@@ -124,6 +180,7 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 
 void test_base(void)
 {
+	char cmd[256], tmp_dir[] = "/tmp/XXXXXX";
 	int server_fd, cgroup_fd;
 
 	cgroup_fd = test__join_cgroup("/mptcp");
@@ -141,6 +198,13 @@ void test_base(void)
 
 with_mptcp:
 	/* with MPTCP */
+	if (CHECK_FAIL(!mkdtemp(tmp_dir)))
+		goto close_cgroup_fd;
+	snprintf(monitor_log_path, sizeof(monitor_log_path),
+		 "%s/ip_mptcp_monitor", tmp_dir);
+	snprintf(cmd, sizeof(cmd), "ip mptcp monitor > %s &", monitor_log_path);
+	if (CHECK_FAIL(system(cmd)))
+		goto close_cgroup_fd;
 	server_fd = start_mptcp_server(AF_INET, NULL, 0, 0);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
@@ -148,6 +212,8 @@ void test_base(void)
 	CHECK_FAIL(run_test(cgroup_fd, server_fd, true));
 
 	close(server_fd);
+	snprintf(cmd, sizeof(cmd), "rm -rf %s", tmp_dir);
+	system(cmd);
 
 close_cgroup_fd:
 	close(cgroup_fd);
diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
index 7b6a25e37de8..c58c191d8416 100644
--- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -12,6 +12,7 @@ extern bool CONFIG_MPTCP __kconfig;
 struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
+	__u32 token;
 };
 
 struct {
@@ -46,6 +47,8 @@ int _sockops(struct bpf_sock_ops *ctx)
 					     BPF_SK_STORAGE_GET_F_CREATE);
 		if (!storage)
 			return 1;
+
+		storage->token = 0;
 	} else {
 		if (!CONFIG_MPTCP)
 			return 1;
@@ -58,6 +61,8 @@ int _sockops(struct bpf_sock_ops *ctx)
 					     BPF_SK_STORAGE_GET_F_CREATE);
 		if (!storage)
 			return 1;
+
+		storage->token = msk->token;
 	}
 	storage->invoked++;
 	storage->is_mptcp = tcp_sk->is_mptcp;
-- 
2.36.0

