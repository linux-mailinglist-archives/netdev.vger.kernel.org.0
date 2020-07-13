Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D540D21DFE5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGMSiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:38:13 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:43447 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgGMSiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:38:13 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06DIa8xS004006;
        Mon, 13 Jul 2020 11:38:09 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 2/3] crypto/chtls: fix tls alert messages
Date:   Tue, 14 Jul 2020 00:05:55 +0530
Message-Id: <20200713183554.11719-3-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200713183554.11719-1-vinay.yadav@chelsio.com>
References: <20200713183554.11719-1-vinay.yadav@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tls data skb is pending for Tx and tls alert comes , It
is wrongly overwrite the record type of tls data to tls alert
record type. fix the issue correcting it.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_io.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index e1401d9cc..2e9acae1c 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1052,14 +1052,15 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 							  &record_type);
 				if (err)
 					goto out_err;
+
+				/* Avoid appending tls handshake, alert to tls data */
+				if (skb)
+					tx_skb_finalize(skb);
 			}
 
 			recordsz = size;
 			csk->tlshws.txleft = recordsz;
 			csk->tlshws.type = record_type;
-
-			if (skb)
-				ULP_SKB_CB(skb)->ulp.tls.type = record_type;
 		}
 
 		if (!skb || (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND) ||
-- 
2.18.1

