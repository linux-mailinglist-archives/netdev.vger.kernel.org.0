Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A583FD31C7
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 22:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfJJUAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 16:00:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:52856 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbfJJUAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 16:00:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 682D2AF05;
        Thu, 10 Oct 2019 20:00:33 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 94D07E378C; Thu, 10 Oct 2019 22:00:32 +0200 (CEST)
Date:   Thu, 10 Oct 2019 22:00:32 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 09/17] ethtool: generic handlers for GET
 requests
Message-ID: <20191010200032.GH22163@unicorn.suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <b000e461e348ba1a0af30f2e8493618bce11ec12.1570654310.git.mkubecek@suse.cz>
 <20191010135639.GJ2223@nanopsycho>
 <20191010180401.GD22163@unicorn.suse.cz>
 <eb6cb68ff77eb4f2c680809e11142150f0d83007.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6cb68ff77eb4f2c680809e11142150f0d83007.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 08:18:05PM +0200, Johannes Berg wrote:
> On Thu, 2019-10-10 at 20:04 +0200, Michal Kubecek wrote:
> > 
> > The only thing I don't like about the genetlink infrastructure is the
> > design decision that policy and corresponding maxattr is an attribute of
> > the family rather than a command. This forces anyone who wants to use it
> > to essentially have one common message format for all commands and if
> > that is not possible, to do what you suggest above, hide the actual
> > request into a nest.
> > 
> > Whether you use one common attribute type for "command specific nest" or
> > different attribute for each request type, you do not actually make
> > things simpler, you just move the complexity one level lower. You will
> > still have to do your own (per request) parsing of the actual request,
> > the only difference is that you will do it in a different place and use
> > nla_parse_nested() rather than nlmsg_parse().
> > 
> > Rather than bending the message layout to fit into the limitations of
> > unified genetlink parsing, I prefer to keep the logical message
> > structure and do the parsing on my own.
> 
> I can't really agree with this.
> 
> Having a common format is way more accessible. Generic netlink (now)
> even exposes the policy (if set) and all of its nested sub-policies to
> userspace (if you use NLA_POLICY_NESTED), so it's very easy to discover
> what's in the policy and how it'll be interpreted.

This, however, would require a different design that Jiri proposed. What
he proposed was one attribute type for "request specific attributes".
But to be able to perform nested validation of the whole message and
export all policies would, with current genetlink design, require having
one such attribute type for each request type (command).

But that would also require an extra check that the request message
contains only the attribute matching its command (request type) so that
the validation performed by genetlink would still be incomplete (it will
always be incomplete as there are lots of strange constraints which
cannot be described by a policy).

Unless you suggest to effectively have just one command and determine
the request type based on which of these request specific attributes is
present (and define what to do if there is more than one).

> This makes it really easy to have tools for introspection, or have
> common debugging tools that just understand the message format based on
> the kernel's policy.
> 
> It's also much easier this way to not mess up things like "attribute # 7
> always means a netdev index". You solved that by nesting the common
> bits, though the part about ETHTOOL_A_HEADER_RFLAGS actually seems ...
> wrong? Shouldn't that have been somewhere else? Or does that mean each
> and every request_policy has to have this at the same index? That sounds
> error prone ...

ETHTOOL_A_HEADER_RFLAGS is a constant, it's always the same. Yes,
logically it would rather belong outside header and maybe should be
replaced by a (possibly empty) set of NLA_FLAG attributes. If having it
in the common header is such a big problem, I'll move it out.

> But you even have *two* policies for each kind of message, one for the
> content and one for the header...?

As I said in reply to another patch, it turns out that the only reason
for having a per request header policy was rejecting
ETHTOOL_A_HEADER_RFLAGS for requests which do not define any request
flags but that's probably an overkill so that one universal header
policy would be sufficient.

> It almost seems though that your argument isn't so much on the actual
> hierarchy/nesting structure of the message itself, but the easy of
> parsing it?

It's both. I still feel that from logical point of view it makes much
more sense to use top level attributes for what the message is actually
about. Nothing you said convinced me otherwise, rather the opposite: it
only confirmed that the only reason for hiding the actual request
contents one level below is to work around the consequences of the
decision to make policy in genetlink per family rather than per command.

> I have thought previous that it might make sense to create a
> hierarchical representation of the message, with the nested TBs pre-
> parsed too in generic netlink, so you wouldn't just have a common
> attrbuf but (optionally) allocate nested attrbufs for those nested
> attributes that are present, and give a way of accessing those.
> 
> I really do think that a single policy that's exposed for introspection
> and links its nested sub-policies for the different sub-commands (which
> are then also exposed to introspection) is much superior to having it
> all just driven by the code like this.

I still don't see any reason why all this could not work with per
command policies and would be principially dependent on having one
universal policy for the whole family.

Michal Kubecek
