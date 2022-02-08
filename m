Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80EE4AD8C0
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343548AbiBHNPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343807AbiBHNNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:13:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6EAC03FECE
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 05:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u555Uj9MFOGpetxZK8sT9IsZn3C2ojJkmHh1ep+pwUM=; b=MyQqG5ZKXmvt6GKOpXztwY55oE
        umDm5/0oK+pevt6/75PTiW2ho/wLTMD92XlA3ukLg/aAnXj5s0olMEBrIwupA1Jb00KG6KBognNXt
        p9n76j6fKNAHlIkGaegfxd6JQg6nXEA4rsjtEzAK8AVh06/Vxej2YCBaggiUvAk0vDAw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHQJR-004rPo-Ej; Tue, 08 Feb 2022 14:13:41 +0100
Date:   Tue, 8 Feb 2022 14:13:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev <netdev@vger.kernel.org>, hkallweit1 <hkallweit1@gmail.com>,
        linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch
 PHY support
Message-ID: <YgJshWvkCQLoGuNX@lunn.ch>
References: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <20220207174532.362781-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <YgGrNWeq6A7Rw3zG@lunn.ch>
 <2044096516.560385.1644309521228.JavaMail.zimbra@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2044096516.560385.1644309521228.JavaMail.zimbra@savoirfairelinux.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 03:38:41AM -0500, Enguerrand de Ribaucourt wrote:
> ----- Original Message -----
> > From: "Andrew Lunn" <andrew@lunn.ch>
> > To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>
> > Cc: "netdev" <netdev@vger.kernel.org>, "hkallweit1" <hkallweit1@gmail.com>, "linux" <linux@armlinux.org.uk>
> > Sent: Tuesday, February 8, 2022 12:28:53 AM
> > Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY support
> 
> > > + /* KSZ8081A3/KSZ8091R1 PHY and KSZ9897 switch share the same
> > > + * exact PHY ID. However, they can be told apart by the default value
> > > + * of the LED mode. It is 0 for the PHY, and 1 for the switch.
> > > + */
> > > + ret &= (MICREL_KSZ8081_CTRL2_LED_MODE0 | MICREL_KSZ8081_CTRL2_LED_MODE1);
> > > + if (!ksz_8081)
> > > + return ret;
> > > + else
> > > + return !ret;
> 
> > What exactly does MICREL_KSZ8081_CTRL2_LED_MODE0 and
> > MICREL_KSZ8081_CTRL2_LED_MODE1 mean? We have to be careful in that
> > there could be use cases which actually wants to configure the
> > LEDs. There have been recent discussions for two other PHYs recently
> > where the bootloader is configuring the LEDs, to something other than
> > their default value.
> 
> Those registers configure the LED Mode according to the KSZ8081 datasheet:
> [00] = LED1: Speed LED0: Link/Activity
> [01] = LED1: Activity LED0: Link
> [10], [11] = Reserved
> default value is [00].
> 
> Indeed, if the bootloader changes them, we would match the wrong
> device. However, I closely examined all the registers, and there is no
> read-only bit that we can use to differentiate both models. The
> LED mode bits are the only ones that have a different default value on the
> KSZ8081: [00] and the KSZ9897: [01]. Also, the RMII registers are not
> documented in the KSZ9897 datasheet so that value is not guaranteed to
> be [01] even though that's what I observed.
> 
> Do you think we should find another way to match KSZ8081 and KSZ9897?
> The good news is that I'm now confident about the phy_id emitted by
> both models.

Lets try asking Prasanna Vengateshan, who is working on other
Microchip switches and PHYs at Microchip.

     Andrew
