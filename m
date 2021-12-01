Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F79464AB2
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 10:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242448AbhLAJf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 04:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242392AbhLAJf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 04:35:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04455C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 01:32:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7155EB81E20
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 09:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8623CC53FCE;
        Wed,  1 Dec 2021 09:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638351125;
        bh=mDwzLOUCEiyV2PDtuJ9SP62pUF86BIpfkhSbO4VpHqw=;
        h=In-Reply-To:References:From:To:Cc:Subject:Date:From;
        b=tD6ya63qPLgKjwUtsncsarXXSKwyV2pOrEQvMcB1nABzTgvEsr+Y7FEzT/Bf4c7Z3
         G0dAwcX3+6NpIqAyDlA9Eouzx+xZ1il1OYAhgsAdplFdv5AbAN2zIT5csop4IVsQm7
         1/2w3Hvvh5sIDVTJvGcv0TypDKR+XAKdgTLTdRGcrIo2/TOcHgKoUMEAxdBEZAb1bX
         Wk6RcKzdfERG4mtCR0W5Fv1YKb5cK/Vk2nK2ogHzOaWP8AlHXbyrXWH8nQzgRDm/3G
         olkLG0KS/yAYkD1Hm6u88kL8B8EQV7yBgyl78Qcrf2mXZfqeeUSxuPA66N58a9AiZ/
         vD+iCqb3+RujQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211130180839.285e31be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211129154520.295823-1-atenart@kernel.org> <20211130180839.285e31be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Antoine Tenart <atenart@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net-sysfs: update the queue counts in the unregistration path
Message-ID: <163835112179.4366.10853783909376430643@kwain>
Date:   Wed, 01 Dec 2021 10:32:01 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2021-12-01 03:08:39)
> On Mon, 29 Nov 2021 16:45:20 +0100 Antoine Tenart wrote:
> > When updating Rx and Tx queue kobjects, the queue count should always be
> > updated to match the queue kobjects count. This was not done in the net
> > device unregistration path and due to the Tx queue logic allowing
> > updates when unregistering (for qdisc cleanup) it was possible with
> > ethtool to manually add new queues after unregister, leading to NULL
> > pointer exceptions and UaFs, such as:
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
> > Updating the queue counts in the unregistration path solve the above
> > issue, as the ethtool path updating the queue counts makes sanity checks
> > and a queue count of 0 should prevent any update.
>=20
> Would you mind pointing where in the code that happens? I can't seem=20
> to find anything looking at real_num_.x_queues outside dev.c and
> net-sysfs.c :S

I read the above commit message again; it's not well explained... Sorry
for that.

The above trace was triggered using veths and this patch would solve
this as veths do use real_num_x_queues to fill 'struct ethtool_channels'
in its get_channels ops[1] which is then used to avoid making channel
counts updates if it is 0[2].

In addition, keeping track of the queue counts in the unregistration
path do help other drivers as it will allow adding a warning in
netdev_queue_update_kobjects when adding queues after unregister
(without tracking the queue counts in the unregistration path we can't
detect illegal queue additions). We could also not only warn for illegal
uses of netdev_queue_update_kobjects but also return an error.

Another change that was discussed is to forbid ethtool ops after
unregister. This is good, but is outside of the queue code so it might
not solve all issues.

(I do have those two patches, warn + ethtool, in my local tree and plan
on targeting net-next).

As you can see I'm a bit puzzled at how to fix this in the best way
possible[3]. I think the combination of the three patches should be good
enough, with only one sent to net as it does fix veths which IMHO is
easier to trigger. WDYT?

Thanks!
Antoine

[1] https://elixir.bootlin.com/linux/latest/source/drivers/net/veth.c#L222
[2] https://elixir.bootlin.com/linux/latest/source/net/ethtool/channels.c#L=
175
[3] Because the queue code does rely on external states.
