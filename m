Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587394F6DD8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 00:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbiDFWgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 18:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiDFWgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 18:36:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EEF33C
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 15:34:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDA3D61CB2
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 22:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87BDC385A3;
        Wed,  6 Apr 2022 22:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649284485;
        bh=cZx+qVS1NxKes38rC8PFLL/4BUjKMgKE6MqNlvMuy4U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S1IUYrUlyi6E1WBrfnxJXS12r4HhEl9e33tP5wuMBBT/Sm/oWrkqfHeGg/wNOI/6T
         cbCvkBYa6u1U/aJbHhF0lZ9YSv/+OxaaR7y3zhIGrec1DGN1A9ZrgE9Al5P9ZmcUgk
         LaxiUPGJ1EkMZzplNXTqm50otqN6z6eJpWlAcjIBVKd/JQ3ZF8RT+s653UvXeNkmFS
         w3CsdjfTgmZWEU/xGjdCNGiuFfhMOd9tNidmaP7DVj8tU8QsccJSVPduiGOo0BUWBU
         6vLvg04rExRzUArmIhaKCmiKOY0BnQZ0wZlb6b3yrxk7VAvGCfxBXCLQ8YrsJXdes6
         2o+3tVNUUzbnA==
Date:   Wed, 6 Apr 2022 15:34:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH net] net: mdio: don't defer probe forever if PHY IRQ
 provider is missing
Message-ID: <20220406153443.51ad52f8@kernel.org>
In-Reply-To: <20220406202323.3390405-1-vladimir.oltean@nxp.com>
References: <20220406202323.3390405-1-vladimir.oltean@nxp.com>
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

On Wed,  6 Apr 2022 23:23:23 +0300 Vladimir Oltean wrote:
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> index 1becb1a731f6..1c1584fca632 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -43,6 +43,11 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>  	int rc;
>  
>  	rc = fwnode_irq_get(child, 0);
> +	/* Don't wait forever if the IRQ provider doesn't become available,
> +	 * just fall back to poll mode
> +	 */
> +	if (rc == -EPROBE_DEFER)
> +		rc = driver_deferred_probe_check_state(&phy->mdio.dev);

This one's not exported, allmodconfig build fails.
