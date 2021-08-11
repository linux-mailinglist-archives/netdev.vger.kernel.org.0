Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600843E973D
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhHKSE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhHKSE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E68560FE6;
        Wed, 11 Aug 2021 18:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705043;
        bh=nvsohcaswZIumN4BvfcFYqFhze4+0DHB6Lx2u4YSDmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nj1IblsG7PtpC7nauaCOmZ/9nq1P2VMe7lI91RlDvw0KBaKeXF4Iu84neU1rI6F6V
         dSNsuRNiiz1N5eFBYsLdY82eq9vBJuwllJAh8TU5XfapcG1ZCC4U1FTgl8+DLGQwqq
         ZlbMiE3DnEHA0waWWMjaFtTcHiUTGqVHO200dqcDhCjQIlxLruegXezWyB53ATtgxr
         LfB6dt6/i5SBj3/nMmMh23I5mLnkp3OwwwkrVvPwzmDOkobPG863uM43us0xc6ZRV0
         hIx/QkeE7Hpu3bG89WjX5LyKWZCgUoj2mtWvypliqgz3pcJFYff9+UK/bSYpE7osad
         6CiBfXc+0uvFw==
Received: by pali.im (Postfix)
        id 3FA547AE; Wed, 11 Aug 2021 20:04:01 +0200 (CEST)
Date:   Wed, 11 Aug 2021 20:04:01 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     James Carlson <carlsonj@workingcode.com>,
        Chris Fowler <cfowler@outpostsentinel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210811180401.owgmie36ydx62iep@pali>
References: <20210807163749.18316-1-pali@kernel.org>
 <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210809193109.mw6ritfdu27uhie7@pali>
 <20210810153941.GB14279@pc-32.home>
 <BN0P223MB0327A247724B7AE211D2E84EA7F79@BN0P223MB0327.NAMP223.PROD.OUTLOOK.COM>
 <20210810171626.z6bgvizx4eaafrbb@pali>
 <2f10b64e-ba50-d8a5-c40a-9b9bd4264155@workingcode.com>
 <20210811173811.GE15488@pc-32.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210811173811.GE15488@pc-32.home>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 11 August 2021 19:38:11 Guillaume Nault wrote:
> On Tue, Aug 10, 2021 at 02:11:11PM -0400, James Carlson wrote:
> > On 8/10/21 1:16 PM, Pali Rohár wrote:
> > > On Tuesday 10 August 2021 16:38:32 Chris Fowler wrote:
> > > > Isn't the UNIT ID the interface number?  As in 'unit 100' will give me ppp100?
> > > 
> > > If you do not specify pppd 'ifname' argument then pppd argument 'unit 100'
> > > will cause that interface name would be ppp100.
> > > 
> > > But you are free to rename interface to any string which you like, even
> > > to "ppp99".
> > > 
> > > But this ppp unit id is not interface number. Interface number is
> > > another number which has nothing with ppp unit id and is assigned to
> > > every network interface (even loopback). You can see them as the first
> > > number in 'ip -o l' output. Or you can retrieve it via if_nametoindex()
> > > function in C.
> > 
> > Correct; completely unrelated to the notion of "interface index."
> > 
> > > ... So if people are really using pppd's 'unit' argument then I think it
> > > really make sense to support it also in new rtnl interface.
> > 
> > The pppd source base is old.  It dates to the mid-80's.  So it predates not
> > just rename-able interfaces in Linux but Linux itself.
> > 
> > I recall supported platforms in the past (BSD-derived) that didn't support
> > allowing the user to specify the unit number.  In general, on those
> > platforms, the option was accepted and just ignored, and there were either
> > release notes or man page updates (on that platform) that indicated that
> > "unit N" wouldn't work there.
> > 
> > Are there users on Linux who make use of the "unit" option and who would
> > mourn its loss?  Nobody really knows.  It's an ancient feature that was
> > originally intended to deal with systems that couldn't rename interfaces
> > (where one had to make sure that the actual interface selected matched up
> > with pre-configured filtering rules or static routes or the like), and to
> > make life nice for administrators (e.g., making sure that serial port 1 maps
> > to ppp1, port 2 is ppp2, and so on).
> > 
> > I would think and hope most users reach for the more-flexible "ifname"
> > option first, but I certainly can't guarantee it.  It could be buried in a
> > script somewhere or (god forbid) some kind of GUI or "usability" tool.
> > 
> > If I were back at Sun, I'd probably call it suitable only for a "Major"
> > release, as it removes a publicly documented feature.  But I don't know what
> > the considerations are here.  Maybe it's just a "don't really care."
> 
> I'm pretty sure someone, somewhere, would hate us if we broke the
> "unit" option. The old PPP ioctl API has been there for so long,
> there certainly remains tons of old tools, scripts and config files
> that "just work" without anybody left to debug or upgrade them.
> 
> We can't just say, "starting from kernel x.y.z the unit option is a
> noop, use ifname instead" as affected people surely won't get the
> message (and there are other tools beyond pppd that may use this
> kernel API).
> 
> But for the netlink API, we don't have to repeat the same mistake.

ifname is not atomic (first it creates ppp<id> interface and later it is
renamed) and have issues. Due to bug described here:
https://lore.kernel.org/netdev/20210807160050.17687-1-pali@kernel.org/
you may get your kernel into state in which it is not possible to create
a new ppp interface. And this issue does not happen when using "unit"
argument.

To fix above issue it is needed to migrate pppd from ioctl API to rtnl.
But this would be possible only after rtnl API starts providing all
features, including specifying custom "unit" argument...

I hit above problem, so now I'm migrating all pppd setups from "ifname"
to "unit" option.
