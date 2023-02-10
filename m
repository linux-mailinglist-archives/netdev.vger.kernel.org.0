Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D41692976
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbjBJVoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjBJVog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:44:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6594DE3D;
        Fri, 10 Feb 2023 13:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Q4ycTM6wjBzQxnmAN1l0VrC0z1bUlOmEH9rHmaSCS7Y=; b=SbS8AXmj9RhgHzGEoljuzMLM5d
        QkbKoM9XzPbnNltx4q3Ehcod7YTDuGAoNbylMlU33dHqjXtYBNGJbov6Vd7vlvkXzgikcAAqdrbAu
        /PxBsPCk8r+AZPx6Aw77YmK0q9WxYCpoLf7bx99XPjz26YitrhpdopmVU94xuDCqoOqvA0A2cVVEP
        DtV28WyswTdHzn7F99dlJlnQYxfsGfGDaGSTH4e+A7KV0SvSGO1Ud14r8bnXOkc3qNJFGEhkiHuJZ
        Id5KnjJSe6fNwaOoU++CS7O/7Mgwngon9xYtrcWqOJ2WCkbs8OdzaDJ8ykiWnLjisTRDt2cPbo7Zp
        ADDCaD4w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60080)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQbBy-0000hg-Ew; Fri, 10 Feb 2023 21:44:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQbBr-0000V9-W4; Fri, 10 Feb 2023 21:44:20 +0000
Date:   Fri, 10 Feb 2023 21:44:19 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v3 07/12] net: ethernet: mtk_eth_soc: only write values
 if needed
Message-ID: <Y+a6s0xGXWE7gdF2@shell.armlinux.org.uk>
References: <cover.1675984550.git.daniel@makrotopia.org>
 <655926d824fac09cf188d746ae18cfb823135525.1675984550.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <655926d824fac09cf188d746ae18cfb823135525.1675984550.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 11:31:51PM +0000, Daniel Golle wrote:
> +		/* Setup the link timer and QPHY power up inside SGMIISYS */
> +		link_timer = phylink_get_link_timer_ns(interface);
> +		if (link_timer < 0)
> +			return link_timer;

My comment on the previous iteration of this series applies here.

(this comment for net-next review tracking purposes.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
