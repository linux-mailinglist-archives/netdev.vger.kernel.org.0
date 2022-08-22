Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C9E59C434
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbiHVQdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237067AbiHVQdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:33:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FC93B961
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 09:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 636BFB81615
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 16:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32D2C433C1;
        Mon, 22 Aug 2022 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661185986;
        bh=okvfTxnpv+Axn2zpjWxtaeu8VLtV6+Dtzc6KU82akzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sJs4MW+U+KUE3XK22lII0tbAlEyUgzV5iH8aLhPMDDHXALEvk25OOcYhaWSHyfItB
         cLjdqgCXIKIH5J1/71lEHLhnzQhQlxpWFsRk/AEPAIV/RG+DnuMYdIlIaSmwJKXVI8
         3whtcbxpytJxw1QpiOvnhOVH/vB8esGinFDAoWmKxjeuNxydSq9gjY8tuC+D+G/cD6
         q6sSJpWgcRvURqRmZRlvKmld5KyOs+H5v0WBmOoxSvNVeVnF6cTdEfSpYZknt6ScMy
         gYhWzT673FWNfUOHwIwmTry/Y2t2Jmc/PdTe3tbi2tRt2Xk4/Atuy/zmSA1v3s7dKc
         Eyw7IaRN3CbWg==
Date:   Mon, 22 Aug 2022 09:33:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220822093304.7ddc5d35@kernel.org>
In-Reply-To: <YwNEUguW7aTXC2Vs@unreal>
References: <20220816195408.56eec0ed@kernel.org>
        <Yvx6+qLPWWfCmDVG@unreal>
        <20220817111052.0ddf40b0@kernel.org>
        <Yv3M/T5K/f35R5UM@unreal>
        <20220818193449.35c79b63@kernel.org>
        <Yv8lGtYIz4z043aI@unreal>
        <20220819084707.7ed64b72@kernel.org>
        <Yv+z0nBW60SBFAmZ@nvidia.com>
        <20220819105356.100003d5@kernel.org>
        <20220822084105.GI2602992@gauss3.secunet.de>
        <YwNEUguW7aTXC2Vs@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Aug 2022 11:54:42 +0300 Leon Romanovsky wrote:
> On Mon, Aug 22, 2022 at 10:41:05AM +0200, Steffen Klassert wrote:
> > On Fri, Aug 19, 2022 at 10:53:56AM -0700, Jakub Kicinski wrote:  
> > > Yup, that's what I thought you'd say. Can't argue with that use case 
> > > if Steffen is satisfied with the technical aspects.  
> > 
> > Yes, everything that can help to overcome the performance problems
> > can help and I'm interested in this type of offload. But we need to
> > make sure the API is usable by the whole community, so I don't
> > want an API for some special case one of the NIC vendors is
> > interested in.  
> 
> BTW, we have a performance data, I planned to send it as part of cover
> letter for v3, but it is worth to share it now.
> 
>  ================================================================================
>  Performance results:
> 
>  TCP multi-stream, using iperf3 instance per-CPU.
>  +----------------------+--------+--------+--------+--------+---------+---------+
>  |                      | 1 CPU  | 2 CPUs | 4 CPUs | 8 CPUs | 16 CPUs | 32 CPUs |
>  |                      +--------+--------+--------+--------+---------+---------+
>  |                      |                   BW (Gbps)                           |
>  +----------------------+--------+--------+-------+---------+---------+---------+
>  | Baseline             | 27.9   | 59     | 93.1  | 92.8    | 93.7    | 94.4    |
>  +----------------------+--------+--------+-------+---------+---------+---------+
>  | Software IPsec       | 6      | 11.9   | 23.3  | 45.9    | 83.8    | 91.8    |
>  +----------------------+--------+--------+-------+---------+---------+---------+
>  | IPsec crypto offload | 15     | 29.7   | 58.5  | 89.6    | 90.4    | 90.8    |
>  +----------------------+--------+--------+-------+---------+---------+---------+
>  | IPsec full offload   | 28     | 57     | 90.7  | 91      | 91.3    | 91.9    |
>  +----------------------+--------+--------+-------+---------+---------+---------+
> 
>  IPsec full offload mode behaves as baseline and reaches linerate with same amount
>  of CPUs.
> 
>  Setups details (similar for both sides):
>  * NIC: ConnectX6-DX dual port, 100 Gbps each.
>    Single port used in the tests.
>  * CPU: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz

My questions about performance were more about where does 
the performance loss originate. Is it because of loss of GRO?
Maybe sharing perf traces could answer some of those questions?
