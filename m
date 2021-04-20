Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64443651B6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 07:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhDTFEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 01:04:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56284 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhDTFEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 01:04:41 -0400
Received: from [50.125.80.157] (helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lYiYM-0007Pm-Tw; Tue, 20 Apr 2021 05:04:03 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id F2D5D5FBBB; Mon, 19 Apr 2021 22:04:00 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id EBF5A9FC56;
        Mon, 19 Apr 2021 22:04:00 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     jin yiting <jinyiting@huawei.com>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, security@kernel.org,
        linux-kernel@vger.kernel.org, xuhanbing@huawei.com,
        wangxiaogang3@huawei.com
Subject: Re: [PATCH] bonding: 3ad: update slave arr after initialize
In-reply-to: <1165c45f-ae7f-48c1-5c65-a879c7bf978a@huawei.com>
References: <1618537982-454-1-git-send-email-jinyiting@huawei.com> <17733.1618547307@famine> <1165c45f-ae7f-48c1-5c65-a879c7bf978a@huawei.com>
Comments: In-reply-to jin yiting <jinyiting@huawei.com>
   message dated "Tue, 20 Apr 2021 11:22:41 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <490.1618895040.1@famine>
Date:   Mon, 19 Apr 2021 22:04:00 -0700
Message-ID: <492.1618895040@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

jin yiting <jinyiting@huawei.com> wrote:
[...]
>> 	The described issue is a race condition (in that
>> ad_agg_selection_logic clears agg->is_active under mode_lock, but
>> bond_open -> bond_update_slave_arr is inspecting agg->is_active outside
>> the lock).  I don't see how the above change will reliably manage this;
>> the real issue looks to be that bond_update_slave_arr is committing
>> changes to the array (via bond_reset_slave_arr) based on a racy
>> inspection of the active aggregator state while it is in flux.
>>
>> 	Also, the description of the issue says "The best aggregator in
>> ad_agg_selection_logic has not changed, no need to update slave arr,"
>> but the change above does the opposite, and will set update_slave_arr
>> when the aggregator has not changed (update_slave_arr remains false at
>> return of ad_agg_selection_logic).
>>
>> 	I believe I understand the described problem, but I don't see
>> how the patch fixes it.  I suspect (but haven't tested) that the proper
>> fix is to acquire mode_lock in bond_update_slave_arr while calling
>> bond_3ad_get_active_agg_info to avoid conflict with the state machine.
>>
>> 	-J
>>
>> ---
>> 	-Jay Vosburgh, jay.vosburgh@canonical.com
>> .
>>
>
>	Thank you for your reply. The last patch does have redundant
>update slave arr.Thank you for your correction.
>
>        As you said, holding mode_lock in bond_update_slave_arr while
>calling bond_3ad_get_active_agg_info can avoid conflictwith the state
>machine. I have tested this patch, with ifdown/ifup operations for bond or
>slaves.
>
>        But bond_update_slave_arr is expected to hold RTNL only and NO
>other lock. And it have WARN_ON(lockdep_is_held(&bond->mode_lock)); in
>bond_update_slave_arr. I'm not sure that holding mode_lock in
>bond_update_slave_arr while calling bond_3ad_get_active_agg_info is a
>correct action.

	That WARN_ON came up in discussion recently, and my opinion is
that it's incorrect, and is trying to insure bond_update_slave_arr is
safe for a potential sleep when allocating memory.

https://lore.kernel.org/netdev/20210322123846.3024549-1-maximmi@nvidia.com/

	The original authors haven't replied, so I would suggest you
remove the WARN_ON and the surrounding CONFIG_LOCKDEP ifdefs as part of
your patch and replace it with a call to might_sleep.

	The other callers of bond_3ad_get_active_agg_info are generally
obtaining the state in order to report it to user space, so I think it's
safe to leave those calls not holding the mode_lock.  The race is still
there, but the data returned to user space is a snapshot and so may
reflect an incomplete state during a transition.  Further, having the
inspection functions acquire the mode_lock permits user space to spam
the lock with little effort.

	-J

>diff --git a/drivers/net/bonding/bond_main.c
>b/drivers/net/bonding/bond_main.c
>index 74cbbb2..db988e5 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -4406,7 +4406,9 @@ int bond_update_slave_arr(struct bonding *bond,
>struct slave *skipslave)
>    if (BOND_MODE(bond) == BOND_MODE_8023AD) {
>        struct ad_info ad_info;
>
>+       spin_lock_bh(&bond->mode_lock);
>        if (bond_3ad_get_active_agg_info(bond, &ad_info)) {
>+           spin_unlock_bh(&bond->mode_lock);
>            pr_debug("bond_3ad_get_active_agg_info failed\n");
>            /* No active aggragator means it's not safe to use
>             * the previous array.
>@@ -4414,6 +4416,7 @@ int bond_update_slave_arr(struct bonding *bond,
>struct slave *skipslave)
>            bond_reset_slave_arr(bond);
>            goto out;
>        }
>+       spin_unlock_bh(&bond->mode_lock);
>        agg_id = ad_info.aggregator_id;
>    }
>    bond_for_each_slave(bond, slave, iter) {

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
