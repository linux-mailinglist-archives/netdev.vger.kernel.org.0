Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B157D55E949
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347157AbiF1Oqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346214AbiF1Oqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:46:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59B52E9E2;
        Tue, 28 Jun 2022 07:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7pHTbqwaXaGFRCw7vMsZqLcpFUBsqDmJuAosMkAmWD0=; b=bRHWXWlSE3wMVf7UeDn4OnRTQt
        zoWrl09nNqQM8atnUITqNjK3zrN07UdVqqzMNTgSa1Ha/9WDOVgAYs1fyfzs+ZbIL4QFERh4gmjqY
        7R127QQv6utP1BeRvqQixqPTyPw2pz5GG8Yj60Ju/qS3Cou/5962e0N/xmqt37WmZSs8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o6CU5-008a55-Ia; Tue, 28 Jun 2022 16:46:33 +0200
Date:   Tue, 28 Jun 2022 16:46:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet phy
Message-ID: <YrsUSSImpUXrZFUl@lunn.ch>
References: <20220628104245.35-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628104245.35-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/phy/motorcomm.c
> +++ b/drivers/net/phy/motorcomm.c
> @@ -1,15 +1,115 @@
>  // SPDX-License-Identifier: GPL-2.0+
>  /*
> - * Driver for Motorcomm PHYs
> + * motorcomm.c: Motorcomm 8511/8521 PHY driver.

Generally you don't include a files name in the file, because it can
get renamed and nobody updates it.

>   *
>   * Author: Peter Geis <pgwipeout@gmail.com>
> + * Author: Frank <Frank.Sae@motor-comm.com>
>   */
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/phy.h>
> +#include <linux/etherdevice.h>

The includes are currently sorted, please keep it so.

>  
>  #define PHY_ID_YT8511		0x0000010a
> +#define PHY_ID_YT8521				0x0000011A
> +
> +/* YT8521 Register Overview
> + *	UTP Register space	|	FIBER Register space
> + *  ------------------------------------------------------------
> + * |	UTP MII			|	FIBER MII		|
> + * |	UTP MMD			|				|
> + * |	UTP Extended		|	FIBER Extended		|
> + *  ------------------------------------------------------------
> + * |			Common Extended				|
> + *  ------------------------------------------------------------
> + */
> +
> +/* 0x10 ~ 0x15 , 0x1E and 0x1F are common MII registers of yt phy */
> +
> +/* Specific Function Control Register */
> +#define YTPHY_SPECIFIC_FUNCTION_CONTROL_REG	0x10
> +
> +/* 2b00 Manual MDI configuration
> + * 2b01 Manual MDIX configuration
> + * 2b10 Reserved
> + * 2b11 Enable automatic crossover for all modes  *default*

> +
> +/* 2b00 10 Mbps
> + * 2b01 100 Mbps
> + * 2b10 1000 Mbps
> + * 2b11 Reserved
> +
> +/* 8 working modes:
> + * 3b000 UTP_TO_RGMII  *default*
> + * 3b001 FIBER_TO_RGMII
> + * 3b010 UTP_FIBER_TO_RGMII
> + * 3b011 UTP_TO_SGMII
> + * 3b100 SGPHY_TO_RGMAC
> + * 3b101 SGMAC_TO_RGPHY
> + * 3b110 UTP_TO_FIBER_AUTO
> + * 3b111 UTP_TO_FIBER_FORCE

I don't think this notation is used anywhere else in the kernel. It
also took me a little while to figure it out. It would probably be
better to just add comments next to the #define.

       Andrew
