Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D4B6DC81A
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjDJO42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDJO41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:56:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E034496
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 07:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uLBLp4W7bbdJuKSr6muVRYgQ+qA4tqtZQjwqJSs6TTs=; b=oJjP/lI2m3D47a9yzzJKOt5rRT
        /dEyXH7BpZ7Z51ie+jSHaf+W5BUq+fBnachEJU7t+PvsfVd2enxB82NM0/znSpaWTvVbfftHnenZM
        LSXZpJWBDIcnls3Fhhj3RWbGoWIwZnbHmEutVliia4X5exo5OOzMgS5/SJsJ+PQIYguw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1plswO-009vGf-RM; Mon, 10 Apr 2023 16:56:20 +0200
Date:   Mon, 10 Apr 2023 16:56:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, arm-soc <arm@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <e39dd60e-0514-4eb6-9f6e-ee38a7e25dc6@lunn.ch>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
 <20230407154159.upribliycphlol5u@skbuf>
 <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
 <20230410100012.esudvvyik3ck7urr@skbuf>
 <c4b386af-2a51-4690-b552-e1da074e06d2@lunn.ch>
 <20230410131157.ye3wuzs2tjsojcim@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410131157.ye3wuzs2tjsojcim@skbuf>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> hmmm... why does this work?
> 
> would you mind adding this small debug print and booting again?
 
mv88e6xxx_translate_cmode: cmode 4, supported: supported=7

CMODE 4 is 'RMII PHY' or 'RMII to PHY', depending on if it has found a
PHY or not.

mv88e6085 mdio_mux-0.1:00: phylink_validate: supported_interfaces=1,3,7, interface rev-rmii
mv88e6085 mdio_mux-0.1:00: phylink_validate: supported_interfaces=1,3,7, interface rev-rmii
mv88e6085 mdio_mux-0.1:00: configuring for fixed/rev-rmii link mode

Both calls to phylink_validate() then returning -EINVAL.

The first call is from phylink_create(), which does not check the
return value.

The second call is from phylink_parse_fixedlink(), which also does not
check the return code.

This is a bit fragile, all it would need is for these return values to
be checked and it would break. So i think cmode 4 should return
REVRMII and cmode 5 shoud be RMII. I will submit a patch making this
change.

	Andrew
