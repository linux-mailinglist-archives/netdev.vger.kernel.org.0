Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6552CF609
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgLDVOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:14:54 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:53587 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgLDVOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 16:14:54 -0500
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0B4LDq25031452;
        Fri, 4 Dec 2020 13:13:52 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net] net/tls: Fix kernel panic when socket is in tls toe mode
Date:   Sat,  5 Dec 2020 02:39:30 +0530
Message-Id: <20201204210929.7892-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When socket is in tls-toe (TLS_HW_RECORD) and connections
are established in kernel stack, on every connection close
it clears tls context which is created once on socket creation,
causing kernel panic. fix it by not initializing listen in
kernel stack incase of tls-toe, allow listen in only adapter.

Fixes: dd0bed1665d6 ("tls: support for Inline tls record")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 net/tls/tls_toe.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/tls/tls_toe.c b/net/tls/tls_toe.c
index 7e1330f19..f74b647d3 100644
--- a/net/tls/tls_toe.c
+++ b/net/tls/tls_toe.c
@@ -81,7 +81,6 @@ int tls_toe_bypass(struct sock *sk)
 
 void tls_toe_unhash(struct sock *sk)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
 	struct tls_toe_device *dev;
 
 	spin_lock_bh(&device_spinlock);
@@ -95,16 +94,13 @@ void tls_toe_unhash(struct sock *sk)
 		}
 	}
 	spin_unlock_bh(&device_spinlock);
-	ctx->sk_proto->unhash(sk);
 }
 
 int tls_toe_hash(struct sock *sk)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
 	struct tls_toe_device *dev;
 	int err;
 
-	err = ctx->sk_proto->hash(sk);
 	spin_lock_bh(&device_spinlock);
 	list_for_each_entry(dev, &device_list, dev_list) {
 		if (dev->hash) {
-- 
2.18.1

