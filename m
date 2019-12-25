Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FAE12A7A3
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 12:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfLYLHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 06:07:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:60808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbfLYLHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Dec 2019 06:07:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4B01AB269;
        Wed, 25 Dec 2019 11:07:29 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3FE15E008B; Wed, 25 Dec 2019 12:07:26 +0100 (CET)
Date:   Wed, 25 Dec 2019 12:07:26 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v8 02/14] ethtool: helper functions for netlink
 interface
Message-ID: <20191225110726.GJ21614@unicorn.suse.cz>
References: <cover.1577052887.git.mkubecek@suse.cz>
 <8cbb9c250caf021f600032ad4aa32c44adf0b8e9.1577052887.git.mkubecek@suse.cz>
 <921763be-9f8d-5f2d-18a3-400c9ac98797@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <921763be-9f8d-5f2d-18a3-400c9ac98797@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 08:08:55PM -0800, Florian Fainelli wrote:
> 
> 
> On 12/22/2019 3:45 PM, Michal Kubecek wrote:
> > Add common request/reply header definition and helpers to parse request
> > header and fill reply header. Provide ethnl_update_* helpers to update
> > structure members from request attributes (to be used for *_SET requests).
> > 
> > Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> > ---
> 
> [snip]
> 
> > +/**
> > + * ethnl_update_u32() - update u32 value from NLA_U32 attribute
> > + * @dst:  value to update
> > + * @attr: netlink attribute with new value or null
> > + * @mod:  pointer to bool for modification tracking
> > + *
> > + * Copy the u32 value from NLA_U32 netlink attribute @attr into variable
> > + * pointed to by @dst; do nothing if @attr is null. Bool pointed to by @mod
> > + * is set to true if this function changed the value of *dst, otherwise it
> > + * is left as is.
> > + */
> 
> I would find it more intuitive if an integer was returned: < 0 in case
> of error, 0 if no change and 1 if something changed.

This trick allows simpler code on caller side when we update multiple
values in a structure - we don't have to check each return value
separately (most update helpers cannot fail). It was a suggestion from
Jiri Pirko in one of earlier discussions.
 
> > +static inline void ethnl_update_u32(u32 *dst, const struct nlattr *attr,
> > +				    bool *mod)
> > +{
> > +	u32 val;
> > +
> > +	if (!attr)
> > +		return;
> > +	val = nla_get_u32(attr);
> > +	if (*dst == val)
> > +		return;
> > +
> > +	*dst = val;
> > +	*mod = true;
> > +}
> > +
> > +/**
> > + * ethnl_update_u8() - update u8 value from NLA_U8 attribute
> > + * @dst:  value to update
> > + * @attr: netlink attribute with new value or null
> > + * @mod:  pointer to bool for modification tracking
> > + *
> > + * Copy the u8 value from NLA_U8 netlink attribute @attr into variable
> > + * pointed to by @dst; do nothing if @attr is null. Bool pointed to by @mod
> > + * is set to true if this function changed the value of *dst, otherwise it
> > + * is left as is.
> > + */
> > +static inline void ethnl_update_u8(u8 *dst, const struct nlattr *attr,
> > +				   bool *mod)
> > +{
> > +	u8 val;
> > +
> > +	if (!attr)
> > +		return;
> > +	val = nla_get_u32(attr);
> 
> Should not this be nla_get_u8() here? This sounds like it is going to
> break on BE machines.

Good catch, thank you. I originally wanted to use NLA_U32 for all
numeric values (as NLA_U8 and NLA_U16 don't save any space anyway) but
then changed those in LINKINFO_GET request to NLA_U8 and forgot to fix
the helper function.

I'll fix this in v9.

Michal
