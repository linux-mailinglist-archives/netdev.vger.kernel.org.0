Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D039DCDE
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 06:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfH0Ezq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 00:55:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:43644 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbfH0Ezq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 00:55:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12AABABCB;
        Tue, 27 Aug 2019 04:55:44 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2A0C5E0CFC; Tue, 27 Aug 2019 06:55:42 +0200 (CEST)
Date:   Tue, 27 Aug 2019 06:55:42 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190827045542.GE29594@unicorn.suse.cz>
References: <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
 <b43ad33c-ea0c-f441-a550-be0b1d8ca4ef@gmail.com>
 <20190813065617.GK2428@nanopsycho>
 <20190826160916.GE2309@nanopsycho.orion>
 <20190826095548.4d4843fe@cakuba.netronome.com>
 <5d79fba4-f82e-97a7-7846-fd1de089a95b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d79fba4-f82e-97a7-7846-fd1de089a95b@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 03:46:43PM -0600, David Ahern wrote:
> On 8/26/19 10:55 AM, Jakub Kicinski wrote:
> > On Mon, 26 Aug 2019 18:09:16 +0200, Jiri Pirko wrote:
> >> DaveA, Roopa. Do you insist on doing add/remove of altnames in the
> >> existing setlist command using embedded message op attrs? I'm asking
> >> because after some time thinking about it, it still feels wrong to me :/
> >>
> >> If this would be a generic netlink api, we would just add another couple
> >> of commands. What is so different we can't add commands here?
> >> It is also much simpler code. Easy error handling, no need for
> >> rollback, no possibly inconsistent state, etc.
> > 
> > +1 the separate op feels like a better uapi to me as well.
> > 
> > Perhaps we could redo the iproute2 command line interface to make the
> > name the primary object? Would that address your concern Dave and Roopa?
> > 
> 
> No, my point is exactly that a name is not a primary object. A name is
> an attribute of a link - something that exists for the convenience of
> userspace only. (Like the 'protocol' for routes, rules and neighbors.)
> 
> Currently, names are changed by RTM_NEWLINK/RTM_SETLINK. Aliases are
> added and deleted by RTM_NEWLINK/RTM_SETLINK. Why is an alternative name
> so special that it should have its own API?

There is only one alias so that it makes perfect sense to set it like
any other attribute. But the series introduces a list of alternative
names. So IMHO better analogy would be network addresses - and we do
have RTM_NEWADDR/RTM_DELADDR for them.

> If only 1 alt name was allowed, then RTM_NEWLINK/RTM_SETLINK would
> suffice. Management of it would have the same semantics as an alias -
> empty string means delete, non-empty string sets the value.
> 
> So really the push for new RTM commands is to handle an unlimited number
> of alt names with the ability to change / delete any one of them. Has
> the need for multiple alternate ifnames been fully established? (I don't
> recall other than a discussion about parallels to block devices.)

I still believe the biggest problem with so-called "predictable names"
for network devices (which turn out to be not predictable and often not
even persistent) comes from the fact that unlike for block (or
character) devices, we don't have anything like symlink for network
device. This forces udev to choose only one naming scheme with all the
unpleasant consequences. So I see this series as an opportunity to get
rid of this limitation.

Michal


