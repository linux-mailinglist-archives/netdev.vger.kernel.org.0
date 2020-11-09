Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFA72AB8B7
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgKIMw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:52:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51404 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729836AbgKIMw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:52:26 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kc6ee-00069P-2a; Mon, 09 Nov 2020 12:52:16 +0000
From:   Colin King <colin.king@canonical.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geliang Tang <geliangtang@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] mptcp: fix a dereference of pointer before msk is null checked.
Date:   Mon,  9 Nov 2020 12:52:15 +0000
Message-Id: <20201109125215.2080172-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the assignment of pointer net from the sock_net(sk) call
is potentially dereferencing a null pointer sk. sk points to the
same location as pointer msk and msk is being null checked after
the sock_net call.  Fix this by calling sock_net after the null
check on pointer msk.

Addresses-Coverity: ("Dereference before null check")
Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/mptcp/pm_netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index ed60538df7b2..e76879ea5a30 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -206,13 +206,15 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
-	struct net *net = sock_net(sk);
+	struct net *net;
 
 	pr_debug("msk=%p", msk);
 
 	if (!msk)
 		return;
 
+	net = sock_net(sk);
+
 	if (inet_sk_state_load(sk) == TCP_CLOSE)
 		return;
 
-- 
2.28.0

