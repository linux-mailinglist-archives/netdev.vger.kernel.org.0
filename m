Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB3B1B118E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgDTQ2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729562AbgDTQ14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:27:56 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45A6C061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:27:55 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z6so224477wml.2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VHdsdAesxb897xNk78shOA6FsoU13ElE8ZB5Lp98kWY=;
        b=m4wivmyT7DmkQWTH7q5hrgxDzraOIY7E0Ho7JlXDE13FlFqoEG6NIYYWRfRxrADeSp
         KBZX9J851yXkMx7SMYZ2ufcq1sKCcako/5O3vuWsiRr5vf6uYi13P/9E1bcMFC5YGcp5
         q1pSIfacU19NcozOG00YoMMCHvdC0dYx81lWJp0XngCgI4yAeuzhS//VzgrLVJ7epAGv
         8vNGBJwEDnwdXFdxD4wouczIV2xEipfE3Q+zXNzJBoxnrs0GUbg1eapROL+l8Xrhe44C
         GxxP8wRL3PgbBMc+3II36aHn22llRTBusFSrfrQJVZVmn6str6l+WfDYdv2Bk1qUtL0Q
         k0ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VHdsdAesxb897xNk78shOA6FsoU13ElE8ZB5Lp98kWY=;
        b=jjJRib556ufK5GhV2QmS109e5gZDOAS7Cg1yHlzJdOImxdrgOvSSmmtFqt8EbrV0KN
         RZ8unwGiOvG2DYsT38x4eePN0nQl1a3uHKf8zduNqt6X6tspyRUHFmFR/mCG11R4k6Og
         2+i5XM2ZOFdplDtKNBT6MOzpdcrbN+D995N80WY6o5ZMtgNWFNwFG4r1L1Fovigcc5Y2
         D988MyWI+deWT1Dt9mEFeLX2elLMSPB0D0cZCOYrbukdsWtU+zMf/jqtZIvbTRV4/Src
         yRi0BBtudC9lXE8CEZb8u2D+2fN4uJ/PF57QLE9zpupQ0gK7Xjfck0inVraefmDkgW2C
         WTvA==
X-Gm-Message-State: AGi0PuZJtX3bZbVlEmjpUlWqNTKZ7T5yWZwX8fOWzNoKNaVnjPB+qtJu
        yZDTjjvMTgG0tkPsv+FXk3o=
X-Google-Smtp-Source: APiQypLxbyru6QpjP8D45VkPK3cDQGjbku+8+DbylbT8a13x1A3lOzQb4b6QHAyim+IbCWH0R2PdgQ==
X-Received: by 2002:a05:600c:2314:: with SMTP id 20mr137203wmo.35.1587400074451;
        Mon, 20 Apr 2020 09:27:54 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id 185sm146245wmc.32.2020.04.20.09.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:27:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@idosch.org, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        kuba@kernel.org
Subject: [PATCH net-next 3/3] net: mscc: ocelot: lift protocol restriction for flow_match_eth_addrs keys
Date:   Mon, 20 Apr 2020 19:27:43 +0300
Message-Id: <20200420162743.15847-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420162743.15847-1-olteanv@gmail.com>
References: <20200420162743.15847-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

An attempt was made in commit fe3490e6107e ("net: mscc: ocelot: Hardware
ofload for tc flower filter") to avoid clashes between MAC_ETYPE rules
and IP rules. Because the protocol blacklist should have included
ETH_P_ALL too, it created some confusion, but now the situation should
be dealt with a bit better by the patch immediately previous to this one
("net: mscc: ocelot: refine the ocelot_ace_is_problematic_mac_etype
function").

So now we can remove that check. MAC_ETYPE rules with a protocol of
ETH_P_IP, ETH_P_IPV6, ETH_P_ARP and ETH_P_ALL _are_ supported, with some
restrictions regarding per-port exclusivity which are enforced now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 67f0f5455ff0..5ce172e22b43 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -87,11 +87,6 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 		     BIT(FLOW_DISSECTOR_KEY_CONTROL)))
 			return -EOPNOTSUPP;
 
-		if (proto == ETH_P_IP ||
-		    proto == ETH_P_IPV6 ||
-		    proto == ETH_P_ARP)
-			return -EOPNOTSUPP;
-
 		flow_rule_match_eth_addrs(rule, &match);
 		ace->type = OCELOT_ACE_TYPE_ETYPE;
 		ether_addr_copy(ace->frame.etype.dmac.value,
-- 
2.17.1

