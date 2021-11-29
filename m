Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B1C462073
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350318AbhK2TbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243298AbhK2T3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:29:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F71AC0619E6
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 07:45:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B7C061536
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 15:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C003CC53FCB;
        Mon, 29 Nov 2021 15:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638200724;
        bh=JAVRsWBl/8H4mLOxaWCkobg96klL0MG+50z2oZBz0ps=;
        h=From:To:Cc:Subject:Date:From;
        b=D1u3f1g8waBQn7l+Oxj4jS6t1LGPrvug+0nPqtkpMroI2xM/DYG7xDeEkuXoQMEoy
         e5dlapMpNaqtxF9q3JKcpZoOjHnUnWsO+watsYmTFZqN27TbZntWvdT0YSTthMuIaF
         8bm2JpzDLgc5JVwrxna7H9nLyXenP0PwKjieLetUIdAfzc1eJLUngzVnxZF6qjZwi+
         LtQKoeD/6u0GD/jB6VH/sEjzkspQ02z0Kvdj0Md7Y1DzhLytmvfbB+JjnBqeSgQU40
         qZFYk6MJ/PCvoKocTSelYM9YQQIlAchGVid4rBIAPV/Vcu1dJ5fTZP4dkhpHKaSDae
         7T8b1TSIfy+Cw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net] net-sysfs: update the queue counts in the unregistration path
Date:   Mon, 29 Nov 2021 16:45:20 +0100
Message-Id: <20211129154520.295823-1-atenart@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When updating Rx and Tx queue kobjects, the queue count should always be
updated to match the queue kobjects count. This was not done in the net
device unregistration path and due to the Tx queue logic allowing
updates when unregistering (for qdisc cleanup) it was possible with
ethtool to manually add new queues after unregister, leading to NULL
pointer exceptions and UaFs, such as:

  BUG: KASAN: use-after-free in kobject_get+0x14/0x90
  Read of size 1 at addr ffff88801961248c by task ethtool/755

  CPU: 0 PID: 755 Comm: ethtool Not tainted 5.15.0-rc6+ #778
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/014
  Call Trace:
   dump_stack_lvl+0x57/0x72
   print_address_description.constprop.0+0x1f/0x140
   kasan_report.cold+0x7f/0x11b
   kobject_get+0x14/0x90
   kobject_add_internal+0x3d1/0x450
   kobject_init_and_add+0xba/0xf0
   netdev_queue_update_kobjects+0xcf/0x200
   netif_set_real_num_tx_queues+0xb4/0x310
   veth_set_channels+0x1c3/0x550
   ethnl_set_channels+0x524/0x610

Updating the queue counts in the unregistration path solve the above
issue, as the ethtool path updating the queue counts makes sanity checks
and a queue count of 0 should prevent any update.

Fixes: 5c56580b74e5 ("net: Adjust TX queue kobjects if number of queues changes during unregister")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Hello,

Following a previous thread[1] I had another look at this issue and now
have a better fix (this patch). In this previous thread we also
discussed preventing ethtool operations after unregister and adding a
warning in netdev_queue_update_kobjects; I'll send two patches for this
but targetting net-next.

Thanks!
Antoine

[1] https://lore.kernel.org/all/20211122162007.303623-1-atenart@kernel.org/T/

 net/core/net-sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9c01c642cf9e..d7f9ee830d34 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1820,6 +1820,9 @@ static void remove_queue_kobjects(struct net_device *dev)
 
 	net_rx_queue_update_kobjects(dev, real_rx, 0);
 	netdev_queue_update_kobjects(dev, real_tx, 0);
+
+	dev->real_num_rx_queues = 0;
+	dev->real_num_tx_queues = 0;
 #ifdef CONFIG_SYSFS
 	kset_unregister(dev->queues_kset);
 #endif
-- 
2.33.1

