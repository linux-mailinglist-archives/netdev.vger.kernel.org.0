Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C7020B45A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgFZPTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFZPTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:19:33 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3741C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:19:32 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h15so9860315wrq.8
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mJoSCKC/5JMKf0aF/DukUmls+1+bj3PfFfXD4tDvSds=;
        b=prnbTcxpENGU7xRYQ5YA7MhINlbdNSh+DIOxDBP/22DltnL0pBaDbbfXvO+9L4WJsv
         0JquibHk88LwkmWV2nwtZgF7uS+eQaeskqBOoywsWbthQPr5kq2RWlIWmHrqbsr30QXp
         qeRO0SGRzGO5NFiry96wk6PxypGkgZQ+WJuLJCTfsOpYQ4t+lDwpgKQAh3DBd/V/rubk
         UnC0M/Wc+J1nlMb5lliX/GU0rbdeJCgO99bihht7kUqGZugfaLZTyAu515/HSukskaXa
         3HtZ8CDPUhEx8Z/6BfGkSt1ZMcbVM0rpRwMQQppcOHkXJ4/W0cr5vEGyuiPzdCpvHaif
         KM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mJoSCKC/5JMKf0aF/DukUmls+1+bj3PfFfXD4tDvSds=;
        b=P6OxCZaBAH9zuBy6EBxK3kz1px6Q9mWyZZAkNVQFHP20R+kiE5TyWlVbw4bfoyNkFD
         ftlLPevfrfiibUIdY0We+ENRxD8ri4qZp0ahz+f9x2rG7WncI+nB72zKlpWIPOOzG6cZ
         TSI8n1cQTH+zT/C9JVqWQN54Wb4YNh60mB6a2Gv6jfKf2TnLTzSLSlLnU43LKPt6VFkV
         sKfEylca5WY+aZ87HZIxmE3ZjvL0WBpFyGnaJXviLBO1j3kPpZS6jn+pIq27db46WDvW
         dabBjDEBjYAwKSm6DvuaknKkmhhFD6ai0bXZXOFChyPecqBmwmE0+3E6wStV7iTwOIGY
         zTHw==
X-Gm-Message-State: AOAM533Pl2rcRQkpanhdCfU2BH9fYBLEVm1BhIJ36OrK6S6jaH+8BNCq
        2ytyvev4YoyuenxGX5r8hAZMS4X+FjE=
X-Google-Smtp-Source: ABdhPJxIrA2XY3lGAfg4HZxYICGlQoy/c3nzBlWZoqpGb9GR/z3Rs8V3R2ki52Y/pZ0F/TltibaGpQ==
X-Received: by 2002:adf:fe46:: with SMTP id m6mr4128965wrs.192.1593184771380;
        Fri, 26 Jun 2020 08:19:31 -0700 (PDT)
Received: from tool.localnet ([213.177.196.114])
        by smtp.googlemail.com with ESMTPSA id 59sm182804wrj.37.2020.06.26.08.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 08:19:30 -0700 (PDT)
From:   Daniel =?ISO-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.petazzoni@bootlin.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, f.fainelli@gmail.com
Subject: [PATCH v2] net: mvneta: speed down the PHY, if WoL used, to save energy
Date:   Fri, 26 Jun 2020 17:18:19 +0200
Message-ID: <24932419.y57xhLMsBk@tool>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHYs connected to this ethernet hardware support the WoL feature.
But when WoL is enabled and the machine is powered off, the PHY remains
waiting for a magic packet at max speed (i.e. 1Gbps), which is a waste of
energy.

Slow down the PHY speed before stopping the ethernet if WoL is enabled,
and save some energy while the machine is powered off or sleeping.

Tested using an Armada 370 based board (LS421DE) equipped with a Marvell
88E1518 PHY.

Signed-off-by: Daniel Gonz=C3=A1lez Cabanelas <dgcbueu@gmail.com>
=2D--
Changes in v2:
  - Patch reworked with the new phylink_speed_(up|down) functions
    provided by Russel King. This should avoid the kernel OOPs issue when
    used with a switch or a PHY on a SFP module.

 drivers/net/ethernet/marvell/mvneta.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/m=
arvell/mvneta.c
index 197d8c6d1..37b9c75a5 100644
=2D-- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3611,6 +3611,10 @@ static void mvneta_start_dev(struct mvneta_port *pp)
 		    MVNETA_CAUSE_LINK_CHANGE);
=20
 	phylink_start(pp->phylink);
+
+	/* We may have called phy_speed_down before */
+	phylink_speed_up(pp->phylink);
+
 	netif_tx_start_all_queues(pp->dev);
=20
 	clear_bit(__MVNETA_DOWN, &pp->state);
@@ -3622,6 +3626,9 @@ static void mvneta_stop_dev(struct mvneta_port *pp)
=20
 	set_bit(__MVNETA_DOWN, &pp->state);
=20
+	if (device_may_wakeup(&pp->dev->dev))
+		phylink_speed_down(pp->phylink, false);
+
 	phylink_stop(pp->phylink);
=20
 	if (!pp->neta_armada3700) {
@@ -4090,6 +4097,10 @@ static int mvneta_mdio_probe(struct mvneta_port *pp)
 	phylink_ethtool_get_wol(pp->phylink, &wol);
 	device_set_wakeup_capable(&pp->dev->dev, !!wol.supported);
=20
+	/* PHY WoL may be enabled but device wakeup disabled */
+	if (wol.supported)
+		device_set_wakeup_enable(&pp->dev->dev, !!wol.wolopts);
+
 	return err;
 }
=20
=2D-=20
2.27.0




