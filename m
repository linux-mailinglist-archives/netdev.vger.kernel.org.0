Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A569C3119FB
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhBFD0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhBFCbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:31:32 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8642FC061222
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:17 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id p20so14443390ejb.6
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q4n4FGiLY5qYF4qlcv5Fy3UvQcNQkdKb8FPZmbU0xEw=;
        b=AQDktQuEuUFrzVhSCwa/k3BJsOCKcsx1w/OWCQsIX9TPo8KMKn04nypL5Qeavs6XPK
         fEC4xNpEAtuyyegJB1HC2MnpTIWJzSTk+7tCB2ZDIIcFY02yB1t+NAZI2OkSeJacDKRx
         esUjIwm+98wyouQDFlSYitk7h2vjSIAOWV9pAKoTkueCNWI1m+Q8FLJYftywyPfC1BB3
         MEnZUPbo9rdFnN0caFOeUqLHJsALPCqGFnRYDNt/T5nZ5Ox6Vz6pqUhmynAM1uriqyS+
         FNb29Q7PSgkCgouKgKYHQrowkMAbE68QcaY5ti5M3uAuEEQ/p37hr/hmfc1sRs1icB9h
         wp2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q4n4FGiLY5qYF4qlcv5Fy3UvQcNQkdKb8FPZmbU0xEw=;
        b=RxRVzBg2V7g9HFi+SBzRwZQeIDcKOKH0+3UZ0Vkzc6Q+rBfRSG3BSr6Woj1O0Wu6aD
         N8xpPxS3rPihjlLT8vtsEFHuYQXjkaekfy92HY9IK8cmgqsz94kzM6VyydbIwG3tbR+r
         t7NZnx6k8PayQ7tpjcMKhzTzTvhXazdKfkavn+QMtvG9yIa6ek1JwTcGv2u+EvnR0SRf
         yPeCEtUeEfrlRvrPOysHbSGlEaVxw+eym3hLZtxBeDafsldXxY09N++4aNWRddQncePt
         ZXArNs63+TiXTqQX8+wGKO12T/7c3PNHhrLOygeRun2jnkBeTgJGewlow89vMnkiT2LK
         1ZFw==
X-Gm-Message-State: AOAM533ISJuXy/IkMx4B68i5hIGDibi/B6wv9ZPOVBNGcW3cs/y2LgvX
        f84y0Wo0a7L3K369XhEqT6o=
X-Google-Smtp-Source: ABdhPJwoqhRPCSgNF6mgW/xzBAvRrTh/pg187PTu+4Jgo0PlIWIqois2I0Z+FnVEe7y3n6RenDwOkA==
X-Received: by 2002:a17:906:d922:: with SMTP id rn2mr6233726ejb.414.1612562595395;
        Fri, 05 Feb 2021 14:03:15 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:14 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 04/12] net: mscc: ocelot: use ipv6 in the aggregation code
Date:   Sat,  6 Feb 2021 00:02:13 +0200
Message-Id: <20210205220221.255646-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

IPv6 header information is not currently part of the entropy source for
the 4-bit aggregation code used for LAG offload, even though it could be.
The hardware reference manual says about these fields:

ANA::AGGR_CFG.AC_IP6_TCPUDP_PORT_ENA
Use IPv6 TCP/UDP port when calculating aggregation code. Configure
identically for all ports. Recommended value is 1.

ANA::AGGR_CFG.AC_IP6_FLOW_LBL_ENA
Use IPv6 flow label when calculating AC. Configure identically for all
ports. Recommended value is 1.

Integration with the xmit_hash_policy of the bonding interface is TBD.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 33274d4fc5af..ef3f10f1e54f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1615,7 +1615,10 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_write(ocelot, ANA_AGGR_CFG_AC_SMAC_ENA |
 			     ANA_AGGR_CFG_AC_DMAC_ENA |
 			     ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA |
-			     ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA, ANA_AGGR_CFG);
+			     ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA |
+			     ANA_AGGR_CFG_AC_IP6_FLOW_LBL_ENA |
+			     ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA,
+			     ANA_AGGR_CFG);
 
 	/* Set MAC age time to default value. The entry is aged after
 	 * 2*AGE_PERIOD
-- 
2.25.1

