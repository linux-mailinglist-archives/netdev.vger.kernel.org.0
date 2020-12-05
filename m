Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22742CFB2B
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 12:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgLELlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 06:41:00 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:37701 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgLELhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 06:37:51 -0500
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0B5BaIbP002408;
        Sat, 5 Dec 2020 03:36:19 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net v2] net/tls: Fix kernel panic when socket is in tls toe mode
Date:   Sat,  5 Dec 2020 17:05:30 +0530
Message-Id: <20201205113529.14574-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When socket is in tls-toe (TLS_HW_RECORD) and connections
are established in kernel stack, on every connection close
it clears tls context which is created once on socket creation,
causing kernel panic. fix it by not initializing listen in
kernel stack incase of tls-toe, allow listen in only adapter.

v1->v2:
- warning correction.

Fixes: dd0bed1665d6 ("tls: support for Inline tls record")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 net/tls/tls_toe.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/tls/tls_toe.c b/net/tls/tls_toe.c
index 7e1330f19..f38861ce9 100644
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
-	int err;
+	int err = 0;
 
-	err = ctx->sk_proto->hash(sk);
 	spin_lock_bh(&device_spinlock);
 	list_for_each_entry(dev, &device_list, dev_list) {
 		if (dev->hash) {
-- 
2.18.1

