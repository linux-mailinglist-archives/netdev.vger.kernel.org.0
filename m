Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7315526F86
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiENDAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 23:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiENC7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 22:59:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEC756768
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 18:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652491732; x=1684027732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xTy6YizjRk/aiQtdxnOlDVnO3Ugko3s9yjx08r1djuo=;
  b=M269oUNtTdcU2USCoveTzhCuHEw9u42b7s2RBvxvfWfyeD+faNV+AQA2
   ox2W18MCqYKTSWSsOhJ0zS7P42Fejp80bMjWBLmzDdovW53/6bGYYIoui
   pKrggYcbAjwJwJQTcVHo9dZiJtM9OWoH+FkplzXFltIt5Utojr+6ViVur
   47gOxbdifjHH8yP8D6eBcqQMozcslXWVHFtaR9gBg+yE2kjQ0axnjy+fe
   NLbopaBPaNpUZ/cN3j9z/q+EJmHhJCz3G99lTMz5JzUhGSA+quVOrM/cQ
   IRhGCL+T0LN/rJoJFtm20MWn26gUVcf2DNWnhoLSquN7p/ZAA+b0hQ4fK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="257994316"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="257994316"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 17:21:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="625102789"
Received: from clakshma-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.160.121])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 17:21:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/3] mptcp: sockopt: add TCP_DEFER_ACCEPT support
Date:   Fri, 13 May 2022 17:21:15 -0700
Message-Id: <20220514002115.725976-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220514002115.725976-1-mathew.j.martineau@linux.intel.com>
References: <20220514002115.725976-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Support this via passthrough to the underlying tcp listener socket.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/271
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 826b0c1dae98..423d3826ca1e 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -756,6 +756,18 @@ static int mptcp_setsockopt_v4(struct mptcp_sock *msk, int optname,
 	return -EOPNOTSUPP;
 }
 
+static int mptcp_setsockopt_sol_tcp_defer(struct mptcp_sock *msk, sockptr_t optval,
+					  unsigned int optlen)
+{
+	struct socket *listener;
+
+	listener = __mptcp_nmpc_socket(msk);
+	if (!listener)
+		return 0; /* TCP_DEFER_ACCEPT does not fail */
+
+	return tcp_setsockopt(listener->sk, SOL_TCP, TCP_DEFER_ACCEPT, optval, optlen);
+}
+
 static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    sockptr_t optval, unsigned int optlen)
 {
@@ -782,6 +794,8 @@ static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 		return mptcp_setsockopt_sol_tcp_cork(msk, optval, optlen);
 	case TCP_NODELAY:
 		return mptcp_setsockopt_sol_tcp_nodelay(msk, optval, optlen);
+	case TCP_DEFER_ACCEPT:
+		return mptcp_setsockopt_sol_tcp_defer(msk, optval, optlen);
 	}
 
 	return -EOPNOTSUPP;
@@ -1142,6 +1156,7 @@ static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_CONGESTION:
 	case TCP_INFO:
 	case TCP_CC_INFO:
+	case TCP_DEFER_ACCEPT:
 		return mptcp_getsockopt_first_sf_only(msk, SOL_TCP, optname,
 						      optval, optlen);
 	case TCP_INQ:
-- 
2.36.1

