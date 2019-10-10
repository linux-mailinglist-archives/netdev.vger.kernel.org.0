Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0668ED301D
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfJJSSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:18:23 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44704 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfJJSSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 14:18:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iId0p-0002lF-Lv; Thu, 10 Oct 2019 20:18:07 +0200
Message-ID: <eb6cb68ff77eb4f2c680809e11142150f0d83007.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v7 09/17] ethtool: generic handlers for GET
 requests
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Thu, 10 Oct 2019 20:18:05 +0200
In-Reply-To: <20191010180401.GD22163@unicorn.suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
         <b000e461e348ba1a0af30f2e8493618bce11ec12.1570654310.git.mkubecek@suse.cz>
         <20191010135639.GJ2223@nanopsycho> <20191010180401.GD22163@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-10 at 20:04 +0200, Michal Kubecek wrote:
> 
> The only thing I don't like about the genetlink infrastructure is the
> design decision that policy and corresponding maxattr is an attribute of
> the family rather than a command. This forces anyone who wants to use it
> to essentially have one common message format for all commands and if
> that is not possible, to do what you suggest above, hide the actual
> request into a nest.
> 
> Whether you use one common attribute type for "command specific nest" or
> different attribute for each request type, you do not actually make
> things simpler, you just move the complexity one level lower. You will
> still have to do your own (per request) parsing of the actual request,
> the only difference is that you will do it in a different place and use
> nla_parse_nested() rather than nlmsg_parse().
> 
> Rather than bending the message layout to fit into the limitations of
> unified genetlink parsing, I prefer to keep the logical message
> structure and do the parsing on my own.

I can't really agree with this.

Having a common format is way more accessible. Generic netlink (now)
even exposes the policy (if set) and all of its nested sub-policies to
userspace (if you use NLA_POLICY_NESTED), so it's very easy to discover
what's in the policy and how it'll be interpreted.

This makes it really easy to have tools for introspection, or have
common debugging tools that just understand the message format based on
the kernel's policy.

It's also much easier this way to not mess up things like "attribute # 7
always means a netdev index". You solved that by nesting the common
bits, though the part about ETHTOOL_A_HEADER_RFLAGS actually seems ...
wrong? Shouldn't that have been somewhere else? Or does that mean each
and every request_policy has to have this at the same index? That sounds
error prone ...

But you even have *two* policies for each kind of message, one for the
content and one for the header...?


It almost seems though that your argument isn't so much on the actual
hierarchy/nesting structure of the message itself, but the easy of
parsing it?

I have thought previous that it might make sense to create a
hierarchical representation of the message, with the nested TBs pre-
parsed too in generic netlink, so you wouldn't just have a common
attrbuf but (optionally) allocate nested attrbufs for those nested
attributes that are present, and give a way of accessing those.


I really do think that a single policy that's exposed for introspection
and links its nested sub-policies for the different sub-commands (which
are then also exposed to introspection) is much superior to having it
all just driven by the code like this.

johannes

