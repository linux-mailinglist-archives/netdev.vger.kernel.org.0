Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F566460E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfGJMMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:12:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:36076 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbfGJMMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 08:12:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9FB0EAC1E;
        Wed, 10 Jul 2019 12:12:36 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id F3A27E0E06; Wed, 10 Jul 2019 14:12:31 +0200 (CEST)
Date:   Wed, 10 Jul 2019 14:12:31 +0200
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
Subject: Re: [PATCH net-next v6 04/15] ethtool: introduce ethtool netlink
 interface
Message-ID: <20190710121231.GA5700@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <e7fa3ad7e9cf4d7a8f9a2085e3166f7260845b0a.1562067622.git.mkubecek@suse.cz>
 <20190702122521.GN2250@nanopsycho>
 <20190702145241.GD20101@unicorn.suse.cz>
 <20190703084151.GR2250@nanopsycho>
 <20190708172729.GC24474@unicorn.suse.cz>
 <20190708192629.GD2282@nanopsycho.orion>
 <20190708202219.GE24474@unicorn.suse.cz>
 <20190709134212.GD2301@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709134212.GD2301@nanopsycho.orion>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 03:42:12PM +0200, Jiri Pirko wrote:
> Mon, Jul 08, 2019 at 10:22:19PM CEST, mkubecek@suse.cz wrote:
> >On Mon, Jul 08, 2019 at 09:26:29PM +0200, Jiri Pirko wrote:
> >> Mon, Jul 08, 2019 at 07:27:29PM CEST, mkubecek@suse.cz wrote:
> >> >
> >> >There are two reasons for this design. First is to reduce the number of
> >> >requests needed to get the information. This is not so much a problem of
> >> >ethtool itself; the only existing commands that would result in multiple
> >> >request messages would be "ethtool <dev>" and "ethtool -s <dev>". Maybe
> >> >also "ethtool -x/-X <dev>" but even if the indirection table and hash
> >> >key have different bits assigned now, they don't have to be split even
> >> >if we split other commands. It may be bigger problem for daemons wanting
> >> >to keep track of system configuration which would have to issue many
> >> >requests whenever a new device appears.
> >> >
> >> >Second reason is that with 8-bit genetlink command/message id, the space
> >> >is not as infinite as it might seem. I counted quickly, right now the
> >> >full series uses 14 ids for kernel messages, with split you propose it
> >> >would most likely grow to 44. For full implementation of all ethtool
> >> >functionality, we could get to ~60 ids. It's still only 1/4 of the
> >> >available space but it's not clear what the future development will look
> >> >like. We would certainly need to be careful not to start allocating new
> >> >commands for single parameters and try to be foreseeing about what can
> >> >be grouped together. But we will need to do that in any case.
> >> >
> >> >On kernel side, splitting existing messages would make some things a bit
> >> >easier. It would also reduce the number of scenarios where only part of
> >> >requested information is available or only part of a SET request fails.
> >> 
> >> Okay, I got your point. So why don't we look at if from the other angle.
> >> Why don't we have only single get/set command that would be in general
> >> used to get/set ALL info from/to the kernel. Where we can have these
> >> bits (perhaps rather varlen bitfield) to for user to indicate which data
> >> is he interested in? This scales. The other commands would be
> >> just for action.
> >> 
> >> Something like RTM_GETLINK/RTM_SETLINK. Makes sense?
> >
> >It's certainly an option but at the first glance it seems as just moving
> >what I tried to avoid one level lower. It would work around the u8 issue
> >(but as Johannes pointed out, we can handle it with genetlink when/if
> >the time comes). We would almost certainly have to split the replies
> >into multiple messages to keep the packet size reasonable. I'll have to
> >think more about the consequences for both kernel and userspace.
> >
> >My gut feeling is that out of the two extreme options (one universal
> >message type and message types corresponding to current infomask bits),
> >the latter is more appealing. After all, ethtool has been gathering
> >features that would need those ~60 message types for 20 years.
> 
> Yeah, but I think that we have to do one or another. Anything in between
> makes the code complex and uapi confusing. Let's start clean :)

I'll split the messages for v7.

Michal
