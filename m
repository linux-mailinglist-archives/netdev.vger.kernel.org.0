Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C91214637C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 09:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgAWI20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 03:28:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:56322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgAWI20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 03:28:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9A7C2B1F7;
        Thu, 23 Jan 2020 08:28:24 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 50B5FE06F7; Thu, 23 Jan 2020 09:28:21 +0100 (CET)
Date:   Thu, 23 Jan 2020 09:28:21 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Luigi Rizzo <lrizzo@google.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net-core: remove unnecessary ETHTOOL_GCHANNELS
 initialization
Message-ID: <20200123082821.GS22304@unicorn.suse.cz>
References: <20200122223326.187954-1-lrizzo@google.com>
 <20200122234753.GA13647@lunn.ch>
 <CAMOZA0LiSV2WyzfHuU5=_g0Ru2z-osx0B-WkS-QHMaQeY4GXeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMOZA0LiSV2WyzfHuU5=_g0Ru2z-osx0B-WkS-QHMaQeY4GXeA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 04:18:56PM -0800, Luigi Rizzo wrote:
> On Wed, Jan 22, 2020 at 3:47 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Wed, Jan 22, 2020 at 02:33:26PM -0800, Luigi Rizzo wrote:
> > > struct ethtool_channels does not need .cmd to be set when calling the
> > > driver's ethtool methods. Just zero-initialize it.
> > >
> > > Tested: run ethtool -l and ethtool -L
> >
> > Hi Luigi
> >
> > This seems pretty risky. You are assuming ethtool is the only user of
> > this API. What is actually wrong with putting a sane cmd value, rather
> > than the undefined value 0.
> 
> Hi Andrew, if I understand correctly your suggestion is that even if
> the values are unused, it is better to stay compliant with the header
> file include/uapi/linux/ethtool.h, which does suggest a value for .cmd
> for the various structs

The point is that unless you check ethtool_ops::get_channels() of all in
tree drivers, you cannot be sure there isn't one which depends on .cmd
being set to expected value. And even then there could be some out of
tree drivers; we usually don't care too much about those but it's always
question of what you gain by the cleanup. AFAICS, in this case it might
be few CPU cycles and even that isn't really sure.

> and only replace the value in ethtool_set_channels() with the correct
> one ETHTOOL_SCHANNELS ?

That would be incorrect. In ethtool_set_channels(), the structure
initialized is curr which is used with ->get_channels() to get current
values (for comparison of new values against driver maximum) so that
ETHTOOL_GCHANNELS is the right command.

Michal
