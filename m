Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C37D56C971
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 14:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiGIMpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 08:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiGIMpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 08:45:07 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461A24E85C
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 05:45:04 -0700 (PDT)
Received: from equinox by eidolon.nox.tf with local (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1oA9pU-008p6Y-D2; Sat, 09 Jul 2022 14:45:00 +0200
Date:   Sat, 9 Jul 2022 14:45:00 +0200
From:   David Lamparter <equinox@diac24.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net-next v5] net: ip6mr: add RTM_GETROUTE netlink op
Message-ID: <Ysl4TPkTNW+6JPj4@eidolon.nox.tf>
References: <20220707093336.214658-1-equinox@diac24.net>
 <20220708202951.46d3454a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708202951.46d3454a@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 08:29:51PM -0700, Jakub Kicinski wrote:
> Few more nit picks, sorry..

Thanks for the feedback!  [opens editor]

> On Thu,  7 Jul 2022 11:33:36 +0200 David Lamparter wrote:
[...]
> > +	err = ip6mr_rtm_valid_getroute_req(in_skb, nlh, tb, extack);
> > +	if (err < 0)
> > +		goto errout;
> 
> Can we:
> 
> 		return err;
> 
> ? I don't know where the preference for jumping to the return statement
> came from, old compilers? someone's "gut feeling"?

If I were forced to find a justification, I'd say having a central
sequence of exit helps avoiding mistakes when some other resource
acquisition is added later.  Easy to add a cleanup call to an existing
cleanup block - easy to overlook a "return err;" that needs to be
changed to "goto errout;".

But I have absolutely no stake in this at all, I'll happily edit it to
whatever the consensus is.  This is just what the IPv4 code looks like
after being adapted for IPv6.

> > +errout:
> > +	return err;
[...]
> > +
> > +errout_free:
> > +	kfree_skb(skb);
> > +	goto errout;
> 
> and no need to do the funky backwards jump here either, IMO

"funky" is a nice description.


-equi/David
