Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9C1362B29
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbhDPWi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:38:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:38339 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234708AbhDPWiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:38:50 -0400
IronPort-SDR: Iise0eYeVnYx61qJwFb+vjkQQ6mHHmp2KfH6ZlZANwi20xfuN233wnassoU01YnR+KGqf9yCm4
 hRQPyrKqzehg==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="215670613"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="215670613"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 15:38:18 -0700
IronPort-SDR: iSDFunbap1hYZWGq+wz+/LJG9s1ZjkrP1RRAbWmQ0ObaC1KPCyyOH8QPQohHBhA7t5uQ2Lm6Ee
 LtdMN5OoPY2g==
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="462107400"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.43.70])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 15:38:18 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/8] mptcp: use mptcp_for_each_subflow in mptcp_close
Date:   Fri, 16 Apr 2021 15:38:08 -0700
Message-Id: <20210416223808.298842-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
References: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch used the macro helper mptcp_for_each_subflow() instead of
list_for_each_entry() in mptcp_close.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e26ea143754d..c14ac2975736 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2611,7 +2611,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 cleanup:
 	/* orphan all the subflows */
 	inet_csk(sk)->icsk_mtup.probe_timestamp = tcp_jiffies32;
-	list_for_each_entry(subflow, &mptcp_sk(sk)->conn_list, node) {
+	mptcp_for_each_subflow(mptcp_sk(sk), subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast(ssk);
 
-- 
2.31.1

