Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165621D3925
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgENSdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:33:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51617 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgENSdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 14:33:06 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jZIfG-00045Y-Js; Thu, 14 May 2020 18:33:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: dsa: felix: fix incorrect clamp calculation for burst
Date:   Thu, 14 May 2020 19:33:02 +0100
Message-Id: <20200514183302.16925-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently burst is clamping on rate and not burst, the assignment
of burst from the clamping discards the previous assignment of burst.
This looks like a cut-n-paste error from the previous clamping
calculation on ramp.  Fix this by replacing ramp with burst.

Addresses-Coverity: ("Unused value")
Fixes: 0fbabf875d18 ("net: dsa: felix: add support Credit Based Shaper(CBS) for hardware offload")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index df4498c0e864..85e34d85cc51 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1360,7 +1360,7 @@ static int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
 	/* Burst unit is 4kB */
 	burst = DIV_ROUND_UP(cbs_qopt->hicredit, 4096);
 	/* Avoid using zero burst size */
-	burst = clamp_t(u32, rate, 1, GENMASK(5, 0));
+	burst = clamp_t(u32, burst, 1, GENMASK(5, 0));
 	ocelot_write_gix(ocelot,
 			 QSYS_CIR_CFG_CIR_RATE(rate) |
 			 QSYS_CIR_CFG_CIR_BURST(burst),
-- 
2.25.1

