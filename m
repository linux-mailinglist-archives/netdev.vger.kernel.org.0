Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FE743B342
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 15:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhJZNkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 09:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230420AbhJZNkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 09:40:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4244360E8C;
        Tue, 26 Oct 2021 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635255505;
        bh=wzC4BI/+CeitzjKeiU9AzylscZ5WYDeZc4mTQmvCEHk=;
        h=From:To:Cc:Subject:Date:From;
        b=rd+pbRMtC1lpPpm0zaRhPaMtUSH2LXcD13RJL/OJLzmgXHebrrGXNMcKOP9JRK+I+
         LL/cOPyOa3ZPZ58F/C5tyqx3aSTU4YkPBb2vDb8mPTNUbwBZsFZcn5jsWGY9Ugu9J5
         tRrFxV3H0Xck9ojxJ5doqHpobisXzxQZ6SJqII1BlNHiwELMFCRTX4YvznThhouIMc
         kKaFY2S2dmZoh5dahnAdMk5uCgZRI3CMAiLMNEh0S0MdJJnVuSBs1/GeElf5UulQzx
         6Z7aHRABu+Kh9uHfucc+0xBvVj3bnx6uuTxSimGuEr6Cek6gTvwQ9Vg4uj07+mSxkZ
         IiQmsYg2gqscg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [net] net-sysfs: avoid registering new queue objects after device unregistration
Date:   Tue, 26 Oct 2021 15:38:22 +0200
Message-Id: <20211026133822.949135-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_queue_update_kobjects can be called after device unregistration
started (and device_del was called) resulting in two issues: possible
registration of new queue kobjects (leading to the following trace) and
providing a wrong 'old_num' number (because real_num_tx_queues is not
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
Tx queue number (we update dev->real_num_tx_queues before returning).
This relies on the fact that dev->real_num_tx_queues is used for
'old_num' expect when firstly allocating queues.

(Rx queues are not affected as net_rx_queue_update_kobjects can't be
called after a net device started its unregistration).

Fixes: 5c56580b74e5 ("net: Adjust TX queue kobjects if number of queues changes during unregister")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Hi,

The 'dev->real_num_tx_queues' update is usually done (or is not needed)
when calling netdev_queue_update_kobjects and I could have added one in
the unregistration path (where it's missing). But I thought this would
be easier to backport for stable and better to tie it with the call of
this function: a following-up patch for net-next cleaning the now
duplicate updates can be made, instead.

To avoid future issues like this and invalid number of queues given to
netdev_queue_update_kobjects we could introduce a warning like (and a
similar one for Rx queues):

  WARN_ON(old_num != 0 && dev->real_num_tx_queues != old_num);

A better fix would be to remove 'old_num' from the function's parameters
and to always use dev->real_num_tx_queues; but it's not that
straightforward: the value can be set before the net device is
registered (and used elsewhere) and when firstly calling
netdev_queue_update_kobjects dev->real_num_tx_queues can not be relied
on. Anyway if possible that would not be a good candidate for a fix.

Thanks,
Antoine

 net/core/net-sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index b2e49eb7001d..2e5c89c7e3c9 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1651,6 +1651,12 @@ netdev_queue_update_kobjects(struct net_device *dev, int old_num, int new_num)
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
@@ -1670,6 +1676,7 @@ netdev_queue_update_kobjects(struct net_device *dev, int old_num, int new_num)
 		kobject_put(&queue->kobj);
 	}
 
+	dev->real_num_tx_queues = new_num;
 	return error;
 #else
 	return 0;
-- 
2.31.1

