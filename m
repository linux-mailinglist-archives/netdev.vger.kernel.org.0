Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE386082F7
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 02:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJVApy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 20:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJVApx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 20:45:53 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108B51FAE7E
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 17:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666399552; x=1697935552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kz8r5YH7Q2QfoWM5VaAHKc6rmHLjowK138ZlxWCEK0I=;
  b=RJr878CSPFkR1icCoT8TtBh5vkty6tmOF0NaVmIfAA/KEZlrY3HXadBX
   V1gMEM4ggYn4TYd7H/X98MzcvBObZcUoVIK7VFlOeTSsmi2RA2nDqG8aL
   WS/Cmn0al3Uv158rkDBesJF71j/usFUE2E/sU5M74SWSrauq1bNttb9/z
   wW23+noxopMGPtTr3XX311bbi6dTKFU1goAYc4ONaGW0yOLkhyBPSky9J
   M1VVBpl394bXuun9TR60o8x3j9lhEIY6NwRLd8bqRII1ymRsmUHB1vV3Y
   aZENOU/RkXlIv3Ds1h/1Vm3vLitO5MhB7Do3bIQOFjI+b7ioQptyUTY+5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="304748915"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="304748915"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 17:45:50 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="581795619"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="581795619"
Received: from tremple-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.81])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 17:45:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/3] mptcp: sockopt: make 'tcp_fastopen_connect' generic
Date:   Fri, 21 Oct 2022 17:45:03 -0700
Message-Id: <20221022004505.160988-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022004505.160988-1-mathew.j.martineau@linux.intel.com>
References: <20221022004505.160988-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

There are other socket options that need to act only on the first
subflow, e.g. all TCP_FASTOPEN* socket options.

This is similar to the getsockopt version.

In the next commit, this new mptcp_setsockopt_first_sf_only() helper is
used by other another option.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index c7cb68c725b2..8d3b09d75c3a 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -769,17 +769,17 @@ static int mptcp_setsockopt_sol_tcp_defer(struct mptcp_sock *msk, sockptr_t optv
 	return tcp_setsockopt(listener->sk, SOL_TCP, TCP_DEFER_ACCEPT, optval, optlen);
 }
 
-static int mptcp_setsockopt_sol_tcp_fastopen_connect(struct mptcp_sock *msk, sockptr_t optval,
-						     unsigned int optlen)
+static int mptcp_setsockopt_first_sf_only(struct mptcp_sock *msk, int level, int optname,
+					  sockptr_t optval, unsigned int optlen)
 {
 	struct socket *sock;
 
-	/* Limit to first subflow */
+	/* Limit to first subflow, before the connection establishment */
 	sock = __mptcp_nmpc_socket(msk);
 	if (!sock)
 		return -EINVAL;
 
-	return tcp_setsockopt(sock->sk, SOL_TCP, TCP_FASTOPEN_CONNECT, optval, optlen);
+	return tcp_setsockopt(sock->sk, level, optname, optval, optlen);
 }
 
 static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
@@ -811,7 +811,8 @@ static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_DEFER_ACCEPT:
 		return mptcp_setsockopt_sol_tcp_defer(msk, optval, optlen);
 	case TCP_FASTOPEN_CONNECT:
-		return mptcp_setsockopt_sol_tcp_fastopen_connect(msk, optval, optlen);
+		return mptcp_setsockopt_first_sf_only(msk, SOL_TCP, optname,
+						      optval, optlen);
 	}
 
 	return -EOPNOTSUPP;
-- 
2.38.1

