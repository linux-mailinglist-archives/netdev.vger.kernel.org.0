Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DC55B7D1B
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 00:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiIMWcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 18:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiIMWcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 18:32:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BE16DAD0;
        Tue, 13 Sep 2022 15:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7CFBB810E2;
        Tue, 13 Sep 2022 22:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C46C433D6;
        Tue, 13 Sep 2022 22:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663108330;
        bh=xQNxJxEcyNL4T14W2RgiHc+osVherdxF9bKhuT2OEJE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RbIRmhpR4/HqeQ8QQ10xdOEksaF5/3/e1DpHaJ39pIQQKAerXx0/yr39srGVnWil0
         XT1QnXnz8Cxi0QwdRDQU9Wmkp2OknRn9wOihZ4Jl/V/EQCqu1TeV1N/kDGrIIZLk8h
         brC30s9zo+cQS1KxOD7kfhLDmeFwUvkDTwjk1Xj0kSkbnIaFyWKx64i3Rz8iOW/jkv
         8yoqfTs6F04c/vkAXUrWDWEPQDIKBCs4KDzzNafuRoFvNa4VBJCJ3XIblEKmTBFaAM
         2LqGlIkYHo1HsrJ940uQZjbssp8ycmmdjglSuGuiFRSGz1sAVewvwwTKdpbc8lu2oc
         N8nEywX1pUlgw==
Date:   Tue, 13 Sep 2022 15:32:08 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: korina: Fix return type of korina_send_packet
Message-ID: <YyEE6MRhVEKnPPpv@dev-arch.thelio-3990X>
References: <20220912214344.928925-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912214344.928925-1-nhuck@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 02:43:40PM -0700, Nathan Huckleberry wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of korina_send_packet should be changed from int to
> netdev_tx_t.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1703
> Cc: llvm@lists.linux.dev
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/net/ethernet/korina.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
> index df9a8eefa007..eec6a9ec528b 100644
> --- a/drivers/net/ethernet/korina.c
> +++ b/drivers/net/ethernet/korina.c
> @@ -416,7 +416,8 @@ static void korina_abort_rx(struct net_device *dev)
>  }
>  
>  /* transmit packet */
> -static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
> +static netdev_tx_t korina_send_packet(struct sk_buff *skb,
> +				      struct net_device *dev)
>  {
>  	struct korina_private *lp = netdev_priv(dev);
>  	u32 chain_prev, chain_next;
> -- 
> 2.37.2.789.g6183377224-goog
> 
