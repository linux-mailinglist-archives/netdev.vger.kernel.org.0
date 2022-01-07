Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D99486EAE
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344132AbiAGAU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:47989 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344032AbiAGAUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514844; x=1673050844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SmK4eTa7/IDy9IX+vrPbcpaVTyIuoZLG19V1MwDuTCw=;
  b=AJTTxXnSUw4KdxN4plgDYoA0HJRn6FrIUdyVR2brPKrkXX1/XqQlvdCc
   P+zAxRGjknTyvBgaocVe+3ZUaM1Io4o1Hw1XF7aCCt2UA1NTeUf1YnWnG
   15Kg2EdbsZ0OAkxu41pKbRA77KTl9Dl+zrhEpWyE36AchXjFJsK7ZZPbl
   SXauemQIP33Aw71iqvhO4AZjVgrcYhFJZD3hMJk2PYv+IarM2IKGUkHL4
   Ycv+PvuJ1evS9NJ0jB9moEQ6s/2tfXaJ2br2A5DpSmIjtaCAk10wW7Nf5
   NVcLMQ9lkhNJHrFZdpi0Sp92xCLJ9BfnHAURmvb5uWTOGJydD9JPKP2PI
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721312"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721312"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508508"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/13] mptcp: clean-up MPJ option writing
Date:   Thu,  6 Jan 2022 16:20:21 -0800
Message-Id: <20220107002026.375427-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Check for all MPJ variant at once, this reduces the number
of conditionals traversed on average and will simplify the
next patch.

No functional change intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 46d35a235f35..38e34a1fb2dd 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1385,27 +1385,29 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 
 		/* MPC is additionally mutually exclusive with MP_PRIO */
 		goto mp_capable_done;
-	} else if (OPTION_MPTCP_MPJ_SYN & opts->suboptions) {
-		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
-				      TCPOLEN_MPTCP_MPJ_SYN,
-				      opts->backup, opts->join_id);
-		put_unaligned_be32(opts->token, ptr);
-		ptr += 1;
-		put_unaligned_be32(opts->nonce, ptr);
-		ptr += 1;
-	} else if (OPTION_MPTCP_MPJ_SYNACK & opts->suboptions) {
-		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
-				      TCPOLEN_MPTCP_MPJ_SYNACK,
-				      opts->backup, opts->join_id);
-		put_unaligned_be64(opts->thmac, ptr);
-		ptr += 2;
-		put_unaligned_be32(opts->nonce, ptr);
-		ptr += 1;
-	} else if (OPTION_MPTCP_MPJ_ACK & opts->suboptions) {
-		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
-				      TCPOLEN_MPTCP_MPJ_ACK, 0, 0);
-		memcpy(ptr, opts->hmac, MPTCPOPT_HMAC_LEN);
-		ptr += 5;
+	} else if (OPTIONS_MPTCP_MPJ & opts->suboptions) {
+		if (OPTION_MPTCP_MPJ_SYN & opts->suboptions) {
+			*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
+					      TCPOLEN_MPTCP_MPJ_SYN,
+					      opts->backup, opts->join_id);
+			put_unaligned_be32(opts->token, ptr);
+			ptr += 1;
+			put_unaligned_be32(opts->nonce, ptr);
+			ptr += 1;
+		} else if (OPTION_MPTCP_MPJ_SYNACK & opts->suboptions) {
+			*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
+					      TCPOLEN_MPTCP_MPJ_SYNACK,
+					      opts->backup, opts->join_id);
+			put_unaligned_be64(opts->thmac, ptr);
+			ptr += 2;
+			put_unaligned_be32(opts->nonce, ptr);
+			ptr += 1;
+		} else {
+			*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
+					      TCPOLEN_MPTCP_MPJ_ACK, 0, 0);
+			memcpy(ptr, opts->hmac, MPTCPOPT_HMAC_LEN);
+			ptr += 5;
+		}
 	} else if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
 		u8 len = TCPOLEN_MPTCP_ADD_ADDR_BASE;
 		u8 echo = MPTCP_ADDR_ECHO;
-- 
2.34.1

