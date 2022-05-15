Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0415A52789F
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 17:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbiEOP7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 11:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235104AbiEOP7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 11:59:03 -0400
Received: from smtp.smtpout.orange.fr (smtp07.smtpout.orange.fr [80.12.242.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D9B1409C
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 08:59:01 -0700 (PDT)
Received: from pop-os.home ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id qGcCn0Tbaqn1xqGe3nISmG; Sun, 15 May 2022 17:59:00 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 15 May 2022 17:59:00 +0200
X-ME-IP: 86.243.180.246
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Veerasenareddy Burru <vburru@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Satananda Burla <sburla@marvell.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] octeon_ep: Fix irq releasing in the error handling path of octep_request_irqs()
Date:   Sun, 15 May 2022 17:56:45 +0200
Message-Id: <a1b6f082fff4e68007914577961113bc452c8030.1652629833.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1652629833.git.christophe.jaillet@wanadoo.fr>
References: <cover.1652629833.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the error handling to work as expected, the index in the
'oct->msix_entries' array must be tweaked because, when the irq are
requested there is:
	msix_entry = &oct->msix_entries[i + num_non_ioq_msix];

So in the error handling path, 'i + num_non_ioq_msix' should be used
instead of 'i'.

The 2nd argument of free_irq() also needs to be adjusted.

Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
I think that the wording above is awful, but I'm sure you get it.
Feel free to rephrase everything to have it more readable.
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 6b60a03574a0..4dcae805422b 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -257,10 +257,12 @@ static int octep_request_irqs(struct octep_device *oct)
 
 	return 0;
 ioq_irq_err:
+	i += num_non_ioq_msix;
 	while (i > num_non_ioq_msix) {
 		--i;
 		irq_set_affinity_hint(oct->msix_entries[i].vector, NULL);
-		free_irq(oct->msix_entries[i].vector, oct->ioq_vector[i]);
+		free_irq(oct->msix_entries[i].vector,
+			 oct->ioq_vector[i - num_non_ioq_msix]);
 	}
 non_ioq_irq_err:
 	while (i) {
-- 
2.34.1

