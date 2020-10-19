Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63BA2926B6
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgJSLvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:51:46 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:13079 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgJSLvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:51:45 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09JBoo1i003914;
        Mon, 19 Oct 2020 04:51:36 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net 5/6] chelsio/chtls: correct function return and return type
Date:   Mon, 19 Oct 2020 17:20:24 +0530
Message-Id: <20201019115025.24233-6-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201019115025.24233-1-vinay.yadav@chelsio.com>
References: <20201019115025.24233-1-vinay.yadav@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

csk_mem_free() should return true if send buffer is available,
false otherwise.

Fixes: 3b8305f5c844 ("crypto: chtls - wait for memory sendmsg, sendpage")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 28c6c538032d..9fb5ca6682ea 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -902,9 +902,9 @@ static int chtls_skb_copy_to_page_nocache(struct sock *sk,
 	return 0;
 }
 
-static int csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
+static bool csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
 {
-	return (cdev->max_host_sndbuf - sk->sk_wmem_queued);
+	return (cdev->max_host_sndbuf - sk->sk_wmem_queued > 0);
 }
 
 static int csk_wait_memory(struct chtls_dev *cdev,
-- 
2.18.1

