Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7DE2D6B9B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390566AbgLJXLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:11:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:9293 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387943AbgLJWbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 17:31:07 -0500
IronPort-SDR: +Y9meKBeXzZ4Sa7CfWzUzJpqLVLCc4LHlQEmKejn1HM7Nt6sIR6jXqknj9weyh/QR9HhL/BDZj
 nzEZfEQq+6jQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="171776488"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="171776488"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:14 -0800
IronPort-SDR: eqmyYaE+2k31xmoEijcNx50w6RdwwxKwiT5cNSZI+wuXeiFGSkTH30MNIGz3pDyKCd4zZn6IHN
 Qp5L/PS3vcTQ==
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="338703756"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.112.51])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/9] mptcp: hold mptcp socket before calling tcp_done
Date:   Thu, 10 Dec 2020 14:25:02 -0800
Message-Id: <20201210222506.222251-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
References: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When processing options from tcp reset path its possible that
tcp_done(ssk) drops the last reference on the mptcp socket which
results in use-after-free.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bf808f1fabe5..73e66a406d99 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -313,12 +313,17 @@ void mptcp_subflow_reset(struct sock *ssk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct sock *sk = subflow->conn;
 
+	/* must hold: tcp_done() could drop last reference on parent */
+	sock_hold(sk);
+
 	tcp_set_state(ssk, TCP_CLOSE);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
 	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&
 	    schedule_work(&mptcp_sk(sk)->work))
-		sock_hold(sk);
+		return; /* worker will put sk for us */
+
+	sock_put(sk);
 }
 
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
-- 
2.29.2

