Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7F45178EF
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387606AbiEBVQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387591AbiEBVQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:16:13 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A949F2DEE;
        Mon,  2 May 2022 14:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651525963; x=1683061963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=szTMMA+89v2H8xSDvTnXgwA74cZHtkhg7qzXfwihkzw=;
  b=NKhRy5ZJCIJSWOy2Lp2621XM1ePJB+7Hinq6JsMvgxeBIAgx1hL/2PRO
   IhKAcvfYDFWpHDLl9ViVGcNcxrOsLtNPptHwLOXJrQEUJ/yzo1HfpugF4
   JCUgW8FSabzc83trHxey4cPHZICkN0oaFGi9kVyJ+nntBvJ0Cl/uJzywj
   bH9447hcizMF7NTcQ99PATWDaq42XnnF3wpLQoIvmEMlFinFIRRLug2zi
   5IXpuxCMau7Ke0fD9WDJXHcWB0/SsvuD9iQhUJZcCxBy761CVg0jzJreF
   plejjy7NE+exazYJ3JvihrmRQO4Bojgt8Qto8eGii44+pjEadiQpDG5u6
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="247878474"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="247878474"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:12:42 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="810393796"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.141.55])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:12:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v3 7/8] selftests: bpf: verify ca_name of struct mptcp_sock
Date:   Mon,  2 May 2022 14:12:33 -0700
Message-Id: <20220502211235.142250-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch verifies another member of struct mptcp_sock, ca_name. Add a
new function get_msk_ca_name() to read the sysctl tcp_congestion_control
and verify it in verify_msk().

v3: Access the sysctl through the filesystem to avoid compatibility issues
with the busybox sysctl command.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/bpf/bpf_mptcp_helpers.h |  1 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  4 ++
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 38 +++++++++++++++++++
 .../testing/selftests/bpf/progs/mptcp_sock.c  |  4 ++
 4 files changed, 47 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
index 87e15810997d..463e4e061c96 100644
--- a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
@@ -10,6 +10,7 @@ struct mptcp_sock {
 	struct inet_connection_sock	sk;
 
 	__u32		token;
+	char		ca_name[TCP_CA_NAME_MAX];
 } __attribute__((preserve_access_index));
 
 #endif
diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
index b1ede6f0b821..89750d732cfa 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -16,6 +16,10 @@ BPF_PROG(name, args)
 #define SOL_TCP 6
 #endif
 
+#ifndef TCP_CA_NAME_MAX
+#define TCP_CA_NAME_MAX	16
+#endif
+
 #define tcp_jiffies32 ((__u32)bpf_jiffies64())
 
 struct sock_common {
diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index c5d96ba81e04..f2d22507431c 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -5,10 +5,15 @@
 #include "cgroup_helpers.h"
 #include "network_helpers.h"
 
+#ifndef TCP_CA_NAME_MAX
+#define TCP_CA_NAME_MAX	16
+#endif
+
 struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
 	__u32 token;
+	char ca_name[TCP_CA_NAME_MAX];
 };
 
 static char monitor_log_path[64];
@@ -79,11 +84,36 @@ static __u32 get_msk_token(void)
 	return token;
 }
 
+void get_msk_ca_name(char ca_name[])
+{
+	size_t len;
+	int fd;
+
+	fd = open("/proc/sys/net/ipv4/tcp_congestion_control", O_RDONLY);
+	if (CHECK_FAIL(fd < 0)) {
+		log_err("Failed to open tcp_congestion_control");
+		return;
+	}
+
+	len = read(fd, ca_name, TCP_CA_NAME_MAX);
+	if (CHECK_FAIL(len < 0)) {
+		log_err("Failed to read ca_name");
+		goto err;
+	}
+
+	if (len > 0 && ca_name[len - 1] == '\n')
+		ca_name[len - 1] = '\0';
+
+err:
+	close(fd);
+}
+
 static int verify_msk(int map_fd, int client_fd)
 {
 	char *msg = "MPTCP subflow socket";
 	int err = 0, cfd = client_fd;
 	struct mptcp_storage val;
+	char ca_name[TCP_CA_NAME_MAX];
 	__u32 token;
 
 	token = get_msk_token();
@@ -92,6 +122,8 @@ static int verify_msk(int map_fd, int client_fd)
 		return -1;
 	}
 
+	get_msk_ca_name(ca_name);
+
 	if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
 		perror("Failed to read socket storage");
 		return -1;
@@ -115,6 +147,12 @@ static int verify_msk(int map_fd, int client_fd)
 		err++;
 	}
 
+	if (strncmp(val.ca_name, ca_name, TCP_CA_NAME_MAX)) {
+		log_err("Unexpected mptcp_sock.ca_name %s != %s",
+			val.ca_name, ca_name);
+		err++;
+	}
+
 	return err;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
index c58c191d8416..226571673800 100644
--- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020, Tessares SA. */
 
+#include <string.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include "bpf_mptcp_helpers.h"
@@ -13,6 +14,7 @@ struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
 	__u32 token;
+	char ca_name[TCP_CA_NAME_MAX];
 };
 
 struct {
@@ -49,6 +51,7 @@ int _sockops(struct bpf_sock_ops *ctx)
 			return 1;
 
 		storage->token = 0;
+		bzero(storage->ca_name, TCP_CA_NAME_MAX);
 	} else {
 		if (!CONFIG_MPTCP)
 			return 1;
@@ -63,6 +66,7 @@ int _sockops(struct bpf_sock_ops *ctx)
 			return 1;
 
 		storage->token = msk->token;
+		memcpy(storage->ca_name, msk->ca_name, TCP_CA_NAME_MAX);
 	}
 	storage->invoked++;
 	storage->is_mptcp = tcp_sk->is_mptcp;
-- 
2.36.0

