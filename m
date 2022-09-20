Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FE35BD96E
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiITBg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiITBg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:36:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7FF49B56
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1EE8B82352
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD106C433C1;
        Tue, 20 Sep 2022 01:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663637784;
        bh=kwcfLJLhrsKvRCJBUy7SyOp36kXJjxlUGS0fk4d20lI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SD5K8GKosK+GOSbeZroeykjYQuHt0sgm7NdAtx6o6neqqckwA8+P6IE4ITlJskbXP
         v3d8OOhvXMU7ITFBfufDGEm6UnowMRddgY7pwKsGZIhrG9SmR809SpUXUpXrqih4vH
         drqBNnIU3a+2jAq8+n6amqs6agQr6vlU1oUTydgXRDvdMrCooNE+vzq/pR1dwsJStR
         DdQYQxatxnFbegNoPsYgc4uCvmLCY4q2PN8Cja894hOBiFfH4brBpNMAN6zo5IZu/E
         DtEQSUQU5AEQkp9jPpoKPeX8JvNdZgGrZbKpGpDCSo+t5yDEOqYnvcw0mjsW/JIrbv
         j+x56AyZypGjg==
Date:   Mon, 19 Sep 2022 18:36:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH v2] net: dsa: mt7530: add support for in-band link
 status
Message-ID: <20220919183622.205ccabf@kernel.org>
In-Reply-To: <Yx5I6nRPxYIiC1ZT@makrotopia.org>
References: <Yx4910YC6/Y7ghfm@shell.armlinux.org.uk>
        <Yx5I6nRPxYIiC1ZT@makrotopia.org>
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

On Sun, 11 Sep 2022 21:45:30 +0100 Daniel Golle wrote:
>  static void mt7531_pcs_get_state(struct phylink_pcs *pcs,
>  				 struct phylink_link_state *state)
>  {
>  	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
>  	int port = pcs_to_mt753x_pcs(pcs)->port;
> +	unsigned int val;
>  
> -	if (state->interface == PHY_INTERFACE_MODE_SGMII)
> +	if (state->interface == PHY_INTERFACE_MODE_SGMII) {
>  		mt7531_sgmii_pcs_get_state_an(priv, port, state);
> -	else
> -		state->link = false;
> +		return;
> +	} else if ((state->interface == PHY_INTERFACE_MODE_1000BASEX) ||
> +		   (state->interface == PHY_INTERFACE_MODE_2500BASEX)) {
> +		mt7531_sgmii_pcs_get_state_inband(priv, port, state);
> +		return;
> +	}
> +
> +	state->link = false;

drivers/net/dsa/mt7530.c:3040:15: warning: unused variable 'val' [-Wunused-variable]
        unsigned int val;
                     ^
