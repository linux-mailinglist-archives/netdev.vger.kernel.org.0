Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A958469FF39
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 00:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjBVXHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 18:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBVXHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 18:07:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6838640C3;
        Wed, 22 Feb 2023 15:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8KYNEFyLJl6kZB7eR6AV4gLPNHQ81KCSRuBqEPC4KkQ=; b=dD1+mwdf+34+KZ3CiX9QkVGdRE
        Eax0k3zP/0k3djWcrhzwLrnaSAOAKdklHcEAkJn0hROSQUgwIQPLt+efZQPuaaEmUcT4DlGBNLZLT
        09ymYe7SsB0DTFS/f9hGpbWkioboA1db4El8O8xkyq6+dZ9tW69GuaVAt2ivMq1W54Y6IdvWFeOAk
        eUIVVhbgnWkgurT/u7EbHc368cwzaTvH92xuX/qvJ2tOnuDzsCt/27FDnHnuQP6IgTXwFvLCm7xjy
        GEeU69tjSNAjSfp7DVbH+8dRCKiTX6MqbkGFGYoV3M3HC7rJdfU+d5DhPzAzlcABzN/y0RqqwCywt
        w09UOPqA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49262)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pUyCj-0007S2-Nu; Wed, 22 Feb 2023 23:07:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pUyCg-0003ZN-9v; Wed, 22 Feb 2023 23:07:14 +0000
Date:   Wed, 22 Feb 2023 23:07:14 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek Vasut <marex@denx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function
 for KSZ87xx
Message-ID: <Y/agIibWwIjQKuNF@shell.armlinux.org.uk>
References: <20230222031738.189025-1-marex@denx.de>
 <20230222210853.pilycwhhwmf7csku@skbuf>
 <ed05fc85-72a8-e694-b829-731f6d720347@denx.de>
 <20230222223141.ozeis33beq5wpkfy@skbuf>
 <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 11:58:23PM +0100, Marek Vasut wrote:
> On 2/22/23 23:31, Vladimir Oltean wrote:
> > On Wed, Feb 22, 2023 at 11:05:10PM +0100, Marek Vasut wrote:
> > > On 2/22/23 22:08, Vladimir Oltean wrote:
> > > > Please summarize in the commit title what is the user-visible impact of
> > > > the problem that is being fixed. Short and to the point.
> > > 
> > > Can you suggest a Subject which is acceptable ?
> > 
> > Nope. The thing is, I don't know what you're seeing, only you do. I can
> > only review and comment if it's plausible or not. I'm sure you can come
> > up with something.
> > 
> > > > > Currently, the driver uses PORT read function on register P_XMII_CTRL_1
> > > > > to access the P_GMII_1GBIT_M, i.e. Is_1Gbps, bit.
> > > > 
> > > > Provably false. The driver does do that, but not for KSZ87xx.
> > > 
> > > The driver uses port read function with register value 0x56 instead of 0x06
> > > , which means the remapping happens twice, which provably breaks the driver
> > > since commit Fixes below .
> > 
> > The sentence is false in the context of ksz87xx, which is what is the
> > implied context of this patch (see commit title written by yourself).
> > The P_GMII_1GBIT_M field is not accessed, and that is a bug in itself.
> > Also, the (lack of) access to the P_GMII_1GBIT_M field is not what
> > causes the breakage that you see, but to other fields from that register.
> > 
> > > > There is no call site other than ksz_set_xmii(). Please delete false
> > > > information from the commit message.
> > > 
> > > $ git grep P_XMII_CTRL_1 drivers/net/dsa/microchip/
> > > drivers/net/dsa/microchip/ksz_common.c: [P_XMII_CTRL_1] = 0x06,
> > > drivers/net/dsa/microchip/ksz_common.c: [P_XMII_CTRL_1] = 0x0301,
> > > drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
> > > drivers/net/dsa/microchip/ksz_common.c: ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
> > > drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
> > > drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
> > > drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
> > > drivers/net/dsa/microchip/ksz_common.c: ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
> > > drivers/net/dsa/microchip/ksz_common.h: P_XMII_CTRL_1,
> > > 
> > > I count 6.
> > 
> > So your response to 2 reviewers wasting their time to do a detailed
> > analysis of the code paths that apply to the KSZ87xx model in particular,
> > to tell you precisely why your commit message is incorrect is "git grep"?
> > 
> > > OK, to make this simple, can you write a commit message which you consider
> > > acceptable, to close this discussion ?
> > 
> > Nope. The thing is, I'm sure you can, too. Maybe you need to take a
> > break and think about this some more.
> 
> Sorry, not like this and not with this feedback tone.

I gave you reasonable technical feedback. I spent a lot of time working
that out.

However, your responses were consistently difficult, but I kept my
cool. I completely agree with Vladimir's sentiments.

Had you come straight out and asked for help writing the commit
message, then I might have been more receptive, but to "play dumb" as
you seemed to do, only to then eventually ask for me to write the
commit message for you... sorry, but no, you don't get that free
cookie anymore and that ship sailed when you decided to be difficult.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
