Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C27C3C8748
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 17:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239602AbhGNP0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 11:26:38 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:46606
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232406AbhGNP0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 11:26:37 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 520EF40654;
        Wed, 14 Jul 2021 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626276224;
        bh=72qzdMBzZ6eMaJYmHwsc2NemfPaJZzLq1bqMqHhsBIw=;
        h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=WWmfTHO5fy04N8BwwyXNkxa3Smryn6bqCj51yBOHmfSgzFe6vrUTe92XuZVxZNW+S
         dO3NKGqyEXbu3KqQzscpvV0Y1/cKBzMey+dL57Nv2SDl+aXFHeFKoRr0kKHeQqJIvr
         K8qM2qbXPjCzFa5xSHCMtYHJuVlCjDxag+jEDO0aAscNjHxo4Bzas1ISvO9PVu/eyT
         q8wwHYgCyq1ugckANJkgGr/3ZH6MIZWPSEG8Ukbvrazw04ggjtxsIpadgcfQBHqoVB
         mGrwiHWHiWW7mbyOYHf+KZ8cLaLHkywgoZesaXjEOS1kUkIQOZbISR4ZXAy5HRbn/N
         ARDc91Np5E9ag==
From:   Colin King <colin.king@canonical.com>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Raghu Vatsavayi <rvatsavayi@caviumnetworks.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] liquidio: Fix unintentional sign extension issue on left shift of u16
Date:   Wed, 14 Jul 2021 16:23:43 +0100
Message-Id: <20210714152343.144795-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Shifting the u16 integer oct->pcie_port by CN23XX_PKT_INPUT_CTL_MAC_NUM_POS
(29) bits will be promoted to a 32 bit signed int and then sign-extended
to a u64. In the cases where oct->pcie_port where bit 2 is set (e.g. 3..7)
the shifted value will be sign extended and the top 32 bits of the result
will be set.

Fix this by casting the u16 values to a u64 before the 29 bit left shift.

Addresses-Coverity: ("Unintended sign extension")

Fixes: 3451b97cce2d ("liquidio: CN23XX register setup")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
index 4cddd628d41b..9ed3d1ab2ca5 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
@@ -420,7 +420,7 @@ static int cn23xx_pf_setup_global_input_regs(struct octeon_device *oct)
 	 * bits 32:47 indicate the PVF num.
 	 */
 	for (q_no = 0; q_no < ern; q_no++) {
-		reg_val = oct->pcie_port << CN23XX_PKT_INPUT_CTL_MAC_NUM_POS;
+		reg_val = (u64)oct->pcie_port << CN23XX_PKT_INPUT_CTL_MAC_NUM_POS;
 
 		/* for VF assigned queues. */
 		if (q_no < oct->sriov_info.pf_srn) {
-- 
2.31.1

