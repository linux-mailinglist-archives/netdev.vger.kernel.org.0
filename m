Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517CAA4481
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 14:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbfHaMqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 08:46:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33916 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfHaMqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 08:46:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id s18so9561162wrn.1
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 05:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=R49GaqFfffgy/T9+7TAQ/XDc9GIqV/Yf/OjqL08qSdE=;
        b=Ls/TM+Hv5+cbaxdxdZ9X4W9t4hzfxfk80My4HiUgschkbWRh/JSunEwyGolFoNX4dS
         BZKgJlj6056S40Led/94jDssDeovv7cx5BZQjjVv81AswtVB5WNljVOJXS6aDqVZ+Jxi
         sP70WwnUiXhGpADtqFBITN+NjBayBiQAxzbixsH/funTEA/QSQsBUvX00PsUucyuKNQn
         RtnfNVvPLWY+/ORoNmuqmyySvCgPQo5GIv8IzX5zhOIYTF4wARG1D7cSPcunQj5T3XY/
         d1OpVn0efuQg/8qQMZhLHjAPnPNE3wm6OE1QsD1WVf1o8iBo+g5VNkZ516tieFkqG0/B
         friA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=R49GaqFfffgy/T9+7TAQ/XDc9GIqV/Yf/OjqL08qSdE=;
        b=rudGidESWVvpic9uFMnQuedyiBLZs8BQohK0On0FwOqimsbLKZ6mrcjZvgyhYEe12R
         UVqENBPDUnJDuxUrF3NOrEAZJwxP1IjMQXjlwZwDZJdFRi+XIP1zC9wWBQT/rK1u2uQx
         UW4ifOJ0+nc6KZZa4niRV6mrqFbkbJPdHaSLmwT5qinLOhGwp31geybtVmlhDKMGyjjb
         809NeflszhVrgRuyWqPMBZ+dyI/IaBpFA6aER12livCLY8kXWHgUohT/nbiPS2rToynb
         gaZisna9qC5DRHupm1v1Ew52dosXu1v+jEGhKvL8/e9mf4buWj6hrmUDu8yO+WpHFKDX
         EbRQ==
X-Gm-Message-State: APjAAAXxctbXRUw8DcVTEqZx9fdWjdgB8FqM8HcELlQUNuB4zGsv+yZd
        RIRPD6gLIWnuk6hX3U+zi14=
X-Google-Smtp-Source: APXvYqzAwbpEvCppgtfFTEY85rALx+clpg25gLID2fLSufDfqrT39yvEiBHxIH39gY/qXKxrh4jGNQ==
X-Received: by 2002:a5d:42c1:: with SMTP id t1mr21163165wrr.344.1567255594080;
        Sat, 31 Aug 2019 05:46:34 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id q14sm3568901wrc.77.2019.08.31.05.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 05:46:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH] net: dsa: Fix off-by-one number of calls to devlink_port_unregister
Date:   Sat, 31 Aug 2019 15:46:19 +0300
Message-Id: <20190831124619.460-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a function such as dsa_slave_create fails, currently the following
stack trace can be seen:

[    2.038342] sja1105 spi0.1: Probed switch chip: SJA1105T
[    2.054556] sja1105 spi0.1: Reset switch and programmed static config
[    2.063837] sja1105 spi0.1: Enabled switch tagging
[    2.068706] fsl-gianfar soc:ethernet@2d90000 eth2: error -19 setting up slave phy
[    2.076371] ------------[ cut here ]------------
[    2.080973] WARNING: CPU: 1 PID: 21 at net/core/devlink.c:6184 devlink_free+0x1b4/0x1c0
[    2.088954] Modules linked in:
[    2.092005] CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.3.0-rc6-01360-g41b52e38d2b6-dirty #1746
[    2.100912] Hardware name: Freescale LS1021A
[    2.105162] Workqueue: events deferred_probe_work_func
[    2.110287] [<c03133a4>] (unwind_backtrace) from [<c030d8cc>] (show_stack+0x10/0x14)
[    2.117992] [<c030d8cc>] (show_stack) from [<c10b08d8>] (dump_stack+0xb4/0xc8)
[    2.125180] [<c10b08d8>] (dump_stack) from [<c0349d04>] (__warn+0xe0/0xf8)
[    2.132018] [<c0349d04>] (__warn) from [<c0349e34>] (warn_slowpath_null+0x40/0x48)
[    2.139549] [<c0349e34>] (warn_slowpath_null) from [<c0f19d74>] (devlink_free+0x1b4/0x1c0)
[    2.147772] [<c0f19d74>] (devlink_free) from [<c1064fc0>] (dsa_switch_teardown+0x60/0x6c)
[    2.155907] [<c1064fc0>] (dsa_switch_teardown) from [<c1065950>] (dsa_register_switch+0x8e4/0xaa8)
[    2.164821] [<c1065950>] (dsa_register_switch) from [<c0ba7fe4>] (sja1105_probe+0x21c/0x2ec)
[    2.173216] [<c0ba7fe4>] (sja1105_probe) from [<c0b35948>] (spi_drv_probe+0x80/0xa4)
[    2.180920] [<c0b35948>] (spi_drv_probe) from [<c0a4c1cc>] (really_probe+0x108/0x400)
[    2.188711] [<c0a4c1cc>] (really_probe) from [<c0a4c694>] (driver_probe_device+0x78/0x1bc)
[    2.196933] [<c0a4c694>] (driver_probe_device) from [<c0a4a3dc>] (bus_for_each_drv+0x58/0xb8)
[    2.205414] [<c0a4a3dc>] (bus_for_each_drv) from [<c0a4c024>] (__device_attach+0xd0/0x168)
[    2.213637] [<c0a4c024>] (__device_attach) from [<c0a4b1d0>] (bus_probe_device+0x84/0x8c)
[    2.221772] [<c0a4b1d0>] (bus_probe_device) from [<c0a4b72c>] (deferred_probe_work_func+0x84/0xc4)
[    2.230686] [<c0a4b72c>] (deferred_probe_work_func) from [<c03650a4>] (process_one_work+0x218/0x510)
[    2.239772] [<c03650a4>] (process_one_work) from [<c03660d8>] (worker_thread+0x2a8/0x5c0)
[    2.247908] [<c03660d8>] (worker_thread) from [<c036b348>] (kthread+0x148/0x150)
[    2.255265] [<c036b348>] (kthread) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
[    2.262444] Exception stack(0xea965fb0 to 0xea965ff8)
[    2.267466] 5fa0:                                     00000000 00000000 00000000 00000000
[    2.275598] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.283729] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    2.290333] ---[ end trace ca5d506728a0581a ]---

