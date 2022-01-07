Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4080486EAB
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344100AbiAGAUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:47 -0500
Received: from mga03.intel.com ([134.134.136.65]:47987 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343994AbiAGAUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514843; x=1673050843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oCyq5RZUHo1umQP1x3X959pDNQKh7V3k2L2OZJIpa1w=;
  b=hjWDp4PPhbYemYp/I+3OlLJEUDov34db5EAmuhx3yarXP/1QcbqUDKc4
   PRUy7CVZymDD9KYFZ46+sjcG514UIQNd8JeBzmkx56J7FbHJFky7tCo2Q
   QceknHN9EV4kL76KbTnHqnVb/14kyBCLYJHZyRPwyavegKy3Vs1m7Cvu0
   8C1IUhaDyfhB04+AiaMVUS8pcBC/IoRLsoAeo2ZGNhO82M8+wZMlakhvB
   P49kntpdm+5Fqh1Gs2gQ09bA6s9zMWuT5i/2vxiVu4BHnaCfxhk4qx20W
   p9rWxH55o13F5L440YeZM+XcEsFnQKEkj7GLEZmviZWeIOBR2Bj31wu+9
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721307"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721307"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:35 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508504"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:35 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/13] mptcp: implement support for user-space disconnect
Date:   Thu,  6 Jan 2022 16:20:18 -0800
Message-Id: <20220107002026.375427-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Handle explicitly AF_UNSPEC in mptcp_stream_connnect() to
allow user-space to disconnect established MPTCP connections

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 628cd60c9d0f..667e153e6e24 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3404,9 +3404,20 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
 	struct mptcp_subflow_context *subflow;
 	struct socket *ssock;
-	int err;
+	int err = -EINVAL;
 
 	lock_sock(sock->sk);
+	if (uaddr) {
+		if (addr_len < sizeof(uaddr->sa_family))
+			goto unlock;
+
+		if (uaddr->sa_family == AF_UNSPEC) {
+			err = mptcp_disconnect(sock->sk, flags);
+			sock->state = err ? SS_DISCONNECTING : SS_UNCONNECTED;
+			goto unlock;
+		}
+	}
+
 	if (sock->state != SS_UNCONNECTED && msk->subflow) {
 		/* pending connection or invalid state, let existing subflow
 		 * cope with that
@@ -3416,10 +3427,8 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	}
 
 	ssock = __mptcp_nmpc_socket(msk);
-	if (!ssock) {
-		err = -EINVAL;
+	if (!ssock)
 		goto unlock;
-	}
 
 	mptcp_token_destroy(msk);
 	inet_sk_state_store(sock->sk, TCP_SYN_SENT);
-- 
2.34.1

