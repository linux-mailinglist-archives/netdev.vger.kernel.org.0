Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806422D4F1D
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgLIXzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:55:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:19420 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbgLIXzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:55:08 -0500
IronPort-SDR: CmcMkLL0KXyuGXZv4JVkb2ev+xyKwdynV/cxrjh/GmJ9z7RInGE8z15CcTsO/Q9Luhets0CMzI
 DzwoYzwWQlRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763089"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763089"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:38 -0800
IronPort-SDR: zrLgXQT5O93zGvkcye+KbvR7Un/3z/qz5EtQpqL7aPZ1hSpwMk1iVPqaP5mU3M/yeiOhv46sAf
 zKgOUnaEpoqQ==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582181"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/11] mptcp: unify ADD_ADDR and ADD_ADDR6 suboptions writing
Date:   Wed,  9 Dec 2020 15:51:19 -0800
Message-Id: <20201209235128.175473-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

The length of ADD_ADDR6 is 12 octets longer than ADD_ADDR. That's the
only difference between them.

This patch dropped the duplicate code between ADD_ADDR and ADD_ADDR6
suboptions writing, and unify them into one.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index a061b2106cfe..639d47e6e2d0 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1075,10 +1075,19 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 	}
 
 mp_capable_done:
-	if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
+	if ((OPTION_MPTCP_ADD_ADDR
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	     | OPTION_MPTCP_ADD_ADDR6
+#endif
+	    ) & opts->suboptions) {
 		u8 len = TCPOLEN_MPTCP_ADD_ADDR_BASE;
 		u8 echo = MPTCP_ADDR_ECHO;
 
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+		if (OPTION_MPTCP_ADD_ADDR6 & opts->suboptions)
+			len = TCPOLEN_MPTCP_ADD_ADDR6_BASE;
+#endif
+
 		if (opts->ahmac) {
 			len += sizeof(opts->ahmac);
 			echo = 0;
@@ -1086,33 +1095,21 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 
 		*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
 				      len, echo, opts->addr_id);
-		memcpy((u8 *)ptr, (u8 *)&opts->addr.s_addr, 4);
-		ptr += 1;
-		if (opts->ahmac) {
-			put_unaligned_be64(opts->ahmac, ptr);
-			ptr += 2;
+		if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
+			memcpy((u8 *)ptr, (u8 *)&opts->addr.s_addr, 4);
+			ptr += 1;
 		}
-	}
-
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	if (OPTION_MPTCP_ADD_ADDR6 & opts->suboptions) {
-		u8 len = TCPOLEN_MPTCP_ADD_ADDR6_BASE;
-		u8 echo = MPTCP_ADDR_ECHO;
-
-		if (opts->ahmac) {
-			len += sizeof(opts->ahmac);
-			echo = 0;
+		else if (OPTION_MPTCP_ADD_ADDR6 & opts->suboptions) {
+			memcpy((u8 *)ptr, opts->addr6.s6_addr, 16);
+			ptr += 4;
 		}
-		*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
-				      len, echo, opts->addr_id);
-		memcpy((u8 *)ptr, opts->addr6.s6_addr, 16);
-		ptr += 4;
+#endif
 		if (opts->ahmac) {
 			put_unaligned_be64(opts->ahmac, ptr);
 			ptr += 2;
 		}
 	}
-#endif
 
 	if (OPTION_MPTCP_RM_ADDR & opts->suboptions) {
 		*ptr++ = mptcp_option(MPTCPOPT_RM_ADDR,
-- 
2.29.2

