Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F046C62C925
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 20:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiKPTqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 14:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiKPTqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 14:46:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DDD27CE8;
        Wed, 16 Nov 2022 11:46:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 561AC61F7C;
        Wed, 16 Nov 2022 19:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52258C433D6;
        Wed, 16 Nov 2022 19:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668627994;
        bh=v9i08SgmR4P+otCsZt87j/UxmXP81hkv7DfyvtbixPY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=etZxJrXg1caExsnBfrraleQ96DDGCKVg89i+k3HPpT+zHtHiRivr99b6u0KGPwBvg
         LpPVx3/U0/9TqKWNh/aAzYP+5tPFwJNiNPsyhyp6mOiH9/rBPfrlQJBnPSAvjqpTme
         gpud1fuBfFNdcNGpyBVP0cc/nSDl4FqhFi9JvjAZcQNYJIxXvOr0i6Ra1bSFqa90eI
         Hz8Wq3fEGe/eGE6ipUv/5yHIX7JofhLl1xFdctCPA9CMYE4xucmus2NEbHk5xvlafS
         78cHppV2Jl9QpttzEf2+8rTy0GtiuZX1U19pRWBkPkyOA2c1qYiwZSFUAFPSqGa11A
         rrfDSoCSM0jfA==
Date:   Wed, 16 Nov 2022 11:46:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@meta.com>, hawk@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Message-ID: <20221116114633.6a297935@kernel.org>
In-Reply-To: <63728784e2d15_43f25208be@john.notmuch>
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
        <20221109215242.1279993-2-john.fastabend@gmail.com>
        <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
        <636c5f21d82c1_13fe5e208e9@john.notmuch>
        <aeb8688f-7848-84d2-9502-fad400b1dcdc@meta.com>
        <636d82206e7c_154599208b0@john.notmuch>
        <636d853a8d59_15505d20826@john.notmuch>
        <86af974c-a970-863f-53f5-c57ebba9754e@meta.com>
        <637136faa95e5_2c136208dc@john.notmuch>
        <10b5eb96-5200-0ffe-a1ba-6d8a16ac4ebe@meta.com>
        <63728784e2d15_43f25208be@john.notmuch>
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

On Mon, 14 Nov 2022 10:23:00 -0800 John Fastabend wrote:
> > > The other piece I would like to get out of the xdp ctx is the
> > > rx descriptor of the device. I want to use this to pull out info
> > > about the received buffer for debug mostly, but could also grab
> > > some fields that are useful for us to track. That we can likely
> > > do this,
> > > 
> > >    ctx->rxdesc  
> > 
> > I think it is possible. Adding rxdesc to xdp_buff as
> >      unsigned char *rxdesc;
> > or
> >      void *rxdesc;

We should avoid having to add fields to structures just to expose 
them to BPF. Would the approach that Stan uses not work here?
Having the driver place the desc pointer in a well known location
on the stack and kfunc or some other magic resolve it?
 
> > and using bpf_get_kern_btf_id(kctx->rxdesc, expected_btf_id)
> > to get a btf id for rxdesc. Here we assume there is
> > a struct available for rxdesc in vmlinux.h.
> > Then you can trace through rxdesc with direct memory
> > access.  
> 
> The trickest part here is that the rxdesc btf_id depends on 
> what device we are attached to. So would need something to
> resolve the btf_id from attached device.

Right, driver needs to get involved one way or another, so it can
return "how to get to the descriptor given a xdp_buff pointer" 
as well as the btf_id or dynptr params.

(Sorry, I'm only catching up with the xdp hw field discussions
now so this may have already been discussed elsewhere..)
