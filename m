Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B07E5A3CFD
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 11:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiH1J2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 05:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiH1J2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 05:28:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19F9550AC
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 02:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8532A60F2C
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 09:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A66BC433C1;
        Sun, 28 Aug 2022 09:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661678918;
        bh=1sWq5xPtyKIhGc9UXdt4kBKH1wr8hfjZcwvqZ3WTgMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Un3CU9Uwoxlt00QFjAnQCl6T4GLLygZWmfDLyZP1gbhA/dXzbU/meKxKfxpDM1MMH
         yyjmSnjziqaqZR2sW2QQbTjgGQakn40FRcfV0fULnjTxLluO6S49Ap1o/94VJ5f8rG
         INfi+eurEaI8QrlxE7pP61Fqza9kEeBh8A1vD5wmYp1DgRdz9RCasukMFOPbna8Kyn
         gvkbm2xuU2aRTroj/LQ/FpN5iiJ3eljzAXK/jFPQQD+gmM8zvmbllvDsrkxH8WbT4k
         m8mYN8G4CTqLMYaGFH+RTYCvz4gQa/3e9MOXeL551NyFLYz7+AT2ViBfwEQXoJscj2
         IzJeJUMbJ4aJg==
Date:   Sun, 28 Aug 2022 12:28:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next v3 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <Yws1Qs4+1Omo8DPL@unreal>
References: <cover.1661260787.git.leonro@nvidia.com>
 <20220825143610.4f13f730@kernel.org>
 <YwhnsWtzwC/wLq1i@unreal>
 <20220826164522.33bfe68c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826164522.33bfe68c@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 04:45:22PM -0700, Jakub Kicinski wrote:
> On Fri, 26 Aug 2022 09:26:57 +0300 Leon Romanovsky wrote:
> > On Thu, Aug 25, 2022 at 02:36:10PM -0700, Jakub Kicinski wrote:
> > > On Tue, 23 Aug 2022 16:31:57 +0300 Leon Romanovsky wrote:  
> > > >  * I didn't hear any suggestion what term to use instead of
> > > >    "full offload", so left it as is. It is used in commit messages
> > > >    and documentation only and easy to rename.
> > > >  * Added performance data and background info to cover letter
> > > >  * Reused xfrm_output_resume() function to support multiple XFRM transformations
> > > >  * Add PMTU check in addition to driver .xdo_dev_offload_ok validation
> > > >  * Documentation is in progress, but not part of this series yet.  
> > > 
> > > Since the use case is somewhat in question, perhaps switch to RFC
> > > postings until the drivers side incl. tc forwarding is implemented?  

<...>

> > We also don't offload anything related to routing as we can't
> > differentiate between local traffic.
> 
> Yeah, nah, that's not what I'm asking for.
> I said forwarding, not sending traffic thru a different virtual
> interface. The TC rules must forward from or two the IPSec ifc.
> 
> That was the use case Jason mentioned.

I see, word "TC" confused me, sorry about that.

My next mlx5-related task after this IPsec full offload will be accepted
is to extend mlx5 with extra eswitch logic.

There is no change in API, xfrm code or behavior, just internal change
where IPsec flow steering tables will be created and how they will be
created/destroyed. 

Unfortunately, this "just.." change is a complicated task due to mlx5 core
internal implementation and will take time, but as I said, I will do it.

> 
> > > Also the perf traces, I don't see them here.  
> > 
> > It is worth to separate it to standalone discussion with a title:
> > "why crypto is not fast enough?". I don't think that mixed discussions
> > about full offload which Steffen said that he is interested and
> > research about crypto bottlenecks will be productive. These discussions
> > are orthogonal.
> 
> What do you mean by crypto bottlenecks?

I think that I used same language all the time.
* IPsec SW - software path
* IPsec crypto - HW offload of crypto part
* IPsec full offload - state and policy offloads to the HW. 

I will try to be more clear next time.

> 
> Please use more precise language. crypto here may mean "crypto only
> offload" or "crypto as done by CPU". I have no idea which one you mean.
> 
> We are very much interested in the former, the latter is indeed out of
> scope here.
