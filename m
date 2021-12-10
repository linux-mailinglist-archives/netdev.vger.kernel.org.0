Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C8B470652
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244130AbhLJQxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240671AbhLJQxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:53:12 -0500
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED88C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:49:37 -0800 (PST)
Received: from equinox by eidolon.nox.tf with local (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1mvj5M-00747h-VD; Fri, 10 Dec 2021 17:49:29 +0100
Date:   Fri, 10 Dec 2021 17:49:28 +0100
From:   David Lamparter <equinox@diac24.net>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Lamparter <equinox@diac24.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] bridge: extend BR_ISOLATE to full split-horizon
Message-ID: <YbOFGJbLtQirRGvc@eidolon.nox.tf>
References: <20211209121432.473979-1-equinox@diac24.net>
 <20211209074204.4be34975@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4d18d015-4154-5a0c-e93d-16b8bdbdaddb@nvidia.com>
 <481128e0-d4d0-3fde-6a9e-65e391bbf64d@nvidia.com>
 <898155b2-08d7-1977-d0c9-bbb1ae99c0bb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <898155b2-08d7-1977-d0c9-bbb1ae99c0bb@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks all for the feedback!
(rolled up several mails below)

On Thu, Dec 09, 2021 at 07:42:04AM -0800, Jakub Kicinski wrote:
> Does not apply to net-next, you'll need to repost even if the code is
> good. Please put [PATCH net-next] in the subject.

Apologies, I think I skipped a step in my rebase somewhere.

On Thu, Dec 09, 2021 at 06:08:03PM +0200, Nikolay Aleksandrov wrote:
> - please drop the sysfs part, we're not extending sysfs anymore

ACK (will remove the "horizon_group" file, change to "isolated" remains)

> - split the bridge change from the driver

ACK - I wasn't sure if it's OK if the intermediate doesn't compile due
to deleted BR_ISOLATED?  Or should I make 3 patches with only the 3rd
removing the flag definition?

> - drop the /* BR_ISOLATED - previously BIT(16) */ comment

Should I move up the other bits below it or just leave a hole at 16?

> - [IFLA_BRPORT_HORIZON_GROUP] = NLA_POLICY_MIN(NLA_S32, 0), why not just { .type = NLA_U32 } ?
>
> Why the limitation (UAPI limited to positive signed int. (recommended ifindex namespace)) ?
> You have the full unsigned space available, user-space can use it as it sees fit.
> You can just remove the comment about recommended ifindex.

No problem, I guess I'm overthinking this a bit.  Using the ifindex is
just a "good way" of avoiding confusion if multiple things in userspace
try to configure this.  Kernel really doesn't care.

> Also please extend the port isolation self-test with a test for a different horizon group.

ACK

> - just forbid having both set (tb[IFLA_BRPORT_ISOLATED] && tb[IFLA_BRPORT_HORIZON_GROUP])
>   user-space should use just one of the two, if isolated is set then it overwrites any older
>   IFLA_BRPORT_HORIZON_GROUP settings, that should simplify things considerably

So a bit of a hidden question here is which way "BR_ISOLATED" maps -
both "ISOLATED :=: group >= 1" and "ISOLATED :=: group == 1" are
possible.  But regardless of which way it's defined, there's to some
degree a risk of "old" tools accidentally wrecking the horizon group
setting.  That's why I ended up making BR_ISOLATE=1 not change the
horizon group if it's nonzero already...

On Thu, Dec 09, 2021 at 05:23:35PM +0100, Alexandra Winter wrote:
> Yes, please keep it compatible with userspace setting IFLA_BRPORT_ISOLATED only.

On Thu, Dec 09, 2021 at 06:23:25PM +0200, Nikolay Aleksandrov wrote:
> Actually they'll have to be exported together always... that's unfortunate. I get
> why you need the extra netlink logic, I think we'll have to keep it.

Yeah - we can't remove BR_ISOLATED from netlink GETs to keep compat, so
we need to accept it in SETs too in order to not break userspace handing
it right back in 1:1 for a get(-modify)-set...

On Thu, Dec 09, 2021 at 06:57:23PM +0200, Nikolay Aleksandrov wrote:
> So one relatively simple way to drop most of the logic is to have BRPORT_HORIZON_GROUP's
> attribute get set after ISOLATED so it always overwrites it, which is similar to the current
> situation but if you set only ISOLATED later it will function as intended (i.e. drop the logic
> for horizon_group when using the old attr). Still will have to disallow ISOLATED = 0/HORIZON_GROUP >0
> and ISOLATED=1/HORIZON_GROUP=0 though as these don't make sense.
>
> e.g.:
> if (tb[IFLA_BRPORT_ISOLATED])
> 	p->horizon_group = !!nla_get_u8(tb[IFLA_BRPORT_ISOLATED]);
> if (tb[IFLA_BRPORT_HORIZON_GROUP])
> 	p->horizon_group = nla_get_u32(tb[IFLA_BRPORT_HORIZON_GROUP]);
>
> This will be also in line with how they're exported (ISOLATED = 1 and HORIZON_GROUP >0).

This boils down to the same logic as is currently in the patch, except
it's written the other way around and with an else, i.e.

if (tb[IFLA_BRPORT_HORIZON_GROUP])
	p->horizon_group = ...
else if (tb[IFLA_BRPORT_ISOLATED])
	p->horizon_group = ...

With the else it seems more obvious to me, to avoid someone in the
future missing the fact that the 2 settings interact - so I would
preferably keep it like this.


Cheers,

-David
