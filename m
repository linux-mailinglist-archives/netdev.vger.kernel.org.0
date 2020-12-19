Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A47B2DF01B
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 16:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgLSPCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 10:02:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgLSPCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 10:02:08 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608390087;
        bh=7Hn2F2SBF/YJrzz+D+SNg2+EbPONa2KSwrLTscj8rxE=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=TYK+8jqg4THpapjN8kgdvrzz9GCSKu4biY+QgPlOTrKCOjynx3T+CJOuUwhZQyrhF
         ReeOwRy/XkzaNQfGXvqLN4BBvcbJy7TUlrDXnrTWZdP6WPDvc/KVeXSX4mj4gQtdMa
         QE288XEfqiWNDRx7LvyuyfnjfiryrA3ATli8Nk2mkWWtxgokbglwwQfaXbrEkG21FM
         h6oqBbLPs+MBdyVfMKn8WP1LXCTNXEKxDJZk4OcWebWxwaz8YrozMPqyOdrYPhPY9x
         fnNyDL45IDtrbQibZLuIgmb/fwN+S1zyblcyt/GOef16YcjpFIgkFWVVdlB8Z0gQRQ
         vkN2wwwi2JlRg==
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAKgT0UeSSwU+pdujyTKNiQXuO4+UAyRxeCr9tB4dwO2n9a-KyA@mail.gmail.com>
References: <20201217162521.1134496-1-atenart@kernel.org> <20201217162521.1134496-2-atenart@kernel.org> <20201218163041.78f36cc2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAKgT0UeSSwU+pdujyTKNiQXuO4+UAyRxeCr9tB4dwO2n9a-KyA@mail.gmail.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net 1/4] net-sysfs: take the rtnl lock when storing xps_cpus
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Message-ID: <160839008460.3141.80891004725293385@kwain.local>
Date:   Sat, 19 Dec 2020 16:01:24 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Alexander,

Quoting Alexander Duyck (2020-12-19 02:41:08)
> On Fri, Dec 18, 2020 at 4:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Two things: (a) is the datapath not exposed to a similar problem?
> > __get_xps_queue_idx() uses dev->tc_num in a very similar fashion.
>=20
> I think we are shielded from this by the fact that if you change the
> number of tc the Tx path has to be torn down and rebuilt since you are
> normally changing the qdisc configuration anyway.

That's right. But there's nothing preventing users to call functions
using the xps maps in between. There are a few functions being exposed.

One (similar) example of that is another bug I reproduced, were the old
and the new map in __netif_set_xps_queue do not have the same size,
because num_tc was updated in between two calls to this function. The
root cause is the same: the size of the map is not embedded in it and
whenever we access it we can make an out of bound access.

> > Should we perhaps make the "num_tcs" part of the XPS maps which is
> > under RCU protection rather than accessing the netdev copy?

Yes, I have a local patch (untested, still WIP) doing exactly that. The
idea is we can't make sure a num_tc update will trigger an xps
reallocation / reconfiguration of the map; but at least we can make sure
the map won't be accessed out of bounds.

It's a different issue though: not being able to access a map out of
bound once it has been allocated whereas this patch wants to prevent an
update of num_tc while the xps map allocation/setup is in progress.

> So it looks like the issue is the fact that we really need to
> synchronize netdev_reset_tc, netdev_set_tc_queue, and
> netdev_set_num_tc with __netif_set_xps_queue.
>=20
> > (b) if we always take rtnl_lock, why have xps_map_mutex? Can we
> > rearrange things so that xps_map_mutex is sufficient?
>=20
> It seems like the quick and dirty way would be to look at updating the
> 3 functions I called out so that they were holding the xps_map_mutex
> while they were updating things, and for __netif_set_xps_queue to
> expand out the mutex to include the code starting at "if (dev->num_tc)
> {".

That should do the trick. The only downside is xps_map_mutex is only
defined with CONFIG_XPS while netdev_set_num_tc is not, adding more
ifdef to it. But that's probably a better compromise than taking the
rtnl lock.

Thanks for the review and suggestions!
Antoine
