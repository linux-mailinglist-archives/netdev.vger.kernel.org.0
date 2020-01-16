Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776A113EEA2
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395125AbgAPSKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:10:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40574 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393257AbgAPSKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:10:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so4788815wmi.5
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5Z7G+yIguA4ekQ5af7TEEosLplPWumPSlYl+GI37Swc=;
        b=avgTJax58ZlKu5EqO4CZZ7ht7SL+6qo/W43+7irBnku3kb+rCaitw9iKtExvT2ZkbI
         MO/MMI0rBwu8aM+Ig37/J+B+89R09T39H5f6BEp67J1z5U9JwWAyQwTRYZ34MEXo3Ymx
         +whqhsNYJ/Nf9chyb7oiZTZcuwdJ0dq6Ki/48L6qPnaThm1MU5MV+UOrl4HADtNona6B
         +3dEy1vYspj8DKCHowMwXvQgVQhEfACbfFii/05WqL5YwUcHJr2HolraBEQoU1JW9DOa
         wDrnxnvS5JKREHu1STpCXCk0nwZJD/8wHsDKK8LlPXHA8jsABw7uQn0/4OC5xhZ7LTtj
         Mz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5Z7G+yIguA4ekQ5af7TEEosLplPWumPSlYl+GI37Swc=;
        b=dKagrxa6Wf/lBVNRpvoANeKn+XZN2ojDY84I9YU7JPgKGu4TNO8lk9mWV1++P6Kyk/
         jpz/kkwYIT1r5BUwGVaqE7Mjqz59oK4d7rfOHz9Ykh46T6iRiO8Kh2Yb7OuCSKhutDU6
         VmRLnS257WvVrj3hnpdliHKWGR1gOoKVon3J4PY1D2RtJFTuwziW652VEwNLNHYP7tCU
         yUR+YcQ6bpEC85xDGq0KzFcYxHVbT+1famXbuolMBewYLod3AvQWOZ//G/avhutk0dLj
         vD6Z1GQG64dY7QuA3wp8XY6MLVCTfLUKj42c5zf1dJEN9W3i5X8f1n4rJT1KzNeYMa/K
         iY/A==
X-Gm-Message-State: APjAAAVDRNarN8Z+/jX3FfCfHFL6p0EG1aZbj3MQWc4h0pYa5wTlWTN1
        4c1Wye8pxOUTaC0ldlfKz3E=
X-Google-Smtp-Source: APXvYqwUaoF8wQGI5BnAJgzyV4+ZxbyaY4MXA9ShCHT7P1CL9FuxtfbZ4y1ao7OiMXBQS0Y5JOaGnQ==
X-Received: by 2002:a05:600c:2c50:: with SMTP id r16mr302704wmg.74.1579198206850;
        Thu, 16 Jan 2020 10:10:06 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v17sm30048095wrt.91.2020.01.16.10.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 10:10:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: felix: Don't restart PCS SGMII AN if not needed
Date:   Thu, 16 Jan 2020 20:09:59 +0200
Message-Id: <20200116180959.29844-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

Some PHYs like VSC8234 don't like it when AN restarts on their system side
and they restart line side AN too, going into an endless link up/down loop.
Don't restart PCS AN if link is up already.

Although in theory this feedback loop should be possible with the other
in-band AN modes too, for some reason it was not seen with the VSC8514
QSGMII and AQR412 USXGMII PHYs. So keep this logic only for SGMII where
the problem was found.

Fixes: bdeced75b13f ("net: dsa: felix: Add PCS operations for PHYLINK")
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1e82b0d72058..2c812b481778 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -645,6 +645,27 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 				   const struct phylink_link_state *state)
 {
 	if (link_an_mode == MLO_AN_INBAND) {
+		int bmsr, bmcr;
+
+		/* Some PHYs like VSC8234 don't like it when AN restarts on
+		 * their system  side and they restart line side AN too, going
+		 * into an endless link up/down loop.  Don't restart PCS AN if
+		 * link is up already.
+		 * We do check that AN is enabled just in case this is the 1st
+		 * call, PCS detects a carrier but AN is disabled from power on
+		 * or by boot loader.
+		 */
+		bmcr = phy_read(pcs, MII_BMCR);
+		if (bmcr < 0)
+			return;
+
+		bmsr = phy_read(pcs, MII_BMSR);
+		if (bmsr < 0)
+			return;
+
+		if ((bmcr & BMCR_ANENABLE) && (bmsr & BMSR_LSTATUS))
+			return;
+
 		/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
 		 * for the MAC PCS in order to acknowledge the AN.
 		 */
-- 
2.17.1

