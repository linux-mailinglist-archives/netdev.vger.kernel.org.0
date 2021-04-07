Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAA035691D
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 12:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbhDGKNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 06:13:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36071 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234398AbhDGKND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 06:13:03 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lU5B2-00049z-Al; Wed, 07 Apr 2021 10:12:48 +0000
From:   Colin King <colin.king@canonical.com>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Raghu Vatsavayi <rvatsavayi@caviumnetworks.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] liquidio: Fix unintented sign extension of a left shift of a u16
Date:   Wed,  7 Apr 2021 11:12:48 +0100
Message-Id: <20210407101248.485307-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The macro CN23XX_PEM_BAR1_INDEX_REG is being used to shift oct->pcie_port
(a u16) left 24 places. There are two subtle issues here, first the
shift gets promoted to an signed int and then sign extended to a u64.
If oct->pcie_port is 0x80 or more then the upper bits get sign extended
to 1. Secondly shfiting a u16 24 bits will lead to an overflow so it
needs to be cast to a u64 for all the bits to not overflow.

It is entirely possible that the u16 port value is never large enough
for this to fail, but it is useful to fix unintended overflows such
as this.

Fix this by casting the port parameter to the macro to a u64 before
the shift.

Addresses-Coverity: ("Unintended sign extension")
Fixes: 5bc67f587ba7 ("liquidio: CN23XX register definitions")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
index e6d4ad99cc38..92c27b148176 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
@@ -521,7 +521,7 @@
 #define    CN23XX_BAR1_INDEX_OFFSET                3
 
 #define    CN23XX_PEM_BAR1_INDEX_REG(port, idx)		\
-		(CN23XX_PEM_BAR1_INDEX_START + ((port) << CN23XX_PEM_OFFSET) + \
+		(CN23XX_PEM_BAR1_INDEX_START + (((u64)port) << CN23XX_PEM_OFFSET) + \
 		 ((idx) << CN23XX_BAR1_INDEX_OFFSET))
 
 /*############################ DPI #########################*/
-- 
2.30.2

