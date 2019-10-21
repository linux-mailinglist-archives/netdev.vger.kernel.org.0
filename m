Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54943DE52F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 09:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfJUHSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 03:18:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:48528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726480AbfJUHSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 03:18:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CBF8DB311;
        Mon, 21 Oct 2019 07:18:17 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id DEC0DE3C6D; Mon, 21 Oct 2019 09:18:15 +0200 (CEST)
Date:   Mon, 21 Oct 2019 09:18:15 +0200
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
Subject: Re: [PATCH net-next v7 06/17] ethtool: netlink bitset handling
Message-ID: <20191021071815.GE27784@unicorn.suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <af208e79258e7e3c3af3860e6a8908a50dec095f.1570654310.git.mkubecek@suse.cz>
 <20191011133429.GA3056@nanopsycho>
 <20191014111847.GB8493@unicorn.suse.cz>
 <20191014130205.GA2314@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014130205.GA2314@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 03:02:05PM +0200, Jiri Pirko wrote:
> Mon, Oct 14, 2019 at 01:18:47PM CEST, mkubecek@suse.cz wrote:
> >On Fri, Oct 11, 2019 at 03:34:29PM +0200, Jiri Pirko wrote:
> >> Wed, Oct 09, 2019 at 10:59:18PM CEST, mkubecek@suse.cz wrote:
> >> >+Bit sets
> >> >+========
> >> >+
> >> >+For short bitmaps of (reasonably) fixed length, standard ``NLA_BITFIELD32``
> >> >+type is used. For arbitrary length bitmaps, ethtool netlink uses a nested
> >> >+attribute with contents of one of two forms: compact (two binary bitmaps
> >> >+representing bit values and mask of affected bits) and bit-by-bit (list of
> >> >+bits identified by either index or name).
> >> >+
> >> >+Compact form: nested (bitset) atrribute contents:
> >> >+
> >> >+  ============================  ======  ============================
> >> >+  ``ETHTOOL_A_BITSET_LIST``     flag    no mask, only a list
> >> 
> >> I find "list" a bit confusing name of a flag. Perhaps better to stick
> >> with the "compact" terminology and make this "ETHTOOL_A_BITSET_COMPACT"?
> >> Then in the code you can have var "is_compact", which makes the code a
> >> bit easier to read I believe.
> >
> >This is not the same as "compact", "list" flag means that the bit set
> >does not represent a value/mask pair but only a single bitmap (which can
> >be understood as a list or subset of possible values).
> 
> Okay, this is confusing. So you say that the "LIST" may be on and
> ETHTOOL_A_BITSET_VALUE present, but ETHTOOL_A_BITSET_MASK not?
> I thought that whtn "LIST" is on, no "VALUE" nor "MASK" should be here.
> 
> >This saves some space in kernel replies where there is no natural mask
> >so that we would have to invent one (usually all possible bits) but it
> 
> Do you have an example?

E.g. peer advertised link modes or the four bitmaps returned in reply to
query for netdev features (replacement for ETHTOOL_GFEATURES).

> >is more important in request where some request want to modify a subset
> >of bits (set some, unset some) while some requests pass a list of bits
> >to be set after the operation (i.e. "I want exactly these to be
> >enabled").
> 
> Hmm, it's a different type of bitset then. Wouldn't it be better to have
> ETHTOOL_A_BITSET_TYPE
> and enum:
> ETHTOOL_A_BITSET_TYPE_LIST
> ETHTOOL_A_BITSET_TYPE_MASKED
> or something like that?
> Or maybe just NLA_FLAG called "MASKED". I don't know, "list" has a
> specific meaning and this isn't that...

"MASKED" sounds fine to me. After all, there is a good chance there will
be more cases when bitset without mask will be returned so that it would
be natural to see unmasked bitmaps as default and value/mask pairs as
something special.

> >> B) Why don't you do bitmap_to_arr32 conversion in this function just
> >>    before val/mask put. Then you can use normal test_bit() here.
> >
> >This relates to the question (below) why we need two versions of the
> >functions, one for unsigned long based bitmaps, one for u32 based ones.
> >The reason is that both are used internally by existing code. So if we
> >had only one set of bitset functions, callers using the other format
> >would have to do the wrapping themselves.
> >
> >There are two reasons why u32 versions are implemented directly and
> >usingned long ones as wrappers. First, u32 based bitmaps are more
> >frequent in existing code. Second, when we can get away with a cast
> >(i.e. anywhere exect 64-bit big endian), unsigned long based bitmap can
> >be always interpreted as u32 based bitmap but if we tried it the other
> >way, we would need a special handling of the last word when the number
> >of 32-bit words is odd.
> 
> Okay. Perhaps you can add it as a comment so it is clear what is going
> on?

OK

Michal
