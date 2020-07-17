Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CFD2243C8
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgGQTFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:05:53 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:27240 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgGQTFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:05:52 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06HJ5SdM018242;
        Fri, 17 Jul 2020 12:05:28 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     borisp@mellanox.com, daniel@iogearbox.net, secdev@chelsio.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net v2] crypto/chtls: fix tls alert messages corrupted by tls data
Date:   Sat, 18 Jul 2020 00:31:42 +0530
Message-Id: <20200717190141.1331-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tls data skb is pending for Tx and tls alert comes , It
is wrongly overwrite the record type of tls data to tls alert
record type. fix the issue correcting it.

v1->v2:
- Correct submission tree.
- Add fixes tag.

Fixes: 6919a8264a32 ("Crypto/chtls: add/delete TLS header in driver")
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

