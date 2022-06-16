Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0673B54D8A6
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347216AbiFPCzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiFPCzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:55:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAD67641;
        Wed, 15 Jun 2022 19:55:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4579960F2A;
        Thu, 16 Jun 2022 02:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5EEC3411A;
        Thu, 16 Jun 2022 02:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655348108;
        bh=1BlpwRvkLZuR8VuvYLx0fMXdHYTki1wa59EE8Nshua4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xw9EFBNMUQdUtyk9AXz+7oZQwZf+rCY+TKRmJJUwzyA17ilqp4LtN+HbLgJpfJVTO
         apmCY2slsoj47DsA7FWCdCrZz/UUEuLH1UNpjpBEWQIhOAvgiPs1I7Y39diCnilsDV
         9Z85a00Mi2M2hjowQoICj0WplRdAsiDYfX7D+Muty/cgu+uxJLPY6rvnZ9NqrGJNyA
         rCqhzNxbJL7Kr3wAGpNKb7i6En+cNVZGiuVgkDn/Phuuxz0YNO5nSZFIoH0HmUm5nz
         Fw/rILwm/6yCvbRECgzMxba+ionnTXmJ9N6mrB9xIW/QAcD09JrMpEl+hx3x3IsFRF
         Ox7iLts9+2kZg==
Date:   Wed, 15 Jun 2022 19:55:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: ethernet: stmicro: stmmac: permit MTU
 change with interface up
Message-ID: <20220615195507.52ee19df@kernel.org>
In-Reply-To: <20220614224141.23576-1-ansuelsmth@gmail.com>
References: <20220614224141.23576-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 00:41:41 +0200 Christian 'Ansuel' Marangi wrote:
> +	if (netif_running(dev)) {
> +		netdev_dbg(priv->dev, "restarting interface to change its MTU\n");
> +		stmmac_release(dev);
> +
> +		stmmac_open(dev);
> +		stmmac_set_filter(priv, priv->hw, dev);

What if stmmac_open() fails because the memory is low or is fragmented?

You'd need to invest more effort into this change and try to allocate
all the resources before shutting the device down.
