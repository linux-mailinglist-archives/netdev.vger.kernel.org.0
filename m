Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E216E26C7
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjDNPX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDNPX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:23:57 -0400
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5B3AD29;
        Fri, 14 Apr 2023 08:23:55 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPV6:240e:3b7:3271:b060:b145:6016:5b08:4ebc])
        by mail-m11875.qiye.163.com (Hmail) with ESMTPA id C120D281066;
        Fri, 14 Apr 2023 23:23:48 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn,
        Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH net v2] sfc: Fix use-after-free due to selftest_work
Date:   Fri, 14 Apr 2023 23:23:06 +0800
Message-Id: <20230414152306.18150-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSExPVh5PTU0fQx8YGkMaSFUTARMWGhIXJBQOD1
        lXWRgSC1lBWUlPSx5BSBlMQUhJTEpBGUtNS0EZSk9OQU1LSk1BThlLQ0FPHhkYWVdZFhoPEhUdFF
        lBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a87805d94042eb1kusnc120d281066
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRA6PRw6Az0cHhpPDjU3C08i
        DAMwCS1VSlVKTUNKT0NOQ0lCTkNMVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlJT0seQUgZTEFISUxKQRlLTUtBGUpPTkFNS0pNQU4ZS0NBTx4ZGFlXWQgBWUFPSEhJNwY+
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a use-after-free scenario that is:

When the NIC is down, user set mac address or vlan tag to VF,
the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
and efx_net_open(), since netif_running() is false, the port will not
start and keep port_enabled false, but selftest_work is scheduled
in efx_net_open().

If we remove the device before selftest_work run, the efx_stop_port()
will not be called since the NIC is down, and then efx is freed,
we will soon get a UAF in run_timer_softirq() like this:

[ 1178.907941] ==================================================================
[ 1178.907948] BUG: KASAN: use-after-free in run_timer_softirq+0xdea/0xe90
[ 1178.907950] Write of size 8 at addr ff11001f449cdc80 by task swapper/47/0
[ 1178.907950]
[ 1178.907953] CPU: 47 PID: 0 Comm: swapper/47 Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
[ 1178.907954] Hardware name: SANGFOR X620G40/WI2HG-208T1061A, BIOS SPYH051032-U01 04/01/2022
[ 1178.907955] Call Trace:
[ 1178.907956]  <IRQ>
[ 1178.907960]  dump_stack+0x71/0xab
[ 1178.907963]  print_address_description+0x6b/0x290
[ 1178.907965]  ? run_timer_softirq+0xdea/0xe90
[ 1178.907967]  kasan_report+0x14a/0x2b0
[ 1178.907968]  run_timer_softirq+0xdea/0xe90
[ 1178.907971]  ? init_timer_key+0x170/0x170
[ 1178.907973]  ? hrtimer_cancel+0x20/0x20
[ 1178.907976]  ? sched_clock+0x5/0x10
[ 1178.907978]  ? sched_clock_cpu+0x18/0x170
[ 1178.907981]  __do_softirq+0x1c8/0x5fa
[ 1178.907985]  irq_exit+0x213/0x240
[ 1178.907987]  smp_apic_timer_interrupt+0xd0/0x330
[ 1178.907989]  apic_timer_interrupt+0xf/0x20
[ 1178.907990]  </IRQ>
[ 1178.907991] RIP: 0010:mwait_idle+0xae/0x370

If the NIC is not actually brought up, there is no need to schedule
selftest_work, so let's move invoking efx_selftest_async_start()
into efx_start_all(), and it will be canceled by broughting down.

Fixes: dd40781e3a4e ("sfc: Run event/IRQ self-test asynchronously when interface is brought up")
Fixes: e340be923012 ("sfc: add ndo_set_vf_mac() function for EF10")
Debugged-by: Huang Cun <huangcun@sangfor.com.cn>
Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
Suggested-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
---
 drivers/net/ethernet/sfc/efx.c        | 1 -
 drivers/net/ethernet/sfc/efx_common.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 884d8d168862..1eceffa02b55 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -541,7 +541,6 @@ int efx_net_open(struct net_device *net_dev)
 	else
 		efx->state = STATE_NET_UP;
 
-	efx_selftest_async_start(efx);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index cc30524c2fe4..361687de308d 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -544,6 +544,8 @@ void efx_start_all(struct efx_nic *efx)
 	/* Start the hardware monitor if there is one */
 	efx_start_monitor(efx);
 
+	efx_selftest_async_start(efx);
+
 	/* Link state detection is normally event-driven; we have
 	 * to poll now because we could have missed a change
 	 */
-- 
2.17.1

