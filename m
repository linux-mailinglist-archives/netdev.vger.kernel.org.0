Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED7B560A7C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 21:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiF2TmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 15:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiF2TmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 15:42:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281C23DA68
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 12:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=s1E+xnoxQam6BGb8WNqWArVqE7MfR4AKHbIGmD6x620=; b=Luw8XnkcQW1ZHN5xTnGzrhqb3q
        j7deHI6vycojFYLuhVHlDtIA8Lkxw3Bpy57gvufnz94D0zE+Gdlrsg/zW178oIi2m2XEsJiEn8w5I
        VTlVeXQxHZHhDR+J9wlGcdkvAqgg+YyP6xzWcAzNtgUL1C0MMe7iO6JHu7hFiRRVoplASflpaA/K1
        S2g71hwKVXZXmYVJCQ10MjOHHsUwZ5s2eGIc0gMNIw98cuCnrsN0QqhnIytFzfhZ8zP7P9zOdl8Dq
        kRB4N9K9WGfEMiaiJaS9qWFJ846pTmW+5rYbbl3I1RF+I/W7g/vMqgsjg2Cj9pDmtLXipAeNDswZB
        KGTnxWNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33106)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6dZc-0003cd-IW; Wed, 29 Jun 2022 20:42:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6dZa-00066W-GX; Wed, 29 Jun 2022 20:42:02 +0100
Date:   Wed, 29 Jun 2022 20:42:02 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phylink: fix NULL pl->pcs dereference
 during phylink_pcs_poll_start
Message-ID: <YryrCrLyqciJqFxY@shell.armlinux.org.uk>
References: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 10:33:58PM +0300, Vladimir Oltean wrote:
> The current link mode of the phylink instance may not require an
> attached PCS. However, phylink_major_config() unconditionally
> dereferences this potentially NULL pointer when restarting the link poll
> timer, which will panic the kernel.
> 
> Fix the problem by checking whether a PCS exists in phylink_pcs_poll_start(),
> otherwise do nothing. The code prior to the blamed patch also only
> looked at pcs->poll within an "if (pcs)" block.
> 
> Fixes: bfac8c490d60 ("net: phylink: disable PCS polling over major configuration")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
