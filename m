Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1F81E9409
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgE3Vnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729083AbgE3Vna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 17:43:30 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49988C03E969;
        Sat, 30 May 2020 14:43:30 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e2so5551458eje.13;
        Sat, 30 May 2020 14:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0r/Hz3aB3/pi6f4PZFpZnSaaYmY5eVDrheC4RHLktY0=;
        b=R6tdZPvhIUfDnAwFPZKnziKhI/J5TX1xg6OW+A5l40wZgKLAQz/dKDBsmM7PGVCdgm
         bwJEelF0HOLj/d7CIB2q8WM4pIwviLGKcSmuowfw65OgWo1J8sAcM4FZTo+CRk7YMmsl
         Aui/wxjgxTXTAKeQDYebie0NHTb4geTPN2OfkDjuj4QDUpIEbOBlwH19Ms4jqAtt1VdG
         roKw3CAWlR5Gc2wB9KY33aO17ITtvma+tPkepg7hJDFmgHlDTZKBnkCAH6Us2TM7rjhw
         pTJPClRcfWbOjzT5ofbwQWmyfdzFmPysGriW/FuXq+vr5V0WIMxkIIZ7psTX9XGZsxQU
         SfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0r/Hz3aB3/pi6f4PZFpZnSaaYmY5eVDrheC4RHLktY0=;
        b=tfCSM9xIQ85oKrHbnjQBKiwrkr1W3lIl8Q3F1Ru7GC7YuDa0jLWpCvyapbC3UdsacI
         9g3SB6QYBFi491184/B/NBE4dlNw6/K0OLj4cGd8YppvDcKbpjEceDDmCMKK8Wt/MUYM
         99SHBMt5WK9K1UROAmE6mH+EFfQ3KjTcVsoqmNm5pBsHCPtkaqGUfdc1DAb4n1rjOObk
         w/Te8yHw1WW2OZpMXb7El5RrmkTLPIDBddv4m8O8hd21Ry8WCnXXot4bl130EMHrKAPP
         5wdUmAFVke7hqq1RUnb9egACPrX66eOzYaVq8gE3owrqB0l522nV2eMJ1PUYMepp5Jcy
         b30g==
X-Gm-Message-State: AOAM530vce6pq3tBnc33pHeWWcn71GzPc6fnXHLMOy6WSljyffUxFOFK
        t8JFlcPLjKWta2+dka72lKFxV3DJ
X-Google-Smtp-Source: ABdhPJwBce6Sb8uM1LR/1+B0DatoobuOfjxtsOJfvUXMlwF2TFDrB4WrSMk6cxI2tUh4qiDuJwwyng==
X-Received: by 2002:a17:906:9404:: with SMTP id q4mr13133406ejx.138.1590875008672;
        Sat, 30 May 2020 14:43:28 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id cq27sm9979207edb.41.2020.05.30.14.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 14:43:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH stable-4.19.y] net: phy: reschedule state machine if AN has not completed in PHY_AN state
Date:   Sun, 31 May 2020 00:43:15 +0300
Message-Id: <20200530214315.1051358-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In kernel 4.19 (and probably earlier too) there are issues surrounding
the PHY_AN state.

For example, if a PHY is in PHY_AN state and AN has not finished, then
what is supposed to happen is that the state machine gets rescheduled
until it is, or until the link_timeout reaches zero which triggers an
autoneg restart process.

But actually the rescheduling never works if the PHY uses interrupts,
because the condition under which rescheduling occurs is just if
phy_polling_mode() is true. So basically, this whole rescheduling
functionality works for AN-not-yet-complete just by mistake. Let me
explain.

Most of the time the AN process manages to finish by the time the
interrupt has triggered. One might say "that should always be the case,
otherwise the PHY wouldn't raise the interrupt, right?".
Well, some PHYs implement an .aneg_done method which allows them to tell
the state machine when the AN is really complete.
The AR8031/AR8033 driver (at803x.c) is one such example. Even when
copper autoneg completes, the driver still keeps the "aneg_done"
variable unset until in-band SGMII autoneg finishes too (there is no
interrupt for that). So we have the premises of a race condition.

In practice, what really happens depends on the log level of the serial
console. If the log level is verbose enough that kernel messages related
to the Ethernet link state are printed to the console, then this gives
in-band AN enough time to complete, which means the link will come up
and everyone will be happy. But if the console is not that verbose, the
link will sometimes come up, and sometimes will be forced down by the
.aneg_done of the PHY driver (forever, since we are not rescheduling).

The conclusion is that an extra condition needs to be explicitly added,
so that the state machine can be rescheduled properly. Otherwise PHY
devices in interrupt mode will never work properly if they have an
.aneg_done callback.

In more recent kernels, the whole PHY_AN state was removed by Heiner
Kallweit in the "[net-next,0/5] net: phy: improve and simplify phylib
state machine" series here:

https://patchwork.ozlabs.org/cover/994464/

and the problem was just masked away instead of being addressed with a
punctual patch.

Fixes: 76a423a3f8f1 ("net: phy: allow driver to implement their own aneg_done")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
I'm not sure the procedure I'm following is correct, sending this
directly to Greg. The patch doesn't apply on net.

 drivers/net/phy/phy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index cc454b8c032c..ca4fd74fd2c8 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -934,7 +934,7 @@ void phy_state_machine(struct work_struct *work)
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct phy_device *phydev =
 			container_of(dwork, struct phy_device, state_queue);
-	bool needs_aneg = false, do_suspend = false;
+	bool recheck = false, needs_aneg = false, do_suspend = false;
 	enum phy_state old_state;
 	int err = 0;
 	int old_link;
@@ -981,6 +981,8 @@ void phy_state_machine(struct work_struct *work)
 			phy_link_up(phydev);
 		} else if (0 == phydev->link_timeout--)
 			needs_aneg = true;
+		else
+			recheck = true;
 		break;
 	case PHY_NOLINK:
 		if (!phy_polling_mode(phydev))
@@ -1123,7 +1125,7 @@ void phy_state_machine(struct work_struct *work)
 	 * PHY, if PHY_IGNORE_INTERRUPT is set, then we will be moving
 	 * between states from phy_mac_interrupt()
 	 */
-	if (phy_polling_mode(phydev))
+	if (phy_polling_mode(phydev) || recheck)
 		queue_delayed_work(system_power_efficient_wq, &phydev->state_queue,
 				   PHY_STATE_TIME * HZ);
 }
-- 
2.25.1

