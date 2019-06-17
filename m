Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD4A487F2
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 17:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbfFQPxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 11:53:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52889 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbfFQPxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 11:53:30 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hctwj-0001vz-UI; Mon, 17 Jun 2019 15:53:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: lio_core: fix potential sign-extension overflow on large shift
Date:   Mon, 17 Jun 2019 16:53:25 +0100
Message-Id: <20190617155325.27017-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Left shifting the signed int value 1 by 31 bits has undefined behaviour
and the shift amount oq_no can be as much as 63.  Fix this by widening
the int 1 to 1ULL.

Addresses-Coverity: ("Bad shift operation")
Fixes: f21fb3ed364b ("Add support of Cavium Liquidio ethernet adapters")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 1c50c10b5a16..e78bdcee200f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -964,7 +964,7 @@ static void liquidio_schedule_droq_pkt_handlers(struct octeon_device *oct)
 
 			if (droq->ops.poll_mode) {
 				droq->ops.napi_fn(droq);
-				oct_priv->napi_mask |= (1 << oq_no);
+				oct_priv->napi_mask |= (1ULL << oq_no);
 			} else {
 				tasklet_schedule(&oct_priv->droq_tasklet);
 			}
-- 
2.20.1

