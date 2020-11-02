Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829672A31C0
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgKBRiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:38:55 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:5714 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgKBRiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:38:55 -0500
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A2Hcl8B005405;
        Mon, 2 Nov 2020 09:38:48 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net,v3] chelsio/chtls: fix memory leaks
Date:   Mon,  2 Nov 2020 23:06:51 +0530
Message-Id: <20201102173650.24754-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

race between user context and softirq causing memleak,
consider the call sequence scenario

chtls_setkey()         //user context
chtls_peer_close()
chtls_abort_req_rss()
chtls_setkey()         //user context

work request skb queued in chtls_setkey() won't be freed
because resources are already cleaned for this connection,
fix it by not queuing work request while socket is closing.

v1->v2:
- fix W=1 warning.

v2->v3:
- separate it out from another memleak fix.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
index f1820aca0d33..62c829023da5 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
@@ -383,6 +383,9 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen,
 	if (ret)
 		goto out_notcb;
 
+	if (unlikely(csk_flag(sk, CSK_ABORT_SHUTDOWN)))
+		goto out_notcb;
+
 	set_wr_txq(skb, CPL_PRIORITY_DATA, csk->tlshws.txqid);
 	csk->wr_credits -= DIV_ROUND_UP(len, 16);
 	csk->wr_unacked += DIV_ROUND_UP(len, 16);
-- 
2.18.1

