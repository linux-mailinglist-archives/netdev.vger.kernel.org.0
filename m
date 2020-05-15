Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E37A1D4401
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 05:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgEODT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 23:19:56 -0400
Received: from mail5.windriver.com ([192.103.53.11]:44664 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgEODTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 23:19:55 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id 04F3IDxZ026037
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Thu, 14 May 2020 20:18:34 -0700
Received: from pek-lpggp4.wrs.com (128.224.153.77) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server id 14.3.487.0; Thu, 14 May 2020
 20:18:15 -0700
From:   Xulin Sun <xulin.sun@windriver.com>
To:     <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xulinsun@gmail.com>, <xulin.sun@windriver.com>
Subject: [PATCH] net: mscc: ocelot: replace readx_poll_timeout with readx_poll_timeout_atomic
Date:   Fri, 15 May 2020 11:18:13 +0800
Message-ID: <20200515031813.30283-1-xulin.sun@windriver.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes call trace like below to use atomic safe API:

BUG: sleeping function called from invalid context at drivers/net/ethernet/mscc/ocelot.c:59
in_atomic(): 1, irqs_disabled(): 0, pid: 3778, name: ifconfig
INFO: lockdep is turned off.
Preemption disabled at:
[<ffff2b163c83b78c>] dev_set_rx_mode+0x24/0x40
Hardware name: LS1028A RDB Board (DT)
Call trace:
dump_backtrace+0x0/0x140
show_stack+0x24/0x30
dump_stack+0xc4/0x10c
___might_sleep+0x194/0x230
__might_sleep+0x58/0x90
ocelot_mact_forget+0x74/0xf8
ocelot_mc_unsync+0x2c/0x38
__hw_addr_sync_dev+0x6c/0x130
ocelot_set_rx_mode+0x8c/0xa0
__dev_set_rx_mode+0x58/0xa0
dev_set_rx_mode+0x2c/0x40
__dev_open+0x120/0x190
__dev_change_flags+0x168/0x1c0
dev_change_flags+0x3c/0x78
devinet_ioctl+0x6c4/0x7c8
inet_ioctl+0x2b8/0x2f8
sock_do_ioctl+0x54/0x260
sock_ioctl+0x21c/0x4d0
do_vfs_ioctl+0x6d4/0x968
ksys_ioctl+0x84/0xb8
__arm64_sys_ioctl+0x28/0x38
el0_svc_common.constprop.0+0x78/0x190
el0_svc_handler+0x70/0x90
el0_svc+0x8/0xc

Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b4731df186f4..6c82ab1b3fa6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -56,7 +56,7 @@ static inline int ocelot_mact_wait_for_completion(struct ocelot *ocelot)
 {
 	u32 val;
 
-	return readx_poll_timeout(ocelot_mact_read_macaccess,
+	return readx_poll_timeout_atomic(ocelot_mact_read_macaccess,
 		ocelot, val,
 		(val & ANA_TABLES_MACACCESS_MAC_TABLE_CMD_M) ==
 		MACACCESS_CMD_IDLE,
-- 
2.17.1

