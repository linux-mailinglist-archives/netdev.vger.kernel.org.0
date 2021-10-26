Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E624B43B465
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhJZOkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234906AbhJZOkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 365EF60F9B;
        Tue, 26 Oct 2021 14:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635259056;
        bh=mZyyCsuNBLDFQ7EOhT0gjKS24zRD93DOBaYqv6Y9vTE=;
        h=In-Reply-To:References:From:To:Subject:Cc:Date:From;
        b=sJNidINuQcVKRhXQA6zwcNxR3q1jb/4U8c3cmCQZzmpX7xxdFxwopXZm+FhLBIvyl
         hU0Zb3Rj6XPoc2DL8OsXqdAzdGHd7Cy+EKLfzk87uIRrh3fXDX1iI3FjsXPS0xFjsd
         qVThpDxMx12GB28cU6Lx6Y1faiO0MnbfAtoDXuUeXOC8mtjU/QUBMPP1n7+0QeQRZw
         DtQRG87mrItNwJG4KMxTikZb8GccQkgOc6gWahCQ/yBe6VjmrVtAuEoI21EjrUN5+e
         dMNE4dsnJh7kQNGS4rYEB2tMT68ImUZz1YiO82ECMbYw6YDPLEB5C/2ZJ6xkxOw9nJ
         AHt2Nmk/EH5Pg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211026.153057.208749798584527471.davem@davemloft.net>
References: <20211026133822.949135-1-atenart@kernel.org> <20211026.153057.208749798584527471.davem@davemloft.net>
From:   Antoine Tenart <atenart@kernel.org>
To:     David Miller <davem@davemloft.net>
Subject: Re: [net] net-sysfs: avoid registering new queue objects after device unregistration
Cc:     kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Message-ID: <163525905360.935735.15638391921416634794@kwain>
Date:   Tue, 26 Oct 2021 16:37:33 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting David Miller (2021-10-26 16:30:57)
> From: Antoine Tenart <atenart@kernel.org>
> Date: Tue, 26 Oct 2021 15:38:22 +0200
>=20
> > netdev_queue_update_kobjects can be called after device unregistration
> > started (and device_del was called) resulting in two issues: possible
> > registration of new queue kobjects (leading to the following trace) and
> > providing a wrong 'old_num' number (because real_num_tx_queues is not
> > updated in the unregistration path).
> >=20
> >   BUG: KASAN: use-after-free in kobject_get+0x14/0x90
> >   Read of size 1 at addr ffff88801961248c by task ethtool/755
> >=20
> >   CPU: 0 PID: 755 Comm: ethtool Not tainted 5.15.0-rc6+ #778
> >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.=
fc34 04/014
> >   Call Trace:
> >    dump_stack_lvl+0x57/0x72
> >    print_address_description.constprop.0+0x1f/0x140
> >    kasan_report.cold+0x7f/0x11b
> >    kobject_get+0x14/0x90
> >    kobject_add_internal+0x3d1/0x450
> >    kobject_init_and_add+0xba/0xf0
> >    netdev_queue_update_kobjects+0xcf/0x200
> >    netif_set_real_num_tx_queues+0xb4/0x310
> >    veth_set_channels+0x1c3/0x550
> >    ethnl_set_channels+0x524/0x610
> >=20
> > The fix for both is to only allow unregistering queue kobjects after a
> > net device started its unregistration and to ensure we know the current
> > Tx queue number (we update dev->real_num_tx_queues before returning).
> > This relies on the fact that dev->real_num_tx_queues is used for
> > 'old_num' expect when firstly allocating queues.
> >=20
> > (Rx queues are not affected as net_rx_queue_update_kobjects can't be
> > called after a net device started its unregistration).
> >=20
> > Fixes: 5c56580b74e5 ("net: Adjust TX queue kobjects if number of queues=
 changes during unregister")
> > Signed-off-by: Antoine Tenart <atenart@kernel.org>
>=20
> netdev_queue_update_kobjects is a confusing function name, it sounds
> like it handles both rx and tx.  It only handles tx so
> net_tx_queue_update_kobjects is more appropriate.

Agreed.

> Could you rename the function in this patch please?

As this is targeting stable kernels, shouldn't the rename be a separate
patch sent to net-next instead? (And it's not the only function that
should be renamed if we take this path, such as netdev_queue_add_kobject
and the functions in struct kobj_type netdev_queue_ktype).

Thanks!
Antoine
