Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7001361674
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238040AbhDOXps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:45:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:63183 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237237AbhDOXpd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:45:33 -0400
IronPort-SDR: eJsNcd+WmRfWDTjTkzSWK3X6rIG9U5ET94NbrpCLiJMEa1BRxPBZKa/GhKeNDnNlrr0jzyRmJG
 605htm1BZ9Qg==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="215480174"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="215480174"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:09 -0700
IronPort-SDR: eIbrRUOAN3WVpfshcuyvUBqVG6jPIvdtXo51BqurG/xyONEOKClESmXd7mnXM2QMFmokSeiw/L
 QGkhKTaopJkw==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="461793371"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.243.150])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:08 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 11/13] mptcp: setsockopt: SO_DEBUG and no-op options
Date:   Thu, 15 Apr 2021 16:45:00 -0700
Message-Id: <20210415234502.224225-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
References: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Handle SO_DEBUG and set it on all subflows.
Ignore those values not implemented on TCP sockets.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 7eb637488dc2..390433b7f324 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -77,6 +77,9 @@ static void mptcp_sol_socket_sync_intval(struct mptcp_sock *msk, int optname, in
 		bool slow = lock_sock_fast(ssk);
 
 		switch (optname) {
+		case SO_DEBUG:
+			sock_valbool_flag(ssk, SOCK_DBG, !!val);
+			break;
 		case SO_KEEPALIVE:
 			if (ssk->sk_prot->keepalive)
 				ssk->sk_prot->keepalive(ssk, !!val);
@@ -150,6 +153,7 @@ static int mptcp_setsockopt_sol_socket_int(struct mptcp_sock *msk, int optname,
 	case SO_KEEPALIVE:
 		mptcp_sol_socket_sync_intval(msk, optname, val);
 		return 0;
+	case SO_DEBUG:
 	case SO_MARK:
 	case SO_PRIORITY:
 	case SO_SNDBUF:
@@ -246,9 +250,21 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 	case SO_RCVBUFFORCE:
 	case SO_MARK:
 	case SO_INCOMING_CPU:
+	case SO_DEBUG:
 		return mptcp_setsockopt_sol_socket_int(msk, optname, optval, optlen);
 	case SO_LINGER:
 		return mptcp_setsockopt_sol_socket_linger(msk, optval, optlen);
+	case SO_NO_CHECK:
+	case SO_DONTROUTE:
+	case SO_BROADCAST:
+	case SO_BSDCOMPAT:
+	case SO_PASSCRED:
+	case SO_PASSSEC:
+	case SO_RXQ_OVFL:
+	case SO_WIFI_STATUS:
+	case SO_NOFCS:
+	case SO_SELECT_ERR_QUEUE:
+		return 0;
 	}
 
 	return sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname, optval, optlen);
-- 
2.31.1

