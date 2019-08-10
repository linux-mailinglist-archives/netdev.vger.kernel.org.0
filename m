Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3653888BFB
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 17:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfHJPuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 11:50:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:50688 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726048AbfHJPuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 11:50:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 20D90AEAC;
        Sat, 10 Aug 2019 15:50:44 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2DAE2E042B; Sat, 10 Aug 2019 17:50:42 +0200 (CEST)
Date:   Sat, 10 Aug 2019 17:50:42 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        David Ahern <dsahern@gmail.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190810155042.GA30089@unicorn.suse.cz>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <20190809154609.GG31971@unicorn.suse.cz>
 <CAJieiUhcG6tpDA3evMtiyPSsKS9bfKPeD=dUO70oYOgGbFKy9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUhcG6tpDA3evMtiyPSsKS9bfKPeD=dUO70oYOgGbFKy9Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 10, 2019 at 06:46:57AM -0700, Roopa Prabhu wrote:
> On Fri, Aug 9, 2019 at 8:46 AM Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> > On Fri, Aug 09, 2019 at 08:40:25AM -0700, Roopa Prabhu wrote:
> > > to that point, I am also not sure why we have a new API For multiple
> > > names. I mean why support more than two names  (existing old name and
> > > a new name to remove the length limitation) ?
> >
> > One use case is to allow "predictable names" from udev/systemd to work
> > the way do for e.g. block devices, see
> >
> >   http://lkml.kernel.org/r/20190628162716.GF29149@unicorn.suse.cz
> >
> 
> thanks for the link. don't know the details about alternate block
> device names. Does user-space generate multiple and assign them to a
> kernel object as proposed in this series ?. is there a limit to number
> of names ?. my understanding of 'predictable names' was still a single
> name but predictable structure to the name.

It is a single name but IMHO mostly because we can only have one name.
For block devices, udev uses symlinks to create multiple aliases based
on different naming schemes, e.g.

mike@lion:~> find -L /dev/disk/ -samefile /dev/sda2 -exec ls -l {} +
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/ata-WDC_WD30EFRX-68AX9N0_WD-WMC1T3114933-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-SATA_WDC_WD30EFRX-68A_WD-WMC1T3114933-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-SATA_WDC_WD30EFRX-68_WD-WMC1T3114933-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-0ATA_WDC_WD30EFRX-68A_WD-WMC1T3114933-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-1ATA_WDC_WD30EFRX-68AX9N0_WD-WMC1T3114933-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-350014ee6589cfea0-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/wwn-0x50014ee6589cfea0-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-partlabel/root2 -> ../../sda2
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-partuuid/71affb47-a93b-40fd-8986-d2e227e1b39d -> ../../sda2
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-path/pci-0000:00:11.0-ata-1-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part2 -> ../../sda2

Few years ago, udev even dropped support for renaming block and
character devices (NAME="...") so that it now keeps kernel name and only
creates symlinks to it. Recent versions only allow NAME="..." for
network devices.

Michal
