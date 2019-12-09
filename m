Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D4F1177AD
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 21:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfLIUpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 15:45:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:35098 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726509AbfLIUpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 15:45:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 118DCAC45;
        Mon,  9 Dec 2019 20:45:47 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 449CEE0321; Mon,  9 Dec 2019 21:45:46 +0100 (CET)
Date:   Mon, 9 Dec 2019 21:45:46 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] ethtool: provide link mode names as a
 string set
Message-ID: <20191209204546.GB31047@unicorn.suse.cz>
References: <cover.1575920565.git.mkubecek@suse.cz>
 <0c239334df943c3f5f4ca74a2509754e08eda9e3.1575920565.git.mkubecek@suse.cz>
 <20191209201511.GL9099@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209201511.GL9099@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 09:15:11PM +0100, Andrew Lunn wrote:
> On Mon, Dec 09, 2019 at 08:55:45PM +0100, Michal Kubecek wrote:
> > Unlike e.g. netdev features, the ethtool ioctl interface requires link mode
> > table to be in sync between kernel and userspace for userspace to be able
> > to display and set all link modes supported by kernel. The way arbitrary
> > length bitsets are implemented in netlink interface, this will be no longer
> > needed.
> > 
> > To allow userspace to access all link modes running kernel supports, add
> > table of ethernet link mode names and make it available as a string set to
> > userspace GET_STRSET requests. Add build time check to make sure names
> > are defined for all modes declared in enum ethtool_link_mode_bit_indices.
> 
> Hi Michal
> 
> Having a build time check is a good idea. However, i don't see it in
> the code. Please could you point it out.

Thanks for noticing. The BUILD_BUG_ON() check got lost when I moved the
patch to an earlier place and changed the declaration to fixed size
array like other name tables have. But you are right, losing the check
would be too high price for the uniformity.

> > +#define __LINK_MODE_NAME(speed, type, duplex) \
> > +	#speed "base" #type "/" #duplex
> > +#define __DEFINE_LINK_MODE_NAME(speed, type, duplex) \
> > +	[ETHTOOL_LINK_MODE(speed, type, duplex)] = \
> > +	__LINK_MODE_NAME(speed, type, duplex)
> > +#define __DEFINE_SPECIAL_MODE_NAME(_mode, _name) \
> > +	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] = _name
> > +
> > +const char
> > +link_mode_names[__ETHTOOL_LINK_MODE_MASK_NBITS][ETH_GSTRING_LEN] = {
> > +	__DEFINE_LINK_MODE_NAME(10, T, Half),
> > +	__DEFINE_LINK_MODE_NAME(10, T, Full),
> > +	__DEFINE_LINK_MODE_NAME(100, T, Half),
> > +	__DEFINE_LINK_MODE_NAME(100, T, Full),
> > +	__DEFINE_LINK_MODE_NAME(1000, T, Half),
> > +	__DEFINE_LINK_MODE_NAME(1000, T, Full),
> > +	__DEFINE_SPECIAL_MODE_NAME(Autoneg, "Autoneg"),
> > +	__DEFINE_SPECIAL_MODE_NAME(TP, "TP"),
> > +	__DEFINE_SPECIAL_MODE_NAME(AUI, "AUI"),
> > +	__DEFINE_SPECIAL_MODE_NAME(MII, "MII"),
> > +	__DEFINE_SPECIAL_MODE_NAME(FIBRE, "FIBRE"),
> > +	__DEFINE_SPECIAL_MODE_NAME(BNC, "BNC"),
> > +	__DEFINE_LINK_MODE_NAME(10000, T, Full),
> > +	__DEFINE_SPECIAL_MODE_NAME(Pause, "Pause"),
> > +	__DEFINE_SPECIAL_MODE_NAME(Asym_Pause, "Asym_Pause"),
> > +	__DEFINE_LINK_MODE_NAME(2500, X, Full),
> > +	__DEFINE_SPECIAL_MODE_NAME(Backplane, "Backplane"),
> > +	__DEFINE_LINK_MODE_NAME(1000, KX, Full),
> > +	__DEFINE_LINK_MODE_NAME(10000, KX4, Full),
> > +	__DEFINE_LINK_MODE_NAME(10000, KR, Full),
> > +	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = "10000baseR_FEC",
> 
> Would
> 
> __DEFINE_SPECIAL_MODE_NAME(10000baseR_FEC, 10000baseR_FEC),
> 
> work here?

Right, it would (with double quotes for second argument). As I wrote the
macro for bits which don't represent actual link modes, it never occured
to me that it can be also used for this special case.

I'll wait until tomorrow to see if there are more comments and send v2.

Michal
