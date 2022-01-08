Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCF2488123
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiAHDon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:44:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37640 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiAHDom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 22:44:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69D8B61F30
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 03:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4C0C36AEB;
        Sat,  8 Jan 2022 03:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641613481;
        bh=+r9AziOMry8y2oB2gLHWb4Q0Lo6tCbuybTqJi7RTSCQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Cl0X2OJxqxg2Z3COLvMSXKlBz6LlTX77iUhj+BKKh/tNHL+scGjsU8g3wRFXzFReb
         SXxIRVm15EWWgGHqJTJ+IC/P9qayICVnFi9BBvZA3CUy09D4IBtH6QT041q1HCA8zy
         HrqCPdJTEHMOX/E71k/Wy6WY12RUwCZI/ThAGZeenE+h2mD8qWRA4uE4UfhCM51eXy
         SXP0hORuPAmSMNdIj3RajLJdFe8nhXIYtRsvX0Y1b4nlO/aVADSW/BaHQRpu0HDJ93
         38Lj10f3horC3e+6UeD6Ke/j/1F/78UnUC0gsJFfPyHZVplF/FuVr1yaI7roGPPyUv
         TaJkvzwUP1e/w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH net-next] net: allwinner: Fix print format
Date:   Fri,  7 Jan 2022 19:44:38 -0800
Message-Id: <20220108034438.2227343-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees reports quoted commit introduced the following warning on arm64:

drivers/net/ethernet/allwinner/sun4i-emac.c:922:60: error: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'resource_size_t' {aka 'long long unsigned int'} [-Werror=format=]
  922 |         netdev_info(ndev, "get io resource from device: 0x%x, size = %u\n",
      |                                                           ~^
      |                                                            |                                      |                                                            unsigned int
      |                                                           %llx
  923 |                     regs->start, resource_size(regs));
      |                     ~~~~~~~~~~~
      |                         |
      |                         resource_size_t {aka long long unsigned int}

.. and another one like that for resource_size().

Switch to %pa and a cast.

Reported-by: Kees Cook <keescook@chromium.org>
Fixes: 47869e82c8b8 ("sun4i-emac.c: add dma support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 964227e342ee..849de4564709 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -919,8 +919,8 @@ static int emac_configure_dma(struct emac_board_info *db)
 		goto out_clear_chan;
 	}
 
-	netdev_info(ndev, "get io resource from device: 0x%x, size = %u\n",
-		    regs->start, resource_size(regs));
+	netdev_info(ndev, "get io resource from device: %pa, size = %u\n",
+		    &regs->start, (unsigned int)resource_size(regs));
 	db->emac_rx_fifo = regs->start + EMAC_RX_IO_DATA_REG;
 
 	db->rx_chan = dma_request_chan(&pdev->dev, "rx");
-- 
2.31.1

