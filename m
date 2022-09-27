Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A897D5EBF9E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiI0KWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiI0KVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:21:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1A5CDCE1
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6991F617AD
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 10:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C85DC433D6;
        Tue, 27 Sep 2022 10:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664274113;
        bh=C0wwzcmNWptVCyQS7D7RUukRfwPISMCKmGSa8U8wHhQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YUK8OAMvz5qEg+wgJTHfzeT68QuMi8I19pfARnx5P0EkwXQZ8sYR8NHcgdAy7jbB1
         VC4kEGItLtJ0sq1kCXkE1p5b8DIySUqyJcV8dZ9qcTSgakTU3Ht0KkaRHd60XZ2P8C
         kycO3UKVvFjuWXxKIPvpp2HWkFLb3HkIrh3wknsm8lJ/WLE691+Vytzmn9o88EGuPQ
         0YLpH1S1WfbYbNLqeD9qAIP7H13jvmXFiiks6frerHcCZSEKTTUE3zjsd+t4fUgYVI
         iT/lJ24Zm1vOcsPf4gHKmPeKVGIiKC8g+J1nGhQ8pAvOXU4UFQjgmngmC6ihx8Yo21
         a220Ko/pcCbAw==
Date:   Tue, 27 Sep 2022 13:21:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 6/8] xfrm: enforce separation between
 priorities of HW/SW policies
Message-ID: <YzLOvT4t2LLpa0UF@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
 <1b9d865971972a63eaa2c076afd71743952bd3c8.1662295929.git.leonro@nvidia.com>
 <20220925093454.GU2602992@gauss3.secunet.de>
 <YzFI0kxN3k2EZw0v@unreal>
 <20220927054838.GL2950045@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927054838.GL2950045@gauss3.secunet.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 07:48:38AM +0200, Steffen Klassert wrote:
> On Mon, Sep 26, 2022 at 09:38:10AM +0300, Leon Romanovsky wrote:
> > On Sun, Sep 25, 2022 at 11:34:54AM +0200, Steffen Klassert wrote:
> > > On Sun, Sep 04, 2022 at 04:15:40PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Devices that implement IPsec full offload mode offload policies too.
> > > > In RX path, it causes to the situation that HW can't effectively handle
> > > > mixed SW and HW priorities unless users make sure that HW offloaded
> > > > policies have higher priorities.
> > > > 
> > > > In order to make sure that users have coherent picture, let's require
> > > > that HW offloaded policies have always (both RX and TX) higher priorities
> > > > than SW ones.
> > > > 
> > > > To do not over engineer the code, HW policies are treated as SW ones and
> > > > don't take into account netdev to allow reuse of same priorities for
> > > > different devices.
> > > 
> > > I think we should split HW and SW SPD (and maybe even SAD) and priorize
> > > over the SPDs instead of doing that in one single SPD. Each NIC should
> > > maintain its own databases and we should do the lookups from SW with
> > > a callback. 
> > 
> > I don't understand how will it work and scale.
> 
> That is rather easy. HW offload devices register their databases
> at the xfrm layer with a certain priority higher than the one
> of the SW databases. The lookup will happen consecutively based
> on the database priorities. If there are no HW databases are
> registered everything is like it was before. It gives us a clear
> separation between HW and SW.
> 
> This has the advantage that you don't need to mess with policy
> priorites. User can keep the priorites as they were before. This
> is in particular important because usually the IKE daemon chosses
> the priorities based on some heuristics.
> 
> The HW offload has also the advantage that we don't need to
> search through all SW policies and states in that case.

And disadvantage for SW policies, because once you register HW DB, you
will first lookup there, won't find and fallback to perform another
lookup in SW.

<...>

> > It makes no
> > sense to convert data from XFRM representation to HW format, execute in
> > HW and convert returned result back. It will be also slow because lookup
> > of SP/SA based on XFRM properties is not datapath.
> 
> In case the HW can't do the lookup itself or is considered to be slower
> than in software, a separated database for HW offload devices can be
> maintained.

ok, this is my case.
I'll try to see what I can do here.

Thanks
