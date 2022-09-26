Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491F65EB5C0
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiIZX1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiIZX1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:27:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F88F6EF29
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664234865; x=1695770865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dTdNtwOMsNbFRYHs8fkMG5KM7mukDSfJKHtWQRWdNQ8=;
  b=ho38uD6CROEELp1goaOA9rVWAz27gENRRVNWLnqLoqZZtTQjw6INpS26
   SYhLsNGGUlApq7h2ItaogJpqZ+GhE49QYZiuvsC1zQwwlAJVDcmdhzDGx
   07H3ZVyhd5HzZzVm9Lo/dHjly0OiOX5+bGQWjZH8jYCZhyLdeQWImeU0k
   EnD3Si4whJk7sDQZiFr/Oo2GRjcG9QvBeSbsxwE0/0Q7L50DgSRtvZZiu
   +4nKNH2TQ6vPKzq7gOmEnqQG3UZsrlhhW5Y86Ni8hZmJX2qHizJSrifiT
   xalQoBypP5ZWXwzkkqgVWtSi1kvxPIr9027Bw/JFLwyuWqmihATHuP3Pq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="280890867"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="280890867"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 16:27:44 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="572424285"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="572424285"
Received: from sankarka-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.3.132])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 16:27:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmytro@shytyi.net,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/4] mptcp: add TCP_FASTOPEN_CONNECT socket option
Date:   Mon, 26 Sep 2022 16:27:36 -0700
Message-Id: <20220926232739.76317-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926232739.76317-1-mathew.j.martineau@linux.intel.com>
References: <20220926232739.76317-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Hesmans <benjamin.hesmans@tessares.net>

Set the option for the first subflow only. For the other subflows TFO
can't be used because a mapping would be needed to cover the data in the
SYN.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Benjamin Hesmans <benjamin.hesmans@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 423d3826ca1e..c7cb68c725b2 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -559,6 +559,7 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		case TCP_NOTSENT_LOWAT:
 		case TCP_TX_DELAY:
 		case TCP_INQ:
+		case TCP_FASTOPEN_CONNECT:
 			return true;
 		}
 
@@ -567,7 +568,7 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		/* TCP_REPAIR, TCP_REPAIR_QUEUE, TCP_QUEUE_SEQ, TCP_REPAIR_OPTIONS,
 		 * TCP_REPAIR_WINDOW are not supported, better avoid this mess
 		 */
-		/* TCP_FASTOPEN_KEY, TCP_FASTOPEN TCP_FASTOPEN_CONNECT, TCP_FASTOPEN_NO_COOKIE,
+		/* TCP_FASTOPEN_KEY, TCP_FASTOPEN, TCP_FASTOPEN_NO_COOKIE,
 		 * are not supported fastopen is currently unsupported
 		 */
 	}
@@ -768,6 +769,19 @@ static int mptcp_setsockopt_sol_tcp_defer(struct mptcp_sock *msk, sockptr_t optv
 	return tcp_setsockopt(listener->sk, SOL_TCP, TCP_DEFER_ACCEPT, optval, optlen);
 }
 
+static int mptcp_setsockopt_sol_tcp_fastopen_connect(struct mptcp_sock *msk, sockptr_t optval,
+						     unsigned int optlen)
+{
+	struct socket *sock;
+
+	/* Limit to first subflow */
+	sock = __mptcp_nmpc_socket(msk);
+	if (!sock)
+		return -EINVAL;
+
+	return tcp_setsockopt(sock->sk, SOL_TCP, TCP_FASTOPEN_CONNECT, optval, optlen);
+}
+
 static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    sockptr_t optval, unsigned int optlen)
 {
@@ -796,6 +810,8 @@ static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 		return mptcp_setsockopt_sol_tcp_nodelay(msk, optval, optlen);
 	case TCP_DEFER_ACCEPT:
 		return mptcp_setsockopt_sol_tcp_defer(msk, optval, optlen);
+	case TCP_FASTOPEN_CONNECT:
+		return mptcp_setsockopt_sol_tcp_fastopen_connect(msk, optval, optlen);
 	}
 
 	return -EOPNOTSUPP;
@@ -1157,6 +1173,7 @@ static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_INFO:
 	case TCP_CC_INFO:
 	case TCP_DEFER_ACCEPT:
+	case TCP_FASTOPEN_CONNECT:
 		return mptcp_getsockopt_first_sf_only(msk, SOL_TCP, optname,
 						      optval, optlen);
 	case TCP_INQ:
-- 
2.37.3

