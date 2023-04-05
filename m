Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C1D6D8007
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 16:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbjDEOu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 10:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbjDEOu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 10:50:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1EE65A8
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 07:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB247629BF
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 14:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9321C433EF;
        Wed,  5 Apr 2023 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680706252;
        bh=yThYtsXxYkuN8/NmxGQJA0k+d6J/oOwW/Bgh1fxgTCE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=syWlWTx3xEaSiXF0gazPRw9obrmVqEYrkzkCLKpPfVuwSOFb2Ox/DkIZ7YVd/KYhM
         JZGHC4uTSW6LfhMffGlEMGViXGeSqGVwQ5wOmb/QfQr52bzrJouSio+99CEdwDKup2
         C0ZhWS1SgyvvqwX9DiZHQwq3psPFPUvaTD4L2iwCj212SCXsy7gBC4xhoIEzBi5neT
         +37HJ8t+x9jIhuF55JdQtfdMF93azPFDQE8K+Vk7QyUs2iiwYV1iwciuWVYfZcS1Dn
         CyN98Ox3MfObl12xUXm1vzlN2VWZd6DzvItWb1LWgOQH2KbGCNZ3WteHwcpqeeslom
         oM/q1IX2DgCzQ==
Date:   Wed, 5 Apr 2023 07:50:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>,
        ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing
 SKBs
Message-ID: <20230405075050.2fbc4502@kernel.org>
In-Reply-To: <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
        <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
        <20230404182116.5795563c@kernel.org>
        <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Apr 2023 16:18:47 +0800 Liang Chen wrote:
> > Sounds like a better fix, indeed. But this sort of code will require
> > another fat comment above to explain why. This:
> >
> >         if (to->pp_recycle == from->pp_recycle && !skb_cloned(from))
> >
> > is much easier to understand, no?
> >
> > We should at least include that in the explanatory comment, I reckon...  
> 
> Sure, the idea of dealing with the case where @from transitioned into non cloned
> skb in the function retains the existing behavior, and gives more
> opportunities to
> coalesce skbs. And it seems (!skb_cloned(from) && !from->pp_recycle) is enough
> here.

Well, that's pretty much what Alex suggested minus the optimization he
put in for "was never cloned" which is probably worth having. So if
you're gonna do this just use his code.

My point was that !from->pp_recycle requires the reader to understand
the relationship between this check and the previous condition at entry.
While to->pp_recycle == from->pp_recycle seems much more obvious to me -
directly shifting frags between skbs with different refcount styles is
dangerous.

Maybe it's just me, so whatever.
Make sure you write a good comment.

> I will take a closer look at the code path for the fragstolen case
> before making v2
> patch  -  If @from transitioned into non cloned skb before "if
> (skb_head_is_locked(from))"
> 
> Thanks for the reviews.
