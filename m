Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCCB4AF259
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbiBINGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbiBINGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:06:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F73DC05CBB4
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=upC8s56EuBQezUfHCbf6Sex/+GOA674B29PJ8A+uuZs=; b=jEde0e7/5XB5RNBY5P0Vm0oUK/
        QNk0l0BR42QvBLJDWE23pmjEGFOKS25qjupBZFdyIZJJwMZtNP3X0WrjOua7p+6GABojoNDdZogGF
        qZM7TXQ+M6I80Mr3OfH2PGqACrQmHLPZo1U3VakRfdmDxMF1d8KHvphtcYkqa/9gUJYzc0hentYbu
        r5XLzDHUAP3TfdLJkNoKwXlqyT+0K6ukhwendyAGkad1ABuLhgeUDZlsfVBPQsPVZbJNbLMO0ezrf
        CJHIn6753z7Q+vcarDxi1uevRXBbnKEBwPjzPyuC83n0RHFIVlvu1S4yMspH0V8c8pmrew68mDaBL
        r9KChxpQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57168)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nHmg8-0004XV-9o; Wed, 09 Feb 2022 13:06:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nHmg4-0001Xq-PC; Wed, 09 Feb 2022 13:06:32 +0000
Date:   Wed, 9 Feb 2022 13:06:32 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 0/7] net: dsa: mt7530: updates for phylink
 changes
Message-ID: <YgO8WMjc77BsOLtD@shell.armlinux.org.uk>
References: <YfwRN2ObqFbrw/fF@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfwRN2ObqFbrw/fF@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 05:30:31PM +0000, Russell King (Oracle) wrote:
> Hi,
> 
> This series is a partial conversion of the mt7530 DSA driver to the
> modern phylink infrastructure. This driver has some exceptional cases
> which prevent - at the moment - its full conversion (particularly with
> the Autoneg bit) to using phylink_generic_validate().
> 
> What stands in the way is this if() condition in
> mt753x_phylink_validate():
> 
> 	if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
> 	    !phy_interface_mode_is_8023z(state->interface)) {
> 
> reduces to being always true. I highlight this here for the attention
> of the driver maintainers.

I'm intending to submit this series later today, preserving the above
behaviour, as I like to keep drivers bug-for-bug compatible, with the
assumption that they've been tested as working, even if the code looks
wrong. However, it would be good if this point could be addressed.
Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
