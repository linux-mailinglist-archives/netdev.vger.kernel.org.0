Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28206027CF
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiJRJCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiJRJCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:02:30 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FFAAA372
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:02:15 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 1527F504ED5;
        Tue, 18 Oct 2022 11:58:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 1527F504ED5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666083485; bh=X81mdm6EZ61PoVnf6bBRgqNNrUio9Fnm/EEZ3tZ0jVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTHHNchZQK1GSBS584W+6kiBBTyPh8tEfeuoiBs142Ow7J2ZUfnzDNOLyChKuypEW
         +7nMNLINvUEKzEymaoee4XwWzytlv/OBwz4p0wauXN7TAxV3p/4/16p9knuzaHCZCW
         733oY1fuBrf/IMRla6BMFupyU+oWOqFwvxxzjJKc=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Charles Parent <charles.parent@orolia2s.com>
Subject: [PATCH net-next v3 3/5] ptp: ocp: add serial port of mRO50 MAC on ART card
Date:   Tue, 18 Oct 2022 12:01:20 +0300
Message-Id: <20221018090122.3361-4-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221018090122.3361-1-vfedorenko@novek.ru>
References: <20221018090122.3361-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

ART card provides interface to access to serial port of miniature atomic
clock found on the card. Add support for this device and configure it
during init phase.

Co-developed-by: Charles Parent <charles.parent@orolia2s.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/ptp_ocp.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 701fa265758a..7da24a82f221 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -208,6 +208,11 @@ struct frequency_reg {
 	u32	ctrl;
 	u32	status;
 };
+
+struct board_config_reg {
+	u32 mro50_serial_activate;
+};
+
 #define FREQ_STATUS_VALID	BIT(31)
 #define FREQ_STATUS_ERROR	BIT(30)
 #define FREQ_STATUS_OVERRUN	BIT(29)
@@ -299,6 +304,7 @@ struct ptp_ocp {
 	struct tod_reg __iomem	*tod;
 	struct pps_reg __iomem	*pps_to_ext;
 	struct pps_reg __iomem	*pps_to_clk;
+	struct board_config_reg __iomem	*board_config;
 	struct gpio_reg __iomem	*pps_select;
 	struct gpio_reg __iomem	*sma_map1;
 	struct gpio_reg __iomem	*sma_map2;
@@ -796,6 +802,17 @@ static struct ocp_resource ocp_art_resource[] = {
 			},
 		},
 	},
+	{
+		OCP_SERIAL_RESOURCE(mac_port),
+		.offset = 0x00190000, .irq_vec = 7,
+		.extra = &(struct ptp_ocp_serial_port) {
+			.baud = 9600,
+		},
+	},
+	{
+		OCP_MEM_RESOURCE(board_config),
+		.offset = 0x210000, .size = 0x1000,
+	},
 	{
 		.setup = ptp_ocp_art_board_init,
 	},
@@ -2411,6 +2428,9 @@ ptp_ocp_art_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	bp->fw_tag = 2;
 	bp->sma_op = &ocp_art_sma_op;
 
+	/* Enable MAC serial port during initialisation */
+	iowrite32(1, &bp->board_config->mro50_serial_activate);
+
 	ptp_ocp_sma_init(bp);
 
 	err = ptp_ocp_attr_group_add(bp, art_timecard_groups);
-- 
2.27.0

