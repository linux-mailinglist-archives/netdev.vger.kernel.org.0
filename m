Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB813604FEB
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiJSSvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJSSvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:51:51 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B451958F1
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:51:51 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 7E057504ECB;
        Wed, 19 Oct 2022 21:48:12 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 7E057504ECB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666205293; bh=DW5nFYcgvXTUFIE6sFmtf5r1sh/I2/XwxCLTjGpmS0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkAlz5SAmXiz+U+QiXzEWONLEODMOCnlmr5pkyS6MvN8bu1+dNz1n2m95GsySvsnI
         1yCsE/lvzH/M9wrl//KDPWAmG47mEjkP+0UHE92rSD28TFy4i7YDC+FS5CDutixbyS
         cigWe3XSIkNmYj2OFiIh8V6if/6l7PUSMnl6MbMk=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Charles Parent <charles.parent@orolia2s.com>
Subject: [PATCH net-next v4 3/5] ptp: ocp: add serial port of mRO50 MAC on ART card
Date:   Wed, 19 Oct 2022 21:51:10 +0300
Message-Id: <20221019185112.28294-4-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221019185112.28294-1-vfedorenko@novek.ru>
References: <20221019185112.28294-1-vfedorenko@novek.ru>
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
 drivers/ptp/ptp_ocp.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 59b226518ee4..9bdfb82d5402 100644
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
@@ -795,6 +801,17 @@ static struct ocp_resource ocp_art_resource[] = {
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
-- 
2.27.0

