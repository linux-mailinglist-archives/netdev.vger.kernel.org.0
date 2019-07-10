Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B0764886
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfGJOiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:38:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:50462 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726380AbfGJOiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 10:38:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0F932AEA1;
        Wed, 10 Jul 2019 14:37:58 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4215BE0E06; Wed, 10 Jul 2019 16:37:55 +0200 (CEST)
Date:   Wed, 10 Jul 2019 16:37:55 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
Message-ID: <20190710143755.GC5700@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
 <20190703114933.GW2250@nanopsycho>
 <20190703181851.GP20101@unicorn.suse.cz>
 <20190704080435.GF2250@nanopsycho>
 <20190704115236.GR20101@unicorn.suse.cz>
 <20190709141817.GE2301@nanopsycho.orion>
 <20190710123803.GB5700@unicorn.suse.cz>
 <20190710125943.GC2291@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710125943.GC2291@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 02:59:43PM +0200, Jiri Pirko wrote:
> Wed, Jul 10, 2019 at 02:38:03PM CEST, mkubecek@suse.cz wrote:
> >On Tue, Jul 09, 2019 at 04:18:17PM +0200, Jiri Pirko wrote:
> >> 
> >> I understand. So how about avoid the bitfield all together and just
> >> have array of either bits of strings or combinations?
> >> 
> >> ETHTOOL_CMD_SETTINGS_SET (U->K)
> >>     ETHTOOL_A_HEADER
> >>         ETHTOOL_A_DEV_NAME = "eth3"
> >>     ETHTOOL_A_SETTINGS_PRIV_FLAGS
> >>        ETHTOOL_A_SETTINGS_PRIV_FLAG
> >>            ETHTOOL_A_FLAG_NAME = "legacy-rx"
> >> 	   ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
> >> 
> >> or the same with index instead of string
> >> 
> >> ETHTOOL_CMD_SETTINGS_SET (U->K)
> >>     ETHTOOL_A_HEADER
> >>         ETHTOOL_A_DEV_NAME = "eth3"
> >>     ETHTOOL_A_SETTINGS_PRIV_FLAGS
> >>         ETHTOOL_A_SETTINGS_PRIV_FLAG
> >>             ETHTOOL_A_FLAG_INDEX = 0
> >>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
> >> 
> >> 
> >> For set you can combine both when you want to set multiple bits:
> >> 
> >> ETHTOOL_CMD_SETTINGS_SET (U->K)
> >>     ETHTOOL_A_HEADER
> >>         ETHTOOL_A_DEV_NAME = "eth3"
> >>     ETHTOOL_A_SETTINGS_PRIV_FLAGS
> >>         ETHTOOL_A_SETTINGS_PRIV_FLAG
> >>             ETHTOOL_A_FLAG_INDEX = 2
> >>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
> >>         ETHTOOL_A_SETTINGS_PRIV_FLAG
> >>             ETHTOOL_A_FLAG_INDEX = 8
> >>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
> >>         ETHTOOL_A_SETTINGS_PRIV_FLAG
> >>             ETHTOOL_A_FLAG_NAME = "legacy-rx"
> >>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
> >> 
> >> 
> >> For get this might be a bit bigger message:
> >> 
> >> ETHTOOL_CMD_SETTINGS_GET_REPLY (K->U)
> >>     ETHTOOL_A_HEADER
> >>         ETHTOOL_A_DEV_NAME = "eth3"
> >>     ETHTOOL_A_SETTINGS_PRIV_FLAGS
> >>         ETHTOOL_A_SETTINGS_PRIV_FLAG
> >>             ETHTOOL_A_FLAG_INDEX = 0
> >>             ETHTOOL_A_FLAG_NAME = "legacy-rx"
> >>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
> >>         ETHTOOL_A_SETTINGS_PRIV_FLAG
> >>             ETHTOOL_A_FLAG_INDEX = 1
> >>             ETHTOOL_A_FLAG_NAME = "vf-ipsec"
> >>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
> >>         ETHTOOL_A_SETTINGS_PRIV_FLAG
> >>             ETHTOOL_A_FLAG_INDEX = 8
> >>             ETHTOOL_A_FLAG_NAME = "something-else"
> >>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
> >
> >This is perfect for "one shot" applications but not so much for long
> >running ones, either "ethtool --monitor" or management or monitoring
> >daemons. Repeating the names in every notification message would be
> >a waste, it's much more convenient to load the strings only once and
> 
> Yeah, for those aplications, the ETHTOOL_A_FLAG_NAME could be omitted
> 
> 
> >cache them. Even if we omit the names in notifications (and possibly the
> >GET replies if client opts for it), this format still takes 12-16 bytes
> >per bit.
> >
> >So the problem I'm trying to address is that there are two types of
> >clients with very different mode of work and different preferences.
> >
> >Looking at the bitset.c, I would rather say that most of the complexity
> >and ugliness comes from dealing with both unsigned long based bitmaps
> >and u32 based ones. Originally, there were functions working with
> >unsigned long based bitmaps and the variants with "32" suffix were
> >wrappers around them which converted u32 bitmaps to unsigned long ones
> >and back. This became a problem when kernel started issuing warnings
> >about variable length arrays as getting rid of them meant two kmalloc()
> >and two kfree() for each u32 bitmap operation, even if most of the
> >bitmaps are in rather short in practice.
> >
> >Maybe the wrapper could do something like
> >
> >int ethnl_put_bitset32(const u32 *value, const u32 *mask,
> >		       unsigned int size,  ...)
> >{
> >	unsigned long fixed_value[2], fixed_mask[2];
> >	unsigned long *tmp_value = fixed_value;
> >	unsigned long *tmp_mask = fixed_mask;
> >
> >	if (size > sizeof(fixed_value) * BITS_PER_BYTE) {
> >		tmp_value = bitmap_alloc(size);
> >		if (!tmp_value)
> >			return -ENOMEM;
> >		tmp_mask = bitmap_alloc(size);
> >		if (!tmp_mask) {
> >			kfree(tmp_value);
> >			return -ENOMEM;
> >		}
> >	}
> >
> >	bitmap_from_arr32(tmp_value, value, size);
> >	bitmap_from_arr32(tmp_mask, mask, size);
> >	ret = ethnl_put_bitset(tmp_value, tmp_mask, size, ...);
> >}
> >
> >This way we would make bitset.c code cleaner while avoiding allocating
> >short bitmaps (which is the most common case). 
> 
> I'm primarily concerned about the uapi. Plus if the uapi approach is united
> for both index and string, we can omit this whole bitset abomination...

I'm afraid I don't understand this comment. Whatever the representation
of bitmaps (both simple bitmaps and value/mask pairs) is going to be, we
will need a function for parsing them (currently ethnl_update_bitset())
and a function for filling them into the message (currently
ethnl_put_bitset()). Unless you are suggesting to write a copy of
essentially the same parser and composer for each of the bitsets (there
is 15 of them at the already and 4 NLA_BITFIELD32 attributes which I'm
seriously considering to replace with arbitrary length bitsets as well
to make the UAPI as future proof as possible).

After all, what you suggested above is exactly the same structure as my
bitset in verbose form, except you omit size (which is a problem, as
discussed in other part of the thread) and put the contents of BITS
container directly under the main container.

Michal
