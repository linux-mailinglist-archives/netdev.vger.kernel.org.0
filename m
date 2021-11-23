Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6630D45A134
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhKWLVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:21:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:56666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232545AbhKWLVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 06:21:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F13E361075;
        Tue, 23 Nov 2021 11:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637666313;
        bh=Jre+m9DknEcDiZag3wJIbAUDpt6awJaqSn1ZSGJ3BaA=;
        h=In-Reply-To:References:To:Subject:From:Cc:Date:From;
        b=J6X5vK3dErlSqczlsdnTBu9pSCS6XmOwQaWlWuDbbVOdqrmmx4vXBlw/mcgGk+uS9
         WYRDPo1VTvPNBlGpuxBlRsybFbZV82Slvig/57jfmmJFdu4d3FCBoviaj9nMUk2G+q
         h8ncCymMi1DsUO2xe5d2njnMFgyq3RT/qT0M4hYkCf5RTcBb0T072gcCdiZqQGg5Qx
         Pu7YsDSlbbvIbK3+aFTRHGxpcI+MMPhXjy3mJoyXPv+QYVT3IgDpGRaFDp1IV2vJJd
         FnxEptGsPeAaAIgF5fc4V/t9Fq0zlJtbagDnZYwT1lHI/YrurbVRFfrGu5ks1j7TQc
         2IVOpNTKp2Nrw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211122113742.16705a54@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211122162007.303623-1-atenart@kernel.org> <20211122083144.7d15a6ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <163760016601.3195.14673180551504824633@kwain> <20211122113742.16705a54@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2] net: avoid registering new queue objects after device unregistration
From:   Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>
Message-ID: <163766631025.3372.17600281769888147460@kwain>
Date:   Tue, 23 Nov 2021 12:18:30 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2021-11-22 20:37:42)
> On Mon, 22 Nov 2021 17:56:06 +0100 Antoine Tenart wrote:
> > Quoting Jakub Kicinski (2021-11-22 17:31:44)
> > > On Mon, 22 Nov 2021 17:20:07 +0100 Antoine Tenart wrote: =20
> > > >    veth_set_channels+0x1c3/0x550
> > > >    ethnl_set_channels+0x524/0x610 =20
> > >=20
> > > The patch looks fine, but ethtool calls should not happen after
> > > unregister IMHO. Too many drivers would be surprised.=20
> > >=20
> > > Maybe we should catch unregistered devices in ethnl_ops_begin()? =20
> >=20
> > That might be good to have indeed, I'll have a look. I'm not sure about
> > other paths that could do the same: if there are, we might want to keep
> > the check in this patch as well. Or WARN to catch future misuses?
>=20
> My knee jerk reaction was to add a WARN() just because I can't think
> why changing queue count after unregister would be needed. But it's not
> really illegal and we do support it before register, so why not after
> unregister..

It's a little tricky. The queue count can be changed before
registration (updating dev->real_num_rx/tx_queues only) but the queue
objects can't[1]. The symmetry would be to only allowing to update
dev->real_num_tx_queues after unregister (which seems useless).

This is what's actually done for Rx queues[2]. For Tx the issue we have
is a quirk that was added to allow qdiscs to remove their extra Tx
queues after unregister[3] as in unregister_netdevice_many the net
devices are unlisted and moved to NETREG_UNREGISTERING before the call
to dev_shutdown().

[1] https://elixir.bootlin.com/linux/v5.16-rc2/source/net/core/dev.c#L2918
[2] https://elixir.bootlin.com/linux/v5.16-rc2/source/net/core/dev.c#L2967
[3] 5c56580b74e5 ("net: Adjust TX queue kobjects if number of queues
    changes during unregister")

> We can venture a warning with a comment saying that this is just for
> catching bad uses and see if any driver hits it on a normal path?

With that a better fix seems to be what you suggested, in
ethnl_ops_begin. A WARN in netdev_queue_update_kobjects[4] detecting
misuses might be good as well as the logic is not that straightforward
here.

[4] Or in netif_set_real_num_tx_queues as it is already detecting when
    queues are being disabled. !disabling && NETREG_UNREGISTERING should
    be illegal or at least not update the kobjects.
    https://elixir.bootlin.com/linux/v5.16-rc2/source/net/core/dev.c#L2913

Thanks!
Antoine
