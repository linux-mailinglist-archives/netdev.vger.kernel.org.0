Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE8A62CD79
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbiKPWPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiKPWPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:15:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE28F5E;
        Wed, 16 Nov 2022 14:15:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE23FB81D80;
        Wed, 16 Nov 2022 22:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B267C433C1;
        Wed, 16 Nov 2022 22:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668636920;
        bh=q8X165r74UwwSmeNoNKF3zS++peos+gHYcaI3lOLpmk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WyLizanc7pR4cofvRgrdnnRL78SV4Ne05ZVfBAORjehHjCUM7kFgV0m8sTiww07pU
         HaE5rkcWuEqfcYK1OSwnR1RlCuN4NyCcFU3jjatTWKNV6aqklGPLq9fCwGqC8AwCg0
         MItS9yoBg4dMc5gSnDKpDAKlWz4gSOCVNeeYx+aWemsqquMpNk1ZVmMy3Dn6PNTbiy
         s+x50KbZQP56P6D7yFLQi5+IiMsIhuIhxAWZTFW+F/XQ52S7gYoDY1uh0UM7+5tOD/
         ohbKmzcF57nIW1ZkTYhquHt2WrlfEhLU02Dj39HnQhkmef6a71Ok8tvwV5FbaiUARq
         brSYfbn3UuFgQ==
Date:   Wed, 16 Nov 2022 14:15:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: Fix tcp_syn_flood_action() if
 CONFIG_IPV6=n
Message-ID: <20221116141519.0ef42fa2@kernel.org>
In-Reply-To: <CAAvyFNhbsks96=yyWHDCi-u+A1vaEy845_+pytghAscoG0rrTQ@mail.gmail.com>
References: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
        <20221116123115.6b49e1b8@kernel.org>
        <CAAvyFNhbsks96=yyWHDCi-u+A1vaEy845_+pytghAscoG0rrTQ@mail.gmail.com>
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

On Thu, 17 Nov 2022 08:39:43 +1100 Jamie Bainbridge wrote:
> >         if (v6) {
> > #ifdef v6
> >                 expensive_call6();
> > #endif
> >         } else {
> >                 expensive_call6();
> >         }  
> 
> These should work, but I expect they cause a comparison which can't be
> optimised out at compile time. This is probably why the first style
> exists.
> 
> In this SYN flood codepath optimisation doesn't matter because we're
> doing ratelimited logging anyway. But if we're breaking with existing
> style, then wouldn't the others also have to change to this style? I
> haven't reviewed all the other usage to tell if they're in an oft-used
> fastpath where such a thing might matter.

I think the word style already implies subjectivity.
