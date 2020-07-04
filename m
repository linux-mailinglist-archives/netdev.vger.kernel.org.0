Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287CF2145ED
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 14:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgGDMpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 08:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgGDMpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 08:45:33 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADCEC061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 05:45:32 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id a8so29019270edy.1
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 05:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZVBFUPOgzhKEsY+rrtCHpTgk1ScAOxfRrD9YVLZy0fI=;
        b=IdyKmz0EBqUKBQJHUd7eUAhCNgo7hhu87v+y+trH2jvif4c9/EdBnrsypTEmGoQWIU
         rQ8nLqGXmDIRDKXmwSI9tEiXSKl0jVjlK1G1lk7pri6vhHTxxdQftkBerYaywTd81lNE
         XeQXOjqp3Q0XTV5SniUCh/+kiVS6nZ9rL4+dgqU7c9GDUFWQMU+kkuDdLGg5al5j3ml6
         X5bmWDum4Rh53Y03E6cCOV2XKi20eE26DbyiWX6Y4PmcN+V7K/ZcwnZqkOY8PnbV/kBh
         58yebR/0vUf7XLwBRBxxQzCe4W+YaEm5bgd82vuC17qQ0oREkWDcNkcdOYYcCrkOPf9b
         E3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZVBFUPOgzhKEsY+rrtCHpTgk1ScAOxfRrD9YVLZy0fI=;
        b=kSx0IUWt00cG4PsWcfypUtFuvCRZgEOwOB4JaadoaYZ+3eKO9nGPU3sE6H20dsysTU
         bw087AYRQQ5/lUARbhYTO2dSe2FaqXmdHSqdXgkx4fC1BH+aP0Cgs72Q1HbfMQfMS6va
         pA+JsmYCsncTNsyXC++ANJaw/CzzOKZQ78SId51kvuo7Z6Z2VigaxmosmABfoYAAV3Ye
         UGg5qd2nSajZZpqcdMlV3G9ORb2q+H203azHgAT/lC4kUxZuznRb0pRJs+54M89QjtpC
         25vYvAwemSd+s/UY46aesiBiXPkjI/F77VImGw+UJ1gZmNyvigS/42DzSnJmXfS0ZyzP
         2Nhg==
X-Gm-Message-State: AOAM532lq/8rvewj+dyRpCK1bHgv2iOPaIMhIyY6QFc6nNxViPP1CJx2
        jId/i9iou/3VDMIkze55l7oWkvRr
X-Google-Smtp-Source: ABdhPJySWp7Do+CVYmaMwWecvf5p9QgoLcqv5LU+QioaRNFYMtnZV4jwaQgo+13nGoMN78Evu/lSsg==
X-Received: by 2002:aa7:d90f:: with SMTP id a15mr33701923edr.86.1593866731429;
        Sat, 04 Jul 2020 05:45:31 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id dm1sm12983851ejc.99.2020.07.04.05.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 05:45:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v2 net-next 4/6] net: dsa: felix: set proper pause frame timers based on link speed
Date:   Sat,  4 Jul 2020 15:45:05 +0300
Message-Id: <20200704124507.3336497-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200704124507.3336497-1-olteanv@gmail.com>
References: <20200704124507.3336497-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

state->speed holds a value of 10, 100, 1000 or 2500, but
SYS_MAC_FC_CFG_FC_LINK_SPEED expects a value in the range 0, 1, 2 or 3.

So set the correct speed encoding into this register.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

Note: this patch is still using state->speed from mac_config(), although
that will be changed in 6/6.

 drivers/net/dsa/ocelot/felix.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4d819cc45bed..4684339012c5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -250,10 +250,25 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
 			   DEV_CLOCK_CFG);
 
-	/* Flow control. Link speed is only used here to evaluate the time
-	 * specification in incoming pause frames.
-	 */
-	mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
+	switch (state->speed) {
+	case SPEED_10:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
+		break;
+	case SPEED_100:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(2);
+		break;
+	case SPEED_1000:
+	case SPEED_2500:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
+		break;
+	case SPEED_UNKNOWN:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(0);
+		break;
+	default:
+		dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
+			port, state->speed);
+		return;
+	}
 
 	/* handle Rx pause in all cases, with 2500base-X this is used for rate
 	 * adaptation.
@@ -265,6 +280,10 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
 			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
 			      SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
+
+	/* Flow control. Link speed is only used here to evaluate the time
+	 * specification in incoming pause frames.
+	 */
 	ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
 
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
-- 
2.25.1

