Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8026D32DBDC
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbhCDVfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:35:33 -0500
Received: from mga12.intel.com ([192.55.52.136]:5219 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230113AbhCDVf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 16:35:29 -0500
IronPort-SDR: Awd/MrDBnS0J6gdWH2YhufIk94lmG6xBAxs9g7k4QmA1OOKJq4IzGlOtML2KOOs/32JcWPRKrp
 3isUlxD9dHJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="166769412"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="166769412"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:23 -0800
IronPort-SDR: LrdgBufSEsW0LFMPRrfy9mZWgaDEKB+SnsHX9sujkOTklNHNEIsfKkh3JC9fHo9lsiYe19toHh
 Q7VlYlrHBmrg==
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368329480"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.105.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:22 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/9] mptcp: put subflow sock on connect error
Date:   Thu,  4 Mar 2021 13:32:09 -0800
Message-Id: <20210304213216.205472-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
References: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

mptcp_add_pending_subflow() performs a sock_hold() on the subflow,
then adds the subflow to the join list.

Without a sock_put the subflow sk won't be freed in case connect() fails.

unreferenced object 0xffff88810c03b100 (size 3000):
[..]
    sk_prot_alloc.isra.0+0x2f/0x110
    sk_alloc+0x5d/0xc20
    inet6_create+0x2b7/0xd30
    __sock_create+0x17f/0x410
    mptcp_subflow_create_socket+0xff/0x9c0
    __mptcp_subflow_connect+0x1da/0xaf0
    mptcp_pm_nl_work+0x6e0/0x1120
    mptcp_worker+0x508/0x9a0

Fixes: 5b950ff4331ddda ("mptcp: link MPC subflow into msk only after accept")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index e1fbcab257e6..41695e26c374 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1297,6 +1297,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	spin_lock_bh(&msk->join_list_lock);
 	list_del(&subflow->node);
 	spin_unlock_bh(&msk->join_list_lock);
+	sock_put(mptcp_subflow_tcp_sock(subflow));
 
 failed:
 	subflow->disposable = 1;
-- 
2.30.1

