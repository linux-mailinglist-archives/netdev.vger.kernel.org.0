Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D43D3A8D
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfJKIJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:09:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33940 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfJKIJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 04:09:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iIpyn-0004vc-O9; Fri, 11 Oct 2019 10:08:54 +0200
Message-ID: <94b8bb500cc3d6d4d740e472e5c083489740ec32.camel@sipsolutions.net>
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
Date:   Fri, 11 Oct 2019 10:08:52 +0200
In-Reply-To: <20191010200032.GH22163@unicorn.suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
         <b000e461e348ba1a0af30f2e8493618bce11ec12.1570654310.git.mkubecek@suse.cz>
         <20191010135639.GJ2223@nanopsycho> <20191010180401.GD22163@unicorn.suse.cz>
         <eb6cb68ff77eb4f2c680809e11142150f0d83007.camel@sipsolutions.net>
         <20191010200032.GH22163@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-10 at 22:00 +0200, Michal Kubecek wrote:
> 
> > Having a common format is way more accessible. Generic netlink (now)
> > even exposes the policy (if set) and all of its nested sub-policies to
> > userspace (if you use NLA_POLICY_NESTED), so it's very easy to discover
> > what's in the policy and how it'll be interpreted.
> 
> This, however, would require a different design that Jiri proposed. What
> he proposed was one attribute type for "request specific attributes".
> But to be able to perform nested validation of the whole message and
> export all policies would, with current genetlink design, require having
> one such attribute type for each request type (command).

Yes, indeed, that's true.

We actually used to have per-command policy in genetlink, but I removed
it as there was only one user, and it would've made the introspection
stuff a lot more complicated and it wasted quite a bit of memory in the
ops tables for everyone else.

Maybe we *do* want this back, with a nested policy pointing to the
common like you have. Then you'd have the option to do exactly what you
do here, but have introspection & common validation.

Actually, it's only half true that we had this - it was that the
*policy* was in the op, but the *maxattr* was in the family. This never
really makes any sense.

(IMHO we really should try to find a way to embed the maxattr into the
family, passing both always is very tiring. Perhaps just having a
terminator entry would be sufficient, or using a trick similar to what I
did with strict_start_type, and putting it into the 0th entry that's
usually unused? Even where the 0th entry *is* used, as long as the type
isn't something that relies on the validation data, we could do that.
But this is totally an aside...)

> But that would also require an extra check that the request message
> contains only the attribute matching its command (request type) so that
> the validation performed by genetlink would still be incomplete (it will
> always be incomplete as there are lots of strange constraints which
> cannot be described by a policy).

Also true, yes.

> Unless you suggest to effectively have just one command and determine
> the request type based on which of these request specific attributes is
> present (and define what to do if there is more than one).

Also possible, I guess, I can't say that's much better.

> ETHTOOL_A_HEADER_RFLAGS is a constant, it's always the same. Yes,
> logically it would rather belong outside header and maybe should be
> replaced by a (possibly empty) set of NLA_FLAG attributes. If having it
> in the common header is such a big problem, I'll move it out.

NLA_FLAG tends to be large - I think having a bitmap is fine.

Btw, you can also have a common *fixed* header in the genetlink family.
I don't think anyone does that, but it's possible.

> > But you even have *two* policies for each kind of message, one for the
> > content and one for the header...?
> 
> As I said in reply to another patch, it turns out that the only reason
> for having a per request header policy was rejecting
> ETHTOOL_A_HEADER_RFLAGS for requests which do not define any request
> flags but that's probably an overkill so that one universal header
> policy would be sufficient.

Missed that, OK.

> > It almost seems though that your argument isn't so much on the actual
> > hierarchy/nesting structure of the message itself, but the easy of
> > parsing it?
> 
> It's both. I still feel that from logical point of view it makes much
> more sense to use top level attributes for what the message is actually
> about. Nothing you said convinced me otherwise, rather the opposite: it
> only confirmed that the only reason for hiding the actual request
> contents one level below is to work around the consequences of the
> decision to make policy in genetlink per family rather than per command.

As I said above, it was actually the other way around and I changed it
relatively recently.

I don't have any strong objections to changing that really, it just
wasn't really used by anyone.

> I still don't see any reason why all this could not work with per
> command policies and would be principially dependent on having one
> universal policy for the whole family.

True, it just makes the code to expose it more complex (and uses more
space in the ops tables.)

If we do bring that back then IMHO it should be done properly and not
have a maxattr in the family, but with each policy. There could still
be a single maxattr (that must be >= max of all maxattrs) for the whole
family to ease allocation, but that could also just be derived as the
max(maxattr of all possible policies) at family registration time.

I'm almost thinking if we do that we should have a "struct
genl_ops_with_policy" and a second ops pointer in the family, so that
families not using this don't have to have a policy pointer & maxattr
for each op, the op struct now is 5 pointers long, so adding
policy/maxattr would cost us an increase of 20% on 64-bit and 40% on 32-
bit ... For families that don't need it, that's pretty large.

johannes

