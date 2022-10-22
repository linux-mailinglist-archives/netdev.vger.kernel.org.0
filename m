Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1366082F9
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 02:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJVAp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 20:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJVApx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 20:45:53 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A6F214661
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 17:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666399552; x=1697935552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zhcIsV30RmXvtXV2KMqAcqNirSX2pOhDxfaozeXt4Dw=;
  b=XSbyTz740Zas0aAH37E2+3l6WPQq+Bev3ar0WxOTTCbzsUFBdGSKJpb5
   Wku84ErDP4mJk+0J6+pzqpSCyU4wt5DOEJ3VYEzyi3oyGM9kh0h8Vl1XF
   hsoFYjlIemPT2Pzyj31rjFFfz/No/hzYgVO4Ul/ZsHyIJ39QwCs8E3fk5
   RoBAjyQAhphksSx9RknrhaHVtTW3ITCpUBKmNNPWEzDvSbL/tS0nhGOdw
   MvwxJZFb2P9A0TwXR9RTMqbllpkA1TfKHKNVLBPTwYUrCsNyAyXxfLTkB
   c6zy5yODXOCBiNJ2sWjlcqI/ABq6oWsu7n8uFMkrFa2Ux8FxVEq4kMrx6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="304748917"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="304748917"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 17:45:50 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="581795621"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="581795621"
Received: from tremple-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.81])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 17:45:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/3] mptcp: sockopt: use new helper for TCP_DEFER_ACCEPT
Date:   Fri, 21 Oct 2022 17:45:05 -0700
Message-Id: <20221022004505.160988-4-mathew.j.martineau@linux.intel.com>
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

mptcp_setsockopt_sol_tcp_defer() was doing the same thing as
mptcp_setsockopt_first_sf_only() except for the returned code in case of
error.

Ignoring the error is needed to mimic how TCP_DEFER_ACCEPT is handled
when used with "plain" TCP sockets.

The specific function for TCP_DEFER_ACCEPT can be replaced by the new
mptcp_setsockopt_first_sf_only() helper and errors can be ignored to
stay compatible with TCP. A bit of cleanup.

Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 1857281a0dd5..f85e9bbfe86f 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -758,18 +758,6 @@ static int mptcp_setsockopt_v4(struct mptcp_sock *msk, int optname,
 	return -EOPNOTSUPP;
 }
 
-static int mptcp_setsockopt_sol_tcp_defer(struct mptcp_sock *msk, sockptr_t optval,
-					  unsigned int optlen)
-{
-	struct socket *listener;
-
-	listener = __mptcp_nmpc_socket(msk);
-	if (!listener)
-		return 0; /* TCP_DEFER_ACCEPT does not fail */
-
-	return tcp_setsockopt(listener->sk, SOL_TCP, TCP_DEFER_ACCEPT, optval, optlen);
-}
-
 static int mptcp_setsockopt_first_sf_only(struct mptcp_sock *msk, int level, int optname,
 					  sockptr_t optval, unsigned int optlen)
 {
@@ -810,7 +798,9 @@ static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_NODELAY:
 		return mptcp_setsockopt_sol_tcp_nodelay(msk, optval, optlen);
 	case TCP_DEFER_ACCEPT:
-		return mptcp_setsockopt_sol_tcp_defer(msk, optval, optlen);
+		/* See tcp.c: TCP_DEFER_ACCEPT does not fail */
+		mptcp_setsockopt_first_sf_only(msk, SOL_TCP, optname, optval, optlen);
+		return 0;
 	case TCP_FASTOPEN_CONNECT:
 	case TCP_FASTOPEN_NO_COOKIE:
 		return mptcp_setsockopt_first_sf_only(msk, SOL_TCP, optname,
-- 
2.38.1

