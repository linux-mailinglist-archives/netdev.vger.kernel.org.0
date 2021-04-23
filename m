Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95A036990A
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbhDWSRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:17:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:40508 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhDWSRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 14:17:51 -0400
IronPort-SDR: VdDSzGTHEK0dvcw25b7k7ow5nP6ilEq82eoPaKZWoHyA9mPrnSDRXdrWMsUZh/SCMsao2H19yz
 V5Xh3zYD5LMA==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="196172519"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="196172519"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 11:17:14 -0700
IronPort-SDR: 3cJ9tlV6f8s9hb1Mw9evb6XTGcTSxqQjIevvDmtX21YwG6yCFb7frc1h/PgDxqvtu/puUpqNOM
 lTvpKPp94uhg==
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="402264967"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.72.13])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 11:17:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/5] mptcp: implement dummy MSG_ERRQUEUE support
Date:   Fri, 23 Apr 2021 11:17:05 -0700
Message-Id: <20210423181709.330233-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
References: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

mptcp_recvmsg() currently silently ignores MSG_ERRQUEUE, returning
input data instead of error cmsg.

This change provides a dummy implementation for MSG_ERRQUEUE - always
returns no data. That is consistent with the current lack of a suitable
IP_RECVERR setsockopt() support.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c14ac2975736..1d5f23bd640c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1945,6 +1945,10 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	int target;
 	long timeo;
 
+	/* MSG_ERRQUEUE is really a no-op till we support IP_RECVERR */
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+
 	if (msg->msg_flags & ~(MSG_WAITALL | MSG_DONTWAIT))
 		return -EOPNOTSUPP;
 
-- 
2.31.1

