Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3416D3849
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjDBOXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDBOXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:23:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9007CC20;
        Sun,  2 Apr 2023 07:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g6mDMfCi6BVBNCKIu3VUX+xX7L6pfIJRxYzALu4wBmc=; b=eXOmnpKNxbfwdy5ySUVHWsesP3
        oNiwVlPOg7Eh3Z6TFAPhuDU6b2Dq09Nuw5vjwUi2tOGd0JXdCtF+wNMcw6uX3+fH5CgpMM03fta5h
        3MIGWTkoriszi1epo6FJnQi5JZ3h3LhzyuH1hsUKIlCKRqS+f9acn2cHa58+6t+FIC+L2j6+GlEF9
        7l82Xqr7WQk39CSxkYYVnRLYEJN0o42IrF0Yz/mMbXgtgIAUGE05EkMD6Vuh8a9wNBRSVMJXftBVb
        aAx7PFT3kMy17X9vEnh8c5OTMnu28QIsqsCe+/ptJQsh74eGf3LZih4heRRgohlRiGMPRycr+9Bw1
        cVwiFmdg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46584)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1piybf-0001ft-4w; Sun, 02 Apr 2023 15:22:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1piyba-0003H9-Ul; Sun, 02 Apr 2023 15:22:50 +0100
Date:   Sun, 2 Apr 2023 15:22:50 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, chowtom <chowtom@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH] net: sfp: add qurik enabling 2500Base-x for HG MXPD-483II
Message-ID: <ZCmPutMh8UEhzI5D@shell.armlinux.org.uk>
References: <5e9a87a3f4c1ccc30625c8092b057f0fbd8a9947.1680435823.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e9a87a3f4c1ccc30625c8092b057f0fbd8a9947.1680435823.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 12:44:37PM +0100, Daniel Golle wrote:
> The HG MXPD-483II 1310nm SFP module is meant to operate with 2500Base-X,
> however, in their EEPROM they incorrectly specify:
>     Transceiver type                          : Ethernet: 1000BASE-LX
>     ...
>     BR, Nominal                               : 2600MBd
> 
> Use sfp_quirk_2500basex for this module to allow 2500Base-X mode anyway.
> 
> https://forum.banana-pi.org/t/bpi-r3-sfp-module-compatibility/14573/60

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Please could you also arrange for the reporter to capture the ethtool
information via:

	ethtool -m ethX raw on > sfp-name.bin

and send me the binary file?

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
