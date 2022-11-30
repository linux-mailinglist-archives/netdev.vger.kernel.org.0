Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F288163CE64
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiK3EgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiK3Ef4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:35:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB11A1A8;
        Tue, 29 Nov 2022 20:35:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E54AB81886;
        Wed, 30 Nov 2022 04:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86811C433C1;
        Wed, 30 Nov 2022 04:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669782953;
        bh=x8nbYm06jHz/XeCUDHAODP1xl6lP6WKv6YN0M3Vc+bI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QurYTJW3SxARDl3Sw3bY+lt1m11cmqLXqH3qRoqI6xwtr2l7eBFxuC9haYFh4YL/N
         ODoWVt9XUI4vr0VpDTyqdbAUGDlCZB6SGW6P3vi2JisG/zL0vqz5PSWXP8a+wrufsV
         bzHjdFlr4arTwrPCk/SU/O59rd4VWSi119N6EtmpckCJoxc5Yv4x5qxS0hbA6dt2Z+
         torc21Va69+/WhGqR/D7b18bbQrrANGFTa6VDSdO2riEQsWcgYWUzbPBadrTttHomB
         5lBQ3XNzZmoEgZnPXoNVZNebr/xyzjZeFQjhf94gnhvbveP68ZnyocnQSRPBrMiIvm
         wq9Ap9pbr0lxQ==
Date:   Tue, 29 Nov 2022 20:35:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: pcs: altera-tse: use
 read_poll_timeout to wait for reset
Message-ID: <20221129203551.170d93e1@kernel.org>
In-Reply-To: <20221125131801.64234-2-maxime.chevallier@bootlin.com>
References: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
        <20221125131801.64234-2-maxime.chevallier@bootlin.com>
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

On Fri, 25 Nov 2022 14:17:59 +0100 Maxime Chevallier wrote:
> -	for (i = 0; i < SGMII_PCS_SW_RESET_TIMEOUT; i++) {
> -		if (!(tse_pcs_read(tse_pcs, MII_BMCR) & BMCR_RESET))
> -			return 0;
> -		udelay(1);
> -	}
> -
> -	return -ETIMEDOUT;
> +	return read_poll_timeout(tse_pcs_read, bmcr, (bmcr & BMCR_RESET),
> +				 10, SGMII_PCS_SW_RESET_TIMEOUT, 1,
> +				 tse_pcs, MII_BMCR);

You say "no functional change intended" in the cover letter but you
switch from udelay to usleep and change timeouts here. I presume this
is intentional but should be mentioned in the commit message, I think.
