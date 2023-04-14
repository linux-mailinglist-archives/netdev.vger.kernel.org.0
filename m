Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388EF6E2604
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjDNOmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjDNOmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:42:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E56FB758;
        Fri, 14 Apr 2023 07:42:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2D66633F0;
        Fri, 14 Apr 2023 14:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181F1C433EF;
        Fri, 14 Apr 2023 14:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681483359;
        bh=DjZBywGFdDSzDPQzRUbyf7CiYMlqZMeQShR8K7hDGjw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P2HHhMLemFRkqclbGCpkxceV7UNq3zgYQRAgNl2YkrNmCTy+SwKzmDIJ3RRIddcFI
         YHV02zmxE0Yu8kB7Ds40HdKEXCkITZ7Q5WCoffur1c8fS23JIdzEvhlHnoRXJXMD6D
         xU0uhrhbX1ZpP5ua568C0GE1hWCqPctwczuzuhCw6iYnQu074C0JxKxwFoiCvgE19n
         5W6a/uIT9Ijhauj7qwWBFHy2FwvVq7qEOmyhiz6W2bhvziu/+8I0kZTwEAxM5gh+7o
         GwG/NafhbD7OHb5EAfQrNjm5NZq75vQMBpVApr2OFE74HpqucmR3pF/+DrxRp5zFTV
         KGU51KEn49t0w==
Date:   Fri, 14 Apr 2023 07:42:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: extend drop reasons for multiple subsystems
Message-ID: <20230414074238.2da8f8db@kernel.org>
In-Reply-To: <9b5c442ce63c885514a833e5b7a422eed19a4314.camel@sipsolutions.net>
References: <20230330212227.928595-1-johannes@sipsolutions.net>
        <20230331213621.0993e25b@kernel.org>
        <9b5c442ce63c885514a833e5b7a422eed19a4314.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 11:25:08 +0200 Johannes Berg wrote:
> On Fri, 2023-03-31 at 21:36 -0700, Jakub Kicinski wrote:
> >   
> > > +/* Note: due to dynamic registrations, access must be under RCU */
> > > +extern const struct drop_reason_list __rcu *
> > > +drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_NUM];
> > > +
> > > +void drop_reasons_register_subsys(enum skb_drop_reason_subsys subsys,
> > > +				  const struct drop_reason_list *list);
> > > +void drop_reasons_unregister_subsys(enum skb_drop_reason_subsys subsys);  
> > 
> > dropreason.h is included by skbuff.h because history, but I don't think
> > any of the new stuff must be visible in skbuff.h.
> > 
> > Could you make a new header, and put as much of this stuff there as
> > possible? Our future selves will thank us for shorter rebuild times..  
> 
> Sure. Not sure it'll make a big difference in rebuild, but we'll see :)
> 
> I ended up moving dropreason.h to dropreason-core.h first, that way we
> also have a naming scheme for non-core dropreason files should they
> become visible outside of the subsystem (i.e. mac80211 just has them
> internally).
> 
> Dunno, let me know if you prefer something else, I just couldn't come up
> with a non-confusing longer name for the new thing.

Sounds good.

> > Weak preference to also take the code out of skbuff.c but that's not as
> > important.  
> 
> I guess I can create a new dropreason.c, but is that worth it? It's only
> a few lines. Let me know, then I can resend.

It's hard to tell. Most additions to the core are small at the start so
we end up chucking all of them into a handful of existing source files.
And those files grow and grow. Splitting the later is extra work and
makes backports harder.

It's a game of predicting which code will likely grow into a reasonable
~500+ LoC at some point, and which code will not. I have the feeling
that dropreason code will grow. But yes, it's still fairly small, we 
can defer.

> > You To'd both wireless and netdev, who are you expecting to apply this?
> > :S  
> 
> Good question :)
> 
> The first patch (patches in v3) really should go through net-next I
> suppose, and I wouldn't mind if the other one did as well, it doesn't
> right now touch anything likely to change.

SG!
