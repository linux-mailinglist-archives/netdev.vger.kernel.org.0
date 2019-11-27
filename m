Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE57E10AB29
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 08:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfK0H2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 02:28:22 -0500
Received: from inva020.nxp.com ([92.121.34.13]:33788 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfK0H2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 02:28:22 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8A2071A0128;
        Wed, 27 Nov 2019 08:28:20 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 924F61A0082;
        Wed, 27 Nov 2019 08:28:17 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 899BE402C7;
        Wed, 27 Nov 2019 15:28:13 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2, 1/2] net: mscc: ocelot: avoid incorrect consuming in skbs list
Date:   Wed, 27 Nov 2019 15:27:56 +0800
Message-Id: <20191127072757.34502-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191127072757.34502-1-yangbo.lu@nxp.com>
References: <20191127072757.34502-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Break the matching loop when find the matching skb for TX timestamp.
This is to avoid consuming more skbs incorrectly. The timestamp ID
is from 0 to 3 while the FIFO could support 128 timestamps at most.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Split a single patch for this fix-up.
---
 drivers/net/ethernet/mscc/ocelot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0e96ffa..6dc9de3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -736,6 +736,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 
 			list_del(pos);
 			kfree(entry);
+			break;
 		}
 
 		/* Next ts */
-- 
2.7.4

