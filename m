Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8A6100B46
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 19:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfKRSRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 13:17:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40043 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfKRSRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 13:17:08 -0500
Received: by mail-wr1-f68.google.com with SMTP id q15so7882065wrw.7
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 10:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Gr1BeLCtbOYspxw5al/W1YgWCGCn9bYOFjlS67l7/xs=;
        b=rLdk+lkYVyUvewrpdHIXKayTQAbjWMePPokNM9+ZOmkZ8jS4OnkiLU1dUc7kcAufM9
         bhky/59/l/oF3ulOFfEZk9P7r2IfYN5GoX7Xopls3YPGKETFY4p9HwzDkxAmzxMWt8F7
         Uk0ky81K+2q7rdYLsHTIAJ901gZVb6BwyrVA6tRa/Ts499FvV6tO1E/IrdkcqgoZObuH
         duoXItCPu/1IAWL6RRIr5MiUWsP1rlCs6vjAjNMREQegmGKhWpWA22Lnitn3M55Db9+k
         f9XSS3G0EMj9U/D92vgl1lqLOUvFeSaf0Be8Wmsgvu4z+1Xj1z0SDLF/U6U3kaIpZFXV
         4YAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Gr1BeLCtbOYspxw5al/W1YgWCGCn9bYOFjlS67l7/xs=;
        b=FapOarlGqwFDRKcn0NSmfXy3LrRFaN+LDpef9pcRxjccB0rhNe0CrekSC2HZscjLwb
         /HXp2gtHgrxZIdmeu2DNzrnR5FLtMUPzJP20pm9zUlep8WBu/yuBNFgC0vEwUWx750w5
         PfZRon/YcbZHsFOAHAitb2mNRrnHY+pftvd9X0HYARhfafhlh4pPvwRoW8bzcd88W/2Z
         7/qYfxoDZmjSgGYgLuffBDYm/xuhUwcyQX9GSUSFa7gAKvyXoXJbXB4uNJBax8bnS8QA
         l5UO5jZ4KZbTavHnNiDsqAsh2MvjriEnLhnb9HhYrWMQJrogh628U/krRU5CoRFblbJf
         49hw==
X-Gm-Message-State: APjAAAUSAusSguRypfoMQ11xYwFphjk7Fo7PeAS67l/LTZd7TZUYCT1w
        UMlPeeZpeD3sPRGWPHBbvUA=
X-Google-Smtp-Source: APXvYqwLHXjgmq6uUVHXxTrJYD2AdXsbm2ruRBTICyU1xUicwYmEtpgDjQqt3fCNEgFYR1FAYg8tLQ==
X-Received: by 2002:adf:ef0e:: with SMTP id e14mr22746040wro.204.1574101024755;
        Mon, 18 Nov 2019 10:17:04 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id b3sm212275wmh.17.2019.11.18.10.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 10:17:04 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: felix: Fix CPU port assignment when not last port
Date:   Mon, 18 Nov 2019 20:16:57 +0200
Message-Id: <20191118181657.25333-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On the NXP LS1028A, there are 2 Ethernet links between the Felix switch
and the ENETC:
- eno2 <-> swp4, at 2.5G
- eno3 <-> swp5, at 1G

Only one of the above Ethernet port pairs can act as a DSA link for
tagging.

When adding initial support for the driver, it was tested only on the 1G
eno3 <-> swp5 interface, due to the necessity of using PHYLIB initially
(which treats fixed-link interfaces as emulated C22 PHYs, so it doesn't
support fixed-link speeds higher than 1G).

After making PHYLINK work, it appears that swp4 still can't act as CPU
port. So it looks like ocelot_set_cpu_port was being called for swp4,
but then it was called again for swp5, overwriting the CPU port assigned
in the DT.

It appears that when you call dsa_upstream_port for a port that is not
defined in the device tree (such as swp5 when using swp4 as CPU port),
its dp->cpu_dp pointer is not initialized by dsa_tree_setup_default_cpu,
and this trips up the following condition in dsa_upstream_port:

	if (!cpu_dp)
		return port;

So the moral of the story is: don't call dsa_upstream_port for a port
that is not defined in the device tree, and therefore its dsa_port
structure is not completely initialized (ds->num_ports is still 6).

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d73c38c6cbcf..89d28f80b99d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -314,7 +314,7 @@ static int felix_setup(struct dsa_switch *ds)
 	for (port = 0; port < ds->num_ports; port++) {
 		ocelot_init_port(ocelot, port);
 
-		if (port == dsa_upstream_port(ds, port))
+		if (dsa_is_cpu_port(ds, port))
 			ocelot_set_cpu_port(ocelot, port,
 					    OCELOT_TAG_PREFIX_NONE,
 					    OCELOT_TAG_PREFIX_LONG);
-- 
2.17.1

