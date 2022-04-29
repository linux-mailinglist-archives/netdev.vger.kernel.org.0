Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4503A514046
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237493AbiD2BjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiD2BjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:39:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0B627CD3
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 18:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XNHltmxRYoVlDHm6y2UJrBF4nRGeAYJBFlUzQ9OqPus=; b=iVzYZTyh3+LnRn8tsnrLgxVREf
        35ins36m8geWMqmdNxCnV9hN1pAP0KhvZNsAL9KmxsQmtQldbgYm907FR4JMkgc9/pDoytaouCGWN
        7/Kcl6YLf9FZZu5kEgbX4p/tWbkYAydKkkROMR1WL/neslqGlYAF7SvAjnVJb4C9A+3I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkFXr-000PDS-Ad; Fri, 29 Apr 2022 03:35:43 +0200
Date:   Fri, 29 Apr 2022 03:35:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] net: phy: marvell: update abilities and
 advertising when switching to SGMII
Message-ID: <YmtA7/OjKIQD/vuD@lunn.ch>
References: <20220427193928.2155805-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427193928.2155805-1-robert.hancock@calian.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 01:39:28PM -0600, Robert Hancock wrote:
> With some SFP modules, such as Finisar FCLF8522P2BTL, the PHY hardware
> strapping defaults to 1000BaseX mode, but the kernel prefers to set them
> for SGMII mode.

Is this the SFP code determining this? Its copper == use SGMII?

> When this happens and the PHY is soft reset, the BMSR
> status register is updated, but this happens after the kernel has already
> read the PHY abilities during probing. This results in support not being
> detected for, and the PHY not advertising support for, 10 and 100 Mbps
> modes, preventing the link from working with a non-gigabit link partner.
> 
> When the PHY is being configured for SGMII mode, call genphy_read_abilities
> again in order to re-read the capabilities, and update the advertising
> field accordingly.

Is this actually a generic problem? There are other PHYs used in SFP
modules, and i assume they also could have their mode changed. So
should the re-reading of the abilities be in the core, not each
driver?

	Andrew
