Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F173C2BFD
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 02:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhGJAXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 20:23:46 -0400
Received: from mga06.intel.com ([134.134.136.31]:60426 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229846AbhGJAXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 20:23:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="270913470"
X-IronPort-AV: E=Sophos;i="5.84,228,1620716400"; 
   d="scan'208";a="270913470"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 17:20:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,228,1620716400"; 
   d="scan'208";a="462343534"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.240.68])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 17:20:57 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Jianguo Wu <wujianguo@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, pabeni@redhat.com,
        fw@strlen.de, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 3/6] mptcp: fix syncookie process if mptcp can not_accept new subflow
Date:   Fri,  9 Jul 2021 17:20:48 -0700
Message-Id: <20210710002051.216010-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
References: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

Lots of "TCP: tcp_fin: Impossible, sk->sk_state=7" in client side
when doing stress testing using wrk and webfsd.

There are at least two cases may trigger this warning:
1.mptcp is in syncookie, and server recv MP_JOIN SYN request,
  in subflow_check_req(), the mptcp_can_accept_new_subflow()
  return false, so subflow_init_req_cookie_join_save() isn't
  called, i.e. not store the data present in the MP_JOIN syn
  request and the random nonce in hash table - join_entries[],
  but still send synack. When recv 3rd-ack,
  mptcp_token_join_cookie_init_state() will return false, and
  3rd-ack is dropped, then if mptcp conn is closed by client,
  client will send a DATA_FIN and a MPTCP FIN, the DATA_FIN
  doesn't have MP_CAPABLE or MP_JOIN,
  so mptcp_subflow_init_cookie_req() will return 0, and pass
  the cookie check, MP_JOIN request is fallback to normal TCP.
  Server will send a TCP FIN if closed, in client side,
  when process TCP FIN, it will do reset, the code path is:
    tcp_data_queue()->mptcp_incoming_options()
      ->check_fully_established()->mptcp_subflow_reset().
  mptcp_subflow_reset() will set sock state to TCP_CLOSE,
  so tcp_fin will hit TCP_CLOSE, and print the warning.

2.mptcp is in syncookie, and server recv 3rd-ack, in
  mptcp_subflow_init_cookie_req(), mptcp_can_accept_new_subflow()
  return false, and subflow_req->mp_join is not set to 1,
  so in subflow_syn_recv_sock() will not reset the MP_JOIN
  subflow, but fallback to normal TCP, and then the same thing
  happens when server will send a TCP FIN if closed.

For case1, subflow_check_req() return -EPERM,
then tcp_conn_request() will drop MP_JOIN SYN.

For case2, let subflow_syn_recv_sock() call
mptcp_can_accept_new_subflow(), and do fatal fallback, send reset.

Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index b15e2017168d..966f777d35ce 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -225,6 +225,8 @@ static int subflow_check_req(struct request_sock *req,
 		if (unlikely(req->syncookie)) {
 			if (mptcp_can_accept_new_subflow(subflow_req->msk))
 				subflow_init_req_cookie_join_save(subflow_req, skb);
+			else
+				return -EPERM;
 		}
 
 		pr_debug("token=%u, remote_nonce=%u msk=%p", subflow_req->token,
@@ -264,9 +266,7 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 		if (!mptcp_token_join_cookie_init_state(subflow_req, skb))
 			return -EINVAL;
 
-		if (mptcp_can_accept_new_subflow(subflow_req->msk))
-			subflow_req->mp_join = 1;
-
+		subflow_req->mp_join = 1;
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq - 1;
 	}
 
-- 
2.32.0

