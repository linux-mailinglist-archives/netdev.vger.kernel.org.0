Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40A962DC6F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239850AbiKQNQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239776AbiKQNQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:16:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A35558D
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 05:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yLEZR/7Mit3u0UM8BtRpOZl8+7QAciChfk8L7WDoj9k=; b=v4cSeC9SoABRgZh90pwZbTt/eX
        SEdO+43bxbABv4+ShSLLhr3YaZ/tUosBCKO8hnwEd5Gf5awObpA4YOOt+E/3+pNnqt2F+MRi1285H
        O461irrtHwXRI6LMZcsVZa5bALlB0V44O8+WHjDy9ANuwN7xHd6zi4J5yCig5dnczfOI0Ob6f7iYO
        GQpbS0igsGjV2nr1lJMgdWvrAiBs73BxavLpffr2jb6nAIthJ/JtLjDx4Rx/ihaoIUZs1Hi+zSyPm
        1hksT8EvMuY12Vq5ATNd1KLMgIej8x8J5hJZvDgva96JztewjOpJEf++tRQvLPRzpiRvgbt6K3VUM
        cQBzGALg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35314)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ovekE-0004YS-RF; Thu, 17 Nov 2022 13:15:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ovekC-0006q3-0s; Thu, 17 Nov 2022 13:15:52 +0000
Date:   Thu, 17 Nov 2022 13:15:51 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Liu Jian <liujian56@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, horatiu.vultur@microchip.com,
        bjarni.jonasson@microchip.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: sparx5: fix error handling in sparx5_port_open()
Message-ID: <Y3Y0B4umLgFdcD4u@shell.armlinux.org.uk>
References: <20221117125918.203997-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117125918.203997-1-liujian56@huawei.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 08:59:18PM +0800, Liu Jian wrote:
> If phylink_of_phy_connect() fails, the port should be disabled.
> If sparx5_serdes_set()/phy_power_on() fails, the port should be
> disabled and the phylink should be stopped and disconnected.
> 
> Fixes: 946e7fd5053a ("net: sparx5: add port module support")
> Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

The patch looks sane for the code structure that's there, but I question
whether this is the best code structure.

phylink_start() will call the pcs_config() method, which then goes on
to call sparx5_port_pcs_set() and sparx5_port_pcs_low_set() - which
then calls sparx5_serdes_set(). Is that safe with the serdes PHY
powered down? I think sparx5 maintainers need to think about that,
and possibly include a comment in the code if it is indeed safe.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
