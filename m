Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8004243B434
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbhJZOdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbhJZOd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:33:29 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7980FC061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:31:05 -0700 (PDT)
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 1A9F04F61D52B;
        Tue, 26 Oct 2021 07:31:01 -0700 (PDT)
Date:   Tue, 26 Oct 2021 15:30:57 +0100 (BST)
Message-Id: <20211026.153057.208749798584527471.davem@davemloft.net>
To:     atenart@kernel.org
Cc:     kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [net] net-sysfs: avoid registering new queue objects after
 device unregistration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211026133822.949135-1-atenart@kernel.org>
References: <20211026133822.949135-1-atenart@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 26 Oct 2021 07:31:02 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>
Date: Tue, 26 Oct 2021 15:38:22 +0200

> netdev_queue_update_kobjects can be called after device unregistration
> started (and device_del was called) resulting in two issues: possible
> registration of new queue kobjects (leading to the following trace) and
> providing a wrong 'old_num' number (because real_num_tx_queues is not
> updated in the unregistration path).
> 
>   BUG: KASAN: use-after-free in kobject_get+0x14/0x90
>   Read of size 1 at addr ffff88801961248c by task ethtool/755
> 
>   CPU: 0 PID: 755 Comm: ethtool Not tainted 5.15.0-rc6+ #778
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/014
>   Call Trace:
>    dump_stack_lvl+0x57/0x72
>    print_address_description.constprop.0+0x1f/0x140
>    kasan_report.cold+0x7f/0x11b
>    kobject_get+0x14/0x90
>    kobject_add_internal+0x3d1/0x450
>    kobject_init_and_add+0xba/0xf0
>    netdev_queue_update_kobjects+0xcf/0x200
>    netif_set_real_num_tx_queues+0xb4/0x310
>    veth_set_channels+0x1c3/0x550
>    ethnl_set_channels+0x524/0x610
> 
> The fix for both is to only allow unregistering queue kobjects after a
> net device started its unregistration and to ensure we know the current
> Tx queue number (we update dev->real_num_tx_queues before returning).
> This relies on the fact that dev->real_num_tx_queues is used for
> 'old_num' expect when firstly allocating queues.
> 
> (Rx queues are not affected as net_rx_queue_update_kobjects can't be
> called after a net device started its unregistration).
> 
> Fixes: 5c56580b74e5 ("net: Adjust TX queue kobjects if number of queues changes during unregister")
> Signed-off-by: Antoine Tenart <atenart@kernel.org>

netdev_queue_update_kobjects is a confusing function name, it sounds like it handles both rx and tx.
It only handles tx so net_tx_queue_update_kobjects is more appropriate.

Could you rename the function in this patch please?

Thank you.
