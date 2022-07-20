Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20E857AB4E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbiGTBHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiGTBHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:07:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2152148EBF;
        Tue, 19 Jul 2022 18:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4A55B81DE0;
        Wed, 20 Jul 2022 01:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26920C341CA;
        Wed, 20 Jul 2022 01:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279226;
        bh=VZKQyUqkgOyxor/CL4FV3kbbmHu2L+VLW6W/lsqp7cU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ecce4uPTOaJ7kVbgFxANyF8ec/qlzYu22XOUCG8lM6f6LZmPKb0D098n+do+fLQWi
         TWUCc0v2qMOkPdEXf4nJ79DrdbyZaCDY6PWVkieUkH9wsv9l4KeOZS4rErVA0PKJtX
         CDhQlBc73y4KlP4UeThiBzOZj3bG0BKF+ZG0s9PWGxDvW0XZ4UjSackLrDeEWVVyno
         Qx9K0ZKUUQcHtFaxdCET2qNY7ImAHhZz6JBXBRMA0GOk3CHok+sNu8wuyO5dsP0Zmn
         OQp3dkMorYONzOH8Gll/+0GYtWXhg/GSKyXwGkfBm05ODVfBVveVe5xeFxei3cT9g9
         R7InpEGCGkcHg==
Date:   Tue, 19 Jul 2022 18:07:05 -0700
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
Subject: Re: [net-next PATCH v4 4/5] net: ethernet: stmicro: stmmac:
 generate stmmac dma conf before open
Message-ID: <20220719180705.45208cb0@kernel.org>
In-Reply-To: <20220719013219.11843-5-ansuelsmth@gmail.com>
References: <20220719013219.11843-1-ansuelsmth@gmail.com>
        <20220719013219.11843-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 03:32:18 +0200 Christian Marangi wrote:
> Rework the driver to generate the stmmac dma_conf before stmmac_open.
> This permits a function to first check if it's possible to allocate a
> new dma_config and then pass it directly to __stmmac_open and "open" the
> interface with the new configuration.

You missed one kdoc:

> @@ -1711,9 +1744,11 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
>   * and allocates the socket buffers. It supports the chained and ring
>   * modes.
>   */
> -static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
> +static int __init_dma_tx_desc_rings(struct stmmac_priv *priv,
> +				    struct stmmac_dma_conf *dma_conf,
> +				    u32 queue)
>  {

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:1750: warning: Function parameter or member 'dma_conf' not described in '__init_dma_tx_desc_rings'
