Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1051601BE8
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 00:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJQWAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 18:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiJQWAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 18:00:38 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5876BD7A
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 15:00:36 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id E9CF4504ECA;
        Tue, 18 Oct 2022 00:56:29 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru E9CF4504ECA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666043791; bh=gdZjPeIzg7tjgAH8VJPNhBpHyMSR0vrrf/TzAvzcAfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBSqz58p6kyegoENoIIyiVuCNHEv+Bpw+xzfz6DGjIcvXWyjMtUspD1UZsQqdAbvP
         hePHXNvf6AFMY04Ghro34/HKDF98fzvMPU6C4qzhXdW/HaNLKPCNPLvX5YS0tvMIA4
         TzUToTsauXd2bEW4+iLRGn67UdXCzxk04sKrueZU=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Charles Parent <charles.parent@orolia2s.com>
Subject: [PATCH net-next 3/5] ptp: ocp: add serial port of mRO50 MAC on ART card
Date:   Tue, 18 Oct 2022 00:59:45 +0300
Message-Id: <20221017215947.7438-4-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221017215947.7438-1-vfedorenko@novek.ru>
References: <20221017215947.7438-1-vfedorenko@novek.ru>
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
Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/ptp_ocp.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index cd4f3860d72a..d8a723e9e21c 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -213,6 +213,11 @@ struct frequency_reg {
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
@@ -304,6 +309,7 @@ struct ptp_ocp {
 	struct tod_reg __iomem	*tod;
 	struct pps_reg __iomem	*pps_to_ext;
 	struct pps_reg __iomem	*pps_to_clk;
+	struct board_config_reg __iomem	*board_config;
 	struct gpio_reg __iomem	*pps_select;
 	struct gpio_reg __iomem	*sma_map1;
 	struct gpio_reg __iomem	*sma_map2;
@@ -801,6 +807,17 @@ static struct ocp_resource ocp_art_resource[] = {
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
@@ -2416,6 +2433,9 @@ ptp_ocp_art_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	bp->fw_tag = 2;
 	bp->sma_op = &ocp_art_sma_op;
 
+	/* Enable MAC serial port during initialisation */
+	iowrite32(1, &bp->board_config->mro50_serial_activate);
+
 	ptp_ocp_sma_init(bp);
 
 	err = ptp_ocp_attr_group_add(bp, art_timecard_groups);
-- 
2.27.0

