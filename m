Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0435220E5D9
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403933AbgF2VmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbgF2Sh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:56 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C56C031C7D;
        Mon, 29 Jun 2020 11:18:19 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B6A7622FA7;
        Mon, 29 Jun 2020 20:18:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1593454698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eEE2UbGu8BTGtcLgMgns43018yjd14SkF1FC8t9v/x8=;
        b=XIaGTyyus2oWlG5KxK6sEEDMh31kXJcp+INP/eDG3A6nTLQzla+6o1S0Fdv7D2wX8neEdV
        WaqZ099GB39Yx2DHEDYBDRxHwccl71glD8/skeZPZU9vUo+ryMfwmJ3N9qU4eBJ5iEpXUN
        5gaOOw33ERueJDXtn3vm8ZOno0emA+8=
From:   Michael Walle <michael@walle.cc>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH 1/2] can: flexcan: use ctrlmode to enable CAN-FD
Date:   Mon, 29 Jun 2020 20:18:08 +0200
Message-Id: <20200629181809.25338-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200629181809.25338-1-michael@walle.cc>
References: <20200629181809.25338-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver will enable CAN-FD mode according to the ctrlmode_supported,
which will always be true, if the controller supports it. This is wrong.
Use the correct ctrlmode instead.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 12043250e398..183e094f8d66 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1345,7 +1345,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		reg_mcr |= FLEXCAN_MCR_SRX_DIS;
 
 	/* MCR - CAN-FD */
-	if (priv->can.ctrlmode_supported & CAN_CTRLMODE_FD)
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
 		reg_mcr |= FLEXCAN_MCR_FDEN;
 	else
 		reg_mcr &= ~FLEXCAN_MCR_FDEN;
-- 
2.20.1

