Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA4F1FFC71
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgFRUZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:25:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:38992 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbgFRUZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 16:25:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4A2CBACCE;
        Thu, 18 Jun 2020 20:25:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 39F5260389; Thu, 18 Jun 2020 22:25:26 +0200 (CEST)
Date:   Thu, 18 Jun 2020 22:25:26 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        kernel-team@fb.com, axboe@kernel.dk,
        Govindarajulu Varadarajan <gvaradar@cisco.com>
Subject: Re: [RFC PATCH 06/21] mlx5: add header_split flag
Message-ID: <20200618202526.zcbuzzxtln2ljawn@lion.mk-sys.cz>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
 <20200618160941.879717-7-jonathan.lemon@gmail.com>
 <4b0e0916-2910-373c-82cf-d912a82502a4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b0e0916-2910-373c-82cf-d912a82502a4@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 11:12:57AM -0700, Eric Dumazet wrote:
> On 6/18/20 9:09 AM, Jonathan Lemon wrote:
> > Adds a "rx_hd_split" private flag parameter to ethtool.
> > 
> > This enables header splitting, and sets up the fragment mappings.
> > The feature is currently only enabled for netgpu channels.
> 
> We are using a similar idea (pseudo header split) to implement 4096+(headers) MTU at Google,
> to enable TCP RX zerocopy on x86.
> 
> Patch for mlx4 has not been sent upstream yet.
> 
> For mlx4, we are using a single buffer of 128*(number_of_slots_per_RX_RING),
> and 86 bytes for the first frag, so that the payload exactly fits a 4096 bytes page.
> 
> (In our case, most of our data TCP packets only have 12 bytes of TCP options)
> 
> I suggest that instead of a flag, you use a tunable, that can be set by ethtool,
> so that the exact number of bytes can be tuned, instead of hard coded in the driver.

I fully agree that such generic parameter would be a better solution
than a private flag. But I have my doubts about adding more tunables.
The point is that the concept of tunables looks like a workaround for
the lack of extensibility of the ioctl interface where the space for
adding new parameters to existing subcommands was limited (or none).

With netlink, adding new parameters is much easier and as only three
tunables were added in 6 years (or four with your proposal), we don't
have to worry about having too many different attributes (current code
isn't even designed to scale well to many tunables).

This new header split parameter could IMHO be naturally put together
with rx-copybreak and tx-copybreak and possibly any future parameters
to control how packet contents is passed between NIC/driver and
networking stack.

> (Patch for the counter part of [1] was resent 10 days ago on netdev@ by Govindarajulu Varadarajan)
> (Not sure if this has been merged yet)

Not yet, I want to take another look in the rest of this week.

Michal

> [1]
> 
> commit f0db9b073415848709dd59a6394969882f517da9
> Author: Govindarajulu Varadarajan <_govind@gmx.com>
> Date:   Wed Sep 3 03:17:20 2014 +0530
> 
>     ethtool: Add generic options for tunables
>     
>     This patch adds new ethtool cmd, ETHTOOL_GTUNABLE & ETHTOOL_STUNABLE for getting
>     tunable values from driver.
>     
>     Add get_tunable and set_tunable to ethtool_ops. Driver implements these
>     functions for getting/setting tunable value.
>     
>     Signed-off-by: Govindarajulu Varadarajan <_govind@gmx.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
