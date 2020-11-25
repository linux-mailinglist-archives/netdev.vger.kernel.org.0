Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B942C4A42
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732970AbgKYVvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:51:18 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:61557 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732508AbgKYVvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 16:51:18 -0500
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0APLpBMa013323;
        Wed, 25 Nov 2020 13:51:12 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Udai Sharma <udai.sharma@chelsio.com>
Subject: [PATCH net] chelsio/chtls: fix panic during unload reload chtls
Date:   Thu, 26 Nov 2020 03:19:14 +0530
Message-Id: <20201125214913.16938-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is kernel panic in inet_twsk_free() while chtls
module unload when socket is in TIME_WAIT state because
sk_prot_creator was not preserved on connection socket.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Udai Sharma <udai.sharma@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 96d561653496..50e3a70e5a29 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1206,6 +1206,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	sk_setup_caps(newsk, dst);
 	ctx = tls_get_ctx(lsk);
 	newsk->sk_destruct = ctx->sk_destruct;
+	newsk->sk_prot_creator = lsk->sk_prot_creator;
 	csk->sk = newsk;
 	csk->passive_reap_next = oreq;
 	csk->tx_chan = cxgb4_port_chan(ndev);
-- 
2.18.1

