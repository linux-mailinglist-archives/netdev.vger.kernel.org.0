Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A6022FA45
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgG0Um3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:42:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:33420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgG0Um3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 16:42:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1AC8CAD60;
        Mon, 27 Jul 2020 20:42:38 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 65C496030D; Mon, 27 Jul 2020 22:42:27 +0200 (CEST)
Date:   Mon, 27 Jul 2020 22:42:27 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jamie Gloudon <jamie.gloudon@gmx.fr>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Subject: Re: Broken link partner advertised reporting in ethtool
Message-ID: <20200727204227.s2gv3hqszmpk7l7r@lion.mk-sys.cz>
References: <20200727154715.GA1901@gmx.fr>
 <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
 <20200727200912.GA1884@gmx.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727200912.GA1884@gmx.fr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 04:09:12PM -0400, Jamie Gloudon wrote:
> On Mon, Jul 27, 2020 at 12:19:13PM -0700, Jacob Keller wrote:
> >
> >
> > On 7/27/2020 8:47 AM, Jamie Gloudon wrote:
> > > Hey,
> > >
> > > While having a discussion with Sasha from Intel. I noticed link partner
> > > advertised support is broken in ethtool 5.7. Sasha hinted to me, the
> > > new API that ethtool is using.
> > >
> > > I see the actual cause in dump_peer_modes() in netlink/settings.c, that
> > > the mask parameter is set to false for dump_link_modes, dump_pause and
> > > bitset_get_bit.
> > >
> > > Regards,
> > > Jamie Gloudon
> > >
> >
> > Hi,
> >
> > Seems like more detail here would be useful. This is about the ethtool
> > application.
> >
> > Answering the following questions would help:
> >
> >  - what you wanted to achieve;
> >
> >  - what you did (including what versions of software and the command
> >    sequence to reproduce the behavior);
> >
> >  - what you saw happen;
> >
> >  - what you expected to see; and
> >
> >  - how the last two are different.
> >
> > The mask parameter for dump_link_modes is used to select between
> > displaying the mask and the value for a bitset.
> >
> > According to the source in filling the LINKMODES_PEER, we actually don't
> > send a mask at all with this setting, so using true for the mask in
> > dump_link_modes here seems like it would be wrong.
> >
> > It appears that to get link partner settings your driver must fill in
> > lp_advertising. If you're referring to an Intel driver, a quick search
> > over drivers/net/ethernet/intel shows that only the ice driver currently
> > supports reporting this information.
> >
> > Given this, I am not convinced there is a bug in ethtool.
> >
> > Thanks,
> > Jake
> 
> I am using r8169 with phy driver which actually fills lp_advertising.
> I recompiled ethtool v5.7 with --disable-netlink and "Link partner
> advertised link modes" works as it should.

Please keep in mind that unlike you, we are not familiar with the issue
and we don't know what exactly you did, what output you expected and
what you got. Also, the issue may be reproducible only with a specific
hardware. What would be definitely helpful would be

  - the exact command you ran (including arguments)
  - expected output (or at least the relevant part)
  - actual output (or at least the relevant part)
  - output with dump of netlink messages, you can get it by enabling
    debugging flags, e.g. "ethtool --debug 0x12 eth0"

Michal
