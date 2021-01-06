Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64AC2EB8FA
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 05:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbhAFEav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 23:30:51 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:25115 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbhAFEau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 23:30:50 -0500
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 1064TfXg022094;
        Tue, 5 Jan 2021 20:30:00 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net 4/7] chtls: Avoid unnecessary freeing of oreq pointer
Date:   Wed,  6 Jan 2021 09:59:09 +0530
Message-Id: <20210106042912.23512-5-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
In-Reply-To: <20210106042912.23512-1-ayush.sawal@chelsio.com>
References: <20210106042912.23512-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In chtls_pass_accept_request(), removing the chtls_reqsk_free()
call to avoid oreq freeing twice. Here oreq is the pointer to
struct request_sock.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 04a8bd5af3b9..3022c802d09a 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1397,7 +1397,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 
 	newsk = chtls_recv_sock(sk, oreq, network_hdr, req, cdev);
 	if (!newsk)
-		goto free_oreq;
+		goto reject;
 
 	if (chtls_get_module(newsk))
 		goto reject;
@@ -1413,8 +1413,6 @@ static void chtls_pass_accept_request(struct sock *sk,
 	kfree_skb(skb);
 	return;
 
-free_oreq:
-	chtls_reqsk_free(oreq);
 reject:
 	mk_tid_release(reply_skb, 0, tid);
 	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
-- 
2.28.0.rc1.6.gae46588

