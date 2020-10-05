Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5C4283F81
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbgJETVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgJETVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:21:45 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F3EC0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 12:21:45 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPW3H-00HOE2-8D; Mon, 05 Oct 2020 21:21:39 +0200
Message-ID: <de5a03325d397fe559ce6c6182dfedc0cdad2c3b.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: wire up get policies to ops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
Date:   Mon, 05 Oct 2020 21:21:36 +0200
In-Reply-To: <20201005121622.55607210@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-2-kuba@kernel.org>
         <631a2328a95d0dd06d901cdb411c3eb06f90bda7.camel@sipsolutions.net>
         <20201005121622.55607210@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 12:16 -0700, Jakub Kicinski wrote:
> On Mon, 05 Oct 2020 20:56:29 +0200 Johannes Berg wrote:
> > On Mon, 2020-10-05 at 08:57 -0700, Jakub Kicinski wrote:
> > > @@ -783,6 +799,9 @@ static const struct genl_ops ethtool_genl_ops[] = {
> > >  		.start	= ethnl_default_start,
> > >  		.dumpit	= ethnl_default_dumpit,
> > >  		.done	= ethnl_default_done,
> > > +		.policy = ethnl_rings_get_policy,
> > > +		.maxattr = ARRAY_SIZE(ethnl_rings_get_policy) - 1,
> > > +
> > >  	},  
> > 
> > If you find some other reason to respin, perhaps remove that blank line
> > :)
> > 
> > Unrelated to that, it bothers me a bit that you put here the maxattr as
> > the ARRAY_SIZE(), which is of course fine, but then still have
> > 
> > > @@ -127,7 +127,7 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
> > >  	.max_attr		= ETHTOOL_A_PRIVFLAGS_MAX,  
> > 
> > max_attr here, using the original define
> 
> Ah, another good catch, this is obviously no longer needed. I will
> remove those members in v2.

Good point, I misread/misunderstood the code and thought it was still
being used to size the parsing array, but that's of course no longer
there since the genl core now does it.

> > But with the difference it seems to me that it'd be possible to get this
> > mixed up?
> 
> Right, I prefer not to have the unnecessary NLA_REJECTS, so my thinking
> was - use the format I like for the new code, but leave the existing
> rejects for a separate series / discussion.
> 
> If we remove the rejects we still need something like
> 
> extern struct nla_policy policy[lastattr + 1];

Not sure I understand? You're using strict validation (I think), so
attrs that are out of range will be rejected same as NLA_REJECT (well,
with a different message) in __nla_validate_parse():

        nla_for_each_attr(nla, head, len, rem) {
                u16 type = nla_type(nla);

                if (type == 0 || type > maxtype) {
                        if (validate & NL_VALIDATE_MAXTYPE) {
                                NL_SET_ERR_MSG_ATTR(extack, nla,
                                                    "Unknown attribute type");
                                return -EINVAL;
                        }


In fact, if you're using strict validation even the default
(0==NLA_UNSPEC) will be rejected, just like NLA_REJECT.


Or am I confused somewhere?

johannes

