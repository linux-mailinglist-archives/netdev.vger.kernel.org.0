Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C097756C012
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbiGHSFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbiGHSFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:05:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FFA7C1A1
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 11:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A4D6B8291D
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 18:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1417C341C0;
        Fri,  8 Jul 2022 18:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657303537;
        bh=s8JFJP23qy4tpmya/r225V+nmPt5AQ6PKkGdqol30Qs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fhfxKXtyPACnx4iGwpNxChERgGWzoxjijBBWMkdSbOOvGReaf0g+XcE51i+t9N+EO
         6AOt8NyaPsffUMcpcci62NLe6DQ986ZF90IuC48lQZF/vCo5kTatwOWnL733bqV9sV
         sKG+QriPjnRrtbXxxl8MguhOIvQJ2xDe7UcRlQsQWTc3vn6YSLl4Lfejcu3ZI5J7A0
         h3JEBcoWSJNscL5YyWxWLSjWqwr43qQcyCe8+3m6h4STWlv521poOOg6RBIUULl3M/
         GiqaqB+fVXR9LS+OrXTn6v4XHSrD80XLBwttRraqbehkxxIG15/R2KfoyLeON6EsM8
         FGFt4FuWMSeNA==
Date:   Fri, 8 Jul 2022 11:05:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jiri Pirko <jiri@nvidia.com>, Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <20220708110535.63a2b8e9@kernel.org>
In-Reply-To: <YsfcUlF9KjFEGGVW@nanopsycho>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
        <20220620130426.00818cbf@kernel.org>
        <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
        <20220630111327.3a951e3b@kernel.org>
        <YsbBbBt+DNvBIU2E@nanopsycho>
        <20220707131649.7302a997@kernel.org>
        <YsfcUlF9KjFEGGVW@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Michal

On Fri, 8 Jul 2022 09:27:14 +0200 Jiri Pirko wrote:
> >> Configuring the TX/RX rate (including groupping) applies to all of
> >> these.  
> >
> >I don't understand why the "side of the wire" matters when the patches
> >target both Rx and Tx. Surely that covers both directions.  
> 
> Hmm, I believe it really does. We have objects which we configure. There
> is a function object, which has some configuration (including this).
> Making user to configure function object via another object (eswitch
> port netdevice on the other side of the wire), is quite confusing and I
> feel it is wrong. The only reason is to somehow fit TC interface for
> which we don't have an anchor for port function.
> 
> What about another configuration? would it be ok to use eswitch port
> netdev to configure port function too, if there is an interface for it?
> I believe not, that is why we introduced port function.

I resisted the port function aberration as long as I could. It's 
a limitation of your design as far as I'm concerned.

Switches use TC to configure egress queuing, that's our Linux model.
Representor is the switch side, TC qdisc on it maps to the egress
of the switch.

I don't understand where the disconnect between us is, you know that's
what mlxsw does..

> >> Putting the configuration on the eswitch representor does not fit:
> >> 1) it is configuring the other side of the wire, the configuration
> >>    should be of the eswitch port. Configuring the other side is
> >>    confusing and misleading. For the purpose of configuring the
> >>    "function" side, we introduced "port function" object in devlink.
> >> 2) it is confuguring netdev/ethernet however the confuguration applies
> >>    to all queues of the function.  
> >
> >If you think it's technically superior to put it in devlink that's fine.
> >I'll repeat myself - what I'm asking for is convergence so that drivers
> >don't have  to implement 3 different ways of configuring this. We have
> >devlink rate for from-VF direction shaping, tc police for bi-dir
> >policing and obviously legacy NDOs. None of them translate between each
> >other so drivers and user space have to juggle interfaces.  
> 
> The legacy ndo is legacy. Drivers that implement switchdev mode do
> not implement those, and should not.

That's irrelevant - what I'm saying is that in practice drivers have to
implement _all_ of these interfaces today. Just because they are not
needed in eswitch mode doesn't mean the sales department won't find a
customer who's happy with the non-switchdev mode and doesn't want to
move.
