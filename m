Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A0C6DE89D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 03:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjDLBAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 21:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDLBAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 21:00:22 -0400
X-Greylist: delayed 570 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Apr 2023 18:00:20 PDT
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1BFE73;
        Tue, 11 Apr 2023 18:00:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPV6:240e:3b7:3273:10b0:7023:7419:46f0:9cf3])
        by mail-m11875.qiye.163.com (Hmail) with ESMTPA id 4D92E280392;
        Wed, 12 Apr 2023 08:50:45 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn,
        Ding Hui <dinghui@sangfor.com.cn>
Subject: [RFC PATCH net] sfc: Fix use-after-free due to selftest_work
Date:   Wed, 12 Apr 2023 08:50:13 +0800
Message-Id: <20230412005013.30456-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZSB9OVkJIQkxDT05IGU1KSVUTARMWGhIXJBQOD1
        lXWRgSC1lBWUlPSx5BSBlMQUhJTEhBSksZS0FMS0lIQUxPSkJBT00dS0FCGB1IWVdZFhoPEhUdFF
        lBWU9LSFVKSktISkNVSktLVUtZBg++
X-HM-Tid: 0a8772f18d0d2eb1kusn4d92e280392
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NCo6FDo5KT0VOCgNNhkNSSoT
        Lw4aFAhVSlVKTUNKSU1LTU9NSklIVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlJT0seQUgZTEFISUxIQUpLGUtBTEtJSEFMT0pCQU9NHUtBQhgdSFlXWQgBWUFIQkNINwY+
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a use-after-free scenario that is:

When netif_running() is false, user set mac address or vlan tag to VF,
the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
and efx_net_open(), since netif_running() is false, the port will not
start and keep port_enabled false, but selftest_worker is scheduled
in efx_net_open().

If we remove the device before selftest_worker run, the efx is freed,
then we will get a UAF in run_timer_softirq() like this:

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

I am thinking about several ways to fix the issue:

[1] In this RFC, I cancel the selftest_worker unconditionally in
efx_pci_remove().

[2] Add a test condition, only invoke efx_selftest_async_start() when
efx->port_enabled is true in efx_net_open().

[3] Move invoking efx_selftest_async_start() from efx_net_open() to
efx_start_all() or efx_start_port(), that matching cancel action in
efx_stop_port().

[4] However, I also notice that in efx_ef10_set_mac_address(), the
efx_net_open() depends on original port_enabled, but others are not,
if we change all efx_net_open() depends on old state like
efx_ef10_set_mac_address() does, the UAF can also be fixed in theory.

But I'm not sure which is better, is there any suggestions? Thanks.

Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
---
 drivers/net/ethernet/sfc/efx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 884d8d168862..dd0b2363eed1 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -876,6 +876,8 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 	efx->state = STATE_UNINIT;
 	rtnl_unlock();
 
+	efx_selftest_async_cancel(efx);
+
 	if (efx->type->sriov_fini)
 		efx->type->sriov_fini(efx);
 
-- 
2.17.1

