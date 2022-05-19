Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4DB52CCB5
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 09:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiESHSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 03:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234720AbiESHRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 03:17:48 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB4086EC79
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:17:26 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 59BBA3200CC;
        Thu, 19 May 2022 08:17:16 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.92)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nraPL-0006DH-K0; Thu, 19 May 2022 08:17:15 +0100
Subject: [PATCH net-next] sfc/siena: Remove duplicate check on segments
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        dan.carpenter@oracle.com
Date:   Thu, 19 May 2022 08:17:15 +0100
Message-ID: <165294463549.23865.4557617334650441347.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Siena only supports software TSO. This means more code can be deleted,
as pointed out by the Smatch static checker warning:
	drivers/net/ethernet/sfc/siena/tx.c:184 __efx_siena_enqueue_skb()
	warn: duplicate check 'segments' (previous on line 158)

Fixes: 956f2d86cb37 ("sfc/siena: Remove build references to missing functionality")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/kernel-janitors/YoH5tJMnwuGTrn1Z@kili/
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/tx.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
index b84b9e348c13..e166dcb9b99c 100644
--- a/drivers/net/ethernet/sfc/siena/tx.c
+++ b/drivers/net/ethernet/sfc/siena/tx.c
@@ -181,14 +181,7 @@ netdev_tx_t __efx_siena_enqueue_skb(struct efx_tx_queue *tx_queue,
 	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb_len, xmit_more))
 		efx_tx_send_pending(tx_queue->channel);
 
-	if (segments) {
-		tx_queue->tso_bursts++;
-		tx_queue->tso_packets += segments;
-		tx_queue->tx_packets  += segments;
-	} else {
-		tx_queue->tx_packets++;
-	}
-
+	tx_queue->tx_packets++;
 	return NETDEV_TX_OK;
 
 


