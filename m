Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2DE524114
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349375AbiEKXhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiEKXhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:37:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911E1FD37
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:36:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36AAAB8265C
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 23:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F7AC340EE;
        Wed, 11 May 2022 23:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652312216;
        bh=6kBCtbuPpj7T/0hQidmOqxseeCpsHxakDC0rArSFUNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XI5j5SDaFjAAn59nAO61vq3RuFxpewUfNoaq6glySvkMvT06JP2vSGfpXZa20dFb/
         yL87cnhE43qJedvZq15ry4pdlIG8huT2kRzddwy1UO1s+kPhlEB7V06kmS4TRPgfqa
         wh3ZGmq5ri9X3SmXVSKsejOcWBAzEaptUtIwHKxUEYM7NooBBuCJu2/2IimRquxQWY
         PtdpKoTZ3iQDwAWmLH3HFCuwIGxeSOyLtSH1f2EpZvddNIZHawphwT/fcyw7H0KAb2
         +KHR8m234vP3/2lZ6kVZfFGzJB6G20ZQRAL1HPF/ZGvh08lh0uSCje/gAMEyZAgz6t
         8p7H81yrB44Jg==
Date:   Wed, 11 May 2022 16:36:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Message-ID: <20220511163655.08fc1ebc@kernel.org>
In-Reply-To: <20220511231745.4olqfvxiz4qm5oht@skbuf>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
        <20220510163615.6096-3-vladimir.oltean@nxp.com>
        <20220511152740.63883ddf@kernel.org>
        <20220511225745.xgrhiaghckrcxdaj@skbuf>
        <20220511161346.69c76869@kernel.org>
        <20220511231745.4olqfvxiz4qm5oht@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 23:17:46 +0000 Vladimir Oltean wrote:
> On Wed, May 11, 2022 at 04:13:46PM -0700, Jakub Kicinski wrote:
> > On Wed, 11 May 2022 22:57:46 +0000 Vladimir Oltean wrote:  
> > > The only entry that is a counter in the Scheduled Traffic MIB is TransmissionOverrun,
> > > but that isn't what this is. Instead, this would be a TransmissionOverrunAvoidedByDropping,
> > > for which there appears to be no standardization.  
> > 
> > TransmissionOversized? There's no standardization in terms of IEEE but
> > the semantics seem pretty clear right? The packet is longer than the
> > entire window so it can never go out?  
> 
> Yes, so what are you saying? Become the ad-hoc standards body for
> scheduled traffic?

We can argue semantics but there doesn't need to be a "standards body"
to add a structured stat in ethtool [1]. When next gen of enetc comes
out you'll likely try to use the same stat name or reuse the entire
driver. So you are already defining uAPI for your users, it's only 
a question of scope at which the uAPI is defined.

What I'm not sure of is what to attach that statistic to. You have it
per ring and we famously don't have per ring APIs, so whatever, let 
me apply as is and move on :)

[1] Coincidentally I plan to add a "real link loss" statistic there
because AFAICR IEEE doesn't have a stat for it, and carrier_changes
count software events so it's meaningless to teams trying to track
cable issues.
