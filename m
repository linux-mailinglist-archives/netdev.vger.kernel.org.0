Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A9E4E31E8
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 21:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353439AbiCUUiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 16:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351883AbiCUUiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 16:38:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D865C8908A;
        Mon, 21 Mar 2022 13:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/ynewyjtxXortQGTIg9iF+Pmp05zFVKl5vdtQZUzoGE=; b=OY1EUol2C5Hj5D6+PFLuswM8Xz
        /dJs+4ZdrIE/dTZ3R1BNICSGQhf9Zw+UtuNviOuU1/8/Ej4859hyLAjcTPG0Dhm5OZEVeWIiRxKKe
        d0ydu7ncM1MxIHE067RHnAcwD0zGHkPJyjNhW6rmB+kE95DTLFCs6l3RnerJU8gfCMBg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWOlJ-00C17E-9x; Mon, 21 Mar 2022 21:36:21 +0100
Date:   Mon, 21 Mar 2022 21:36:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clause 45 and Clause 22 PHYs on one MDIO bus
Message-ID: <YjjhxbZgKHykJ+35@lunn.ch>
References: <240354b0a54b37e8b5764773711b8aa3@walle.cc>
 <cdb3d3f6ad35d4e26fd8abb23b2e96a3@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdb3d3f6ad35d4e26fd8abb23b2e96a3@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Actually, it looks like mdiobus_c45_read() is really c45 only and only
> used for PHYs which just support c45 and not c45-over-c22 (?). I was
> mistaken by the heavy use of the function in phy_device.c. All the
> methods in phy-c45.c use phy_*_mmd() functions. Thus it might only be
> the mxl-gpy doing something fishy in its probe function.

Yes, there is something odd here. You should search back on the
mailing list.

If i remember correctly, it is something like it responds to both c22
and c45. If it is found via c22, phylib does not set phydev->is_c45,
and everything ends up going indirect. So the probe additionally tries
to find it via c45? Or something like that.

> Nevertheless, I'd still need the opt-out of any c45 access. Otherwise,
> if someone will ever implement c45 support for the mdio-mscc-mdio
> driver, I'll run in the erratic behavior.

Yah, i need to think about that. Are you purely in the DT world, or is
ACPI also an option?

Maybe extend of_mdiobus_register() to look for a DT property to limit
what values probe_capabilities can take?

     Andrew
