Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFB855DF6F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbiF1BDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243007AbiF1BCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:02:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B31422B14
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 18:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656378174; x=1687914174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wi7F1z6CctRCQxoeHDKSVN4TBguQrYOW58cE0JPGs0U=;
  b=iXeFQDrQHCQbQJXblbLihqMLtImMM5jLufSpGTT2Vj9LJFNM7Ljh3j+G
   7RHM39hS29WJvPt8Hc86pPBk7UYDwV1yRgX16Qs1C5FQ0/+zfWu+YlNjI
   oym4PlW0aW8v9ya/TTYFRvDPu/Dz40+t599c+p3y5wRJm5Lsdk0XrBTm7
   B6pyAfQ0vDuIeO9NBHaTaY5bwmAY6mKRbYpvrjPn9MbLQ2Q6HD5seyhjK
   a+Jr4Tu6eH7n6Y5Wy6aP+ovPOZL69pVG7T0LEbC8ocVA7YJjLlF3iyTdQ
   NleJuxuDmvdFRULDlZKZHl/rWPwIxzuBjeoe1VBFSeCtWF1KbLEU/dydx
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="264642458"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="264642458"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="692867421"
Received: from cgarner-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.0.217])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:52 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de, geliang.tang@suse.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net 9/9] selftests: mptcp: Initialize variables to quiet gcc 12 warnings
Date:   Mon, 27 Jun 2022 18:02:43 -0700
Message-Id: <20220628010243.166605-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
References: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a few MPTCP selftest tools, gcc 12 complains that the 'sock' variable
might be used uninitialized. This is a false positive because the only
code path that could lead to uninitialized access is where getaddrinfo()
fails, but the local xgetaddrinfo() wrapper exits if such a failure
occurs.

Initialize the 'sock' variable anyway to allow the tools to build with
gcc 12.

Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c | 2 +-
 tools/testing/selftests/net/mptcp/mptcp_inq.c     | 2 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 8628aa61b763..e2ea6c126c99 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -265,7 +265,7 @@ static void sock_test_tcpulp(int sock, int proto, unsigned int line)
 static int sock_listen_mptcp(const char * const listenaddr,
 			     const char * const port)
 {
-	int sock;
+	int sock = -1;
 	struct addrinfo hints = {
 		.ai_protocol = IPPROTO_TCP,
 		.ai_socktype = SOCK_STREAM,
diff --git a/tools/testing/selftests/net/mptcp/mptcp_inq.c b/tools/testing/selftests/net/mptcp/mptcp_inq.c
index 29f75e2a1116..8672d898f8cd 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_inq.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_inq.c
@@ -88,7 +88,7 @@ static void xgetaddrinfo(const char *node, const char *service,
 static int sock_listen_mptcp(const char * const listenaddr,
 			     const char * const port)
 {
-	int sock;
+	int sock = -1;
 	struct addrinfo hints = {
 		.ai_protocol = IPPROTO_TCP,
 		.ai_socktype = SOCK_STREAM,
diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
index ac9a4d9c1764..ae61f39556ca 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
@@ -136,7 +136,7 @@ static void xgetaddrinfo(const char *node, const char *service,
 static int sock_listen_mptcp(const char * const listenaddr,
 			     const char * const port)
 {
-	int sock;
+	int sock = -1;
 	struct addrinfo hints = {
 		.ai_protocol = IPPROTO_TCP,
 		.ai_socktype = SOCK_STREAM,
-- 
2.37.0

