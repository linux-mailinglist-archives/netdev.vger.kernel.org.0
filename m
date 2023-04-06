Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930466D9D7F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 18:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238682AbjDFQZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 12:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbjDFQZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 12:25:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA86D46B3
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 09:25:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E06860D2D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE27C433EF;
        Thu,  6 Apr 2023 16:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680798310;
        bh=voEKh0gXuGpuufJcxWGEcbDKLnc9kXxQvXL1LZIzdqU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=vDTIk60E7OBX3uLR5GUxVePsvcE9oE3IqMZF5zJieCv6cl1o+MGyaxlJIv055035U
         qLxhtXV7YUhcz4mRsh4nYY5TKg0Aq9xd9IDcC/JtXc4RieBQZYA4pi9ySeIKuzv5IJ
         mJyVGV7nITzRjTkasQJSudEn4vSLo6wFuC0q9ZcSpBzj9zMOGmOHbjRg7LWEO8lD/4
         RQW00nw+EAiAJ4hYAAItm6hzyJtUCAGiEZq2sA1/usAV7BUUvm3cRC80XoR6psVkTT
         NLG+JSeP88f/1y+f42yQoU8sagjOT+0ocahx2US5x3m4tKOj5RS/0reOzgEJZqottR
         nZ0H2u1c+eJUg==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 5904115404B4; Thu,  6 Apr 2023 09:25:10 -0700 (PDT)
Date:   Thu, 6 Apr 2023 09:25:10 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <5f1ea1ed-739d-4d0d-a08e-748249ef8175@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20230403085601.44f04cd2@kernel.org>
 <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
 <20230403120345.0c02232c@kernel.org>
 <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
 <1e9bbdde-df97-4319-a4b7-e426c4351317@paulmck-laptop>
 <ZC5VbfkTIluwKYDn@gondor.apana.org.au>
 <dba8aec7-f236-4cb6-b53b-fabefcfa295a@paulmck-laptop>
 <20230406074648.4c26a795@kernel.org>
 <c3b05efb-e691-4947-84f9-cf524e7d2cd9@paulmck-laptop>
 <20230406085629.3e0c9514@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406085629.3e0c9514@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 08:56:29AM -0700, Jakub Kicinski wrote:
> On Thu, 6 Apr 2023 08:45:10 -0700 Paul E. McKenney wrote:
> > > Starting the queue only happens from softirq (I hope) and stopping 
> > > can happen from any context. So we're risking false-starts again.
> > > I think this puts to bed any hope of making this code safe against
> > > false-starts with just barriers :(  
> > 
> > Is it possible to jam all the relevant state into a single variable?
> > (I believe that that answer is "no", but just in case asking this question
> > inspires someone to come up with a good idea.)
> 
> Not in any obvious way, half of the state is driver-specific the other
> half is flags maintained by the core :S

Hey, I had to ask!  ;-)

							Thanx, Paul
