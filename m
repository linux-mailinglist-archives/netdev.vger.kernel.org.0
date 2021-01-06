Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CDC2EB8F6
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 05:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbhAFEao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 23:30:44 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:58247 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbhAFEao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 23:30:44 -0500
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 1064TfXe022094;
        Tue, 5 Jan 2021 20:29:54 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net 2/7] chtls: Remove invalid set_tcb call
Date:   Wed,  6 Jan 2021 09:59:07 +0530
Message-Id: <20210106042912.23512-3-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
In-Reply-To: <20210106042912.23512-1-ayush.sawal@chelsio.com>
References: <20210106042912.23512-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the time of SYN_RECV, connection information is not
initialized at FW, updating tcb flag over uninitialized
connection causes adapter crash. We don't need to
update the flag during SYN_RECV state, so avoid this.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 561b5f2273af..431d1e3844ab 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -2096,9 +2096,6 @@ static void chtls_abort_req_rss(struct sock *sk, struct sk_buff *skb)
 	int queue = csk->txq_idx;
 
 	if (is_neg_adv(req->status)) {
-		if (sk->sk_state == TCP_SYN_RECV)
-			chtls_set_tcb_tflag(sk, 0, 0);
-
 		kfree_skb(skb);
 		return;
 	}
-- 
2.28.0.rc1.6.gae46588

