Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFE0609C0C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJXIGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 04:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJXIF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:05:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11C75601D
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 01:05:55 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jbe@pengutronix.de>)
        id 1omsT4-0001Pc-9a; Mon, 24 Oct 2022 10:05:54 +0200
Received: from [2a0a:edc0:0:900:1d::45] (helo=ginster)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <jbe@pengutronix.de>)
        id 1omsT4-0004o7-Go; Mon, 24 Oct 2022 10:05:53 +0200
Received: from jbe by ginster with local (Exim 4.94.2)
        (envelope-from <jbe@pengutronix.de>)
        id 1omsT2-0005TZ-2s; Mon, 24 Oct 2022 10:05:52 +0200
From:   Juergen Borleis <jbe@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH v2] net: fec: limit register access on i.MX6UL
Date:   Mon, 24 Oct 2022 10:05:52 +0200
Message-Id: <20221024080552.21004-1-jbe@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using 'ethtool -d […]' on an i.MX6UL leads to a kernel crash:

   Unhandled fault: external abort on non-linefetch (0x1008) at […]

due to this SoC has less registers in its FEC implementation compared to other
i.MX6 variants. Thus, a run-time decision is required to avoid access to
non-existing registers.

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
---

Notes:
    v2: using of_machine_is_compatible() to detect the i.MX6UL SoC

 drivers/net/ethernet/freescale/fec_main.c | 46 ++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 98d5cd31..28ef4d3 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2432,6 +2432,31 @@ static u32 fec_enet_register_offset[] = {
 	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
 	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
 };
+/* for i.MX6ul */
+static u32 fec_enet_register_offset_6ul[] = {
+	FEC_IEVENT, FEC_IMASK, FEC_R_DES_ACTIVE_0, FEC_X_DES_ACTIVE_0,
+	FEC_ECNTRL, FEC_MII_DATA, FEC_MII_SPEED, FEC_MIB_CTRLSTAT, FEC_R_CNTRL,
+	FEC_X_CNTRL, FEC_ADDR_LOW, FEC_ADDR_HIGH, FEC_OPD, FEC_TXIC0, FEC_RXIC0,
+	FEC_HASH_TABLE_HIGH, FEC_HASH_TABLE_LOW, FEC_GRP_HASH_TABLE_HIGH,
+	FEC_GRP_HASH_TABLE_LOW, FEC_X_WMRK, FEC_R_DES_START_0,
+	FEC_X_DES_START_0, FEC_R_BUFF_SIZE_0, FEC_R_FIFO_RSFL, FEC_R_FIFO_RSEM,
+	FEC_R_FIFO_RAEM, FEC_R_FIFO_RAFL, FEC_RACC,
+	RMON_T_DROP, RMON_T_PACKETS, RMON_T_BC_PKT, RMON_T_MC_PKT,
+	RMON_T_CRC_ALIGN, RMON_T_UNDERSIZE, RMON_T_OVERSIZE, RMON_T_FRAG,
+	RMON_T_JAB, RMON_T_COL, RMON_T_P64, RMON_T_P65TO127, RMON_T_P128TO255,
+	RMON_T_P256TO511, RMON_T_P512TO1023, RMON_T_P1024TO2047,
+	RMON_T_P_GTE2048, RMON_T_OCTETS,
+	IEEE_T_DROP, IEEE_T_FRAME_OK, IEEE_T_1COL, IEEE_T_MCOL, IEEE_T_DEF,
+	IEEE_T_LCOL, IEEE_T_EXCOL, IEEE_T_MACERR, IEEE_T_CSERR, IEEE_T_SQE,
+	IEEE_T_FDXFC, IEEE_T_OCTETS_OK,
+	RMON_R_PACKETS, RMON_R_BC_PKT, RMON_R_MC_PKT, RMON_R_CRC_ALIGN,
+	RMON_R_UNDERSIZE, RMON_R_OVERSIZE, RMON_R_FRAG, RMON_R_JAB,
+	RMON_R_RESVD_O, RMON_R_P64, RMON_R_P65TO127, RMON_R_P128TO255,
+	RMON_R_P256TO511, RMON_R_P512TO1023, RMON_R_P1024TO2047,
+	RMON_R_P_GTE2048, RMON_R_OCTETS,
+	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
+	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
+};
 #else
 static __u32 fec_enet_register_version = 1;
 static u32 fec_enet_register_offset[] = {
@@ -2456,7 +2481,24 @@ static void fec_enet_get_regs(struct net_device *ndev,
 	u32 *buf = (u32 *)regbuf;
 	u32 i, off;
 	int ret;
+#if defined(CONFIG_M523x) || defined(CONFIG_M527x) || defined(CONFIG_M528x) || \
+	defined(CONFIG_M520x) || defined(CONFIG_M532x) || defined(CONFIG_ARM) || \
+	defined(CONFIG_ARM64) || defined(CONFIG_COMPILE_TEST)
+	u32 *reg_list;
+	u32 reg_cnt;
 
+	if (!of_machine_is_compatible("fsl,imx6ul")) {
+		reg_list = fec_enet_register_offset;
+		reg_cnt = ARRAY_SIZE(fec_enet_register_offset);
+	} else {
+		reg_list = fec_enet_register_offset_6ul;
+		reg_cnt = ARRAY_SIZE(fec_enet_register_offset_6ul);
+	}
+#else
+	/* coldfire */
+	static u32 *reg_list = fec_enet_register_offset;
+	static const u32 reg_cnt = ARRAY_SIZE(fec_enet_register_offset);
+#endif
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return;
@@ -2465,8 +2507,8 @@ static void fec_enet_get_regs(struct net_device *ndev,
 
 	memset(buf, 0, regs->len);
 
-	for (i = 0; i < ARRAY_SIZE(fec_enet_register_offset); i++) {
-		off = fec_enet_register_offset[i];
+	for (i = 0; i < reg_cnt; i++) {
+		off = reg_list[i];
 
 		if ((off == FEC_R_BOUND || off == FEC_R_FSTART) &&
 		    !(fep->quirks & FEC_QUIRK_HAS_FRREG))
-- 
2.30.2

