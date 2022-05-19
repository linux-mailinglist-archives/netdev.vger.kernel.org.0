Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D851752E08E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343617AbiESXaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343563AbiESXa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:30:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD450108AA0;
        Thu, 19 May 2022 16:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653003024; x=1684539024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ODbT1+khY/f6Bdz1dRXyxw7XWKQOQC7s2NBBVtoK5wo=;
  b=McOEwOnNCuT2WHG/ooM3cd8CCgbymdRLhM0X5rjor/wvj2gWlpJM9Fni
   Go5jl9k/WavSbmjhyan4Qg88rEqeu7X0xtmNJAVS5BZvB9NMgmmnsJN5C
   CCPvJ5Qfjw3ZticWX8hR784McnpFhC1iMIN6ZYMQqQrqUJHwzMv6XZaHv
   VYDyizn5bnQtcDzljO/KbbdbzGuVDdiq7ElCFLGoRfJxt9dv++eJ5g/uj
   UJZMPOI7U4vRalDphP+1bOJbgmQkzAQ1Cr5N/lfpCgTFkrcmJScYlGW4S
   cMXoG7GhHmBaYVE1TJhBuFoKvthv644tsYE08O35x8Gkvow2xn6epGqNA
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272547203"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272547203"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570491199"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.132.179])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v5 5/7] selftests/bpf: verify token of struct mptcp_sock
Date:   Thu, 19 May 2022 16:30:14 -0700
Message-Id: <20220519233016.105670-6-mathew.j.martineau@linux.intel.com>
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

This patch verifies the struct member token of struct mptcp_sock. Add a
new member token in struct mptcp_storage to store the token value of the
msk socket got by bpf_skc_to_mptcp_sock(). Trace the kernel function
mptcp_pm_new_connection() by using bpf fentry prog to obtain the msk token
and save it in a global bpf variable. Pass the variable to verify_msk() to
verify it with the token saved in socket_storage_map.

v4:
 - use ASSERT_* instead of CHECK_FAIL (Andrii)
 - skip the test if 'ip mptcp monitor' is not supported (Mat)

v5:
 - Drop 'ip mptcp monitor', trace mptcp_pm_new_connection instead (Martin)
 - Use ASSERT_EQ (Andrii)

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h  |  1 +
 tools/testing/selftests/bpf/prog_tests/mptcp.c | 15 +++++++++++++--
 tools/testing/selftests/bpf/progs/mptcp_sock.c | 16 ++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
index 90fecafc493d..422491872619 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -229,6 +229,7 @@ extern void tcp_cong_avoid_ai(struct tcp_sock *tp, __u32 w, __u32 acked) __ksym;
 struct mptcp_sock {
 	struct inet_connection_sock	sk;
 
+	__u32		token;
 } __attribute__((preserve_access_index));
 
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index 6f333e3aba9c..138bcc80ab9e 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -10,6 +10,7 @@
 struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
+	__u32 token;
 };
 
 static int verify_tsk(int map_fd, int client_fd)
@@ -30,11 +31,14 @@ static int verify_tsk(int map_fd, int client_fd)
 	return err;
 }
 
-static int verify_msk(int map_fd, int client_fd)
+static int verify_msk(int map_fd, int client_fd, __u32 token)
 {
 	int err, cfd = client_fd;
 	struct mptcp_storage val;
 
+	if (!ASSERT_GT(token, 0, "invalid token"))
+		return -1;
+
 	err = bpf_map_lookup_elem(map_fd, &cfd, &val);
 	if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
 		return err;
@@ -45,6 +49,9 @@ static int verify_msk(int map_fd, int client_fd)
 	if (!ASSERT_EQ(val.is_mptcp, 1, "unexpected is_mptcp"))
 		err++;
 
+	if (!ASSERT_EQ(val.token, token, "unexpected token"))
+		err++;
+
 	return err;
 }
 
@@ -57,6 +64,10 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 	if (!ASSERT_OK_PTR(sock_skel, "skel_open_load"))
 		return -EIO;
 
+	err = mptcp_sock__attach(sock_skel);
+	if (!ASSERT_OK(err, "skel_attach"))
+		goto out;
+
 	prog_fd = bpf_program__fd(sock_skel->progs._sockops);
 	if (!ASSERT_GE(prog_fd, 0, "bpf_program__fd")) {
 		err = -EIO;
@@ -79,7 +90,7 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 		goto out;
 	}
 
-	err += is_mptcp ? verify_msk(map_fd, client_fd) :
+	err += is_mptcp ? verify_msk(map_fd, client_fd, sock_skel->bss->token) :
 			  verify_tsk(map_fd, client_fd);
 
 	close(client_fd);
diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
index dc73b3fbb50b..f038b0e699a2 100644
--- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -7,10 +7,12 @@
 #include "bpf_tcp_helpers.h"
 
 char _license[] SEC("license") = "GPL";
+__u32 token = 0;
 
 struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
+	__u32 token;
 };
 
 struct {
@@ -47,6 +49,8 @@ int _sockops(struct bpf_sock_ops *ctx)
 					     BPF_SK_STORAGE_GET_F_CREATE);
 		if (!storage)
 			return 1;
+
+		storage->token = 0;
 	} else {
 		msk = bpf_skc_to_mptcp_sock(sk);
 		if (!msk)
@@ -56,9 +60,21 @@ int _sockops(struct bpf_sock_ops *ctx)
 					     BPF_SK_STORAGE_GET_F_CREATE);
 		if (!storage)
 			return 1;
+
+		storage->token = msk->token;
 	}
 	storage->invoked++;
 	storage->is_mptcp = is_mptcp;
 
 	return 1;
 }
+
+SEC("fentry/mptcp_pm_new_connection")
+int BPF_PROG(trace_mptcp_pm_new_connection, struct mptcp_sock *msk,
+	     const struct sock *ssk, int server_side)
+{
+	if (!server_side)
+		token = msk->token;
+
+	return 0;
+}
-- 
2.36.1

