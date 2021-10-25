Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B88C439F08
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhJYTPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233083AbhJYTPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 15:15:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD66660EFE;
        Mon, 25 Oct 2021 19:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635189166;
        bh=qcgqj6EL72dxtL9tgsfyof8wxelEwQ7EL8RNoufi/F4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l3HbWPlJT8niZS63SsAawpBaDIkansLkf+kAYCGbQJaq70sXBITLP1EaPFrzT7Svw
         7vCNszZr7jZcaC5jA8LwROGx8WCg+Yxpk/mU61ZEfv6vVcpu1Bsz3+4OkA5QtBIDXq
         eFPhyuYGqE1L6ZMbaOjYHJqek9HdmA5ryDjd3vRs9Yvq9QfjulFusqAOouhg+QSggF
         p2HVwEknLmpkuT2qfFKktXbJS2MJFAVu6Dh3QJxgAo8rnFesRN0KrYKmXWxABTVtq+
         zOkoFU8mKBVk+vGUwrMQdrTorkIfalNwMIM6lNa285seFJRtLiJF1t7+ng9PznH6Ep
         3UhNzzuJH6+uw==
Date:   Mon, 25 Oct 2021 22:12:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXcBqtSMa8We6fl2@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <YXUtbOpjmmWr71dU@unreal>
 <YXU5+XLhQ9zkBGNY@shredder>
 <YXZB/3+IR6I0b2xE@unreal>
 <YXZl4Gmq6DYSdDM3@shredder>
 <20211025112453.089519e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025112453.089519e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 11:24:53AM -0700, Jakub Kicinski wrote:
> On Mon, 25 Oct 2021 11:08:00 +0300 Ido Schimmel wrote:
> > No, it's not correct. After your patch, trap properties like action are
> > not set back to the default. Regardless of what you think is the "right
> > design", you cannot introduce such regressions.
> > 
> > Calling devlink_*_unregister() in reload_down() and devlink_*_register()
> > in reload_up() is not new. It is done for multiple objects (e.g., ports,
> > regions, shared buffer, etc). After your patch, netdevsim is still doing
> > it.
> 
> If we want to push forward in the direction that Leon advocates we'd
> have to unregister the devlink instance before reload_down(), right?

Not really, we ensure that during "devlink reload", users can't send any
get/set commands. So you don't need to unregister anything, because
driver is safe to change any internal values it wants. The devlink instance
is locked for exclusive access.

The protection is done now by devlink_mutex, but will be slightly
different in the near future.

> 
> Otherwise it seems fundamentally incompatible with the idea of reload
> for reconfig. And we'd be trading one partially correct model for
> another partially correct model :/

I see devlink reload as command to reconfigure device and not devlink
itself. This is the difference between my direction vs. mlxsw way.

Thanks
