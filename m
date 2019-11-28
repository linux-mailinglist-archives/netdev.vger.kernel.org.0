Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8EAF10C7DD
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 12:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfK1LX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 06:23:56 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40052 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfK1LX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 06:23:56 -0500
Received: by mail-wm1-f67.google.com with SMTP id y5so11241603wmi.5
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 03:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2hiK+xRXlPxURuLqayLGvGiBlijvu9wohhwXV3tZ0rU=;
        b=R5CIFAEqNiSoGH8YK6huQWKlyde3bmplcOVvOFropxLcO8nA+hgpT9GA8X0AJStXHX
         p3yINxJU/ZhaYMwhNCk+/t4ECFtis1auqZ9FYeCk63WK33yhMXiCgaQj+cs2GMbO75cE
         CGyCQh0EcN2ZsEas5Rh6vYYxhqXuwpDxZQ7ykuAswjRKa7/QRTBkvMXqQeWEiLPQUvns
         jLVz3NTNDbtKPcymr6isPVs/Vl8mnw8c8KlVJIQ3ACDTLp0AbUt5uFXIQmtpOtAq3pof
         p5QfaW/FbHwE+pOaLeocTtYQ4g1/hYlLO/QuxChfMLnY8zJgKsHD/CLkPabSzkBSjcqj
         7mJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2hiK+xRXlPxURuLqayLGvGiBlijvu9wohhwXV3tZ0rU=;
        b=P/5Z36y5c6QmoTPKq7HHNZiEcrUBYNThUOtFrb/tD1V/d4JK3Pb9tQSELqrDxi+tms
         vQ/b3Q6gVD3UhSqlRqzHWtUM2o/b7xEgsuy9JjrjJlApeTfpyeaoHRFMLIx83sjqSJ77
         ZA1OhRqP8vkBtumxFXfKAcveXxCTlWOzp2bAPMOW/8tumEpBXVyx8eLx87GnXya5r9V6
         HjUHlT25wIZ1na9AB3Q9+MQtzBEGU8SRNLnPtkmF31O2Vuh8znXY1S1Le3qtV3Bm2aHa
         vZOsY2rYKojX03UXiLB/1HpYv2nynqrIP1NaD48bHYfolrSwL9Jf2pS7dzZMZbEIglAy
         qmbw==
X-Gm-Message-State: APjAAAU/vSOQa4dljujP18oVDy2eUq7xtC2sBKkSOGD4kngt7zY2FceF
        kevaA3NJf+GKL9qEZX0cfdM=
X-Google-Smtp-Source: APXvYqyPSW029+zGm4aDe/FifDJuBB6u45DnbjEVSB9V03GwsQjzge4vIJaQ7yOt4994IPGKPydrVA==
X-Received: by 2002:a1c:16:: with SMTP id 22mr9561375wma.0.1574940231558;
        Thu, 28 Nov 2019 03:23:51 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id i25sm9642889wmd.25.2019.11.28.03.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 03:23:51 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, richardcochran@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH v2 net] net: mscc: ocelot: unregister the PTP clock on deinit
Date:   Thu, 28 Nov 2019 13:23:42 +0200
Message-Id: <20191128112342.2547-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently a switch driver deinit frees the regmaps, but the PTP clock is
still out there, available to user space via /dev/ptpN. Any PTP
operation is a ticking time bomb, since it will attempt to use the freed
regmaps and thus trigger kernel panics:

