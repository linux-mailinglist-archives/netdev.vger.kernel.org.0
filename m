Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD295EAED
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 19:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfGCRxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 13:53:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:57864 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbfGCRxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 13:53:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 135E8AD7F;
        Wed,  3 Jul 2019 17:53:42 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 316DCE0159; Wed,  3 Jul 2019 19:53:39 +0200 (CEST)
Date:   Wed, 3 Jul 2019 19:53:39 +0200
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
Subject: Re: [PATCH net-next v6 09/15] ethtool: generic handlers for GET
 requests
Message-ID: <20190703175339.GO20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <4faa0ce52dfe02c9cde5a46012b16c9af6764c5e.1562067622.git.mkubecek@suse.cz>
 <20190703142510.GA2250@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703142510.GA2250@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 04:25:10PM +0200, Jiri Pirko wrote:
> Tue, Jul 02, 2019 at 01:50:24PM CEST, mkubecek@suse.cz wrote:
> 
> [...]	
> 	
> >+/* generic ->doit() handler for GET type requests */
> >+static int ethnl_get_doit(struct sk_buff *skb, struct genl_info *info)
> 
> It is very unfortunate for review to introduce function in a patch and
> don't use it. In general, this approach is frowned upon. You should use
> whatever you introduce in the same patch. I understand it is sometimes
> hard.

It's not as if I introduced something and didn't show how to use it.
First use is in the very next patch so if you insist on reading each
patch separately without context, just combine 09/15 and 10/15 together;
the overlap is minimal (10/15 adds an entry into get_requests[]
introduced in 09/15).

I could have done that myself but the resulting patch would add over
1000 lines (also something frown upon in general) and if someone asked
if it could be split, the only honest answer I could give would be:
"Of course it should be split, it consists of two completely logically
separated parts (which are also 99% separated in code)."

> IIUC, you have one ethnl_get_doit for all possible commands, and you

Not all of them, only GET requests (and related notifications) and out
of them, only those which fit the common pattern. There will be e.g. Rx
rules and stats (maybe others) where dump request won't be iterating
through devices so that they will need at least their own dumpit
handler.

> have this ops to do cmd-specific tasks. That is quite unusual. Plus if
> you consider the complicated datastructures connected with this, 
> I'm lost from the beginning :( Any particular reason form this indirection?
> I don't think any other generic netlink code does that (correct me if
> I'm wrong). The nice thing about generic netlink is the fact that
> you have separate handlers per cmd.
> 
> I don't think you need these ops and indirections. For the common parts,
> just have a set of common helpers, as the other generic netlink users
> are doing. The code would be much easier to read and follow then.

As I said last time, what you suggest is going back to what I already
had in the early versions; so I have pretty good idea what the result
would look like.

I could go that way, having a separate main handler for each request
type and call common helpers from it. But as there would always be
a doit() handler, a dumpit() handler and mostly also a notification
handler, I would have to factor out the functions which are now
callbacks in struct get_request_ops anyway. To avoid too many
parameters, I would end up with structures very similar to what I have
now.  (Not really "I would", the structures were already there, the only
difference was that the "request" and "data" parts were two structures
rather than one.)

So at the moment, I would have 5 functions looking almost the same as
ethnl_get_doit(), 5 functions looking almost as ethnl_get_dumpit() and
2 functions looking like ethnl_std_notify(), with the prospect of more
to be added. Any change in the logic would need to be repeated for all
of them. Moreover, you also proposed (or rather requested) to drop the
infomask concept and split the message types into multiple separate
ones. With that change, the number of almost copies would be 21 doit(),
21 dumpit() and 13 notification handlers (for now, that is).

I'm also not happy about the way typical GET and SET request processing
looks now. But I would much rather go in the opposite direction: define
relationship between message attributes and data structure members so
that most of the size estimate, data prepare, message fill and data
update functions which are all repeating the same pattern could be
replaced by universal functions doing these actions according to the
description. The direction you suggest is the direction I came from.

Seriously, I don't know what to think. Anywhere I look, return code is
checked with "if (ret < 0)" (sure, some use "if (ret)" but it's
certainly not prevalent or universally preferred, more like 1:1), now
you tell me it's wrong. Networking stack is full of simple helpers and
wrappers, yet you keep telling me simple wrappers are wrong. Networking
stack is full of abstractions and ops, you tell me it's wrong. It's
really confusing...

Michal
