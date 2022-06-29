Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7975855F48B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiF2Dyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiF2Dyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:54:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97591FCD9;
        Tue, 28 Jun 2022 20:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A13E7B82160;
        Wed, 29 Jun 2022 03:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C218AC34114;
        Wed, 29 Jun 2022 03:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656474877;
        bh=uGe21oy82tSdMA/YvpYvQVzqQbNQiBgl0vADr1AFTdY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lNSlP1p+ukhqJtiPg2ozJ5MLFhq2KeadAUOnIaxqNjPNALtINmszC1a778vlk/+Jv
         QAi+R+5uceMsmtAbOx35LGxwwsPcG0N2aZ+xHf4OAHNKpYqjQWLHKDy+z8GsRcpjI2
         XfxkCtqrEMAYKbPBm+8t/6UpYntRTKDFFD3oQXjdANESi/s6807MUxASlB3AZJguBc
         ulLXwIGHyiIFe+nY3V7+XDNQVP4q316rjalagSZzFQqTObTNvShUZ5jr84p16jxDJo
         9ztfUwwO77UzYDDz5UlTNYCA8E+GCGUhlAfZE0N8k8A/72C6N87rVJhy9/HJOQ0JE0
         u89rPBXslFfCg==
Date:   Tue, 28 Jun 2022 20:54:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH RFC 2/5] net: ethernet: stmicro: stmmac: first
 disable all queues in release
Message-ID: <20220628205435.44b0c78c@kernel.org>
In-Reply-To: <20220628013342.13581-3-ansuelsmth@gmail.com>
References: <20220628013342.13581-1-ansuelsmth@gmail.com>
        <20220628013342.13581-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 03:33:39 +0200 Christian Marangi wrote:
> +	stmmac_disable_all_queues(priv);
> +
> +	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
> +		hrtimer_cancel(&priv->tx_queue[chan].txtimer);

IIRC this hrtimer is to check for completions. Canceling it before
netif_tx_disable() looks odd, presumably until the queues are stopped
the timer can get scheduled again, no?

>  	netif_tx_disable(dev);
>  
>  	if (device_may_wakeup(priv->device))
> @@ -3764,11 +3769,6 @@ static int stmmac_release(struct net_device *dev)
>  	phylink_stop(priv->phylink);
>  	phylink_disconnect_phy(priv->phylink);
>  
> -	stmmac_disable_all_queues(priv);
> -
> -	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
> -		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
