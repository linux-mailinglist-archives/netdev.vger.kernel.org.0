Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE95E57D587
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiGUVGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbiGUVGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:06:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC27E140E8;
        Thu, 21 Jul 2022 14:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VjdhoOSxwUofmsbkQeM/8D+CSkyHvLKN59Rxj/F9hAk=; b=potu6KJKW9LMXDbBhWXEPnrxkY
        v6wY9K28GB+AntBqQh/V1uy+6LECYWrmIYENogAwFqyz7zMGHvyeliWkdaHKk8Tc2qU+ivB3YPLWC
        HzM8Ma1btMKrO4p1rXnhY/uy6I9jncN/HWsXyU4knH0Kcox4RQiMSK+olNg3/0t0T/crGgc+cJ/sj
        2FdjQabgMNxEIpMVR0JTiQ88ckUgX0JixgbjTE0rYqlFxlFSruyq/MIYy7UMWXYjmNvuyoPOT5KMn
        XLHIJxD7DHEjQCiCBbojztQY5HTj5qTCnmrMbi55NNjy0ZJ0aD7ssR5Ma9cTnMAEm8gaCWgCD6ky5
        AXUb1F/w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33492)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oEdNT-0005zq-Ui; Thu, 21 Jul 2022 22:06:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oEdNQ-00059m-5e; Thu, 21 Jul 2022 22:06:32 +0100
Date:   Thu, 21 Jul 2022 22:06:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 08/11] net: phylink: Adjust advertisement based on
 rate adaptation
Message-ID: <Ytm/2Co9U0od0mIX@shell.armlinux.org.uk>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-9-sean.anderson@seco.com>
 <Ytep4isHcwFM7Ctc@shell.armlinux.org.uk>
 <3844f2a6-90fb-354e-ce88-0e9ff0a10475@seco.com>
 <YtmVIXYKpCJ2GEwK@shell.armlinux.org.uk>
 <YtmckydVRP9Z/Mem@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtmckydVRP9Z/Mem@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 08:36:03PM +0200, Andrew Lunn wrote:
> > I guess it would depend on the structure of the PHY - whether the PHY
> > is structured similar to a two port switch internally, having a MAC
> > facing the host and another MAC facing the media side. (I believe this
> > is exactly how the MACSEC versions of the 88x3310 are structured.)
> > 
> > If you don't have that kind of structure, then I would guess that doing
> > duplex adaption could be problematical.
> 
> If you don't have that sort of structure, i think rate adaptation
> would have problems in general. Pause is not very fine grained. You
> need to somehow buffer packets because what comes from the MAC is
> likely to be bursty. And when that buffer overflows, you want to be
> selective about what you throw away. You want ARP, OSPF and other
> signalling packets to have priority, and user data gets
> tossed. Otherwise your network collapses.

I don't think rate adaption is that inteligent - it's all about slowing
the MAC down to the speed of the media. From what I remember looking at
pause frames, they can specify how long to delay further transmission
by the receiver, and I would expect this to be set according to the
media speed for setups that use pause packets.

For those which don't, then that's a whole different ball game, because
they tend not to have MACs, and then you're probably down to the
capabilities of nothing more than a FIFO in the PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
