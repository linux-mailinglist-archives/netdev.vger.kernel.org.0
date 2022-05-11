Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8ECE5238C9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344631AbiEKQUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344628AbiEKQUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:20:15 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BDA6237240
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:20:14 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id E46183200F2;
        Wed, 11 May 2022 17:20:13 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nop4P-0000Dd-NJ; Wed, 11 May 2022 17:20:13 +0100
Subject: [PATCH net-next 5/6] sfc/siena: Make PTP and reset support specific
 for Siena
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Wed, 11 May 2022 17:20:13 +0100
Message-ID: <165228601357.696.10361036152437614572.stgit@palantir17.mph.net>
In-Reply-To: <165228589518.696.7119477411428288875.stgit@palantir17.mph.net>
References: <165228589518.696.7119477411428288875.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the clock name and work queue names to differentiate them from
the names used in sfc.ko.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx_common.c |    2 +-
 drivers/net/ethernet/sfc/siena/ptp.c        |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index a615bffcbad4..954daf464abb 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -112,7 +112,7 @@ static struct workqueue_struct *reset_workqueue;
 
 int efx_siena_create_reset_workqueue(void)
 {
-	reset_workqueue = create_singlethread_workqueue("sfc_reset");
+	reset_workqueue = create_singlethread_workqueue("sfc_siena_reset");
 	if (!reset_workqueue) {
 		printk(KERN_ERR "Failed to create reset workqueue\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/sfc/siena/ptp.c b/drivers/net/ethernet/sfc/siena/ptp.c
index 8e18da096595..7c46752e6eae 100644
--- a/drivers/net/ethernet/sfc/siena/ptp.c
+++ b/drivers/net/ethernet/sfc/siena/ptp.c
@@ -1422,7 +1422,7 @@ static void efx_ptp_worker(struct work_struct *work)
 
 static const struct ptp_clock_info efx_phc_clock_info = {
 	.owner		= THIS_MODULE,
-	.name		= "sfc",
+	.name		= "sfc_siena",
 	.max_adj	= MAX_PPB,
 	.n_alarm	= 0,
 	.n_ext_ts	= 0,
@@ -1458,7 +1458,7 @@ static int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 
 	skb_queue_head_init(&ptp->rxq);
 	skb_queue_head_init(&ptp->txq);
-	ptp->workwq = create_singlethread_workqueue("sfc_ptp");
+	ptp->workwq = create_singlethread_workqueue("sfc_siena_ptp");
 	if (!ptp->workwq) {
 		rc = -ENOMEM;
 		goto fail2;
@@ -1502,7 +1502,8 @@ static int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 			goto fail3;
 		} else if (ptp->phc_clock) {
 			INIT_WORK(&ptp->pps_work, efx_ptp_pps_worker);
-			ptp->pps_workwq = create_singlethread_workqueue("sfc_pps");
+			ptp->pps_workwq =
+				create_singlethread_workqueue("sfc_siena_pps");
 			if (!ptp->pps_workwq) {
 				rc = -ENOMEM;
 				goto fail4;