devlink_free is complaining right here:

	WARN_ON(!list_empty(&devlink->port_list));

This happens because devlink_port_unregister is no longer done right
away in dsa_port_setup when a DSA_PORT_TYPE_USER has failed.
Vivien said about this change that:

    Also no need to call devlink_port_unregister from within dsa_port_setup
    as this step is inconditionally handled by dsa_port_teardown on error.

which is not really true. The devlink_port_unregister function _is_
being called unconditionally from within dsa_port_setup, but not for
this port that just failed, just for the previous ones which were set
up.

ports_teardown:
	for (i = 0; i < port; i++)
		dsa_port_teardown(&ds->ports[i]);

Initially I was tempted to fix this by extending the "for" loop to also
cover the port that failed during setup. But this could have potentially
unforeseen consequences unrelated to devlink_port or even other types of
ports than user ports, which I can't really test for. For example, if
for some reason devlink_port_register itself would fail, then
unconditionally unregistering it in dsa_port_teardown would not be a
smart idea. The list might go on.

So just make dsa_port_setup undo the setup it had done upon failure, and
let the for loop undo the work of setting up the previous ports, which
are guaranteed to be brought up to a consistent state.

Fixes: 955222ca5281 ("net: dsa: use a single switch statement for port setup")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/dsa2.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f8445fa73448..b501c90aabe4 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -259,8 +259,11 @@ static int dsa_port_setup(struct dsa_port *dp)
 	const unsigned char *id = (const unsigned char *)&dst->index;
 	const unsigned char len = sizeof(dst->index);
 	struct devlink_port *dlp = &dp->devlink_port;
+	bool dsa_port_link_registered = false;
+	bool devlink_port_registered = false;
 	struct devlink *dl = ds->devlink;
-	int err;
+	bool dsa_port_enabled = false;
+	int err = 0;
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
@@ -272,15 +275,19 @@ static int dsa_port_setup(struct dsa_port *dp)
 				       dp->index, false, 0, id, len);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
-			return err;
+			break;
+		devlink_port_registered = true;
 
 		err = dsa_port_link_register_of(dp);
 		if (err)
-			return err;
+			break;
+		dsa_port_link_registered = true;
 
 		err = dsa_port_enable(dp, NULL);
 		if (err)
-			return err;
+			break;
+		dsa_port_enabled = true;
+
 		break;
 	case DSA_PORT_TYPE_DSA:
 		memset(dlp, 0, sizeof(*dlp));
@@ -288,15 +295,19 @@ static int dsa_port_setup(struct dsa_port *dp)
 				       dp->index, false, 0, id, len);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
-			return err;
+			break;
+		devlink_port_registered = true;
 
 		err = dsa_port_link_register_of(dp);
 		if (err)
-			return err;
+			break;
+		dsa_port_link_registered = true;
 
 		err = dsa_port_enable(dp, NULL);
 		if (err)
-			return err;
+			break;
+		dsa_port_enabled = true;
+
 		break;
 	case DSA_PORT_TYPE_USER:
 		memset(dlp, 0, sizeof(*dlp));
@@ -304,18 +315,26 @@ static int dsa_port_setup(struct dsa_port *dp)
 				       dp->index, false, 0, id, len);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
-			return err;
+			break;
+		devlink_port_registered = true;
 
 		dp->mac = of_get_mac_address(dp->dn);
 		err = dsa_slave_create(dp);
 		if (err)
-			return err;
+			break;
 
 		devlink_port_type_eth_set(dlp, dp->slave);
 		break;
 	}
 
-	return 0;
+	if (err && dsa_port_enabled)
+		dsa_port_disable(dp);
+	if (err && dsa_port_link_registered)
+		dsa_port_link_unregister_of(dp);
+	if (err && devlink_port_registered)
+		devlink_port_unregister(dlp);
+
+	return err;
 }
 
 static void dsa_port_teardown(struct dsa_port *dp)
-- 
2.17.1

