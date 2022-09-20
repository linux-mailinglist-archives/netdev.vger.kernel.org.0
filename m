Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3426F5BE9F0
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiITPTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiITPTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:19:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F37E5AC72
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:19:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E449EB82A9A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 15:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758F3C433C1;
        Tue, 20 Sep 2022 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663687152;
        bh=UaJFrj8sWLzJ3OiH1q1T+G/LrXcSY/5FUZ7yEbTtsxk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SteGs08ki02SSSMjQd1NBHCgNdLOF85q8Yu6ws8GNTkTtoZ/h2VkhcDYg2wO4MdFp
         l8mlSQXnZPlAEmbggdGpzYNMVocCWTTuJZCnzRyNPwe0wITbeaPxZ/DchdyWyjg0S4
         JL+/IV0w2qLiITHW20xlG+EfCTGwrXj6BcFuoWYvu8E3gFRkjd2h+SbsinhCwVHuQ9
         +UitxgE8awfM681K/Inhu2T4zQx/SNbiarybRA+sGvlxYpah+T4TUnpbrGJFM9eqoE
         R3IDZVGpFiLnOMZhNR+NXL6EJp+7OVizYhRQ1lJ2U04vISX6NHqB01oR1Vpc3EEoG8
         XOeCC53VIKjqA==
Date:   Tue, 20 Sep 2022 08:19:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Baruch Siach <baruch@tkos.co.il>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Baruch Siach <baruch.siach@siklu.com>
Subject: Re: [PATCH v2] net: sfp: workaround GPIO input signals bounce
Message-ID: <20220920081911.619ffeef@kernel.org>
In-Reply-To: <931ac53e9d6421f71f776190b2039abaa69f7d43.1663133795.git.baruch@tkos.co.il>
References: <931ac53e9d6421f71f776190b2039abaa69f7d43.1663133795.git.baruch@tkos.co.il>
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

On Wed, 14 Sep 2022 08:36:35 +0300 Baruch Siach wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> Add a trivial debounce to avoid miss of state changes when there is no
> proper hardware debounce on the input signals. Otherwise a GPIO might
> randomly indicate high level when the signal is actually going down,
> and vice versa.
> 
> This fixes observed miss of link up event when LOS signal goes down on
> Armada 8040 based system with an optical SFP module.
> 
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> ---
> v2:
>   Skip delay in the polling case (RMK)

Is this acceptable now, Russell?

> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 63f90fe9a4d2..b0ba144c9633 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -313,7 +313,9 @@ static unsigned long poll_jiffies;
>  static unsigned int sfp_gpio_get_state(struct sfp *sfp)
>  {
>  	unsigned int i, state, v;
> +	int repeat = 10;
>  
> +again:
>  	for (i = state = 0; i < GPIO_MAX; i++) {
>  		if (gpio_flags[i] != GPIOD_IN || !sfp->gpio[i])
>  			continue;
> @@ -323,6 +325,16 @@ static unsigned int sfp_gpio_get_state(struct sfp *sfp)
>  			state |= BIT(i);
>  	}
>  
> +	/* Trivial debounce for the interrupt case. When no state change is
> +	 * detected, wait for up to a limited bound time interval for the
> +	 * signal state to settle.
> +	 */
> +	if (state == sfp->state && !sfp->need_poll && repeat > 0) {
> +		udelay(10);
> +		repeat--;
> +		goto again;
> +	}
> +
>  	return state;
>  }
>  

