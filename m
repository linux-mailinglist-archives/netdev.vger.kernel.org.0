Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F3C6081E9
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 00:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiJUW7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 18:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJUW7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 18:59:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88F72995E9
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 15:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666393144; x=1697929144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CA6i6CFTN0mN7T76uvkkOqtLAcmcKR9ugoAod1AZzIs=;
  b=aQjxOyjUPBGgEA019qqV9Ve6luVs89n2Og8DqxLMjWKbGyaMXLx9BXzr
   EwV9l7W53XNjtypOEr8wQeroqV6Ajy4lo1JfPueOi/WJmyLUkQgCpK7Yw
   qzJmGQAm1mLR0WMiTsxXjckV4twNLbWp5OYKjpQLEeb6iXu86Lws+l7ey
   XvG4uPtt1Lo+RsjgYVwBQ8AO8gWODl+Q+uafgcswtl0odx/GSA9lOR0M0
   w26q5LGrYrYMQPhUFtLj9rEGAJyXxdwgEBH4HCAlolAcWooE2HHGjrMag
   J23bgpYwT9H7WM4zWK/cqKxE3klc3MZPpWdSrYaoVh6OPnrLfEOqTL4IA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="369186386"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="369186386"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 15:59:02 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="663928730"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="663928730"
Received: from tremple-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.81])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 15:59:01 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, dmytro@shytyi.net,
        benjamin.hesmans@tessares.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/3] mptcp: set msk local address earlier
Date:   Fri, 21 Oct 2022 15:58:54 -0700
Message-Id: <20221021225856.88119-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221021225856.88119-1-mathew.j.martineau@linux.intel.com>
References: <20221021225856.88119-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The mptcp_pm_nl_get_local_id() code assumes that the msk local address
is available at that point. For passive sockets, we initialize such
address at accept() time.

Depending on the running configuration and the user-space timing, a
passive MPJ subflow can join the msk socket before accept() completes.

In such case, the PM assigns a wrong local id to the MPJ subflow
and later PM netlink operations will end-up touching the wrong/unexpected
subflow.

All the above causes sporadic self-tests failures, especially when
the host is heavy loaded.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/308
Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Fixes: d045b9eb95a9 ("mptcp: introduce implicit endpoints")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 3 +--
 net/mptcp/protocol.h | 1 +
 net/mptcp/subflow.c  | 7 +++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f599ad44ed24..e33f9caf409d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2952,7 +2952,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 	sock_put(sk);
 }
 
-static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
+void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	const struct ipv6_pinfo *ssk6 = inet6_sk(ssk);
@@ -3699,7 +3699,6 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		if (mptcp_is_fully_established(newsk))
 			mptcp_pm_fully_established(msk, msk->first, GFP_KERNEL);
 
-		mptcp_copy_inaddrs(newsk, msk->first);
 		mptcp_rcv_space_init(msk, msk->first);
 		mptcp_propagate_sndbuf(newsk, msk->first);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index c0b5b4628f65..be19592441df 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -599,6 +599,7 @@ int mptcp_is_checksum_enabled(const struct net *net);
 int mptcp_allow_join_id0(const struct net *net);
 unsigned int mptcp_stale_loss_cnt(const struct net *net);
 int mptcp_get_pm_type(const struct net *net);
+void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool __mptcp_retransmit_pending_data(struct sock *sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 07dd23d0fe04..02a54d59697b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -723,6 +723,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 				goto dispose_child;
 			}
 
+			if (new_msk)
+				mptcp_copy_inaddrs(new_msk, child);
 			subflow_drop_ctx(child);
 			goto out;
 		}
@@ -750,6 +752,11 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			ctx->conn = new_msk;
 			new_msk = NULL;
 
+			/* set msk addresses early to ensure mptcp_pm_get_local_id()
+			 * uses the correct data
+			 */
+			mptcp_copy_inaddrs(ctx->conn, child);
+
 			/* with OoO packets we can reach here without ingress
 			 * mpc option
 			 */
-- 
2.38.1

