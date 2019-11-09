Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6B4F5F49
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfKINDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:39 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34688 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfKINDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:37 -0500
Received: by mail-wr1-f68.google.com with SMTP id e6so10002544wrw.1
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+chtXMPTaXjrLtc6l73tKM8fwSvHKyZ8xGogErp4LSw=;
        b=LCreOn1aWHrOrnIRrL4Eop15v+iWiwwd5dGclwCqQyOLHcH8FNGxq3sC0lbRrjAR+5
         ncTx0mnvgnsBS4k/QYrsy3aQrw1SnFkim5LVK2dFwVDCrQsR+XHbrbsaVyGX8qxUmUJF
         uMxowvpCG1CRBCNH1wmGYgGBONBVfhwtVy4lFGtYBsSGNcSszlRySjiHMIcF6QYBrYXq
         Q9n++kEDl2Sr+FfG/os0Hxmb/uD65X8GwiCfCL6gc6gRV+x0IvvC4Tdgnbzjg0yhyGuC
         i8p+E4C79FFYi9mgEyM1ihWE3aCcVHB/QRy2V/MfdbCaEf/X4rlELmwmiIsOhr89ucGo
         GSMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+chtXMPTaXjrLtc6l73tKM8fwSvHKyZ8xGogErp4LSw=;
        b=GMj+SN3udQnWqsuzsUuT4XLf7lNW4S1sne68iO8Ng5dgthOeRux3w8quqsl2aOOUNz
         6/mEtP1eFVOVOlUNbbLXIVSnZoY3PHipvH6BKv2YBw1EiNjtN06MucfSIBj+YrMtJzQl
         ejDivzb3SrkTwN3Q1A0gvyTdFD20sdObRHuNrJg1LhXmY8eY6LYkJ4041vQwr/UTk9lK
         VvWSsULmDADfLGaIl2jh3AX7MXvouh890R/vxeobJ2ytocgzXMWOAdz4knl5Svt4yfyn
         U5SY8xSKwb1rlsBFfJVTzMTU/11Gr5JT+G5thA5cVyBOOjI/65KWGjdMxEv0rb0AXB4R
         h49A==
X-Gm-Message-State: APjAAAUfeeqb6oabwnyYFLmrvZujItCEiGonK24BgmdXf8j/2QsVUmqP
        87iSesLoW6A+JTSPLGs+wqk=
X-Google-Smtp-Source: APXvYqyoYbv0aqIRWjsId1Jmtd63B1pnHoMJcgkEh3WK6LKGE8Orh3avfhHUsabbcgRcRv2K+UoLeQ==
X-Received: by 2002:adf:ec4b:: with SMTP id w11mr12535652wrn.243.1573304615411;
        Sat, 09 Nov 2019 05:03:35 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:34 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 12/15] net: mscc: ocelot: initialize list of multicast addresses in common code
Date:   Sat,  9 Nov 2019 15:02:58 +0200
Message-Id: <20191109130301.13716-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

This is just common path code that belongs to ocelot_init,
it has nothing to do with a specific SoC/board instance.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c       | 1 +
 drivers/net/ethernet/mscc/ocelot_board.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index df8796f05ff9..4cb78e14f2fd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2243,6 +2243,7 @@ int ocelot_init(struct ocelot *ocelot)
 	if (!ocelot->stats_queue)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&ocelot->multicast);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
 	ocelot_ace_init(ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 4793d275d845..9985fb334aac 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -364,7 +364,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
 				     sizeof(struct ocelot_port *), GFP_KERNEL);
 
-	INIT_LIST_HEAD(&ocelot->multicast);
 	ocelot_init(ocelot);
 
 	for_each_available_child_of_node(ports, portnp) {
-- 
2.17.1

