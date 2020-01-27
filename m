Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3048E149EEE
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 07:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgA0GIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 01:08:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:45352 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgA0GIi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 01:08:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4D1A7AF83;
        Mon, 27 Jan 2020 06:08:36 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 62125E0B78; Mon, 27 Jan 2020 07:08:35 +0100 (CET)
Date:   Mon, 27 Jan 2020 07:08:35 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200127060835.GA570@unicorn.suse.cz>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal>
 <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal>
 <31c6c46a-63b2-6397-5c75-5671ee8d41c3@pensando.io>
 <20200126212424.GD3870@unreal>
 <0755f526-73cb-e926-2785-845fec0f51dd@pensando.io>
 <20200126222253.GX22304@unicorn.suse.cz>
 <b05ea7dd-d985-66b5-07c6-9c1d7ba74429@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b05ea7dd-d985-66b5-07c6-9c1d7ba74429@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 02:57:21PM -0800, Shannon Nelson wrote:
> On 1/26/20 2:22 PM, Michal Kubecek wrote:
> > On Sun, Jan 26, 2020 at 02:12:38PM -0800, Shannon Nelson wrote:
> > > Part of the pain of supporting our users is getting them to give us useful
> > > information about their problem.  The more commands I need them to run to
> > > get information about the environment, the less likely I will get anything
> > > useful.  We've been training our users over the years to use "ethtool -i" to
> > > get a good chunk of that info, with the knowledge that the driver version is
> > > only a hint, based upon the distro involved.  I don't want to lose that
> > > hint.  If anything, I'd prefer that we added a field for UTS_RELEASE in the
> > > ethtool output, but I know that's too much to ask.
> > 
> > At the same time, I've been trying to explain both our L1/L2 support
> > guys and our customers that "driver version" information reported by
> > "ethtool -i" is almost useless and that if they really want to identify
> > driver version, they should rather use srcversion as reported by modinfo
> > or sysfs.
> 
> So as I suggested elsewhere, can we compromise by not bashing the driver
> string in the caller stack, but require the in-kernel drivers to use a
> particular macro that will put the kernel/git version into the string?  This
> allows out-of-tree drivers the option of overriding the version with some
> other string that can be meaningful in any other given old or new distro
> kernel.  This should be easy to enforce mechanically with checkpatch, and
> easy enough to do a sweeping coccinelle change on the existing drivers.

Personally, I rather liked what Jakub suggested earlier: set
ethtool_drvinfo::version to kernel version before ops->get_drvinfo() is called
in ethtool_get_drvinfo() (and its netlink counterpart once we get some
consensus about what information should be in the message), clean up in-tree
drivers so that they don't touch it and add a coccinelle check so that we keep
in-tree drivers compliant; this would allow out-of-tree drivers to overwrite
ethtool_drvinfo::version with whatever they want.

Michal
