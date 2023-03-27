Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C956CAC5B
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjC0Ryv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbjC0Ryp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:54:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094A6170A
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kAYwkEs6Pk6pN73CbrsbdiPUKX92a5m4AQhTAMwzL0Y=; b=o3ug+tvkwhPdussXq14K6r54M8
        ZNYC717FKKXqaxEeAhMsJ88cp+qTbcscSZRgPFwR2oTV1Rv/PbxxFzvcbSPR5BpRv71JGSMd+3MpI
        2fqhKtRBOcffLj92MQ4ptBiHHR3wiv2FQybnLG2gmne4jA8CSEYkOOdyzSInaLZG3EdYErqxTWDN7
        Z+cvvmfC5uR18hOwTE7nUsh7ZRVRnxOW91iJb/KofDJZ/ZHlTpU9D7FM6tjoFXPjHPkH7dnOyPy/w
        Oe7Zzr1WcirDiPA4rvCzIl94lC31kjlAwom20ic9Dvye8bUD7HT8c2AwJEeepPq48RaXpISXA/trP
        9+cQhB8A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49080)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pgr3H-0004Oj-NY; Mon, 27 Mar 2023 18:54:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pgr3F-0005co-Jq; Mon, 27 Mar 2023 18:54:37 +0100
Date:   Mon, 27 Mar 2023 18:54:37 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC/RFT 01/23] net: phy: Add phydev->eee_active to simplify
 adjust link callbacks
Message-ID: <ZCHYXbKvZhkZhJ8L@shell.armlinux.org.uk>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327170201.2036708-2-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 07:01:39PM +0200, Andrew Lunn wrote:
> MAC drivers which support EEE need to know the results of the EEE
> auto-neg in order to program the hardware to perform EEE or not.  The
> oddly named phy_init_eee() can be used to determine this, it returns 0
> if EEE should be used, or a negative error code,
> e.g. -EOPPROTONOTSUPPORT if the PHY does not support EEE or negotiate
> resulted in it not being used.
> 
> However, many MAC drivers get this wrong. Add phydev->eee_active which
> indicates the result of the autoneg for EEE, including if EEE is
> administratively disabled with ethtool. The MAC driver can then access
> this in the same way as link speed and duplex in the adjust link
> callback.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
