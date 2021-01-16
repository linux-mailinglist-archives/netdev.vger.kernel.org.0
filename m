Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9332F8A29
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbhAPBBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbhAPBBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:46 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC691C061798
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:40 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id u19so11544832edx.2
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7XIru9YSoOQaS1swKibuoVI0XxqPGJLS/vhoFQlVy90=;
        b=koqnNFsLm3jQd2ZVwKu886UTvHEKqODcIi84dm3QUTBpvD9ZzmK7CtZ/S/Km/E3quK
         wAX0Kr9CCMwMD3Aa76KnYevdA5cn3Py9QSLHZ7FOaCXUuB9e0HhSJU2jtVqc3Sd8OfO7
         eiAxBt9zIUCJx/J0/qqI2iX1Q0q/4JAnrcJnWdhjoH9ZNS8rfDLGdNrgWkM+5whHvIan
         949esH6RbdRSd9dW2aJrVw+Df000DiMCFJ+P9o3ebBXqX9M6KxCQIol76VlVpvA64j5v
         ERHc1zJMdhstWmZH7VYX1mEnJbLZE9OP4mJ9nfSzTk69b6mJGz6FHHp8E9wf220yxZX3
         Ws7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7XIru9YSoOQaS1swKibuoVI0XxqPGJLS/vhoFQlVy90=;
        b=od/HQpesNTH+CgEk2yUTaSKXU/mDvNhJR8J5CWrF2eiC8tlPjICNQyCFqM45PtpMJz
         dnkIpMJu6GKAX+s69T5hYitL3eqKtEMk8bIsHZMDKk67PiDEQGWSkDznE9QJPmqlWSvg
         15gdg4Pj7A02xSIwl39mR2NQp2nbL0R9rdpGDt5GMbrXNj5R0+CwDtnNgovPpfltlWoz
         39yi/ZdWUdfi+NkzSPE2yK6QGUunrB4dXHeMPFZmcHoQpRCWChYMX9G9bVKYjuZYUfGI
         pr42gETw7ncd1wErHA65fLrVQ3hW/cFDBq8RVTrX0Fq3PDBciSoiuOhFA6mqoHOAdzLO
         ikeQ==
X-Gm-Message-State: AOAM532DtEtsygDQnQChZX7rFibAHHobbGXmgRWuX9w0v1il0eP36XXP
        ulToV8AWRsEdZL2QXhcWhDI=
X-Google-Smtp-Source: ABdhPJyv28e6JcvffFNPKDe0M9E6DFHCKv1NbxAuzQ6DQfrjPCcCbNk0RpJdqK10He7cjaANEfG3ng==
X-Received: by 2002:a05:6402:1ad1:: with SMTP id ba17mr11502112edb.51.1610758839611;
        Fri, 15 Jan 2021 17:00:39 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 net-next 05/14] net: mscc: ocelot: use ipv6 in the aggregation code
Date:   Sat, 16 Jan 2021 02:59:34 +0200
Message-Id: <20210116005943.219479-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
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
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d3a92c46f610..2b542f286739 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1548,7 +1548,10 @@ int ocelot_init(struct ocelot *ocelot)
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

