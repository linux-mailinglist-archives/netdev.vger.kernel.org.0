Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE92A2926AF
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgJSLvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:51:10 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:45973 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgJSLvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:51:10 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09JBoo1e003914;
        Mon, 19 Oct 2020 04:51:05 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net 1/6] chelsio/chtls: fix socket lock
Date:   Mon, 19 Oct 2020 17:20:20 +0530
Message-Id: <20201019115025.24233-2-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201019115025.24233-1-vinay.yadav@chelsio.com>
References: <20201019115025.24233-1-vinay.yadav@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In chtls_sendpage() socket lock is released but not acquired,
fix it by taking lock.

Fixes: 36bedb3f2e5b ("crypto: chtls - Inline TLS record Tx")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 2e9acae1cba3..28c6c538032d 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1240,6 +1240,7 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 	copied = 0;
 	csk = rcu_dereference_sk_user_data(sk);
 	cdev = csk->cdev;
+	lock_sock(sk);
 	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
 
 	err = sk_stream_wait_connect(sk, &timeo);
-- 
2.18.1

