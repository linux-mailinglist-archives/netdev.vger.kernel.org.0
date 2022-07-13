Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60062573C30
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 19:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiGMRw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 13:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiGMRw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 13:52:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E8C2D1CB
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 10:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7968061CCA
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 17:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831E7C34114;
        Wed, 13 Jul 2022 17:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657734776;
        bh=PVBRoJ5r3h8Fbmul370PfTVFgn4YG3r7pBZA372P04k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uJktk5rcEsz8J+NLk3AEHAFciLAuqvseBX5t0TksuVD44zj//1pnSlk3oHCwJ72ha
         d8RajPAHgFOwUndefYB9udPOLOmAmIh6VklGnZq1gTPsKQKVrPkno/aBwypX+eKj19
         Lc4rOL8LoK3fOES3HTddYeBv7YKhmPHG8m7QghEBvYpHIcEyhl78MtsOg+0F2Ae0xn
         RMiPcL3n1L0MqYoFIkWM/TCiggTe7mEdzOzKADq/woBj3rtpRGdRq9jhZ1kKWJUG4S
         fM9lP1UDbeD/HeOsCx4F2gR/Z1joBGuqgJl2CZAQXr1JT/WtBNRqzyLCe6gQSYObCJ
         hUHPyVaLM04QA==
Date:   Wed, 13 Jul 2022 10:52:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jiri Pirko <jiri@nvidia.com>, Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <20220713105255.4654c4ad@kernel.org>
In-Reply-To: <Ys5SRCNwD8prZ0pL@nanopsycho>
References: <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
        <20220630111327.3a951e3b@kernel.org>
        <YsbBbBt+DNvBIU2E@nanopsycho>
        <20220707131649.7302a997@kernel.org>
        <YsfcUlF9KjFEGGVW@nanopsycho>
        <20220708110535.63a2b8e9@kernel.org>
        <YskOt0sbTI5DpFUu@nanopsycho>
        <20220711102957.0b278c12@kernel.org>
        <Ys0OvOtwVz7Aden9@nanopsycho>
        <20220712171341.29e2e91c@kernel.org>
        <Ys5SRCNwD8prZ0pL@nanopsycho>
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

On Wed, 13 Jul 2022 07:04:04 +0200 Jiri Pirko wrote:
> Wed, Jul 13, 2022 at 02:13:41AM CEST, kuba@kernel.org wrote:
> >> I don't think this has anything to do with netdev model. 
> >> It is actually out of the scope of it, therefore there cannot be any mudding of it.  
> >
> >You should have decided that rate limiting was out of scope for netdev
> >before we added tc qdisc and tc police support. Now those offloads are
> >there, used by people and it's too late.
> >
> >If you want to create a common way to rate limit functions you must
> >provide plumbing for the existing methods (at least tc police,
> >preferably legacy NDO as well) to automatically populate the new API.  
> 
> Even if there is no netdevice to hook it to, because it does not exist?
> I have to be missing something, sorry :/

What I'm saying is that we can treat the devlink rate API as a "lower
layer interface". A layer under the netdevs. That seems sensible and
removes the API duplication which otherwise annoys me.

We want drivers to only have to implement one API.

So when user calls the legacy NDO API it should check if the device has
devlink rate support, first, and try to translate the legacy request
into devlink rate.

Same for TC police as installed by the OvS offload feature that Simon
knows far more about than I do. IIRC we use a combination of matchall
and police to do shaping.

That way drivers don't have to implement all three APIs, only devlink
rate (four APIs if we count TC qdisc but I think only NFP uses that
one and it has RED etc so that's too much).

Does this help or am I still not making sense?
