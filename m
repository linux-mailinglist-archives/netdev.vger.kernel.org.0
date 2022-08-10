Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1693A58EEAE
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 16:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiHJOpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 10:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiHJOpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 10:45:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BB349B75
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 07:45:45 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oLmxq-00028X-Ew; Wed, 10 Aug 2022 16:45:42 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oLmxn-002vUa-6G; Wed, 10 Aug 2022 16:45:41 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oLmxo-00AnsB-Mj; Wed, 10 Aug 2022 16:45:40 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH] can: rx-offload: Break loop on queue full
Date:   Wed, 10 Aug 2022 16:45:36 +0200
Message-Id: <20220810144536.389237-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1982; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=Cn04GZTinb3PN++vuBq/xD3wJWb9dO28EXwq06xJYPM=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBi88SMnBsnvOfBX9QR1MhCX82hZIFPz2XNtmDorvRp dxQd+yCJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYvPEjAAKCRDB/BR4rcrsCQlhB/ 4haeId7TOd3cTFuUcjcNgW48p6P7AGuZP85k/cxmvNKpeuNZ9TxSJkrVaUIj7iqFB1nzZZotRLOyGx FxOSN2mnhmsc4YV/pDIDI1ErPNYBHFznFRG8+IbTXwbWZF9QyBe8NlgzKo/9iEkytdrhFt+V7I8eVh +9sKrLCa6tj8hqltweWn8XP19JtBt/0sy0ue+qi6Gc7DjsySBH4yZUXVMOv9JVk2Ypcf36qtLT7zlY jayTSi0EoaMcm82KChpxhDkcraFqoP6n59c+5Jp6yiYNlJ3od2BD+vZZUSW0BTQehLpfALoDO69Jm6 wwwSfJV1WzjuU50lSYD0I8yhprqhGP
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following happend on an i.MX25 using flexcan with many packets on
the bus:

The rx-offload queue reached a length more than skb_queue_len_max. So in
can_rx_offload_offload_one() the drop variable was set to true which
made the call to .mailbox_read() (here: flexcan_mailbox_read()) just
return ERR_PTR(-ENOBUFS) (plus some irrelevant hardware interaction) and
so can_rx_offload_offload_one() returned ERR_PTR(-ENOBUFS), too.

Now can_rx_offload_irq_offload_fifo() looks as follows:

	while (1) {
		skb = can_rx_offload_offload_one(offload, 0);
		if (IS_ERR(skb))
			continue;
		...
	}

As the i.MX25 is a single core CPU while the rx-offload processing is
active there is no thread to process packets from the offload queue and
so it doesn't get shorter.

The result is a tight loop: can_rx_offload_offload_one() does nothing
relevant and returns an error code and so
can_rx_offload_irq_offload_fifo() calls can_rx_offload_offload_one()
again.

To break that loop don't continue calling can_rx_offload_offload_one()
after it reported an error.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this patch just implements the obvious change to break the loop. I'm not
100% certain that there is no corner case where the break is wrong. The
problem exists at least since v5.6, didn't go back further to check.

This fixes a hard hang on said i.MX25.

Best regards
Uwe

 drivers/net/can/dev/rx-offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
index a32a01c172d4..d5d33692bb6a 100644
--- a/drivers/net/can/dev/rx-offload.c
+++ b/drivers/net/can/dev/rx-offload.c
@@ -207,7 +207,7 @@ int can_rx_offload_irq_offload_fifo(struct can_rx_offload *offload)
 	while (1) {
 		skb = can_rx_offload_offload_one(offload, 0);
 		if (IS_ERR(skb))
-			continue;
+			break;
 		if (!skb)
 			break;
 
-- 
2.36.1

