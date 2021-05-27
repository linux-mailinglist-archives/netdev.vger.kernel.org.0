Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB713939BA
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbhE0X4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:56:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:38830 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236733AbhE0X4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:56:16 -0400
IronPort-SDR: iQeLhKaAgs+vWhbnvo+jKtGH9z/KyTEf/YZof36ybnmGav0+Fi/y3GpuBHIEUiIhZLm89u0vxe
 ld6e9X/bGFdQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="224079921"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="224079921"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:54:36 -0700
IronPort-SDR: vlnpwSYz5Z+7E4q84uRb+iSyJm8HIO4VjUaYajWCgrEpYiifKl9gCCKp2G6oAcPRD2pSFRpkNv
 QTUd8eNQ64gw==
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="443774251"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.84.136])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:54:36 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Jianguo Wu <wujianguo@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/7] mptcp: using TOKEN_MAX_RETRIES instead of magic number
Date:   Thu, 27 May 2021 16:54:25 -0700
Message-Id: <20210527235430.183465-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
References: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

We have macro TOKEN_MAX_RETRIES for the number of token generate retries,
so using TOKEN_MAX_RETRIES in subflow_check_req().

And rename TOKEN_MAX_RETRIES to MPTCP_TOKEN_MAX_RETRIES as it is now
exposed.

Fixes: 535fb8152f31 ("mptcp: token: move retry to caller")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.h | 2 ++
 net/mptcp/subflow.c  | 2 +-
 net/mptcp/token.c    | 3 +--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0c6f99c67345..89f6b73783d5 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -627,6 +627,8 @@ static inline void mptcp_write_space(struct sock *sk)
 
 void mptcp_destroy_common(struct mptcp_sock *msk);
 
+#define MPTCP_TOKEN_MAX_RETRIES	4
+
 void __init mptcp_token_init(void);
 static inline void mptcp_token_init_request(struct request_sock *req)
 {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bde6be77ea73..a50a97908866 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -162,7 +162,7 @@ static int subflow_check_req(struct request_sock *req,
 	}
 
 	if (mp_opt.mp_capable && listener->request_mptcp) {
-		int err, retries = 4;
+		int err, retries = MPTCP_TOKEN_MAX_RETRIES;
 
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 again:
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 72a24e63b131..a98e554b034f 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -33,7 +33,6 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
-#define TOKEN_MAX_RETRIES	4
 #define TOKEN_MAX_CHAIN_LEN	4
 
 struct token_bucket {
@@ -153,7 +152,7 @@ int mptcp_token_new_connect(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
-	int retries = TOKEN_MAX_RETRIES;
+	int retries = MPTCP_TOKEN_MAX_RETRIES;
 	struct token_bucket *bucket;
 
 again:
-- 
2.31.1

