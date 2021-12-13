Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E78147291B
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhLMKSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:18:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57970 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237182AbhLMKPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:15:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6069DCE0F0F;
        Mon, 13 Dec 2021 10:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFE8C34602;
        Mon, 13 Dec 2021 10:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639390509;
        bh=my/X2S/rJujwq12TrbafCXI5IQ5H0PRDazBL7lL4chE=;
        h=From:To:Cc:Subject:Date:From;
        b=rrr90osq3QT7vjfjzI8sRS1qNte5Zbt/uQ0IlZUpdUP+byVGy/Ifa3SOBrlbxWoD1
         8gCIs6+IoVr5SPCtCVy4QW5yRegPx+UGtQcHDvxDbX83rqwo55CrbvVxa9v5gWCV4S
         HjoaGBKHCReSxny1MXQH72VGPxesg0c3TwMAsuvoRAmqoZrePAzPHHsluS5eTT+dvS
         0g+gvbGPKbxyeGAg1UOd7lvp6uSKjQi5fvT9AxpUPlUhp5f+UcISrqvbBjtG2u81Lt
         T7LAS40+AnI3MlO06jNZRmKtW3TYuiV5rZcFIK/Wrf8UrELZ6yV+WRUHUZOR7liRh6
         8AJ288qJCucdA==
From:   Antoine Tenart <atenart@kernel.org>
To:     gregkh@linuxfoundation.org, davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 5.10] ethtool: do not perform operations on net devices being unregistered
Date:   Mon, 13 Dec 2021 11:15:06 +0100
Message-Id: <20211213101506.118377-1-atenart@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit dde91ccfa25fd58f64c397d91b81a4b393100ffa upstream

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

[The patch differs from the upstream one as code was moved around by
commit 41107ac22fcf ("ethtool: move netif_device_present check from
ethnl_parse_header_dev_get to ethnl_ops_begin"). The check on the netdev
state is still done in ethnl_ops_begin as it must be done in an rtnl
section (the one which performs the op) to not race with
unregister_netdevice_many.
Also note the trace in [1] is not possible here as the channel ops for
veth were added later, but that was just one example.]

Fixes: 041b1c5d4a53 ("ethtool: helper functions for netlink interface")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Hello,

This patch is intended for the stable 5.10 tree.

As reported by Greg, patch dde91ccfa25f ("ethtool: do not perform
operations on net devices being unregistered") did not apply correctly
on the 5.10 tree. The explanation of this and the approach taken here is
explained in the above commit log, between [].

I removed the Link tag and Signed-off-by from Jakub from the original
patch as this one is slightly different in its implementation.

Thanks,
Antoine

 net/ethtool/netlink.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index d8efec516d86..979dee6bb88c 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -249,6 +249,9 @@ struct ethnl_reply_data {
 
 static inline int ethnl_ops_begin(struct net_device *dev)
 {
+	if (dev && dev->reg_state == NETREG_UNREGISTERING)
+		return -ENODEV;
+
 	if (dev && dev->ethtool_ops->begin)
 		return dev->ethtool_ops->begin(dev);
 	else
-- 
2.33.1

