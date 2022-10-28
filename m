Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED4E61110E
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 14:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiJ1MUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 08:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiJ1MT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 08:19:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA4D27B04;
        Fri, 28 Oct 2022 05:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=i5cA5BhW3R9VDdcstHtx2JgpWOioh55YU9ezi8M+rnQ=; b=4sHhl61c1zjRaeqk5lnkUBQs6O
        8h1AKyGW90xLhQQZLD+wYWImEY0O4K7rrs3Q5YsuGy7IsIG9ppCkaHT8DB+V7uY79Dn1T+zEUsC7T
        HLtHa1vQt8Bv09znM5fzJJkhYNhpEV8qNuLIaoRq9Cwc1DAns2Q19UyPKtS5MYHc5NfQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ooOJP-000o8E-KG; Fri, 28 Oct 2022 14:18:11 +0200
Date:   Fri, 28 Oct 2022 14:18:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, michael.chan@broadcom.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        moshet@nvidia.com, linux@rempel-privat.de,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next v2] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <Y1vIg8bR8NBnQ3J5@lunn.ch>
References: <20221028012719.2702267-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028012719.2702267-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -67,6 +67,7 @@ static void phy_link_down(struct phy_device *phydev)
>  {
>  	phydev->phy_link_change(phydev, false);
>  	phy_led_trigger_change_speed(phydev);
> +	WRITE_ONCE(phydev->link_down_events, phydev->link_down_events + 1);

I'm not sure the WRITE_ONCE adds much value. Many systems using PHYLIB
are 32 bit, and i don't think WRITE_ONCE will make that 64 bit write
atomic on 32 bit systems. And as Florian pointed out, you have bigger
problems if you manged to overflow a u32 into a u64.

> @@ -723,6 +724,8 @@ struct phy_device {
>  
>  	int pma_extable;
>  
> +	unsigned int link_down_events;

And here is unsigned int, not u64? Or u32? It would be good to be
consistent.

> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -262,6 +262,8 @@ enum {
>  	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
>  	ETHTOOL_A_LINKSTATE_EXT_STATE,		/* u8 */
>  	ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,	/* u8 */
> +	ETHTOOL_A_LINKSTATE_PAD,
> +	ETHTOOL_A_LINKSTATE_EXT_DOWN_CNT,	/* u64 */

What is the PAD for?

     Andrew
