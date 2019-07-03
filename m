Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FFF5DECC
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfGCHX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:23:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:51422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726327AbfGCHX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:23:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1123EAE2E;
        Wed,  3 Jul 2019 07:23:27 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3615BE0159; Wed,  3 Jul 2019 09:23:26 +0200 (CEST)
Date:   Wed, 3 Jul 2019 09:23:26 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 05/15] ethtool: helper functions for netlink
 interface
Message-ID: <20190703072326.GI20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <44957b13e8edbced71aca893908d184eb9e57341.1562067622.git.mkubecek@suse.cz>
 <20190702183724.423e3b1e@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702183724.423e3b1e@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 06:37:24PM -0700, Jakub Kicinski wrote:
> On Tue,  2 Jul 2019 13:50:04 +0200 (CEST), Michal Kubecek wrote:
> > Add common request/reply header definition and helpers to parse request
> > header and fill reply header. Provide ethnl_update_* helpers to update
> > structure members from request attributes (to be used for *_SET requests).
> > 
> > Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> 
> > diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> > index 3c98b41f04e5..e13f29bbd625 100644
> > --- a/net/ethtool/netlink.c
> > +++ b/net/ethtool/netlink.c
> > @@ -1,8 +1,181 @@
> >  // SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
> >  
> > +#include <net/sock.h>
> >  #include <linux/ethtool_netlink.h>
> >  #include "netlink.h"
> >  
> > +static struct genl_family ethtool_genl_family;
> > +
> > +static const struct nla_policy dflt_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
> > +	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
> 
> I think we want strict checking on all new netlink interfaces, and
> unfortunately that feature is opt-in.. so you need to add:
> 
> 	.strict_start_type = ETHTOOL_A_HEADER_UNSPEC + 1
> 
> To the first attr.

Oops... I'll have to check again how this works. I thought using
nla_parse_nested() instead of nla_parse_nested_deprecated() is
sufficient to have everything strict checked.

Michal
