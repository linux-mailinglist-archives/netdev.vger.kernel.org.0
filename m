Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6744C5B68EA
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 09:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiIMHsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 03:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiIMHsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 03:48:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3546A5A3C8
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 00:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4adA3WGta17K9Xm/Y7x7sihozZeoygCz4taXNK2AlN8=; b=SEbmuyUo3echOtiLDeRaVOgyvw
        Ax6FG7UVUzFFTctGXgIdtjkPyiuepxRgu6EsKRPjd4GU/m8g5izi+Upp9aBbtW1qbyIsQzH6vWs1z
        G9jzwivX93uEd22LaQNwYmt4QrPEgWJjpkTd+qf2KEpQTqhEsoA6VrJaLBwFAe09E4TQpOzkdg7IL
        RZXSqNprQtExSvZrsUtu9CvS8D54LJnzkjtJ5klUt3gddpLqDbS2EujasZoMaxKGKo50LYUrQQDf+
        LNWbHw4K0AC5wXEHjGWAof6/VjpvcBz7uw2nWINeYxeHGromvo8K/Zr3b+0QDSgs7lB58KXPZygmY
        Hf3QdtHg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34288)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oY0eI-0002ar-KK; Tue, 13 Sep 2022 08:48:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oY0eH-0000Vv-ET; Tue, 13 Sep 2022 08:48:01 +0100
Date:   Tue, 13 Sep 2022 08:48:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Baruch Siach <baruch.siach@siklu.com>
Subject: Re: [PATCH] net: sfp: workaround GPIO input signals bounce
Message-ID: <YyA1sfZRuoka8yhl@shell.armlinux.org.uk>
References: <5934427dadd3065b125b80c38a111320677fa723.1663055018.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5934427dadd3065b125b80c38a111320677fa723.1663055018.git.baruch@tkos.co.il>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 10:43:38AM +0300, Baruch Siach wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> Add a trivial debounce to avoid miss of state changes when there is no
> proper hardware debounce on the input signals. Otherwise a GPIO might
> randomly indicate high level when the signal is actually going down,
> and vice versa.
> 
> This fixes observed miss of link up event when LOS signal goes down on
> Armada 8040 based system with an optical SFP module.

NAK. This needs more inteligent handling. For systems where we poll,
your code introduces a 100us delay each time we poll and there has
been no change.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
