Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267621C63E1
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 00:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgEEW1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 18:27:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:50266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728875AbgEEW1v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 18:27:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 58A16AE2C;
        Tue,  5 May 2020 22:27:52 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id AEDF2602B9; Wed,  6 May 2020 00:27:48 +0200 (CEST)
Date:   Wed, 6 May 2020 00:27:48 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jann Horn <jannh@google.com>
Subject: Re: [Patch net] net: fix a potential recursive NETDEV_FEAT_CHANGE
Message-ID: <20200505222748.GQ8237@lion.mk-sys.cz>
References: <20200505215819.1997-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505215819.1997-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 02:58:19PM -0700, Cong Wang wrote:
> syzbot managed to trigger a recursive NETDEV_FEAT_CHANGE event
> between bonding master and slave. I managed to find a reproducer
> for this:
> 
>   ip li set bond0 up
>   ifenslave bond0 eth0
>   brctl addbr br0
>   ethtool -K eth0 lro off
>   brctl addif br0 bond0
>   ip li set br0 up
> 
> When a NETDEV_FEAT_CHANGE event is triggered on a bonding slave,
> it captures this and calls bond_compute_features() to fixup its
> master's and other slaves' features. However, when syncing with
> its lower devices by netdev_sync_lower_features() this event is
> triggered again on slaves, so it goes back and forth recursively
> until the kernel stack is exhausted.
> 
> It is unnecessary to trigger it for a second time, because when
> we update the features from top down, we rely on each
> dev->netdev_ops->ndo_fix_features() to do the job, each stacked
> device should implement it. NETDEV_FEAT_CHANGE event is necessary
> when we update from bottom up, like in existing stacked device
> implementations.
> 
> Just calling __netdev_update_features() is sufficient to fix this
> issue.
> 
> Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
> Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
> Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
> Cc: Jarod Wilson <jarod@redhat.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Jann Horn <jannh@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 522288177bbd..ece50ae346c3 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8907,7 +8907,7 @@ static void netdev_sync_lower_features(struct net_device *upper,
>  			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
>  				   &feature, lower->name);
>  			lower->wanted_features &= ~feature;
> -			netdev_update_features(lower);
> +			__netdev_update_features(lower);
>  
>  			if (unlikely(lower->features & feature))
>  				netdev_WARN(upper, "failed to disable %pNF on %s!\n",

Wouldn't this mean that when we disable LRO on a bond manually with
"ethtool -K", LRO will be also disabled on its slaves but no netlink
notification for them would be sent to userspace?

Michal
