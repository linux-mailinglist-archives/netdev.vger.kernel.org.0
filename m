Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4368E6082F8
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 02:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiJVApz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 20:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJVApx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 20:45:53 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270C91FB7A9
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 17:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666399552; x=1697935552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bts6J7VmVqhJslBL4eKvBMqv2XznmmoBLJcdMMDN+8A=;
  b=TlVNLXPWRDb8ykMdbbsMyU/yNeRg5wG9WhbYigrT6m56MZ0x/4mlJtr+
   oOCvQalNyPj6aqvmYMiB6zB3D+IedV289qcHI0QH34qm6HrC9nIW17V/6
   /jH5fAATygDDkMYy0lkrv/Jq5igCFEvpVp5DZaa8QG002IEwlMN+8SvuN
   3vZrXUy6MQ7bP1UYj4uLUkKClgFSbFWu2qm9iJ8GR7C1FOFIbikVrJ5D0
   o+oC30t3MG45L9CkTCMojSamoNMKPejb3/alRVeuTQdsHCOaqJQKvd7g2
   siAp8aIOzBJVp8Za/7wQ4tVYQI2sipQ6OHvap7JaaqIytzlq6PD9gjVSY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="304748916"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="304748916"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 17:45:50 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="581795620"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="581795620"
Received: from tremple-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.81])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 17:45:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/3] mptcp: add TCP_FASTOPEN_NO_COOKIE support
Date:   Fri, 21 Oct 2022 17:45:04 -0700
Message-Id: <20221022004505.160988-3-mathew.j.martineau@linux.intel.com>
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

The goal of this socket option is to configure MPTCP + TFO without
cookie per socket.

It was already possible to enable TFO without a cookie per netns by
setting net.ipv4.tcp_fastopen sysctl knob to the right value. Per route
was also supported by setting 'fastopen_no_cookie' option. This patch
adds a per socket support like it is possible to do with TCP thanks to
TCP_FASTOPEN_NO_COOKIE socket option.

The only thing to do here is to relay the request to the first subflow
like it is already done for TCP_FASTOPEN_CONNECT.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 8d3b09d75c3a..1857281a0dd5 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -560,6 +560,7 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		case TCP_TX_DELAY:
 		case TCP_INQ:
 		case TCP_FASTOPEN_CONNECT:
+		case TCP_FASTOPEN_NO_COOKIE:
 			return true;
 		}
 
@@ -568,8 +569,8 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		/* TCP_REPAIR, TCP_REPAIR_QUEUE, TCP_QUEUE_SEQ, TCP_REPAIR_OPTIONS,
 		 * TCP_REPAIR_WINDOW are not supported, better avoid this mess
 		 */
-		/* TCP_FASTOPEN_KEY, TCP_FASTOPEN, TCP_FASTOPEN_NO_COOKIE,
-		 * are not supported fastopen is currently unsupported
+		/* TCP_FASTOPEN_KEY, TCP_FASTOPEN are not supported because
+		 * fastopen for the listener side is currently unsupported
 		 */
 	}
 	return false;
@@ -811,6 +812,7 @@ static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_DEFER_ACCEPT:
 		return mptcp_setsockopt_sol_tcp_defer(msk, optval, optlen);
 	case TCP_FASTOPEN_CONNECT:
+	case TCP_FASTOPEN_NO_COOKIE:
 		return mptcp_setsockopt_first_sf_only(msk, SOL_TCP, optname,
 						      optval, optlen);
 	}
@@ -1175,6 +1177,7 @@ static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_CC_INFO:
 	case TCP_DEFER_ACCEPT:
 	case TCP_FASTOPEN_CONNECT:
+	case TCP_FASTOPEN_NO_COOKIE:
 		return mptcp_getsockopt_first_sf_only(msk, SOL_TCP, optname,
 						      optval, optlen);
 	case TCP_INQ:
-- 
2.38.1

