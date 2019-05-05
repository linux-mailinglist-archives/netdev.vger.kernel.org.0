Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4083F1426B
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfEEVPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:15:53 -0400
Received: from mx1.mailbox.org ([80.241.60.212]:26130 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbfEEVPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 17:15:53 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx1.mailbox.org (Postfix) with ESMTPS id 23EF74CCBC;
        Sun,  5 May 2019 23:15:51 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id 2536b7xi9mgb; Sun,  5 May 2019 23:15:37 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 1/5] net: dsa: lantiq: Allow special tags only on CPU port
Date:   Sun,  5 May 2019 23:15:13 +0200
Message-Id: <20190505211517.25237-2-hauke@hauke-m.de>
In-Reply-To: <20190505211517.25237-1-hauke@hauke-m.de>
References: <20190505211517.25237-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the special tag in ingress only on the CPU port and not on all
ports. A packet with a special tag could circumvent the hardware
forwarding and should only be allowed on the CPU port where Linux
controls the port.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/dsa/lantiq_gswip.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index d8328866908c..0a2259cb09df 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -461,8 +461,6 @@ static int gswip_port_enable(struct dsa_switch *ds, int port,
 			 GSWIP_FDMA_PCTRLp(port));
 	gswip_switch_mask(priv, 0, GSWIP_SDMA_PCTRL_EN,
 			  GSWIP_SDMA_PCTRLp(port));
-	gswip_switch_mask(priv, 0, GSWIP_PCE_PCTRL_0_INGRESS,
-			  GSWIP_PCE_PCTRL_0p(port));
 
 	if (!dsa_is_cpu_port(ds, port)) {
 		u32 macconf = GSWIP_MDIO_PHY_LINK_AUTO |
@@ -578,6 +576,10 @@ static int gswip_setup(struct dsa_switch *ds)
 	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
 			  GSWIP_FDMA_PCTRLp(cpu_port));
 
+	/* accept special tag in ingress direction */
+	gswip_switch_mask(priv, 0, GSWIP_PCE_PCTRL_0_INGRESS,
+			  GSWIP_PCE_PCTRL_0p(cpu_port));
+
 	gswip_switch_mask(priv, 0, GSWIP_MAC_CTRL_2_MLEN,
 			  GSWIP_MAC_CTRL_2p(cpu_port));
 	gswip_switch_w(priv, VLAN_ETH_FRAME_LEN + 8, GSWIP_MAC_FLEN);
-- 
2.20.1

