Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61597467494
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379798AbhLCKQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:16:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379673AbhLCKQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:16:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0C0C6293C
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 10:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F18C53FC7;
        Fri,  3 Dec 2021 10:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638526402;
        bh=Vlmux8NkkE2ZiuwiSuMMf7TnqH8fZNsIDhuJxsiW6l4=;
        h=From:To:Cc:Subject:Date:From;
        b=UynUmRlo5xnZOFFAS9o3mb+8iogWwBXjGCShOcusMJken8RWWIb91CZUQwqFXPOcr
         EQW4FYoVoCIrqcCxHW8FZAxWCHSs5PyuLoeNqmYtaSl2cqw3qOR5Uj9uT0dAMi3+E5
         mZ+/JWLrMc65ohM+8nByfN5pjmPtRqusCBkEpmTPWXM65rd/9hnHCsBszQx7zwot/k
         Ab28bufk1rFlUzju6NE7/mjwQVlDBQ177ZT+A70Qyv6j05XB3spaUjTRWPXT4lR5C+
         dFkk69XarDlUmVybzguBaXjieAf/Yq6vJD9yvAcLg6AXTcq/iJ2Q214A1gsReZQiNX
         +ZNOkouZy502A==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, alexander.duyck@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org
Subject: [PATCH net] ethtool: do not perform operations on net devices being unregistered
Date:   Fri,  3 Dec 2021 11:13:18 +0100
Message-Id: <20211203101318.435618-1-atenart@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a short period between a net device starts to be unregistered
and when it is actually gone. In that time frame ethtool operations
could still be performed, which might end up in unwanted or undefined
behaviours[1].

Do not allow ethtool operations after a net device starts its
unregistration. This patch targets the netlink part as the ioctl one
isn't affected: the reference to the net device is taken and the
operation is executed within an rtnl lock section and the net device
won't be found after unregister.

[1] For example adding Tx queues after unregister ends up in NULL
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

Fixes: 041b1c5d4a53 ("ethtool: helper functions for netlink interface")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Following the discussions in those threads:
- https://lore.kernel.org/all/20211129154520.295823-1-atenart@kernel.org/T/
- https://lore.kernel.org/all/20211122162007.303623-1-atenart@kernel.org/T/

 net/ethtool/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 38b44c0291b1..96f4180aabd2 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -40,7 +40,8 @@ int ethnl_ops_begin(struct net_device *dev)
 	if (dev->dev.parent)
 		pm_runtime_get_sync(dev->dev.parent);
 
-	if (!netif_device_present(dev)) {
+	if (!netif_device_present(dev) ||
+	    dev->reg_state == NETREG_UNREGISTERING) {
 		ret = -ENODEV;
 		goto err;
 	}
-- 
2.33.1

