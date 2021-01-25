Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB1A302B0C
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 20:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbhAYTDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 14:03:37 -0500
Received: from mga05.intel.com ([192.55.52.43]:23607 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731462AbhAYTC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 14:02:58 -0500
IronPort-SDR: l5Np5GohHYTu6SPsSKgrkXX9+rgcclcCWhUbGwjVlTWXJroML7UzcsuHtk8tQeVIaF+97YheQ5
 bpLX48LVcTig==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="264604209"
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="264604209"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:26 -0800
IronPort-SDR: WyraG6K4e1IxZGICzyLZ3o25F0Fzhkvy02YSVxWFU5m/7BzLWpKCTGVEYv9SYPn+TWUHEhpKKG
 3HtVLSpELBCg==
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="361637474"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.126.22])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/5] mptcp: pm nl: reduce variable scope
Date:   Mon, 25 Jan 2021 10:59:02 -0800
Message-Id: <20210125185904.6997-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
References: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

To avoid confusions like when working on the previous patch, better to
declare and assign this variable only where it is needed.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index f0afff6ba015..83976b9ee99b 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -325,7 +325,6 @@ void mptcp_pm_free_anno_list(struct mptcp_sock *msk)
 
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
-	struct mptcp_addr_info remote = { 0 };
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_pm_addr_entry *local;
 	struct pm_nl_pernet *pernet;
@@ -359,13 +358,14 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 	/* check if should create a new subflow */
 	if (msk->pm.local_addr_used < msk->pm.local_addr_max &&
 	    msk->pm.subflows < msk->pm.subflows_max) {
-		remote_address((struct sock_common *)sk, &remote);
-
 		local = select_local_address(pernet, msk);
 		if (local) {
+			struct mptcp_addr_info remote = { 0 };
+
 			msk->pm.local_addr_used++;
 			msk->pm.subflows++;
 			check_work_pending(msk);
+			remote_address((struct sock_common *)sk, &remote);
 			spin_unlock_bh(&msk->pm.lock);
 			__mptcp_subflow_connect(sk, &local->addr, &remote);
 			spin_lock_bh(&msk->pm.lock);
-- 
2.30.0

