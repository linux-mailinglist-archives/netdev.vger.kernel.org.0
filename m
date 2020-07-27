Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C40D22FC83
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgG0WyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:54:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:46286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0WyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:54:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E050CADE0;
        Mon, 27 Jul 2020 22:54:09 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2634A6073D; Tue, 28 Jul 2020 00:53:59 +0200 (CEST)
Date:   Tue, 28 Jul 2020 00:53:59 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
Subject: Re: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
Message-ID: <20200727225359.hsy4bzmmfvrkw23e@lion.mk-sys.cz>
References: <20200727214700.5915-1-jacob.e.keller@intel.com>
 <20200727222158.bg52mg2mfsta2f37@lion.mk-sys.cz>
 <10bd731c-8286-f62e-19d4-9ee567910392@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10bd731c-8286-f62e-19d4-9ee567910392@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:32:34PM -0700, Jacob Keller wrote:
> On 7/27/2020 3:21 PM, Michal Kubecek wrote:
> > On Mon, Jul 27, 2020 at 02:47:00PM -0700, Jacob Keller wrote:
> >> The ethtool netlink API can send bitsets without an associated bitmask.
> >> These do not get displayed properly, because the dump_link_modes, and
> >> bitset_get_bit to not check whether the provided bitset is a NOMASK
> >> bitset. This results in the inability to display peer advertised link
> >> modes.
> >>
> >> The dump_link_modes and bitset_get_bit functions are designed so they
> >> can print either the values or the mask. For a nomask bitmap, this
> >> doesn't make sense. There is no mask.
> >>
> >> Modify dump_link_modes to check ETHTOOL_A_BITSET_NOMASK. For compact
> >> bitmaps, always check and print the ETHTOOL_A_BITSET_VALUE bits,
> >> regardless of the request to display the mask or the value. For full
> >> size bitmaps, the set of provided bits indicates the valid values,
> >> without using ETHTOOL_A_BITSET_VALUE fields. Thus, do not skip printing
> >> bits without this attribute if nomask is set. This essentially means
> >> that dump_link_modes will treat a NOMASK bitset as having a mask
> >> equivalent to all of its set bits.
> >>
> >> For bitset_get_bit, also check for ETHTOOL_A_BITSET_NOMASK. For compact
> >> bitmaps, always use ETHTOOL_A_BITSET_BIT_VALUE as in dump_link_modes.
> >> For full bitmaps, if nomask is set, then always return true of the bit
> >> is in the set, rather than only if it provides an
> >> ETHTOOL_A_BITSET_BIT_VALUE. This will then correctly report the set
> >> bits.
> >>
> >> This fixes display of link partner advertised fields when using the
> >> netlink API.
> >>
> >> Reported-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
> >> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> >> ---
> >>  netlink/bitset.c   | 9 ++++++---
> >>  netlink/settings.c | 8 +++++---
> >>  2 files changed, 11 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/netlink/bitset.c b/netlink/bitset.c
> >> index 130bcdb5b52c..ba5d3ea77ff7 100644
> >> --- a/netlink/bitset.c
> >> +++ b/netlink/bitset.c
> >> @@ -50,6 +50,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
> >>  	DECLARE_ATTR_TB_INFO(bitset_tb);
> >>  	const struct nlattr *bits;
> >>  	const struct nlattr *bit;
> >> +	bool nomask;
> >>  	int ret;
> >>  
> >>  	*retptr = 0;
> >> @@ -57,8 +58,10 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
> >>  	if (ret < 0)
> >>  		goto err;
> >>  
> >> -	bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
> >> -		      bitset_tb[ETHTOOL_A_BITSET_VALUE];
> >> +	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
> >> +
> >> +	bits = mask && !nomask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
> >> +		                 bitset_tb[ETHTOOL_A_BITSET_VALUE];
> >>  	if (bits) {
> >>  		const uint32_t *bitmap =
> >>  			(const uint32_t *)mnl_attr_get_payload(bits);
> > 
> > I don't like this part: (mask && nomask) is a situation which should
> > never happen as it would mean we are trying to get mask value from
> > a bitmap which does not any. In other words, if we ever see such
> > combination, it is a result of a bug either on ethtool side or on kernel
> > side.
> > 
> > Rather than silently returning something else than asked, we should
> > IMHO report an error. Which is easy in dump_link_modes() but it would
> > require rewriting bitset_get_bit().
> > 
> > Michal
> 
> The "mask" boolean is an indication that you want to print the mask for
> a bitmap, rather than its value. I think treating a bitmap without a
> predefined mask to have its mask be equivalent to its values is
> reasonable.

It depends on the context. In requests, value=0x1,mask=0x1 means "set
bit 0 and leave the rest untouched" while nomask bitmap with value=0x1
would mean "set bit 0 and clear the rest".

For kernel replies, it should be documented which variant is expected.

>             However, I could see the argument for not wanting this since
> it is effectively a bug somewhere.

We actually had this kind of bug in FEC modes handling as we just found.

Michal

> For dump_link_modes, it is trivial. If nomask is set, and mask is
> requested, bail out of the function. It looks like we can also report an
> error for the bitset_get_bit too. I'll take a look closer.
> 
> Thanks,
> Jake
