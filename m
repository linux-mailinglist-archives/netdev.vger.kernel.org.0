Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975845E66FC
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiIVPXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiIVPXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:23:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F861F858A
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:23:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB75C6361D
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DD3C433D6;
        Thu, 22 Sep 2022 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663860231;
        bh=LAEX5cCEFf1NDGEF0tN2HavSK3D8M6bseQWsmZQhkWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LY3Obt99UC79MQAXv6L2NQsle92FI0ztsf8vP+PIKjjKGIyoadWnFrDxzZieVoQSc
         6j6xur17ZLxqp++ifsEOFwPG5SrWK4hDVzpI46QrQNPwVOY14WLK9P30hpU2QJ+N+u
         aEvFP5T10hVRTu/cVq2fusnU3XTVOgr4iLpPwpzsEWl/2q6LHDaOqjdd7DxIfLgh7L
         YGcKVpgZzoVxyswtB3Yx1znVG3RJ6OSESrZaYt3jbuiGe6RKwTn7puj/kK0wyNaF39
         o4go38w1HN43r5EUk/EbdhGzAKnx4qC04M5fnlHAsLU8jqcp3htEg4vceuSNLlD+XX
         cgs0JLtI7B/Sw==
Date:   Thu, 22 Sep 2022 08:23:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Paul Blakey <paulb@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net 1/1] net: Fix return value of qdisc ingress handling
 on success
Message-ID: <20220922082349.18fb65d6@kernel.org>
In-Reply-To: <2338579f-689f-4891-ec58-22ac4046dd5a@iogearbox.net>
References: <1663750248-20363-1-git-send-email-paulb@nvidia.com>
        <c322d8d6-8594-65a9-0514-3b6486d588fe@iogearbox.net>
        <20220921074854.48175d87@kernel.org>
        <2338579f-689f-4891-ec58-22ac4046dd5a@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 16:47:14 +0200 Daniel Borkmann wrote:
> >> Looks reasonable and aligns with sch_handle_egress() fwiw. I think your Fixes tag is wrong
> >> since that commit didn't modify any of the above. This patch should also rather go to net-next
> >> tree to make sure it has enough soak time to catch potential regressions from this change in
> >> behavior.  
> > 
> > I don't think we do "soak time" in networking. Perhaps we can try
> > to use the "CC: stable # after 4 weeks" delay mechanism which Greg
> > promised at LPC?  
> 
> Isn't that implicit? If the commit has Fixes tag and lands in net-next, stable team
> anyway automatically pulls it once everything lands in Linus' tree via merge win and
> then does the backporting for stable.

What I meant is we don't merge fixes into net-next directly.
Perhaps that's my personal view, not shared by other netdev maintainers.

To me the 8 rc release process is fairly arbitrary timing wise.
The fixes continue flowing in after Linus cuts final, plus only 
after a few stable releases the kernel makes it to a wide audience.

Putting a fix in -next gives us anywhere between 0 and 8 weeks of delay.
Explicit delay on the tag seems much more precise and independent of
where we are in the release cycle.

The cases where we put something in -next, later it becomes urgent 
and we can't get it to stable stand out in my memory much more than
problems introduced late in the rc cycle.
