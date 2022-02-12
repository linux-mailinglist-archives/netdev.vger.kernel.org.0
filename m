Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE4D4B320D
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354410AbiBLAfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:35:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245212AbiBLAfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:35:02 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 115BFD7E;
        Fri, 11 Feb 2022 16:34:59 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA104ED1;
        Fri, 11 Feb 2022 16:34:58 -0800 (PST)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B78A13F70D;
        Fri, 11 Feb 2022 16:34:58 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: [BUG/PATCH v2] net: mvpp2: always set port pcs ops
Date:   Fri, 11 Feb 2022 18:34:54 -0600
Message-Id: <20220212003454.3214726-1-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Booting a MACCHIATObin with 5.17, the system OOPs with
a null pointer deref when the network is started. This
is caused by the pcs->ops structure being null in
mcpp2_acpi_start() when it tries to call pcs_config().

Hoisting the code which sets pcs_gmac.ops and pcs_xlg.ops,
assuring they are always set, fixes the problem.

The OOPs looks like:
[   18.687760] Unable to handle kernel access to user memory outside uaccess routines at virtual address 0000000000000010
[   18.698561] Mem abort info:
[   18.698564]   ESR = 0x96000004
[   18.698567]   EC = 0x25: DABT (current EL), IL = 32 bits
[   18.709821]   SET = 0, FnV = 0
[   18.714292]   EA = 0, S1PTW = 0
[   18.718833]   FSC = 0x04: level 0 translation fault
[   18.725126] Data abort info:
[   18.729408]   ISV = 0, ISS = 0x00000004
[   18.734655]   CM = 0, WnR = 0
[   18.738933] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000111bbf000
[   18.745409] [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
[   18.752235] Internal error: Oops: 96000004 [#1] SMP
[   18.757134] Modules linked in: rfkill ip_set nf_tables nfnetlink qrtr sunrpc vfat fat omap_rng fuse zram xfs crct10dif_ce mvpp2 ghash_ce sbsa_gwdt phylink xhci_plat_hcd ahci_plam
[   18.773481] CPU: 0 PID: 681 Comm: NetworkManager Not tainted 5.17.0-0.rc3.89.fc36.aarch64 #1
[   18.781954] Hardware name: Marvell                         Armada 7k/8k Family Board      /Armada 7k/8k Family Board      , BIOS EDK II Jun  4 2019
[   18.795222] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   18.802213] pc : mvpp2_start_dev+0x2b0/0x300 [mvpp2]
[   18.807208] lr : mvpp2_start_dev+0x298/0x300 [mvpp2]
[   18.812197] sp : ffff80000b4732c0
[   18.815522] x29: ffff80000b4732c0 x28: 0000000000000000 x27: ffffccab38ae57f8
[   18.822689] x26: ffff6eeb03065a10 x25: ffff80000b473a30 x24: ffff80000b4735b8
[   18.829855] x23: 0000000000000000 x22: 00000000000001e0 x21: ffff6eeb07b6ab68
[   18.837021] x20: ffff6eeb07b6ab30 x19: ffff6eeb07b6a9c0 x18: 0000000000000014
[   18.844187] x17: 00000000f6232bfe x16: ffffccab899b1dc0 x15: 000000006a30f9fa
[   18.851353] x14: 000000003b77bd50 x13: 000006dc896f0e8e x12: 001bbbfccfd0d3a2
[   18.858519] x11: 0000000000001528 x10: 0000000000001548 x9 : ffffccab38ad0fb0
[   18.865685] x8 : ffff80000b473330 x7 : 0000000000000000 x6 : 0000000000000000
[   18.872851] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff80000b4732f8
[   18.880017] x2 : 000000000000001a x1 : 0000000000000002 x0 : ffff6eeb07b6ab68
[   18.887183] Call trace:
[   18.889637]  mvpp2_start_dev+0x2b0/0x300 [mvpp2]
[   18.894279]  mvpp2_open+0x134/0x2b4 [mvpp2]
[   18.898483]  __dev_open+0x128/0x1e4
[   18.901988]  __dev_change_flags+0x17c/0x1d0
[   18.906187]  dev_change_flags+0x30/0x70
[   18.910038]  do_setlink+0x278/0xa7c
[   18.913540]  __rtnl_newlink+0x44c/0x7d0
[   18.917391]  rtnl_newlink+0x5c/0x8c
[   18.920892]  rtnetlink_rcv_msg+0x254/0x314
[   18.925006]  netlink_rcv_skb+0x48/0x10c
[   18.928858]  rtnetlink_rcv+0x24/0x30
[   18.932449]  netlink_unicast+0x290/0x2f4
[   18.936386]  netlink_sendmsg+0x1d0/0x41c
[   18.940323]  sock_sendmsg+0x60/0x70
[   18.943825]  ____sys_sendmsg+0x248/0x260
[   18.947762]  ___sys_sendmsg+0x74/0xa0
[   18.951438]  __sys_sendmsg+0x64/0xcc
[   18.955027]  __arm64_sys_sendmsg+0x30/0x40
[   18.959140]  invoke_syscall+0x50/0x120
[   18.962906]  el0_svc_common.constprop.0+0x4c/0xf4
[   18.967629]  do_el0_svc+0x30/0x9c
[   18.970958]  el0_svc+0x28/0xb0
[   18.974025]  el0t_64_sync_handler+0x10c/0x140
[   18.978400]  el0t_64_sync+0x1a4/0x1a8
[   18.982078] Code: 52800004 b9416262 aa1503e0 52800041 (f94008a5)
[   18.988196] ---[ end trace 0000000000000000 ]---

Fixes: cff056322372 ("net: mvpp2: use .mac_select_pcs() interface")
Suggested-by: Russel King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 7cdbf8b8bbf6..1a835b48791b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6870,6 +6870,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;
 	dev->dev.of_node = port_node;
 
+	port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
+	port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
+
 	if (!mvpp2_use_acpi_compat_mode(port_fwnode)) {
 		port->phylink_config.dev = &dev->dev;
 		port->phylink_config.type = PHYLINK_NETDEV;
@@ -6940,9 +6943,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 				  port->phylink_config.supported_interfaces);
 		}
 
-		port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
-		port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
-
 		phylink = phylink_create(&port->phylink_config, port_fwnode,
 					 phy_mode, &mvpp2_phylink_ops);
 		if (IS_ERR(phylink)) {
-- 
2.34.1

