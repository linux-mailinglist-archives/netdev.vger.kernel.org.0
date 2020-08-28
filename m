Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BE2255E17
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 17:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgH1PpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 11:45:13 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:61697 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgH1Po6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 11:44:58 -0400
Received: from localhost (mehrangarh.blr.asicdesigners.com [10.193.185.169])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 07SFinbW029722;
        Fri, 28 Aug 2020 08:44:50 -0700
From:   Potnuri Bharat Teja <bharat@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com, bharat@chelsio.com
Subject: [PATCH net] cxgb4: fix thermal zone device registration
Date:   Fri, 28 Aug 2020 21:14:40 +0530
Message-Id: <20200828154440.14231-1-bharat@chelsio.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When multiple adapters are present in the system, pci hot-removing second
adapter leads to the following warning as both the adapters registered
thermal zone device with same thermal zone name/type.
Therefore, use unique thermal zone name during thermal zone device
initialization. Also mark thermal zone dev NULL once unregistered.

[  414.370143] ------------[ cut here ]------------
[  414.370944] sysfs group 'power' not found for kobject 'hwmon0'
[  414.371747] WARNING: CPU: 9 PID: 2661 at fs/sysfs/group.c:281
 sysfs_remove_group+0x76/0x80
[  414.382550] CPU: 9 PID: 2661 Comm: bash Not tainted 5.8.0-rc6+ #33
[  414.383593] Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.0a 06/23/2016
[  414.384669] RIP: 0010:sysfs_remove_group+0x76/0x80
[  414.385738] Code: 48 89 df 5b 5d 41 5c e9 d8 b5 ff ff 48 89 df e8 60 b0 ff ff
 eb cb 49 8b 14 24 48 8b 75 00 48 c7 c7 90 ae 13 bb e8 6a 27 d0 ff <0f> 0b 5b 5d
 41 5c c3 0f 1f 00 0f 1f 44 00 00 48 85 f6 74 31 41 54
[  414.388404] RSP: 0018:ffffa22bc080fcb0 EFLAGS: 00010286
[  414.389638] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  414.390829] RDX: 0000000000000001 RSI: ffff8ee2de3e9510 RDI: ffff8ee2de3e9510
[  414.392064] RBP: ffffffffbaef2ee0 R08: 0000000000000000 R09: 0000000000000000
[  414.393224] R10: 0000000000000000 R11: 000000002b30006c R12: ffff8ee260720008
[  414.394388] R13: ffff8ee25e0a40e8 R14: ffffa22bc080ff08 R15: ffff8ee2c3be5020
[  414.395661] FS:  00007fd2a7171740(0000) GS:ffff8ee2de200000(0000)
 knlGS:0000000000000000
[  414.396825] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  414.398011] CR2: 00007f178ffe5020 CR3: 000000084c5cc003 CR4: 00000000003606e0
[  414.399172] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  414.400352] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  414.401473] Call Trace:
[  414.402685]  device_del+0x89/0x400
[  414.403819]  device_unregister+0x16/0x60
[  414.405024]  hwmon_device_unregister+0x44/0xa0
[  414.406112]  thermal_remove_hwmon_sysfs+0x196/0x200
[  414.407256]  thermal_zone_device_unregister+0x1b5/0x1f0
[  414.408415]  cxgb4_thermal_remove+0x3c/0x4f [cxgb4]
[  414.409668]  remove_one+0x212/0x290 [cxgb4]
[  414.410875]  pci_device_remove+0x36/0xb0
[  414.412004]  device_release_driver_internal+0xe2/0x1c0
[  414.413276]  pci_stop_bus_device+0x64/0x90
[  414.414433]  pci_stop_and_remove_bus_device_locked+0x16/0x30
[  414.415609]  remove_store+0x75/0x90
[  414.416790]  kernfs_fop_write+0x114/0x1b0
[  414.417930]  vfs_write+0xcf/0x210
[  414.419059]  ksys_write+0xa7/0xe0
[  414.420120]  do_syscall_64+0x4c/0xa0
[  414.421278]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  414.422335] RIP: 0033:0x7fd2a686afd0
[  414.423396] Code: Bad RIP value.
[  414.424549] RSP: 002b:00007fffc1446148 EFLAGS: 00000246 ORIG_RAX:
 0000000000000001
[  414.425638] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fd2a686afd0
[  414.426830] RDX: 0000000000000002 RSI: 00007fd2a7196000 RDI: 0000000000000001
[  414.427927] RBP: 00007fd2a7196000 R08: 000000000000000a R09: 00007fd2a7171740
[  414.428923] R10: 00007fd2a7171740 R11: 0000000000000246 R12: 00007fd2a6b43400
[  414.430082] R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
[  414.431027] irq event stamp: 76300
[  414.435678] ---[ end trace 13865acb4d5ab00f ]---

Fixes: b18719157762 ("cxgb4: Add thermal zone support")
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
index 3de8a5e83b6c..d7fefdbf3e57 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
@@ -62,6 +62,7 @@ static struct thermal_zone_device_ops cxgb4_thermal_ops = {
 int cxgb4_thermal_init(struct adapter *adap)
 {
 	struct ch_thermal *ch_thermal = &adap->ch_thermal;
+	char ch_tz_name[THERMAL_NAME_LENGTH];
 	int num_trip = CXGB4_NUM_TRIPS;
 	u32 param, val;
 	int ret;
@@ -82,7 +83,8 @@ int cxgb4_thermal_init(struct adapter *adap)
 		ch_thermal->trip_type = THERMAL_TRIP_CRITICAL;
 	}
 
-	ch_thermal->tzdev = thermal_zone_device_register("cxgb4", num_trip,
+	snprintf(ch_tz_name, sizeof(ch_tz_name), "cxgb4_%s", adap->name);
+	ch_thermal->tzdev = thermal_zone_device_register(ch_tz_name, num_trip,
 							 0, adap,
 							 &cxgb4_thermal_ops,
 							 NULL, 0, 0);
@@ -97,7 +99,9 @@ int cxgb4_thermal_init(struct adapter *adap)
 
 int cxgb4_thermal_remove(struct adapter *adap)
 {
-	if (adap->ch_thermal.tzdev)
+	if (adap->ch_thermal.tzdev) {
 		thermal_zone_device_unregister(adap->ch_thermal.tzdev);
+		adap->ch_thermal.tzdev = NULL;
+	}
 	return 0;
 }
-- 
2.24.0

