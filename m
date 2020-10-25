Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7370D298365
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 20:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418562AbgJYThf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 15:37:35 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:11160 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438265AbgJYThf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 15:37:35 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09PJbRWW029555;
        Sun, 25 Oct 2020 12:37:27 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net] chelsio/chtls: fix deadlock issue
Date:   Mon, 26 Oct 2020 01:05:39 +0530
Message-Id: <20201025193538.31112-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In chtls_pass_establish() we hold child socket lock using bh_lock_sock
and we are again trying bh_lock_sock in add_to_reap_list, causing deadlock.
Remove bh_lock_sock in add_to_reap_list() as lock is already held.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index d128fc860c6f..24154816d1d1 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1512,7 +1512,6 @@ static void add_to_reap_list(struct sock *sk)
 	struct chtls_sock *csk = sk->sk_user_data;
 
 	local_bh_disable();
-	bh_lock_sock(sk);
 	release_tcp_port(sk); /* release the port immediately */
 
 	spin_lock(&reap_list_lock);
@@ -1521,7 +1520,6 @@ static void add_to_reap_list(struct sock *sk)
 	if (!csk->passive_reap_next)
 		schedule_work(&reap_task);
 	spin_unlock(&reap_list_lock);
-	bh_unlock_sock(sk);
 	local_bh_enable();
 }
 
-- 
2.18.1

