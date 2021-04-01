Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6764E352352
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbhDAXTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:19:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:18940 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233921AbhDAXTw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:19:52 -0400
IronPort-SDR: Tq2So5m2KwHT8FLoBWFb4p3UdhaHpnPSp44d6XfEP8Usk6OTF7sxNxd8BHCwdGUs8VWt7ytwAq
 agQaEdMco85A==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="191829877"
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="191829877"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:19:52 -0700
IronPort-SDR: 4AWNG12Iypa19vUT9P7oPRn+oQz6L2IZkd8hDfhDcNHfi7KgUucLMdoNQ/iAG2yTZm//FL9MJy
 UBZArSGzMOjQ==
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="446269182"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.128.105])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:19:52 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/7] mptcp: add mib for token creation fallback
Date:   Thu,  1 Apr 2021 16:19:41 -0700
Message-Id: <20210401231947.162836-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210401231947.162836-1-mathew.j.martineau@linux.intel.com>
References: <20210401231947.162836-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

If the MPTCP protocol is unable to create a new token,
the socket fallback to plain TCP, let's keep track
of such events via a specific MIB.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c      | 1 +
 net/mptcp/mib.h      | 1 +
 net/mptcp/protocol.c | 4 +++-
 net/mptcp/subflow.c  | 3 +++
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index 3780c29c321d..b0429aca4f76 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -13,6 +13,7 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("MPCapableACKRX", MPTCP_MIB_MPCAPABLEPASSIVEACK),
 	SNMP_MIB_ITEM("MPCapableFallbackACK", MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK),
 	SNMP_MIB_ITEM("MPCapableFallbackSYNACK", MPTCP_MIB_MPCAPABLEACTIVEFALLBACK),
+	SNMP_MIB_ITEM("MPFallbackTokenInit", MPTCP_MIB_TOKENFALLBACKINIT),
 	SNMP_MIB_ITEM("MPTCPRetrans", MPTCP_MIB_RETRANSSEGS),
 	SNMP_MIB_ITEM("MPJoinNoTokenFound", MPTCP_MIB_JOINNOTOKEN),
 	SNMP_MIB_ITEM("MPJoinSynRx", MPTCP_MIB_JOINSYNRX),
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 72afbc135f8e..50e1668c9a01 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -6,6 +6,7 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_MPCAPABLEPASSIVEACK,	/* Received third ACK with MP_CAPABLE */
 	MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK,/* Server-side fallback during 3-way handshake */
 	MPTCP_MIB_MPCAPABLEACTIVEFALLBACK, /* Client-side fallback during 3-way handshake */
+	MPTCP_MIB_TOKENFALLBACKINIT,	/* Could not init/allocate token */
 	MPTCP_MIB_RETRANSSEGS,		/* Segments retransmitted at the MPTCP-level */
 	MPTCP_MIB_JOINNOTOKEN,		/* Received MP_JOIN but the token was not found */
 	MPTCP_MIB_JOINSYNRX,		/* Received a SYN + MP_JOIN */
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 171b77537dcb..3b50e8cc0c5f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3224,8 +3224,10 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	if (rcu_access_pointer(tcp_sk(ssock->sk)->md5sig_info))
 		mptcp_subflow_early_fallback(msk, subflow);
 #endif
-	if (subflow->request_mptcp && mptcp_token_new_connect(ssock->sk))
+	if (subflow->request_mptcp && mptcp_token_new_connect(ssock->sk)) {
+		MPTCP_INC_STATS(sock_net(ssock->sk), MPTCP_MIB_TOKENFALLBACKINIT);
 		mptcp_subflow_early_fallback(msk, subflow);
+	}
 
 do_connect:
 	err = ssock->ops->connect(ssock, uaddr, addr_len, flags);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6c074d3db0ed..b96e8dc01f08 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -165,6 +165,7 @@ static int subflow_check_req(struct request_sock *req,
 			if (mptcp_token_exists(subflow_req->token)) {
 				if (retries-- > 0)
 					goto again;
+				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_TOKENFALLBACKINIT);
 			} else {
 				subflow_req->mp_capable = 1;
 			}
@@ -176,6 +177,8 @@ static int subflow_check_req(struct request_sock *req,
 			subflow_req->mp_capable = 1;
 		else if (retries-- > 0)
 			goto again;
+		else
+			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_TOKENFALLBACKINIT);
 
 	} else if (mp_opt.mp_join && listener->request_mptcp) {
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
-- 
2.31.1

