Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828201D6E3F
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 02:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgERAXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 20:23:37 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48004 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgERAXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 20:23:37 -0400
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 168F1283BD; Sun, 17 May 2020 20:23:35 -0400 (EDT)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     "Paul Mackerras" <paulus@samba.org>, "Jeremy Kerr" <jk@ozlabs.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <769e9041942802d0e9ff272c12ee359a04b84a90.1589761211.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] net: bmac: Fix stack corruption panic in bmac_probe()
Date:   Mon, 18 May 2020 10:20:11 +1000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes an old bug recently revealed by CONFIG_STACKPROTECTOR.

[   25.707616] scsi host0: MESH
[   28.488852] eth0: BMAC at 00:05:02:07:5a:a6
[   28.488859]
[   28.505397] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: bmac_probe+0x540/0x618
[   28.535152] CPU: 0 PID: 1 Comm: swapper Not tainted 5.6.13 #1
[   28.552399] Call Trace:
[   28.559754] [e101dc88] [c0031fe4] panic+0x138/0x314 (unreliable)
[   28.577764] [e101dce8] [c0031c2c] print_tainted+0x0/0xcc
[   28.593711] [e101dcf8] [c03a6bf8] bmac_probe+0x540/0x618
[   28.609667] [e101dd38] [c035e8a8] macio_device_probe+0x60/0x114
[   28.627457] [e101dd58] [c033ec1c] really_probe+0x100/0x3a0
[   28.643908] [e101dd88] [c033f098] driver_probe_device+0x68/0x410
[   28.661948] [e101dda8] [c033f708] device_driver_attach+0xb4/0xe4
[   28.679986] [e101ddc8] [c033f7a0] __driver_attach+0x68/0x10c
[   28.696978] [e101dde8] [c033c8c0] bus_for_each_dev+0x88/0xf0
[   28.713973] [e101de18] [c033ded8] bus_add_driver+0x1c0/0x228
[   28.730966] [e101de48] [c033ff48] driver_register+0x88/0x15c
[   28.747966] [e101de68] [c00044a0] do_one_initcall+0x7c/0x218
[   28.764976] [e101ded8] [c0640480] kernel_init_freeable+0x168/0x230
[   28.783512] [e101df18] [c000486c] kernel_init+0x14/0x104
[   28.799473] [e101df38] [c0012234] ret_from_kernel_thread+0x14/0x1c
[   28.818031] Rebooting in 180 seconds..

The bmac_probe() stack frame was apparently corrupted by an array bounds
overrun in bmac_get_station_address().

This patch is the simplest way to resolve the issue given possible
side effects (?) from hardware accesses in bmac_get_station_address().

Cc: Paul Mackerras <paulus@samba.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Fixes: 1a2509c946bf ("[POWERPC] netdevices: Constify & voidify get_property()")
Reported-and-tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
This choice of 'Fixes' tag is (of course) debatable. Other possible
choices might be 1da177e4c3f4 ("Linux-2.6.12-rc2"),
c3ff2a5193fa ("powerpc/32: add stack protector support") and so on.
---
 drivers/net/ethernet/apple/bmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index a58185b1d8bf..4d9deed3409c 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1239,7 +1239,7 @@ static int bmac_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	int j, rev, ret;
 	struct bmac_data *bp;
 	const unsigned char *prop_addr;
-	unsigned char addr[6];
+	unsigned char addr[12];
 	struct net_device *dev;
 	int is_bmac_plus = ((int)match->data) != 0;
 
-- 
2.26.2

