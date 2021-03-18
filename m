Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6034088D
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 16:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCRPQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 11:16:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:34432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229960AbhCRPQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 11:16:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 651C9AD86;
        Thu, 18 Mar 2021 15:16:12 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E39E060753; Thu, 18 Mar 2021 16:16:11 +0100 (CET)
Date:   Thu, 18 Mar 2021 16:16:11 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Don Bollinger <don@thebollingers.org>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <20210318151611.hlfafz6hpbozof5v@lion.mk-sys.cz>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
 <1615828363-464-2-git-send-email-moshe@nvidia.com>
 <YFNPhvelhxg4+5Cl@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFNPhvelhxg4+5Cl@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 02:03:02PM +0100, Andrew Lunn wrote:
> On Mon, Mar 15, 2021 at 07:12:39PM +0200, Moshe Shemesh wrote:
> >  
> > +EEPROM_DATA
> > +===========
> > +
> > +Fetch module EEPROM data dump.
> > +
> > +Request contents:
> > +
> > +  =====================================  ======  ==========================
> > +  ``ETHTOOL_A_EEPROM_DATA_HEADER``       nested  request header
> > +  ``ETHTOOL_A_EEPROM_DATA_OFFSET``       u32     offset within a page
> > +  ``ETHTOOL_A_EEPROM_DATA_LENGTH``       u32     amount of bytes to read
> 
> I wonder if offset and length should be u8. At most, we should only be
> returning a 1/2 page, so 128 bytes. We don't need a u32.

There is no actual gain using NLA_U8 due to padding. Out of the
interfaces used here, kernel-userspace API is the least flexible so
I would generally prefer NLA_U32, except for bools or enumerated values
where it's absolutely obvious the number of possible values cannot grow
too much. In this case, I can't really say it's impossible we could have
devices with bigger pages in something like 20 years.

> >  Request translation
> >  ===================
> >  
> > @@ -1357,8 +1387,8 @@ are netlink only.
> >    ``ETHTOOL_GET_DUMP_FLAG``           n/a
> >    ``ETHTOOL_GET_DUMP_DATA``           n/a
> >    ``ETHTOOL_GET_TS_INFO``             ``ETHTOOL_MSG_TSINFO_GET``
> > -  ``ETHTOOL_GMODULEINFO``             n/a
> > -  ``ETHTOOL_GMODULEEEPROM``           n/a
> > +  ``ETHTOOL_GMODULEINFO``             ``ETHTOOL_MSG_MODULE_EEPROM_GET``
> > +  ``ETHTOOL_GMODULEEEPROM``           ``ETHTOOL_MSG_MODULE_EEPROM_GET``
> >    ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
> >    ``ETHTOOL_SEEE``                    ``ETHTOOL_MSG_EEE_SET``
> >    ``ETHTOOL_GRSSH``                   n/a
> 
> We should check with Michal about this. It is not a direct replacement
> of the old IOCTL API, it is new API. He may want it documented
> differently.

This table is meant to give a hint in the sense "for what you used
ioctl command in left column, use now netlink request in the right".
So IMHO it's appropriate. Perhaps it would deserve a comment explaining
this.

> > +	request->offset = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
> > +	request->length = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
> > +	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
> > +	    dev->ethtool_ops->get_module_eeprom_data_by_page &&
> > +	    request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN)
> > +		return -EINVAL;
> 
> You need to watch out for overflows here. 0xfffffff0 + 0x20 is less
> than ETH_MODULE_EEPROM_PAGE_LEN when it wraps around, but will cause
> bad things to happen.

BtW, the ioctl code also suffers from this problem and we recently had
a report from customer (IIRC the effect was ethtool trying to allocate
~4GB of memory), upstream fix should follow soon.

Michal
