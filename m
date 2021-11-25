Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35B345DDFC
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345423AbhKYPxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:53:07 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:46387 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbhKYPvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 10:51:37 -0500
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id EA6F810000B;
        Thu, 25 Nov 2021 15:48:22 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH net-next 2/4] net: mvneta: Don't force-set the offloading flag
Date:   Thu, 25 Nov 2021 16:48:11 +0100
Message-Id: <20211125154813.579169-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20211125154813.579169-1-maxime.chevallier@bootlin.com>
References: <20211125154813.579169-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qopt->hw flag is set by the TC code according to the offloading mode
asked by user. Don't force-set it in the driver, but instead read it to
make sure we do what's asked.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 46b7604805f7..d3ce87e69d2a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4915,7 +4915,9 @@ static int mvneta_setup_mqprio(struct net_device *dev,
 	u8 num_tc;
 	int i;
 
-	mqprio->qopt.hw = TC_MQPRIO_HW_OFFLOAD_TCS;
+	if (mqprio->qopt.hw != TC_MQPRIO_HW_OFFLOAD_TCS)
+		return 0;
+
 	num_tc = mqprio->qopt.num_tc;
 
 	if (num_tc > rxq_number)
-- 
2.25.4

