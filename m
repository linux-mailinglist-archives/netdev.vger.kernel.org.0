Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6EE561E52
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbfGHMW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:22:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:39532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728964AbfGHMW5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 08:22:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5FC9AC66;
        Mon,  8 Jul 2019 12:22:54 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 0238FE00B7; Mon,  8 Jul 2019 14:22:51 +0200 (CEST)
Date:   Mon, 8 Jul 2019 14:22:51 +0200
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
Subject: Re: [PATCH net-next v6 05/15] ethtool: helper functions for netlink
 interface
Message-ID: <20190708122251.GB24474@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <44957b13e8edbced71aca893908d184eb9e57341.1562067622.git.mkubecek@suse.cz>
 <20190702130515.GO2250@nanopsycho>
 <20190702163437.GE20101@unicorn.suse.cz>
 <20190703100435.GS2250@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703100435.GS2250@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 12:04:35PM +0200, Jiri Pirko wrote:
> Tue, Jul 02, 2019 at 06:34:37PM CEST, mkubecek@suse.cz wrote:
> >On Tue, Jul 02, 2019 at 03:05:15PM +0200, Jiri Pirko wrote:
> >> Tue, Jul 02, 2019 at 01:50:04PM CEST, mkubecek@suse.cz wrote:
> >> >+/**
> >> >+ * ethnl_is_privileged() - check if request has sufficient privileges
> >> >+ * @skb: skb with client request
> >> >+ *
> >> >+ * Checks if client request has CAP_NET_ADMIN in its netns. Unlike the flags
> >> >+ * in genl_ops, this allows finer access control, e.g. allowing or denying
> >> >+ * the request based on its contents or witholding only part of the data
> >> >+ * from unprivileged users.
> >> >+ *
> >> >+ * Return: true if request is privileged, false if not
> >> >+ */
> >> >+static inline bool ethnl_is_privileged(struct sk_buff *skb)
> >> 
> >> I wonder why you need this helper. Genetlink uses
> >> ops->flags & GENL_ADMIN_PERM for this. 
> >
> >It's explained in the function description. Sometimes we need finer
> >control than by request message type. An example is the WoL password:
> >ETHTOOL_GWOL is privileged because of it but I believe there si no
> >reason why unprivileged user couldn't see enabled WoL modes, we can
> >simply omit the password for him. (Also, it allows to combine query for
> >WoL settings with other unprivileged settings.)
> 
> Why can't we have rather:
> ETHTOOL_WOL_GET for all
> ETHTOOL_WOL_PASSWORD_GET  with GENL_ADMIN_PERM
> ?
> Better to stick with what we have in gennetlink rather then to bend the
> implementation from the very beginning I think.

We can. But it would also mean two separate SET requests (or breaking
the rule that _GET_REPLY, _SET and _NTF share the layout). That would be
unfortunate as ethtool_ops callback does not actually allow setting only
the modes so that the ETHTOOL_MSG_WOL_SET request (which would have to
go first as many drivers ignore .sopass if WAKE_MAGICSECURE is not set)
would have to pass a different password (most likely just leaving what
->get_wol() put there) and that password would be actually set until the
second request arrives. There goes the idea of getting rid of ioctl
interface raciness...

I would rather see returning to WoL modes not being visible to
unprivileged users than that (even if there is no actual reason for it).
Anyway, shortening the series left WoL settings out if the first part so
that I can split this out for now and leave the discussion for when we
get to WoL one day.

> >> >+/**
> >> >+ * ethnl_reply_header_size() - total size of reply header
> >> >+ *
> >> >+ * This is an upper estimate so that we do not need to hold RTNL lock longer
> >> >+ * than necessary (to prevent rename between size estimate and composing the
> >> 
> >> I guess this description is not relevant anymore. I don't see why to
> >> hold rtnl mutex for this function...
> >
> >You don't need it for this function, it's the other way around: unless
> >you hold RTNL lock for the whole time covering both checking needed
> >message size and filling the message - and we don't - the device could
> >be renamed in between. Thus if we returned size based on current device
> >name, it might not be sufficient at the time the header is filled.
> >That's why this function returns maximum possible size (which is
> >actually a constant).
> 
> I suggest to avoid the description. It is misleading. Perhaps something
> to have in a patch description but not here in code.

The reason I put the comment there was to prevent someone "optimizing"
the helper by using strlen() later. Maybe something shorter and more to
the point, e.g.

  Using IFNAMSIZ is faster and prevents a race if the device is renamed
  before we fill the name into skb.

?

Michal
