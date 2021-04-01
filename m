Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BE4352353
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbhDAXTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:19:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:18940 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234814AbhDAXTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:19:53 -0400
IronPort-SDR: WZdS2ka+tXB/Wjzgjo1vPZPYR+G4LXOR6+IiZdxQmU0Dnh1NogDrkJDN9dr9FX8npdF7DjN25L
 mVOp6p0K/Q7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="191829880"
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="191829880"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:19:53 -0700
IronPort-SDR: +HHGjp+Fo/zfZdsVmN3Ovsf4J5BA2xf9BCAlpmz6fVRYbZ+YFpMITIBNbXR7VU72kaHEuKGeB4
 4vEWWx2Eo+kw==
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="446269185"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.128.105])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:19:52 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/7] mptcp: add active MPC mibs
Date:   Thu,  1 Apr 2021 16:19:42 -0700
Message-Id: <20210401231947.162836-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210401231947.162836-1-mathew.j.martineau@linux.intel.com>
References: <20210401231947.162836-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

We are not currently tracking the active MPTCP connection
attempts. Let's add the related counters.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c      | 2 ++
 net/mptcp/mib.h      | 2 ++
 net/mptcp/protocol.c | 2 ++
 net/mptcp/subflow.c  | 1 +
 4 files changed, 7 insertions(+)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index b0429aca4f76..eb2dc6dbe212 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -10,6 +10,8 @@
 
 static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("MPCapableSYNRX", MPTCP_MIB_MPCAPABLEPASSIVE),
+	SNMP_MIB_ITEM("MPCapableSYNTX", MPTCP_MIB_MPCAPABLEACTIVE),
+	SNMP_MIB_ITEM("MPCapableSYNACKRX", MPTCP_MIB_MPCAPABLEACTIVEACK),
 	SNMP_MIB_ITEM("MPCapableACKRX", MPTCP_MIB_MPCAPABLEPASSIVEACK),
 	SNMP_MIB_ITEM("MPCapableFallbackACK", MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK),
 	SNMP_MIB_ITEM("MPCapableFallbackSYNACK", MPTCP_MIB_MPCAPABLEACTIVEFALLBACK),
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 50e1668c9a01..f0da4f060fe1 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -3,6 +3,8 @@
 enum linux_mptcp_mib_field {
 	MPTCP_MIB_NUM = 0,
 	MPTCP_MIB_MPCAPABLEPASSIVE,	/* Received SYN with MP_CAPABLE */
+	MPTCP_MIB_MPCAPABLEACTIVE,	/* Sent SYN with MP_CAPABLE */
+	MPTCP_MIB_MPCAPABLEACTIVEACK,	/* Received SYN/ACK with MP_CAPABLE */
 	MPTCP_MIB_MPCAPABLEPASSIVEACK,	/* Received third ACK with MP_CAPABLE */
 	MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK,/* Server-side fallback during 3-way handshake */
 	MPTCP_MIB_MPCAPABLEACTIVEFALLBACK, /* Client-side fallback during 3-way handshake */
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3b50e8cc0c5f..0c916d48cad8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3228,6 +3228,8 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 		MPTCP_INC_STATS(sock_net(ssock->sk), MPTCP_MIB_TOKENFALLBACKINIT);
 		mptcp_subflow_early_fallback(msk, subflow);
 	}
+	if (likely(!__mptcp_check_fallback(msk)))
+		MPTCP_INC_STATS(sock_net(sock->sk), MPTCP_MIB_MPCAPABLEACTIVE);
 
 do_connect:
 	err = ssock->ops->connect(ssock, uaddr, addr_len, flags);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index b96e8dc01f08..7a5f50d00d4b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -395,6 +395,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 		subflow->remote_key = mp_opt.sndr_key;
 		pr_debug("subflow=%p, remote_key=%llu", subflow,
 			 subflow->remote_key);
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEACTIVEACK);
 		mptcp_finish_connect(sk);
 	} else if (subflow->request_join) {
 		u8 hmac[SHA256_DIGEST_SIZE];
-- 
2.31.1

