Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B3C526D15
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 00:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384869AbiEMWsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 18:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384866AbiEMWsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 18:48:39 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0AC532CE;
        Fri, 13 May 2022 15:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652482118; x=1684018118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=laeO4u7TU0q3/dYSryZrbK67npAa9r/pFeBQjOmJvOo=;
  b=WFim9hWRNk9gBvrNPhVRcegBR6bpWL62B+BBihUpAvOdZJM+rONHr8Qh
   jwyxHmbGenisC7/QBbZGoFg/0POGhDmSuSUTCBHUevXlp+idV1SlO45QT
   E250yVR9P8RK+4RyUxmP6UZoSmHq9Cj/WZ/IQSDRW7XtDhKWKdKysmQjt
   Xs7vjfYipmiDH8VjQaM/+u60+umUHPpzDelVQoHfC3QPmqYi1WbHvDZ2w
   L0p92hSI5jDqawWnRhYC+8rRwJYu4dAFUeX3HU0dMTTWrTILOkkQFOTyk
   y6RdNn44oht3vUtcL6VgSO4NYhz1jr6rB42KEsAlc6M64R+vLosVamjqT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="270101183"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="270101183"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 15:48:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="815588256"
Received: from clakshma-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.160.121])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 15:48:35 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v4 6/7] selftests/bpf: verify ca_name of struct mptcp_sock
Date:   Fri, 13 May 2022 15:48:26 -0700
Message-Id: <20220513224827.662254-7-mathew.j.martineau@linux.intel.com>
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

This patch verifies another member of struct mptcp_sock, ca_name. Add a
new function get_msk_ca_name() to read the sysctl tcp_congestion_control
and verify it in verify_msk().

v3: Access the sysctl through the filesystem to avoid compatibility
    issues with the busybox sysctl command.
v4: use ASSERT_* instead of CHECK_FAIL (Andrii)

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  5 +++
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 34 +++++++++++++++++++
 .../testing/selftests/bpf/progs/mptcp_sock.c  |  4 +++
 3 files changed, 43 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
index 422491872619..c38c66d5c1e6 100644
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
@@ -230,6 +234,7 @@ struct mptcp_sock {
 	struct inet_connection_sock	sk;
 
 	__u32		token;
+	char		ca_name[TCP_CA_NAME_MAX];
 } __attribute__((preserve_access_index));
 
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index ac98aa314123..2ff7f18ea0ce 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -6,10 +6,15 @@
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
@@ -75,17 +80,40 @@ static __u32 get_msk_token(void)
 	return token;
 }
 
+void get_msk_ca_name(char ca_name[])
+{
+	size_t len;
+	int fd;
+
+	fd = open("/proc/sys/net/ipv4/tcp_congestion_control", O_RDONLY);
+	if (!ASSERT_GE(fd, 0, "Failed to open tcp_congestion_control"))
+		return;
+
+	len = read(fd, ca_name, TCP_CA_NAME_MAX);
+	if (!ASSERT_GT(len, 0, "Failed to read ca_name"))
+		goto err;
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
 	int err, cfd = client_fd;
 	struct mptcp_storage val;
+	char ca_name[TCP_CA_NAME_MAX];
 	__u32 token;
 
 	token = get_msk_token();
 	if (!ASSERT_GT(token, 0, "Unexpected token"))
 		return -1;
 
+	get_msk_ca_name(ca_name);
+
 	err = bpf_map_lookup_elem(map_fd, &cfd, &val);
 	if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
 		return err;
@@ -108,6 +136,12 @@ static int verify_msk(int map_fd, int client_fd)
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
index 4890130826c6..c36f2f6bd2f1 100644
--- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2020, Tessares SA. */
 /* Copyright (c) 2022, SUSE. */
 
+#include <string.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include "bpf_tcp_helpers.h"
@@ -13,6 +14,7 @@ struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
 	__u32 token;
+	char ca_name[TCP_CA_NAME_MAX];
 };
 
 struct {
@@ -51,6 +53,7 @@ int _sockops(struct bpf_sock_ops *ctx)
 			return 1;
 
 		storage->token = 0;
+		bzero(storage->ca_name, TCP_CA_NAME_MAX);
 	} else {
 		if (!CONFIG_MPTCP)
 			return 1;
@@ -65,6 +68,7 @@ int _sockops(struct bpf_sock_ops *ctx)
 			return 1;
 
 		storage->token = msk->token;
+		memcpy(storage->ca_name, msk->ca_name, TCP_CA_NAME_MAX);
 	}
 	storage->invoked++;
 	storage->is_mptcp = is_mptcp;
-- 
2.36.1

