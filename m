Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C88AF5F4E
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfKINDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51142 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfKINDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:45 -0500
Received: by mail-wm1-f66.google.com with SMTP id l17so8020471wmh.0
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EYy/hjzsllEpsH3Cm/t6xTMUhWb7unIXSrje8MyOveI=;
        b=lUEAxLb2unjZRH13bT75q2sA6qfTx935D80H2mdtoIv9Jqv9jrDWfDphbN7RqFuGJE
         4zXgDL5Hk3Y/kmOvw2j1IYYNDtJIvVTUUfJRCGRFD4/R2mfs4MyZjAHIqHnma/ZugS6H
         N1oIxQUR3g7TiNbFKG2WnnBQazDVGKWgS5SKyHOabinwOwT+tvPtMRwPuilbUtI5WJte
         df31GjR8DNzHpPSudnHgfYGiymtzUZpU42z9g/OpxpdhGn9SKKMHC8Iznye5wXnWALXC
         9+jImFN4IK//D0ODzjklDadrBVE6wGyl+NIoaVRN4xcEjIDrGAyyVAifovbMpPT+0c8o
         Pqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EYy/hjzsllEpsH3Cm/t6xTMUhWb7unIXSrje8MyOveI=;
        b=nL7ciqZG6zFgWn108Ma/Bch9B6viTTb+cU6RLBVySU6dHE5ioJ04lqonsNHl0eCpR5
         AAiVwC3KA9JqHd8E8tn3X0H1NB6eM8DSoBsa7h0aXtm46eM/2j7KCNDth05SRkwvz+Qe
         UXcn6IvxKQ6CLK+MQLNN4wtO03E87GVFINP7A0ZCQaj1SCYlylZFyeTrEcsanBzAxIyT
         VNR90zqI2O6wW1zFEiFng5Z7//W7RR+dpEmqR2Qt0WnZCGueWGfuku0d5wfePORVcmo1
         FS5lLCSflKTi+SNGDDFPLUpDazCaYBvKOvijNOW6969rMpKgg7m0J5LsoXcyF6KBp688
         if/w==
X-Gm-Message-State: APjAAAWSmX2/EOxEzaJqQiqHLdtAyVO+SnAQQDGjmR4qWA5OtOKNrpA+
        ddZYi5zpsnWqPI8Wwz/l1W0=
X-Google-Smtp-Source: APXvYqzyco8QUFC2fsmB6NRjdb1PXulRYe6fYChcMlTuQLab0sQoiRfKv+YvjpQAO+7iHT38mrvngQ==
X-Received: by 2002:a1c:9a4f:: with SMTP id c76mr12701425wme.103.1573304622982;
        Sat, 09 Nov 2019 05:03:42 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:42 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 15/15] net: mscc: ocelot: don't hardcode the number of the CPU port
Date:   Sat,  9 Nov 2019 15:03:01 +0200
Message-Id: <20191109130301.13716-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

VSC7514 is a 10-port switch with 2 extra "CPU ports" (targets in the
queuing subsystem for terminating traffic locally).

There are 2 issues with hardcoding the CPU port as #10:
- It is not clear which snippets of the code are configuring something
  for one of the CPU ports, and which snippets are just doing something
  related to the number of physical ports.
- Actually any physical port can act as a CPU port connected to an
  external CPU (in addition to the local CPU). This is called NPI mode
  (Node Processor Interface) and is the way that the 6-port VSC9959
  (Felix) switch is integrated inside NXP LS1028A (the "local management
  CPU" functionality is not used there).

This patch makes it clear that the ocelot_bridge_stp_state_set function
operates on the CPU port (by making it an implicit member of the
bridging domain), and at the same time adds logic for the NPI port (aka
a physical port) to play the role of a CPU port (it shouldn't be part of
bridge_fwd_mask, as it's not explicitly enslaved to a bridge).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index bba6d60dc5a8..3e7a2796c37d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1383,7 +1383,7 @@ static void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port,
 	 * a source for the other ports.
 	 */
 	for (p = 0; p < ocelot->num_phys_ports; p++) {
-		if (ocelot->bridge_fwd_mask & BIT(p)) {
+		if (p == ocelot->cpu || (ocelot->bridge_fwd_mask & BIT(p))) {
 			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
 
 			for (i = 0; i < ocelot->num_phys_ports; i++) {
@@ -1398,15 +1398,18 @@ static void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port,
 				}
 			}
 
-			ocelot_write_rix(ocelot,
-					 BIT(ocelot->num_phys_ports) | mask,
+			/* Avoid the NPI port from looping back to itself */
+			if (p != ocelot->cpu)
+				mask |= BIT(ocelot->cpu);
+
+			ocelot_write_rix(ocelot, mask,
 					 ANA_PGID_PGID, PGID_SRC + p);
 		} else {
 			/* Only the CPU port, this is compatible with link
 			 * aggregation.
 			 */
 			ocelot_write_rix(ocelot,
-					 BIT(ocelot->num_phys_ports),
+					 BIT(ocelot->cpu),
 					 ANA_PGID_PGID, PGID_SRC + p);
 		}
 	}
-- 
2.17.1

