Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0419551643C
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346591AbiEALkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346586AbiEALkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:40:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E29E1D0D4
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=arKfTv1fFH6Sz8kyfUN97JF1tDtbXMqgigUBKPYzOwY=; b=kNQKFsup6s3lSIBJW20B6kpZ60
        YqV+sEJEVTNlMmojwFyjZscCIDQjYc6ZBy+OiJOZFS6XVC/dsBA/VrdoJI72hEvzKdHVFT4Yyu/QA
        mEJdoCASERfkM+cpeuppaNYcSLJU89dT83OWQvGbanXDR8T5cvZPLHLJm6RnRCp/x8tvbcsW0s3LY
        16DbwmbVpJ//if5ry0pvjsIp+YRD3my2YbpN5/sh9ScOrNa9El/CKZ+u/jXDKn0BeqjrfajUEFkhJ
        lOeamEkiguqE/uPoWCPfT60DHzw7aLp6WUD1hsAsAfVGkoH81M39gB5OnqrjArw1oeh5ouP/6xQEo
        Wh3HgyHw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58478)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nl7sy-0006Dz-Ny; Sun, 01 May 2022 12:37:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nl7sx-0003qy-SJ; Sun, 01 May 2022 12:37:07 +0100
Date:   Sun, 1 May 2022 12:37:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Marcin Wojtas <mw@semihalf.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Message-ID: <Ym5w43WeWut05Mev@shell.armlinux.org.uk>
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
 <87levpzcds.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87levpzcds.fsf@tarshish>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 01:59:55PM +0300, Baruch Siach wrote:
> Hi Marcin,
> 
> I can add that DT phy-mode is set to "10gbase-kr" (equivalent to
> "10gbase-r" in this case).

Please do not use 10gbase-kr - this is for backplane support, and was an
early mistake with the 88x3310 nand Armada 8040. Both behave compatibly
with it for older DT, and that's only what it's there for. You should be
specifying "10gbase-r" in DT. Please update your DT.

> The port cp0_eth0 is connected to a 1G
> Ethernet switch. Kernel messages indicate that on interface up the MAC
> is first configured to XLG (10G), but after Ethernet (wire)
> auto-negotiation that MAC switches to SGMII. If I set DT phy-mode to
> "sgmii" the issue does not show. Same if I make a down/up cycle of the
> interface.

Sounds like old PHY firmware.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
