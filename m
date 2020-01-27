Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEFD149F10
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 07:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgA0Gn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 01:43:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgA0Gn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 01:43:28 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCFB72071E;
        Mon, 27 Jan 2020 06:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580107407;
        bh=6OHYWclefkhj8HG11dN6ImAke1O53qn0FM/jsZOMjKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p5R/J2+atwgg/Q1VFmhIRn1H8G2048X8ehWu9B9mYq4uYlV9BJnvvReijPi8qO/hl
         gjhW2j18Jh7G9Zz3lMLfeXLt4Ns9kmjhdXbwLWoi3PVpkmwKd7E5cz2HpEDlKbbSrd
         fVH+0ePd0WZAc6D6XwwYMKqbToqTKxGSKaFasmEo=
Date:   Mon, 27 Jan 2020 08:42:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200127064258.GI3870@unreal>
References: <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal>
 <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal>
 <31c6c46a-63b2-6397-5c75-5671ee8d41c3@pensando.io>
 <20200126212424.GD3870@unreal>
 <0755f526-73cb-e926-2785-845fec0f51dd@pensando.io>
 <20200126222253.GX22304@unicorn.suse.cz>
 <b05ea7dd-d985-66b5-07c6-9c1d7ba74429@pensando.io>
 <20200127060835.GA570@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200127060835.GA570@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 07:08:35AM +0100, Michal Kubecek wrote:
> On Sun, Jan 26, 2020 at 02:57:21PM -0800, Shannon Nelson wrote:
> > On 1/26/20 2:22 PM, Michal Kubecek wrote:
> > > On Sun, Jan 26, 2020 at 02:12:38PM -0800, Shannon Nelson wrote:
> > > > Part of the pain of supporting our users is getting them to give us useful
> > > > information about their problem.  The more commands I need them to run to
> > > > get information about the environment, the less likely I will get anything
> > > > useful.  We've been training our users over the years to use "ethtool -i" to
> > > > get a good chunk of that info, with the knowledge that the driver version is
> > > > only a hint, based upon the distro involved.  I don't want to lose that
> > > > hint.  If anything, I'd prefer that we added a field for UTS_RELEASE in the
> > > > ethtool output, but I know that's too much to ask.
> > >
> > > At the same time, I've been trying to explain both our L1/L2 support
> > > guys and our customers that "driver version" information reported by
> > > "ethtool -i" is almost useless and that if they really want to identify
> > > driver version, they should rather use srcversion as reported by modinfo
> > > or sysfs.
> >
> > So as I suggested elsewhere, can we compromise by not bashing the driver
> > string in the caller stack, but require the in-kernel drivers to use a
> > particular macro that will put the kernel/git version into the string?  This
> > allows out-of-tree drivers the option of overriding the version with some
> > other string that can be meaningful in any other given old or new distro
> > kernel.  This should be easy to enforce mechanically with checkpatch, and
> > easy enough to do a sweeping coccinelle change on the existing drivers.
>
> Personally, I rather liked what Jakub suggested earlier: set
> ethtool_drvinfo::version to kernel version before ops->get_drvinfo() is called
> in ethtool_get_drvinfo() (and its netlink counterpart once we get some
> consensus about what information should be in the message), clean up in-tree
> drivers so that they don't touch it and add a coccinelle check so that we keep
> in-tree drivers compliant; this would allow out-of-tree drivers to overwrite
> ethtool_drvinfo::version with whatever they want.

It works for MODULE_VERSION(), so I don't see any reason to have different
solution for the same value for ethtool.

For example, ib_core module doesn't have MODULE_VERSION() string.
[leonro@server ~]$ modinfo ib_core
filename:       /lib/modules/5.5.0-rc6/modules/ib_core.ko
<...>
intree:         Y
name:           ib_core
vermagic:       5.5.0-rc6 SMP mod_unload modversions
<...>

Thanks

>
> Michal
