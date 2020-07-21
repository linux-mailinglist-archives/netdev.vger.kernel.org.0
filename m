Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF4B2286F5
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgGURPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:15:01 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:31410 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730015AbgGURO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:14:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595351699; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=wMU4DbU33JbajyG3cP1sY2UVCv9Nr6xvONZ479ljK6o=; b=du9P5YWr7w/pm1rtRaXZh7apkQq+BtD4NWzb8maegqCgt7cPdXMSBz5iYb8//XYDFAwT2aU6
 aRYGLIWnae44zCg8GltbVP9x1FCmKwisJY4SIFM3olaVx5f8IHTAMsKKPHGxa02pZGVLOijg
 OxXKqYiArHLbQsQn1gKIBNx1Wqo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5f172292f9ca681bd08d75cb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Jul 2020 17:14:58
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0A83DC433B1; Tue, 21 Jul 2020 17:14:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DB20FC433C6;
        Tue, 21 Jul 2020 17:14:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DB20FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dianders@chromium.org, evgreen@chromium.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [RFC 4/7] ath10k: Do not exhaust budget on process tx completion
Date:   Tue, 21 Jul 2020 22:44:23 +0530
Message-Id: <1595351666-28193-5-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the entire NAPI budget is marked as exhausted
if any tx completion is processed.
In scenarios of bi-directional traffic, this leads to a
situation where the irqs are never enabled and the NAPI
is rescheuled again and again.

Increase the work done quota by the number of tx completions
which are processed in the NAPI context.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index cac05e7..a4a6618 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -4077,21 +4077,18 @@ int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget)
 	/* Deliver received data after processing data from hardware */
 	quota = ath10k_htt_rx_deliver_msdu(ar, quota, budget);
 
-	/* From NAPI documentation:
-	 *  The napi poll() function may also process TX completions, in which
-	 *  case if it processes the entire TX ring then it should count that
-	 *  work as the rest of the budget.
-	 */
-	if ((quota < budget) && !kfifo_is_empty(&htt->txdone_fifo))
-		quota = budget;
-
 	/* kfifo_get: called only within txrx_tasklet so it's neatly serialized.
 	 * From kfifo_get() documentation:
 	 *  Note that with only one concurrent reader and one concurrent writer,
 	 *  you don't need extra locking to use these macro.
 	 */
-	while (kfifo_get(&htt->txdone_fifo, &tx_done))
+	while (kfifo_get(&htt->txdone_fifo, &tx_done)) {
 		ath10k_txrx_tx_unref(htt, &tx_done);
+		quota++;
+	}
+
+	if (quota > budget)
+		resched_napi = true;
 
 	ath10k_mac_tx_push_pending(ar);
 
-- 
2.7.4

