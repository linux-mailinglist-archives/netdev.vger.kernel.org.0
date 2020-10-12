Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1626A28C141
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391296AbgJLTL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388013AbgJLTLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 15:11:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8988C0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 12:11:25 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kS3Dz-004KOd-1W; Mon, 12 Oct 2020 21:11:11 +0200
Message-ID: <52f7e2d98ae575f353c6f519065c85ba782168be.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Date:   Mon, 12 Oct 2020 21:10:53 +0200
In-Reply-To: <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201010154119.3537085-1-idosch@idosch.org>
         <20201010154119.3537085-2-idosch@idosch.org>
         <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry, somehow didn't see this until now.

> > +/* Lanes, 1, 2, 4 or 8. */
> > +#define ETHTOOL_LANES_1			1
> > +#define ETHTOOL_LANES_2			2
> > +#define ETHTOOL_LANES_4			4
> > +#define ETHTOOL_LANES_8			8
> 
> Not an extremely useful set of defines, not sure Michal would agree.
> 
> > +#define ETHTOOL_LANES_UNKNOWN		0
> >  struct link_mode_info {
> >  	int				speed;
> > +	int				lanes;
> 
> why signed?
> 
> >  	u8				duplex;
> >  };
> > @@ -274,16 +277,17 @@ const struct nla_policy ethnl_linkmodes_set_policy[] = {
> >  	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
> >  	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
> >  	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_U8 },
> > +	[ETHTOOL_A_LINKMODES_LANES]		= { .type = NLA_U32 },
> 
> NLA_POLICY_VALIDATE_FN(), not sure why the types for this
> validation_type are limited.. Johannes, just an abundance of caution?

So let me see if I got this right - you're saying you'd like to use
NLA_POLICY_VALIDATE_FN() for an NLA_U32, to validate against the _LANES
being 1, 2, 4 or 8?

First of all, you _can_, no? I mean, it's limited by

#define NLA_ENSURE_NO_VALIDATION_PTR(tp)                \
        (__NLA_ENSURE(tp != NLA_BITFIELD32 &&           \
                      tp != NLA_REJECT &&               \
                      tp != NLA_NESTED &&               \
                      tp != NLA_NESTED_ARRAY) + tp)

and the reason is sort of encoded in that - the types listed here
already use the pointer *regardless of the validation_type*, so you
can't have a pointer to the function in the same union.

But not sure I understood :-)

johannes

