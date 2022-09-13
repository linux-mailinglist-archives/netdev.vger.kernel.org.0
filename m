Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1086D5B7D16
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 00:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiIMWbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 18:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiIMWbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 18:31:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F2C61723;
        Tue, 13 Sep 2022 15:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B98B615F6;
        Tue, 13 Sep 2022 22:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF60C433D6;
        Tue, 13 Sep 2022 22:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663108273;
        bh=CNNrVQXB5RHuPodp+2y8dbJdbh0v4jEbTVcWCwUBVJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EbqSYOgNEkHCFSyUVPMegTUCUfNLiMKR0LTwYTZtN9tc17hwbQ0EGsw86v2JHL/tx
         JHERYk/ldz2bA32a5EZWSyDA1O/o/PlTIvWEhrUUwOetpXFuqOf7zFgjzzNLZ0r1eS
         iWiKaoRv4gPJUKdQCrvOHNjIGgnvt7GmX4s+eHxlFPc+bgJm3mUx990MxiU2EF0QrU
         G/amDn3Tw7t3m50Vo/i8tNUZG5Z95Mr6uf3o+aCnopIjsP6vfGnNZVoltVB06CAY7v
         f5kHtG1jv4A/yTM2uQj/bfWc04dKIUhn6KFWTy1DbxF2UYXOZhMyxuFiDao9HIUPkP
         3rxQaLLMx/IEQ==
Date:   Tue, 13 Sep 2022 15:31:11 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: litex: Fix return type of
 liteeth_start_xmit
Message-ID: <YyEErzoi9+8NMRCP@dev-arch.thelio-3990X>
References: <20220912195307.812229-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912195307.812229-1-nhuck@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 12:53:07PM -0700, Nathan Huckleberry wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of liteeth_start_xmit should be changed from int to
> netdev_tx_t.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1703
> Cc: llvm@lists.linux.dev
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/net/ethernet/litex/litex_liteeth.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
> index fdd99f0de424..35f24e0f0934 100644
> --- a/drivers/net/ethernet/litex/litex_liteeth.c
> +++ b/drivers/net/ethernet/litex/litex_liteeth.c
> @@ -152,7 +152,8 @@ static int liteeth_stop(struct net_device *netdev)
>  	return 0;
>  }
>  
> -static int liteeth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> +static netdev_tx_t liteeth_start_xmit(struct sk_buff *skb,
> +				      struct net_device *netdev)
>  {
>  	struct liteeth *priv = netdev_priv(netdev);
>  	void __iomem *txbuffer;
> -- 
> 2.37.2.789.g6183377224-goog
> 