[    4.291746] fsl_enetc 0000:00:00.2 eth1: error -22 setting up slave phy
[    4.291871] mscc_felix 0000:00:00.5: Failed to register DSA switch: -22
[    4.308666] mscc_felix: probe of 0000:00:00.5 failed with error -22
[    6.358270] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000088
[    6.367090] Mem abort info:
[    6.369888]   ESR = 0x96000046
[    6.369891]   EC = 0x25: DABT (current EL), IL = 32 bits
[    6.369892]   SET = 0, FnV = 0
[    6.369894]   EA = 0, S1PTW = 0
[    6.369895] Data abort info:
[    6.369897]   ISV = 0, ISS = 0x00000046
[    6.369899]   CM = 0, WnR = 1
[    6.369902] user pgtable: 4k pages, 48-bit VAs, pgdp=00000020d58c7000
[    6.369904] [0000000000000088] pgd=00000020d5912003, pud=00000020d5915003, pmd=0000000000000000
[    6.369914] Internal error: Oops: 96000046 [#1] PREEMPT SMP
[    6.420443] Modules linked in:
[    6.423506] CPU: 1 PID: 262 Comm: phc_ctl Not tainted 5.4.0-03625-gb7b2a5dadd7f #204
[    6.431273] Hardware name: LS1028A RDB Board (DT)
[    6.435989] pstate: 40000085 (nZcv daIf -PAN -UAO)
[    6.440802] pc : css_release+0x24/0x58
[    6.444561] lr : regmap_read+0x40/0x78
[    6.448316] sp : ffff800010513cc0
[    6.451636] x29: ffff800010513cc0 x28: ffff002055873040
[    6.456963] x27: 0000000000000000 x26: 0000000000000000
[    6.462289] x25: 0000000000000000 x24: 0000000000000000
[    6.467617] x23: 0000000000000000 x22: 0000000000000080
[    6.472944] x21: ffff800010513d44 x20: 0000000000000080
[    6.478270] x19: 0000000000000000 x18: 0000000000000000
[    6.483596] x17: 0000000000000000 x16: 0000000000000000
[    6.488921] x15: 0000000000000000 x14: 0000000000000000
[    6.494247] x13: 0000000000000000 x12: 0000000000000000
[    6.499573] x11: 0000000000000000 x10: 0000000000000000
[    6.504899] x9 : 0000000000000000 x8 : 0000000000000000
[    6.510225] x7 : 0000000000000000 x6 : ffff800010513cf0
[    6.515550] x5 : 0000000000000000 x4 : 0000000fffffffe0
[    6.520876] x3 : 0000000000000088 x2 : ffff800010513d44
[    6.526202] x1 : ffffcada668ea000 x0 : ffffcada64d8b0c0
[    6.531528] Call trace:
[    6.533977]  css_release+0x24/0x58
[    6.537385]  regmap_read+0x40/0x78
[    6.540795]  __ocelot_read_ix+0x6c/0xa0
[    6.544641]  ocelot_ptp_gettime64+0x4c/0x110
[    6.548921]  ptp_clock_gettime+0x4c/0x58
[    6.552853]  pc_clock_gettime+0x5c/0xa8
[    6.556699]  __arm64_sys_clock_gettime+0x68/0xc8
[    6.561331]  el0_svc_common.constprop.2+0x7c/0x178
[    6.566133]  el0_svc_handler+0x34/0xa0
[    6.569891]  el0_sync_handler+0x114/0x1d0
[    6.573908]  el0_sync+0x140/0x180
[    6.577232] Code: d503201f b00119a1 91022263 b27b7be4 (f9004663)
[    6.583349] ---[ end trace d196b9b14cdae2da ]---
[    6.587977] Kernel panic - not syncing: Fatal exception
[    6.593216] SMP: stopping secondary CPUs
[    6.597151] Kernel Offset: 0x4ada54400000 from 0xffff800010000000
[    6.603261] PHYS_OFFSET: 0xffffd0a7c0000000
[    6.607454] CPU features: 0x10002,21806008
[    6.611558] Memory Limit: none

And now that ocelot->ptp_clock is checked at exit, prevent a potential
error where ptp_clock_register returned a pointer-encoded error, which
we are keeping in the ocelot private data structure. So now,
ocelot->ptp_clock is now either NULL or a valid pointer.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- Dropped the redundant check on ocelot->ptp and changed the topic of
  the if condition.
- Populated ocelot->ptp_clock in ocelot_init_timestamp only on valid
  return value from ptp_clock_register, so that the deinit check can
  never mis-trigger.

 drivers/net/ethernet/mscc/ocelot.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 52a1b1f12af8..875eea702c58 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2166,16 +2166,26 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.adjfine	= ocelot_ptp_adjfine,
 };
 
+static void ocelot_deinit_timestamp(struct ocelot *ocelot)
+{
+	if (ocelot->ptp_clock)
+		ptp_clock_unregister(ocelot->ptp_clock);
+}
+
 static int ocelot_init_timestamp(struct ocelot *ocelot)
 {
+	struct ptp_clock *ptp_clock;
+
 	ocelot->ptp_info = ocelot_ptp_clock_info;
-	ocelot->ptp_clock = ptp_clock_register(&ocelot->ptp_info, ocelot->dev);
-	if (IS_ERR(ocelot->ptp_clock))
-		return PTR_ERR(ocelot->ptp_clock);
+	ptp_clock = ptp_clock_register(&ocelot->ptp_info, ocelot->dev);
+	if (IS_ERR(ptp_clock))
+		return PTR_ERR(ptp_clock);
 	/* Check if PHC support is missing at the configuration level */
-	if (!ocelot->ptp_clock)
+	if (!ptp_clock)
 		return 0;
 
+	ocelot->ptp_clock = ptp_clock;
+
 	ocelot_write(ocelot, SYS_PTP_CFG_PTP_STAMP_WID(30), SYS_PTP_CFG);
 	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_LOW);
 	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_HIGH);
@@ -2508,6 +2518,7 @@ void ocelot_deinit(struct ocelot *ocelot)
 	destroy_workqueue(ocelot->stats_queue);
 	mutex_destroy(&ocelot->stats_lock);
 	ocelot_ace_deinit();
+	ocelot_deinit_timestamp(ocelot);
 
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		port = ocelot->ports[i];
-- 
2.17.1

