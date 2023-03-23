Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94A06C5F0A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjCWFho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjCWFha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:37:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C9E2E835
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9D6B623CB
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9E9C433EF;
        Thu, 23 Mar 2023 05:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679549834;
        bh=Akx83h+WYZ34peLYb8XQdc/MRPVhM0jPFekIbdtI1Vw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ffERXjvjiAtH9/r5lUjL+wKB2LXYgcpaXXA2wJS6Z45JTIKUJM/ZGYm87Bzr0mN4H
         o9hwUTp+dIO5Vhn2V3iC8J6ZQ9TNWhGC2XIRuBcy7jCEk1pHZKAGI30SWrzxbffHoP
         ngWHzzviKvMFhO0wjo67cB3eGs9r3ZMxzkUHIsIQqY9NXBdDvxjc+/gSk/J9mRRPqV
         Kdli1rpA5Ul/Zm73wWXjPaO3INl8NxYPvc+XMPImEjfbJQLGv4rIobw3dWd0GsaYvb
         6WjvepC0ZCyUUFB6Ke3JWti97LHv+4D/SbvqzTjnCuS36nTcY8l3CSIzGdEz/bpMZU
         I9JQktn5PKnhg==
Date:   Wed, 22 Mar 2023 22:37:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: ethernet: mtk_eth_soc: fix flow block
 refcounting
Message-ID: <20230322223713.4e339b35@kernel.org>
In-Reply-To: <ZBsR0C/3+0ZsWnhf@corigine.com>
References: <20230321133719.49652-1-nbd@nbd.name>
        <ZBsR0C/3+0ZsWnhf@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 15:33:52 +0100 Simon Horman wrote:
> On Tue, Mar 21, 2023 at 02:37:18PM +0100, Felix Fietkau wrote:
> > Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we need to call
> > flow_block_cb_incref unconditionally, even for a newly allocated cb.
> > Fixes a use-after-free bug. Also fix the accidentally inverted refcount
> > check on unbind.  
> 
> Firstly, it's usually best to have one fix per patch.

Or at least reword the commit message to make it look like it's fixing
the refcounting logic?

> >  		block_cb = flow_block_cb_lookup(f->block, cb, dev);
> > -		if (block_cb) {
> > -			flow_block_cb_incref(block_cb);
> > -			return 0;
> > +		if (!block_cb) {
> > +			block_cb = flow_block_cb_alloc(cb, dev, dev, NULL);
> > +			if (IS_ERR(block_cb))
> > +				return PTR_ERR(block_cb);
> > +
> > +			register_block = true;
> >  		}
> > -		block_cb = flow_block_cb_alloc(cb, dev, dev, NULL);
> > -		if (IS_ERR(block_cb))
> > -			return PTR_ERR(block_cb);
> >  
> > -		flow_block_cb_add(block_cb, f);
> > -		list_add_tail(&block_cb->driver_list, &block_cb_list);
> > +		flow_block_cb_incref(block_cb);
> > +
> > +		if (register_block) {
> > +			flow_block_cb_add(block_cb, f);
> > +			list_add_tail(&block_cb->driver_list, &block_cb_list);
> > +		}
> >  		return 0;  
> 
> I think the existing code was more idiomatic, and could
> be maintained by simply adding a call to flow_block_cb_incref()
> before the call to flow_block_cb_add().
> 
> @@ -576,6 +576,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
>  		if (IS_ERR(block_cb))
>  			return PTR_ERR(block_cb);
>  
> +		flow_block_cb_incref(block_cb);
>  		flow_block_cb_add(block_cb, f);
>  		list_add_tail(&block_cb->driver_list, &block_cb_list);
>  		return 0;

That'd be my go to fix as well, FWIW.

Alternatively - the block cannot be removed until FLOW_BLOCK_UNBIND is
called, right? So the register_block bool can be skipped and
refcount taken after flow_block_cb_add() / list_add_tail().
That way at least the new block handling doesn't have to be split
into two chunks.
