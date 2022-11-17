Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584C262DAF2
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbiKQMd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240165AbiKQMdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:33:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E04E76178
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:32:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C3061965
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523D2C433D6;
        Thu, 17 Nov 2022 12:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668688336;
        bh=dl7w4Rfw/ijV2UH1mX/hCcL7UbcWqmPRa+d5LxVKE58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hvkBQLKV4E1L/qW9XfL7SeOcWZNIaz+RSCF22XGhbEMb7nCyAFYqLC6xhJjV0+b+f
         MdCj0UMPBurO/GvD9o/ZoWMvX8DfW/iTLs58/uDudcf7DgkAtiRtpod1rOOG4UTFUf
         qVlTP0UvIamVw0UB8niqvMteV5fjfK5XFYPllVtgNVLiHeyLn9KUpojdDQXSno/9+P
         EfHAASdXzImPXgpnPcojTooI/9qPtn/9w7nXtDYi4CE3laILBQzlAYwhfYI9RwQhZp
         vYKQWWzIMwfq3FTKJ79V+aiihdzE+BosQ415wWnuQh/L6bt16SGo0iGi7mMkFYdzzG
         lhZrhbuWggA9Q==
Date:   Thu, 17 Nov 2022 14:32:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 4/8] xfrm: add TX datapath support for IPsec
 packet offload mode
Message-ID: <Y3YpyplG969qtYO3@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
 <f0148001c77867d288251a96f6d838a16a6dbdc4.1667997522.git.leonro@nvidia.com>
 <20221117115939.GI704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117115939.GI704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 12:59:39PM +0100, Steffen Klassert wrote:
> On Wed, Nov 09, 2022 at 02:54:32PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> 
> > @@ -2708,6 +2710,23 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
> >  	if (!dev)
> >  		goto free_dst;
> >  
> > +	dst1 = &xdst0->u.dst;
> > +	/* Packet offload: both policy and SA should be offloaded */
> > +	if ((policy->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
> > +	     dst1->xfrm->xso.type != XFRM_DEV_OFFLOAD_PACKET) ||
> > +	    (policy->xdo.type != XFRM_DEV_OFFLOAD_PACKET &&
> > +	     dst1->xfrm->xso.type == XFRM_DEV_OFFLOAD_PACKET)) {
> > +		err = -EINVAL;
> > +		goto free_dst;
> > +	}
> > +
> > +	/* Packet offload: both policy and SA should have same device */
> > +	if (policy->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
> > +	    policy->xdo.dev != dst1->xfrm->xso.dev) {
> > +		err = -EINVAL;
> > +		goto free_dst;
> > +	}
> > +
> 
> This is the wrong place for these checks. Things went already wrong
> in the lookup if policy and state do not match here.

Where do you think we should put such checks?

We need to make sure that both policy and SA are offloaded when handle
packet, It prevents various corner cases where we will mix SW and HW
paths.

xfrm_bundle_create() is called when we perform XFRM lookup to create dst_entry.

Thanks
