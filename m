Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA6371B82
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbfGWPYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:24:03 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:33506 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfGWPYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 11:24:02 -0400
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id 084998217E2; Tue, 23 Jul 2019 22:17:10 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249.iskra.kb (unknown [62.213.40.60])
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPA id 8C4808217EC;
        Tue, 23 Jul 2019 22:17:10 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>
Subject: [RFC PATCH 2/2] net: phylink: don't start and stop SGMII PHYs in SFP modules twice
Date:   Tue, 23 Jul 2019 22:17:02 +0700
Message-Id: <20190723151702.14430-3-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190723151702.14430-1-asolokha@kb.kras.ru>
References: <20190723151702.14430-1-asolokha@kb.kras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SFP modules connected using the SGMII interface have their own PHYs which
are handled by the struct phylink's phydev field. After commit ce0aa27ff3f6
("sfp: add sfp-bus to bridge between network devices and sfp cages") an
sfp-bus attached to the same phylink also gets control over a PHY in an SFP
module which is actually the same PHY managed by phylink itself. This
results in WARNs during network interface bringup and shutdown when a
copper SFP module is connected, as phy_start() and phy_stop() are called
twice in a row for the same phy_device:

  % ip link set up dev eth0
  ------------[ cut here ]------------
  called from state UP
  WARNING: CPU: 1 PID: 155 at drivers/net/phy/phy.c:895 phy_start+0x74/0xc0
  Modules linked in:
  CPU: 1 PID: 155 Comm: backend Not tainted 5.2.0+ #1
  NIP:  c0227bf0 LR: c0227bf0 CTR: c004d224
  REGS: df547720 TRAP: 0700   Not tainted  (5.2.0+)
  MSR:  00029000 <CE,EE,ME>  CR: 24002822  XER: 00000000

  GPR00: c0227bf0 df5477d8 df5d7080 00000014 df9d2370 df9d5ac4 1f4eb000 00000001
  GPR08: c061fe58 00000000 00000000 df5477d8 0000003c 100c8768 00000000 00000000
  GPR16: df486a00 c046f1c8 c046eea0 00000000 c046e904 c0239604 db68449c 00000000
  GPR24: e9083204 00000000 00000001 db684460 e9083404 00000000 db6dce00 db6dcc00
  NIP [c0227bf0] phy_start+0x74/0xc0
  LR [c0227bf0] phy_start+0x74/0xc0
  Call Trace:
  [df5477d8] [c0227bf0] phy_start+0x74/0xc0 (unreliable)
  [df5477e8] [c023cad0] startup_gfar+0x398/0x3f4
  [df547828] [c023cf08] gfar_enet_open+0x364/0x374
  [df547898] [c029d870] __dev_open+0xe4/0x140
  [df5478c8] [c029db70] __dev_change_flags+0xf0/0x188
  [df5478f8] [c029dc28] dev_change_flags+0x20/0x54
  [df547918] [c02ae304] do_setlink+0x310/0x818
  [df547a08] [c02b1eb8] __rtnl_newlink+0x384/0x6b0
  [df547c28] [c02b222c] rtnl_newlink+0x48/0x68
  [df547c48] [c02ad7c8] rtnetlink_rcv_msg+0x240/0x27c
  [df547c98] [c02cc068] netlink_rcv_skb+0x8c/0xf0
  [df547cd8] [c02cba3c] netlink_unicast+0x114/0x19c
  [df547d08] [c02cbd74] netlink_sendmsg+0x2b0/0x2c0
  [df547d58] [c027b668] sock_sendmsg_nosec+0x20/0x40
  [df547d68] [c027d080] ___sys_sendmsg+0x17c/0x1dc
  [df547e98] [c027df7c] __sys_sendmsg+0x68/0x84
  [df547ef8] [c027e430] sys_socketcall+0x1a0/0x204
  [df547f38] [c000d1d8] ret_from_syscall+0x0/0x38
  --- interrupt: c01 at 0xfd4e030
      LR = 0xfd4e010
  Instruction dump:
  813f0188 38800000 2b890005 419d0014 3d40c046 5529103a 394aa208 7c8a482e
  3c60c046 3863a1b8 4cc63182 4be009a1 <0fe00000> 48000030 3c60c046 3863a1d0
  ---[ end trace d4c095aeaf6ea998 ]---

and

  % ip link set down dev eth0
  ------------[ cut here ]------------
  called from state HALTED
  WARNING: CPU: 1 PID: 184 at drivers/net/phy/phy.c:858 phy_stop+0x3c/0x88

  <...>

  Call Trace:
  [df581788] [c0228450] phy_stop+0x3c/0x88 (unreliable)
  [df581798] [c022d548] sfp_sm_phy_detach+0x1c/0x44
  [df5817a8] [c022e8cc] sfp_sm_event+0x4b0/0x87c
  [df581848] [c022f04c] sfp_upstream_stop+0x34/0x44
  [df581858] [c0225608] phylink_stop+0x7c/0xe4
  [df581868] [c023c57c] stop_gfar+0x7c/0x94
  [df581888] [c023c5b8] gfar_close+0x24/0x94
  [df5818a8] [c0298688] __dev_close_many+0xdc/0xf8
  [df5818c8] [c029db58] __dev_change_flags+0xd8/0x188
  [df5818f8] [c029dc28] dev_change_flags+0x20/0x54
  [df581918] [c02ae304] do_setlink+0x310/0x818
  [df581a08] [c02b1eb8] __rtnl_newlink+0x384/0x6b0
  [df581c28] [c02b222c] rtnl_newlink+0x48/0x68
  [df581c48] [c02ad7c8] rtnetlink_rcv_msg+0x240/0x27c
  [df581c98] [c02cc068] netlink_rcv_skb+0x8c/0xf0
  [df581cd8] [c02cba3c] netlink_unicast+0x114/0x19c
  [df581d08] [c02cbd74] netlink_sendmsg+0x2b0/0x2c0
  [df581d58] [c027b668] sock_sendmsg_nosec+0x20/0x40
  [df581d68] [c027d080] ___sys_sendmsg+0x17c/0x1dc
  [df581e98] [c027df7c] __sys_sendmsg+0x68/0x84
  [df581ef8] [c027e430] sys_socketcall+0x1a0/0x204
  [df581f38] [c000d1d8] ret_from_syscall+0x0/0x38

  <...>

  ---[ end trace d4c095aeaf6ea999 ]---

SFP modules with the 1000Base-X interface are not affected.

So, skip explicit calls to phy_start() and phy_stop() when phylink has just
enabled or disabled an attached SFP module.

Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
---
 drivers/net/phy/phylink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5d0af041b8f9..4de7665876af 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -992,7 +992,7 @@ void phylink_start(struct phylink *pl)
 		mod_timer(&pl->link_poll, jiffies + HZ);
 	if (pl->sfp_bus)
 		sfp_upstream_start(pl->sfp_bus);
-	if (pl->phydev)
+	else if (pl->phydev)
 		phy_start(pl->phydev);
 }
 EXPORT_SYMBOL_GPL(phylink_start);
@@ -1010,10 +1010,10 @@ void phylink_stop(struct phylink *pl)
 {
 	ASSERT_RTNL();
 
-	if (pl->phydev)
-		phy_stop(pl->phydev);
 	if (pl->sfp_bus)
 		sfp_upstream_stop(pl->sfp_bus);
+	else if (pl->phydev)
+		phy_stop(pl->phydev);
 	del_timer_sync(&pl->link_poll);
 	if (pl->link_irq) {
 		free_irq(pl->link_irq, pl);
-- 
2.22.0

