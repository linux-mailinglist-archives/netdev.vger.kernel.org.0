Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB6542395B
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 10:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbhJFIFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237384AbhJFIFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 04:05:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3845861040;
        Wed,  6 Oct 2021 08:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633507423;
        bh=0Vv+csbdkwlttiOflCSI9HLmcF9hI+YyiF8qnC+DLHI=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=s82W9I9NOmXD3d7/83GVz+XYFsSYw94EvTnt7hfm0mhcdChB5rQqfuRNE0KiSlHdI
         hQu+oJglJQz5Wnlzod2K3oSHcRs626i13u4kMUH3yNL737wTHZJ9jbiJQFNa5DIDn9
         U/7l2TUEeoGPL6HhDQ145oY4pm3RNjnb8clkovokBsA3178AoJIytF5k/rcxmhYpIo
         5Bz9xbnHMS3hq74z7Cg4PebxUk91OQkf4pMdzVnuRaY8l50DiVivsQeMkwo+iqsPQB
         /S0+/6ySE34UUKoBgI/BbE6q15pbFYVJiP2+Zm4UCxrBzuzK7JrdxUaobk3TZahoaw
         pxsoUUZULsfDg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YV1GJg/aqPARptJp@dhcp22.suse.cz>
References: <20210928125500.167943-1-atenart@kernel.org> <20210928125500.167943-10-atenart@kernel.org> <YV1GJg/aqPARptJp@dhcp22.suse.cz>
Subject: Re: [RFC PATCH net-next 9/9] net-sysfs: remove the use of rtnl_trylock/restart_syscall
From:   Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
To:     Michal Hocko <mhocko@suse.com>
Message-ID: <163350742102.4226.2656822862076181317@kwain>
Date:   Wed, 06 Oct 2021 10:03:41 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Michal Hocko (2021-10-06 08:45:58)
> On Tue 28-09-21 14:55:00, Antoine Tenart wrote:
> > The ABBA deadlock avoided by using rtnl_trylock and restart_syscall was
> > fixed in previous commits, we can now remove the use of this
> > trylock/restart logic and have net-sysfs operations not spinning when
> > rtnl is already taken.
>=20
> Shouldn't those lock be interruptible or killable at least? As mentioned
> in other reply we are seeing multiple a contention on some sysfs file
> because mlx driver tends to do some heavy lifting in its speed callback
> so it would be great to be able to interact with waiters during that
> time.

Haven't thought much about this, but it should be possible to use
rtnl_lock_killable. I think this should be a patch on its own with its
own justification though (to help bisecting). But that is easy to do
once the trylock logic is gone.

Thanks,
Antoine
