Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AEB65F395
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjAESQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjAESQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:16:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603A22672;
        Thu,  5 Jan 2023 10:16:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F139C61AC9;
        Thu,  5 Jan 2023 18:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A869C433D2;
        Thu,  5 Jan 2023 18:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672942604;
        bh=spNqhtecEzPXAesgLew7Qzlo1+T6wWByMbgn+mPFE/k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BQxyw/QwqmefFG99oJIJkSqeYJbbi9n77zfW2iRTIXHZlPVP7BXBtfs8Sh4RTV2a7
         zkfGObdd7AirnrSsI82jVtFkf9/rGJ8d3YdgDDvW/0Qa5EGsGgfOBRNxJPR0VcvL9m
         f0z1hu9/7ShKje7XFIMkPuzZx2V+IBNgVrEFmS5jZXmvNccn7v0lKEnwKaaxOMJxW2
         sT+/uRFGxjHXaaVDrSN6kJvsUQKH8dvfva2t+QjUxrIM7bbcQSaKBEdk+6LoKG2lzs
         nMyka6+xEMD0RHozi6urGxpJpnrAixepU1qPUrfjYjNuuBjsgrwmL5gU0N2yNt6DFi
         IqQCQ+pQQTf7Q==
Date:   Thu, 5 Jan 2023 10:16:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        lorenzo.bianconi@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Message-ID: <20230105101642.1a31f278@kernel.org>
In-Reply-To: <Y7cBfE7GpX04EI97@C02YVCJELVCG.dhcp.broadcom.net>
References: <20220621175402.35327-1-gospo@broadcom.com>
        <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
        <87k0234pd6.fsf@toke.dk>
        <20230103172153.58f231ba@kernel.org>
        <Y7U8aAhdE3TuhtxH@lore-desk>
        <87bkne32ly.fsf@toke.dk>
        <a12de9d9-c022-3b57-0a15-e22cdae210fa@gmail.com>
        <871qo90yxr.fsf@toke.dk>
        <Y7cBfE7GpX04EI97@C02YVCJELVCG.dhcp.broadcom.net>
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

On Thu, 5 Jan 2023 11:57:32 -0500 Andy Gospodarek wrote:
> > So my main concern would be that if we "allow" this, the only way to
> > write an interoperable XDP program will be to use bpf_xdp_load_bytes()
> > for every packet access. Which will be slower than DPA, so we may end up
> > inadvertently slowing down all of the XDP ecosystem, because no one is
> > going to bother with writing two versions of their programs. Whereas if
> > you can rely on packet headers always being in the linear part, you can
> > write a lot of the "look at headers and make a decision" type programs
> > using just DPA, and they'll work for multibuf as well.  
> 
> The question I would have is what is really the 'slow down' for
> bpf_xdp_load_bytes() vs DPA?  I know you and Jesper can tell me how many
> instructions each use. :)

Until we have an efficient and inlined DPA access to frags an
unconditional memcpy() of the first 2 cachelines-worth of headers
in the driver must be faster than a piece-by-piece bpf_xdp_load_bytes()
onto the stack, right?

> Taking a step back...years ago Dave mentioned wanting to make XDP
> programs easy to write and it feels like using these accessor APIs would
> help accomplish that.  If the kernel examples use bpf_xdp_load_bytes()
> accessors everywhere then that would accomplish that.

I've been pushing for an skb_header_pointer()-like helper but 
the semantics were not universally loved :)
