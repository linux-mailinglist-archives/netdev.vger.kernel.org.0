Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92DD63201D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiKULPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiKULOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:14:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD26FBFF64
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5149AB80E6D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7898CC433B5;
        Mon, 21 Nov 2022 11:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669029020;
        bh=vmnKL1HNdj9hjcxqAxzTQCOjgehMdyfX0jZXqfWGi5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L1einEpB2zxZ88yjuL1bXoAcayg6qfHsiwPbfhsog70vmdgcAaGZl2sOI5vLztUf3
         NStw05LspmER4w8bU2yrDacc2ojhWkM3j/3gIyL+RKlwSzvUdTN8A9T1FmFTiiTYwc
         1glaXGE7c7jPIbgUoMGY7so42miNwBKobuDtfYcFM/vsrpioCXVUZzqFKwjWfWDG95
         u7AJxN9vXbjAPtXKyCvmktUcNtJpG7KMl24S6qkv2bKxPLc2eaGaPjQ9Z3pptppMd9
         WnVMsuNzvYlLeS9fmmTBlyvZ3tgcMXxSXa2/lYC2X/olsKOj5dJDCHCGxnaDdaevpM
         0GjO2OH44c4uw==
Date:   Mon, 21 Nov 2022 13:10:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 4/8] xfrm: add TX datapath support for IPsec
 packet offload mode
Message-ID: <Y3tcl3H/d9tkj/v8@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
 <f0148001c77867d288251a96f6d838a16a6dbdc4.1667997522.git.leonro@nvidia.com>
 <20221117115939.GI704954@gauss3.secunet.de>
 <Y3YpyplG969qtYO3@unreal>
 <20221118102310.GQ704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118102310.GQ704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 11:23:10AM +0100, Steffen Klassert wrote:
> On Thu, Nov 17, 2022 at 02:32:10PM +0200, Leon Romanovsky wrote:
> > On Thu, Nov 17, 2022 at 12:59:39PM +0100, Steffen Klassert wrote:
> > > On Wed, Nov 09, 2022 at 02:54:32PM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > > @@ -2708,6 +2710,23 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
> > > >  	if (!dev)
> > > >  		goto free_dst;
> > > >  
> > > > +	dst1 = &xdst0->u.dst;
> > > > +	/* Packet offload: both policy and SA should be offloaded */
> > > > +	if ((policy->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
> > > > +	     dst1->xfrm->xso.type != XFRM_DEV_OFFLOAD_PACKET) ||
> > > > +	    (policy->xdo.type != XFRM_DEV_OFFLOAD_PACKET &&
> > > > +	     dst1->xfrm->xso.type == XFRM_DEV_OFFLOAD_PACKET)) {
> > > > +		err = -EINVAL;
> > > > +		goto free_dst;
> > > > +	}
> > > > +
> > > > +	/* Packet offload: both policy and SA should have same device */
> > > > +	if (policy->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
> > > > +	    policy->xdo.dev != dst1->xfrm->xso.dev) {
> > > > +		err = -EINVAL;
> > > > +		goto free_dst;
> > > > +	}
> > > > +
> > > 
> > > This is the wrong place for these checks. Things went already wrong
> > > in the lookup if policy and state do not match here.
> > 
> > Where do you think we should put such checks?
> 
> You need to create a new lookup key for this and match the policies
> template against the TS of the state. This happens in xfrm_state_find.
> Unfortunately this affects also the SW datapath even without HW
> policies/states. So please try to make it a NOP if there are no HW
> policies/states.

Do you think that this will be enough?

+static bool xfrm_state_and_policy_mixed(struct xfrm_state *x,
+                                       struct xfrm_policy *p)
+{
+       /* Packet offload: both policy and SA should be offloaded */
+       if (p->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
+           x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
+               return true;
+
+       if (p->xdo.type != XFRM_DEV_OFFLOAD_PACKET &&
+           x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
+               return true;
+
+       if (p->xdo.type != XFRM_DEV_OFFLOAD_PACKET)
+               return false;
+
+       /* Packet offload: both policy and SA should have same device */
+       if (p->xdo.dev != x->xso.dev)
+               return true;
+
+       return false;
+}
+
 struct xfrm_state *
 xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
                const struct flowi *fl, struct xfrm_tmpl *tmpl,
@@ -1228,6 +1250,10 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
                        *err = -EAGAIN;
                        x = NULL;
                }
+               if (x && xfrm_state_and_policy_mixed(x, pol)) {
+                       *err = -EINVAL;
+                       x = NULL;
+               }
        } else {
                *err = acquire_in_progress ? -EAGAIN : error;
        }
(END)


> 
