Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB95452AD35
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353095AbiEQVAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353125AbiEQU74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:59:56 -0400
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91603532D5
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 13:59:55 -0700 (PDT)
Received: from pop-os.home ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id r4IJn7nvuVfTCr4IKncUEs; Tue, 17 May 2022 22:59:54 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 17 May 2022 22:59:54 +0200
X-ME-IP: 86.243.180.246
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sburla@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2 1/2] octeon_ep: Fix a memory leak in the error handling path of octep_request_irqs()
Date:   Tue, 17 May 2022 22:59:51 +0200
Message-Id: <38fb0e6de389eeb06820aba8b0a15c5534d8f540.1652819974.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1652819974.git.christophe.jaillet@wanadoo.fr>
References: <cover.1652819974.git.christophe.jaillet@wanadoo.fr>
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

'oct->non_ioq_irq_names' is not freed in the error handling path of
octep_request_irqs().

Add the missing kfree().

Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Veerasenareddy Burru <vburru@marvell.com>
---
v2: Add Acked-by tag

v1:
    https://lore.kernel.org/all/78dcfbb5d22328bc83edbfc74af10c3625c54087.1652629833.git.christophe.jaillet@wanadoo.fr/
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index e020c81f3455..6b60a03574a0 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -267,6 +267,8 @@ static int octep_request_irqs(struct octep_device *oct)
 		--i;
 		free_irq(oct->msix_entries[i].vector, oct);
 	}
+	kfree(oct->non_ioq_irq_names);
+	oct->non_ioq_irq_names = NULL;
 alloc_err:
 	return -1;
 }
-- 
2.34.1

