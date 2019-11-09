Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9FBF5F46
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfKINDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:34 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41809 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfKINDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:31 -0500
Received: by mail-wr1-f66.google.com with SMTP id p4so9917988wrm.8
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7HxLSRkakGUkkAU1gXE6jl3MxJjgpRnG4RCmbCLhCqo=;
        b=nhP7XLx1JbWPPHs8BJ6xwLzZJjK9cC6V8vhr5OyIar9DTNIAF8W+3Zp2UCHMKZQfpJ
         xbR1bqkyxVLC3o5e94PEr1WREodXdt8kHVcLoMF5Zmy4Jy80wL5h+jFozoUsy55aRky5
         Gk9xzXa4mZdwmbA4acmIxpqqxeH8dxCCXfl2s7UhmQ2AFsvu/Y8hm/fEId/UA2gDiJYj
         7YLss7x6r7FCjm2jPud7e08q9IxxZ0kuv1t+5E1GA6RhxSG6nR6fGLsU4vg6Wxq3fCKA
         mYEGAD3m0JllLSMVEu/o5TeNz2lhek+zGaB3PuNRdJdzvJq8Aq6cqDUTHNU1hwJCgHr6
         gKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7HxLSRkakGUkkAU1gXE6jl3MxJjgpRnG4RCmbCLhCqo=;
        b=HEmJGB9xY39bFy+pPb+v8siee5RoBPxgFloxMTdXs5BZ5o+NSa3tOyYYFG0ExdSh9D
         W84tm1BGzU/oUsQMVChFl4nWTkiRo544OGbMt0nh4Tu5ayWCl0sLvEcT/bdSFAmiWHcH
         ygxAfNID02a2M63kInZp6tn3mZYAflUclmeLwy6LPYZxP3kmHYRxlPfsbr5TcGqqYNEE
         44aNHvXuhPQmbYSMqfK4/l7d+SknF9V9N0wq2B1GrGGoa1P/PWJw7SOe9mqjnVg6hewV
         05rVQC9HkVR3e+maZjQ6MzdDHPnV6KkrEjW/BPa+uf94wd0BJ/Y+CHF/BMipE/xkfiYY
         a92w==
X-Gm-Message-State: APjAAAUeAqFZLjfolDeb1SnXN3gI76Hf0KzWsuoxynVzErCgY9qGs37W
        VEBzSuvxTjKSjVDG+f5tHbI=
X-Google-Smtp-Source: APXvYqw3CzB6x8VqAnbe44UvSOvFjWpgFKTtxBEpHV+8kEYrIWfDOT3h0dxao/o/xe6zK6dsOIadZA==
X-Received: by 2002:adf:f303:: with SMTP id i3mr3254wro.157.1573304610014;
        Sat, 09 Nov 2019 05:03:30 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:29 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 09/15] net: mscc: ocelot: limit vlan ingress filtering to actual number of ports
Date:   Sat,  9 Nov 2019 15:02:55 +0200
Message-Id: <20191109130301.13716-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The VSC7514 switch (Ocelot) is a 10-port device, while VSC9959 (Felix)
is 6-port. Therefore the VLAN filtering mask would be out of bounds when
calling for this new switch. Fix that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 58ead0652bce..107a07cfaec9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -389,7 +389,8 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	/* Set vlan ingress filter mask to all ports but the CPU port by
 	 * default.
 	 */
-	ocelot_write(ocelot, GENMASK(9, 0), ANA_VLANMASK);
+	ocelot_write(ocelot, GENMASK(ocelot->num_phys_ports - 1, 0),
+		     ANA_VLANMASK);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		ocelot_write_gix(ocelot, 0, REW_PORT_VLAN_CFG, port);
-- 
2.17.1

