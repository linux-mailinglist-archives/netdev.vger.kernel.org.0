Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD19285A8F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 10:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgJGIdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 04:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgJGIdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 04:33:50 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A0BD2076C;
        Wed,  7 Oct 2020 08:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602059629;
        bh=QZJsdeR6kkzL7jdIlnzqgGYorHeaWfRE51jVL1thrbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dind4c0kyj5VY5lhUctxSDaA7SbxcT7eaRgGX14lTbUf6sdc3of97orwPK6fMOmep
         XvMMeV8kI6QQQbQGbAknhb3ySNUsj+nX1Yu3Mtlhq79XwER92qdN14qVlF4q4tckMf
         d8KVEeZcH5JuGPQ6pO3JSbTChOL4NeTdcJXJDamg=
Date:   Wed, 7 Oct 2020 11:33:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v2 0/7] ethtool: allow dumping policies to user
 space
Message-ID: <20201007083345.GW1874917@unreal>
References: <20201005220739.2581920-1-kuba@kernel.org>
 <7586c9e77f6aa43e598103ccc25b43415752507d.camel@sipsolutions.net>
 <20201006.062618.628708952352439429.davem@davemloft.net>
 <20201007062754.GU1874917@unreal>
 <cf5fdfa13cce37fe7dcf46a4e3a113a64c927047.camel@sipsolutions.net>
 <20201007082437.GV1874917@unreal>
 <7f26de5605d4d19eda19f35b2a239d7098fad7b3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f26de5605d4d19eda19f35b2a239d7098fad7b3.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 10:29:01AM +0200, Johannes Berg wrote:
> On Wed, 2020-10-07 at 11:24 +0300, Leon Romanovsky wrote:
> > On Wed, Oct 07, 2020 at 09:30:51AM +0200, Johannes Berg wrote:
> > > On Wed, 2020-10-07 at 09:27 +0300, Leon Romanovsky wrote:
> > > > This series and my guess that it comes from ff419afa4310 ("ethtool: trim policy tables")
> > > > generates the following KASAN out-of-bound error.
> > >
> > > Interesting. I guess that is
> > >
> > > 	req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
> > >
> > > which basically means that before you never actually *use* the
> > > ETHTOOL_A_STRSET_COUNTS_ONLY flag, but of course it shouldn't be doing
> > > this ...
> > >
> > > Does this fix it?
> >
> > Yes, it fixed KASAN, but it we got new failure after that.
>
> Good.
>
> I'm not very familiar with ethtool netlink tbh :)
>
> > 11:07:51 player_id: 1 shell.py:62 [LinuxEthtoolAgent] DEBUG : running command(/opt/mellanox/ethtool/sbin/ethtool --set-channels eth2 combined 3) with pid: 13409
> > 11:07:51 player_id: 1 protocol.py:605 [OpSetChannels] ERROR : RC:1, STDERR:
> > netlink error: Unknown attribute type (offset 36)
> > netlink error: Invalid argument
>
> That's even stranger, since strict validation should've meant this was
> always rejected? Hmm.
>
> Oh, copy/paste error I guess, try this:

I'm trying it now and will update in the next hour.

Thanks
