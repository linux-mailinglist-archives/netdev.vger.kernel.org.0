Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F9C28C20F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 22:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgJLUIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 16:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgJLUIq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 16:08:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A064A206D4;
        Mon, 12 Oct 2020 20:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602533325;
        bh=9NXc2lIc//PjYXcDjSriqsqtMDlhFxrWqlBvZRYLGqE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VF3jXMCFSXhfEQs/rM+0CeTLWgpunyT2mlpVOCJ51pvHHZuS/s+9rTuXJvjFzfDDL
         yigyxxORPlIXs6OggepNLZi2uNv1AnWK18BTCcnbdJRI4Jgpk69z8AlECz4w2Vjt6g
         hyTr99F7ym8h5jl2GJPev3n/4b1Qes9ysAmeA6Cw=
Date:   Mon, 12 Oct 2020 13:08:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, danieller@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201012130842.5f498631@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <52f7e2d98ae575f353c6f519065c85ba782168be.camel@sipsolutions.net>
References: <20201010154119.3537085-1-idosch@idosch.org>
        <20201010154119.3537085-2-idosch@idosch.org>
        <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <52f7e2d98ae575f353c6f519065c85ba782168be.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 21:10:53 +0200 Johannes Berg wrote:
> Hi,
> 
> Sorry, somehow didn't see this until now.
> 
> > > +/* Lanes, 1, 2, 4 or 8. */
> > > +#define ETHTOOL_LANES_1			1
> > > +#define ETHTOOL_LANES_2			2
> > > +#define ETHTOOL_LANES_4			4
> > > +#define ETHTOOL_LANES_8			8  
> > 
> > Not an extremely useful set of defines, not sure Michal would agree.
> >   
> > > +#define ETHTOOL_LANES_UNKNOWN		0
> > >  struct link_mode_info {
> > >  	int				speed;
> > > +	int				lanes;  
> > 
> > why signed?
> >   
> > >  	u8				duplex;
> > >  };
> > > @@ -274,16 +277,17 @@ const struct nla_policy ethnl_linkmodes_set_policy[] = {
> > >  	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
> > >  	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
> > >  	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_U8 },
> > > +	[ETHTOOL_A_LINKMODES_LANES]		= { .type = NLA_U32 },  
> > 
> > NLA_POLICY_VALIDATE_FN(), not sure why the types for this
> > validation_type are limited.. Johannes, just an abundance of caution?  
> 
> So let me see if I got this right - you're saying you'd like to use
> NLA_POLICY_VALIDATE_FN() for an NLA_U32, to validate against the _LANES
> being 1, 2, 4 or 8?
> 
> First of all, you _can_, no? I mean, it's limited by
> 
> #define NLA_ENSURE_NO_VALIDATION_PTR(tp)                \
>         (__NLA_ENSURE(tp != NLA_BITFIELD32 &&           \
>                       tp != NLA_REJECT &&               \
>                       tp != NLA_NESTED &&               \
>                       tp != NLA_NESTED_ARRAY) + tp)
> 
> and the reason is sort of encoded in that - the types listed here
> already use the pointer *regardless of the validation_type*, so you
> can't have a pointer to the function in the same union.
> 
> But not sure I understood :-)

Yes, you're right. Sorry for the noise, one day I'll learn to read..
