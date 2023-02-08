Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E12068EFB5
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjBHN1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBHN1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:27:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2C023675
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 05:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=b+UE50I3cqS7Z7xe3M4khVDXZklYfj2TnH0XnO2ACAk=; b=DEDweJWY7X9s3HuPEk2ZtV/x+F
        JFS87RzT4Ra2WDBwsMsa5PGSjXHcjIuDyfz5PkcDxGUpRhSw7uGUkbfivVqS76GpD+UGk5aRoicgu
        0G5zV2woZAsKWj0sVFtP6mExGUbJuhYFJ5Bw0Qo5gzO2wtRilI0EK2gFQxhvyRzLcCTc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPkTb-004P9J-Vl; Wed, 08 Feb 2023 14:27:07 +0100
Date:   Wed, 8 Feb 2023 14:27:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guan Wentao <guanwentao@uniontech.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: get phydev->interface from mac for mdio phy
 init
Message-ID: <Y+OjKx7aJ88xjqvK@lunn.ch>
References: <20230208112054.22965-1-guanwentao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208112054.22965-1-guanwentao@uniontech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 07:20:54PM +0800, Guan Wentao wrote:
> The phy->interface from mdiobus_get_phy is default from phy_device_create.
> In some phy devices like at803x, we need the correct value to init delay.
> Use priv->plat->interface to init if we know.

You commit message i missing a lot of details to make this easy to
review.

So you board is not using DT? And so there is not a DT node specifying
the phy-mode. You have some other way of getting the correct interface
mode into plat->interface. And since you don't have DT, you also have
some other mechanism to set plat->phy_addr to the address on the MDIO
bus. The code then directly gets the PHY from the MDIO bus, and calls
phylink_connect_phy() to connect the PHY. The old code used
phy_connect() which took an interface parameter but
phylink_connect_phy() does not. And that is your problem.

So your fix makes sense.

Please improve the commit message.

Please also take a look at
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
You should set the email Subject: line to indicate which tree this
patch is for.

       Andrew
