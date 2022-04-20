Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E1F5092AE
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 00:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356256AbiDTW2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 18:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356127AbiDTW2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 18:28:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11E840A23;
        Wed, 20 Apr 2022 15:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650493518; x=1682029518;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ucorovcDrcWUwvZrK1HhQ9+JjNaUShoehufUGweoie0=;
  b=CBi0Xs953dMvUocId93p0IpEx8O6d9rWw++xguNgEHtW9zD4WFwzRJUm
   MfmSG/oB4hoLMBDrSizpzd39Eperh60FFVemNQYWhCFOvbSPwspdDuGSv
   i1HS5gady1cRUPbPEySxDoIiYXu1u94ULI7r2rlh3PCDiyzR8ss6GXfNL
   Id8dHWLqwdHDO18Zo8nrE/LPuBjt3FPLKEhhggSIt0wTFCIWKfgFABTNk
   9aXSr+gDsfXAkWy/pvDsDzHb6pJnh+GzVz40ghBbjOKaYDWC3rPuWZHkg
   bCSKN11SsQklpiG6aQSU8yFqUcD3tEwBtPvCrY/kgKv2UpLPGsSAzc05r
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="289277609"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="289277609"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:25:18 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="555422607"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.100.38])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:25:17 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next 6/7] selftests: bpf: verify ca_name of struct mptcp_sock
Date:   Wed, 20 Apr 2022 15:24:58 -0700
Message-Id: <20220420222459.307649-7-mathew.j.martineau@linux.intel.com>
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

This patch verifies another member of struct mptcp_sock, ca_name. Add a
new function get_msk_ca_name() to read the sysctl tcp_congestion_control
and verify it in verify_msk().

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/bpf/bpf_mptcp_helpers.h |  1 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  4 ++++
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 24 +++++++++++++++++++
 .../testing/selftests/bpf/progs/mptcp_sock.c  |  4 ++++
 4 files changed, 33 insertions(+)

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
index c5d96ba81e04..4518aa6e661e 100644
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
@@ -79,11 +84,22 @@ static __u32 get_msk_token(void)
 	return token;
 }
 
+void get_msk_ca_name(char ca_name[])
+{
+	FILE *stream = popen("sysctl -b net.ipv4.tcp_congestion_control", "r");
+
+	if (!fgets(ca_name, TCP_CA_NAME_MAX, stream))
+		log_err("Failed to read ca_name");
+
+	pclose(stream);
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
@@ -92,6 +108,8 @@ static int verify_msk(int map_fd, int client_fd)
 		return -1;
 	}
 
+	get_msk_ca_name(ca_name);
+
 	if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
 		perror("Failed to read socket storage");
 		return -1;
@@ -115,6 +133,12 @@ static int verify_msk(int map_fd, int client_fd)
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
index 56cc7c61131b..53bf67580010 100644
--- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020, Tessares SA. */
 
+#include <string.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include "bpf_mptcp_helpers.h"
@@ -12,6 +13,7 @@ struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
 	__u32 token;
+	char ca_name[TCP_CA_NAME_MAX];
 };
 
 struct {
@@ -48,6 +50,7 @@ int _sockops(struct bpf_sock_ops *ctx)
 			return 1;
 
 		storage->token = 0;
+		bzero(storage->ca_name, TCP_CA_NAME_MAX);
 	} else {
 		msk = bpf_skc_to_mptcp_sock(sk);
 		if (!msk)
@@ -59,6 +62,7 @@ int _sockops(struct bpf_sock_ops *ctx)
 			return 1;
 
 		storage->token = msk->token;
+		memcpy(storage->ca_name, msk->ca_name, TCP_CA_NAME_MAX);
 	}
 	storage->invoked++;
 	storage->is_mptcp = tcp_sk->is_mptcp;
-- 
2.36.0

