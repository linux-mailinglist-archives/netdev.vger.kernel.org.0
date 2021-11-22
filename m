Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474CF4592E5
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbhKVQXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240203AbhKVQXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 11:23:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5A9160551;
        Mon, 22 Nov 2021 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637598010;
        bh=abieEKAVpmwXYqp4K9bjeBJTBEoTtjgU+rejF+xfJpc=;
        h=From:To:Cc:Subject:Date:From;
        b=kByKqyy+i+mJiGpc3tJqksllXgLnJ4Oi5NtLpKjiakLjk31YUlXT0yAymU+u5qI/W
         ELkcFXF9B7HW91ydzVZAG+l4R65e9l1S+WaQtPmdD8x32IdL6Lj5GQacPn4rW7arU+
         iAdESsx/OYWYszv65dd8L+P8xm2IF4a0fsx+Z5tbbUGKwrBDidaJbZcW2E07NoqUO0
         zKdPQ3lZOIyfBhnpjvPqYfmfziPIgztZnLdsKnpEEvJXkxuzC96MSmzJ/4tOEcZmNk
         XnTeum4qaub4fnrkshomBi6zeIHqSAzqvZDt+6EXSxOJAPzptOk9/o909xv7D2izEN
         qN/bgr3oHtLcQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net v2] net: avoid registering new queue objects after device unregistration
Date:   Mon, 22 Nov 2021 17:20:07 +0100
Message-Id: <20211122162007.303623-1-atenart@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_queue_update_kobjects can be called after device unregistration
started (and device_del was called) resulting in two issues: possible
registration of new queue kobjects (leading to the following trace) and
providing a wrong 'old_queue' number (because real_num_tx_queues is not
updated in the unregistration path).

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

The fix for both is to only allow unregistering queue kobjects after a
net device started its unregistration and to ensure we know the current
Tx queue numbers (we update dev->real_num_tx_queues before returning).
This relies on the fact that dev->real_num_tx_queues is used for
'old_num' expect when firstly allocating queues.

(Rx queues are not affected as net_rx_queue_update_kobjects can't be
called after a net device started its unregistration).

Fixes: 5c56580b74e5 ("net: Adjust TX queue kobjects if number of queues changes during unregister")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Since v1:
  - Rebased on latest net tree.

David asked in v1 to rename queue functions in net-sysfs[1]. I do have a
patch to prefix all Rx queue functions with net_rx_queue_ and all Tx
ones with net_tx_queue_ in net-sysfs. However this could be confusing as
for historical reasons 'netdev_queue' was always used for Tx queues and
'(net(dev)_)rx_queue' for Rx ones, including 'struct netdev_queue' and
'struct netdev_rx_queue.

- Only renaming the functions in net-sysfs can be a little confusing
  with key structures not following the same scheme.

- But renaming 'struct netdev_queue' is really invasive (380+
  occurrences all over the kernel).

WDYT?

(Anyway such a patch would target net-next while this one is a fix for
net).

Thanks!

[1] https://lore.kernel.org/all/20211026133822.949135-1-atenart@kernel.org/T/#mb0ed3e8366d92df21c35b95cecb2a7e497d25544

 net/core/net-sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9c01c642cf9e..0d9777484576 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1706,6 +1706,12 @@ netdev_queue_update_kobjects(struct net_device *dev, int old_num, int new_num)
 	int i;
 	int error = 0;
 
+	/* When unregistering a net device we can't register new kobjects, as
+	 * this would result in an UaF of the device's kobj.
+	 */
+	if (dev->reg_state == NETREG_UNREGISTERING && new_num > old_num)
+		return -EINVAL;
+
 	for (i = old_num; i < new_num; i++) {
 		error = netdev_queue_add_kobject(dev, i);
 		if (error) {
@@ -1725,6 +1731,7 @@ netdev_queue_update_kobjects(struct net_device *dev, int old_num, int new_num)
 		kobject_put(&queue->kobj);
 	}
 
+	dev->real_num_tx_queues = new_num;
 	return error;
 #else
 	return 0;
-- 
2.33.1

