Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E283A52E08B
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343619AbiESXah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343572AbiESXa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:30:27 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586C010788E;
        Thu, 19 May 2022 16:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653003026; x=1684539026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=la3wcnMhgWCUcLyaEaClOPhyG2MoAKhnFpoSTvrOpAQ=;
  b=Sk+IQI+zGn3OY8T2Lt0SbcrOJ2w9iqNK/Sm6oanPYaaT7YVsKfPXYqkC
   VliSvsfit9lL1OqWOjaCavoEugwlqSRo4IoEwgUgOQ8aedGPBJ+HKYJ52
   v2eaK/1KYMdU5ot0SB5RpmrcSeJc5FJiECFrN/rdBot1OZAuIq2iVDG1K
   R5SEgbXQTovwT/apSh5NvGEQgR4rVLSx+3QSN3AaZ81hRgKcNisOgKevo
   R6Ga3ZdAt7nuIbtpJsSD1Cnfb9QUTyzSmxEw7ejni4/15690NVBCvT7H5
   tQi51gb+dIk5gOuHKZPxyB2NG2Yjv8xCz9yIZ3Ri46bIi7iIQSWa3RpcT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272547208"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272547208"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570491205"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.132.179])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v5 7/7] selftests/bpf: verify first of struct mptcp_sock
Date:   Thu, 19 May 2022 16:30:16 -0700
Message-Id: <20220519233016.105670-8-mathew.j.martineau@linux.intel.com>
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

This patch verifies the 'first' struct member of struct mptcp_sock, which
points to the first subflow of msk. Save 'sk' in mptcp_storage, and verify
it with 'first' in verify_msk().

v5:
 - Use ASSERT_EQ() instead of a manual comparison + log (Andrii).

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h  | 1 +
 tools/testing/selftests/bpf/prog_tests/mptcp.c | 5 +++++
 tools/testing/selftests/bpf/progs/mptcp_sock.c | 5 +++++
 3 files changed, 11 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
index c38c66d5c1e6..82a7c9de95f9 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -234,6 +234,7 @@ struct mptcp_sock {
 	struct inet_connection_sock	sk;
 
 	__u32		token;
+	struct sock	*first;
 	char		ca_name[TCP_CA_NAME_MAX];
 } __attribute__((preserve_access_index));
 
diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index 17ad1cb07339..257a8668ad40 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -14,7 +14,9 @@
 struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
+	struct sock *sk;
 	__u32 token;
+	struct sock *first;
 	char ca_name[TCP_CA_NAME_MAX];
 };
 
@@ -80,6 +82,9 @@ static int verify_msk(int map_fd, int client_fd, __u32 token)
 	if (!ASSERT_EQ(val.token, token, "unexpected token"))
 		err++;
 
+	if (!ASSERT_EQ(val.first, val.sk, "unexpected first"))
+		err++;
+
 	if (!ASSERT_STRNEQ(val.ca_name, ca_name, TCP_CA_NAME_MAX, "unexpected ca_name"))
 		err++;
 
diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
index 6a78e7b754a8..f638cb876424 100644
--- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -13,7 +13,9 @@ __u32 token = 0;
 struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
+	struct sock *sk;
 	__u32 token;
+	struct sock *first;
 	char ca_name[TCP_CA_NAME_MAX];
 };
 
@@ -54,6 +56,7 @@ int _sockops(struct bpf_sock_ops *ctx)
 
 		storage->token = 0;
 		bzero(storage->ca_name, TCP_CA_NAME_MAX);
+		storage->first = NULL;
 	} else {
 		msk = bpf_skc_to_mptcp_sock(sk);
 		if (!msk)
@@ -66,9 +69,11 @@ int _sockops(struct bpf_sock_ops *ctx)
 
 		storage->token = msk->token;
 		memcpy(storage->ca_name, msk->ca_name, TCP_CA_NAME_MAX);
+		storage->first = msk->first;
 	}
 	storage->invoked++;
 	storage->is_mptcp = is_mptcp;
+	storage->sk = (struct sock *)sk;
 
 	return 1;
 }
-- 
2.36.1

