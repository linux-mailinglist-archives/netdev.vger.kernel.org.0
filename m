Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D791F604650
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiJSNGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbiJSNGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:06:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658131C117F;
        Wed, 19 Oct 2022 05:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0fsK06XH6eOz8QUYu7W6haCyhqbOJ3WnbeWYAL5slVo=; b=pXNf/TpCCzgHcbe302KXLuoY7+
        8Y/jFPJ4a4iKo5bMujxGTdL82eq5duKQVc/eXLuh1S85tm7iEza7H7XPeqm3EehVYbt7FNdBveqB8
        CyrFEthXrArT8/uPCt7zKGMFyML0Y+Hgp/tTExGAqYmyNHAIZ+wqogCcyTXWKLyFIo4rdnAO2DDL9
        ekr6JFNSkwDWW0ZmQS9xO/Dqm35W7iyL8ovtm3l2sb4HlqcaHYCXuENhNrcZk+xY8Bg0LvkU0o5zr
        0si6evLOEWm2iK+LCl/7WgFhMhA+Nwd4zqP1bmDmQ7TV86V44ZaJ24pyh8eaE7ZsouNPxAbxMAQxv
        SDNqcQYA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34802)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ol8Vo-0005fg-Oh; Wed, 19 Oct 2022 13:49:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ol8Vk-0002AK-MA; Wed, 19 Oct 2022 13:49:28 +0100
Date:   Wed, 19 Oct 2022 13:49:28 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH] net: stmmac: linkup phy after enabled mac when system
 resume
Message-ID: <Y0/yWHvHs6NHdB8W@shell.armlinux.org.uk>
References: <20221019123643.1937889-1-xiaoning.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019123643.1937889-1-xiaoning.wang@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 08:36:43PM +0800, Clark Wang wrote:
> +	mutex_unlock(&priv->lock);
> +	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
> +		phylink_resume(priv->phylink);
> +	} else {
> +		phylink_resume(priv->phylink);
> +		if (device_may_wakeup(priv->device))
> +			phylink_speed_up(priv->phylink);
> +	}
> +	mutex_lock(&priv->lock);

First, is there a reason this isn't coded as:

	mutex_unlock(&priv->lock);
	phylink_resume(priv->phylink);

	if (!priv->plat->pmt && device_may_wakeup(priv->device))
		phylink_speed_up(priv->phylink);

	mutex_lock(&priv->lock);

And secondly, is it really safe to drop this lock? What specifically
is the lock protecting? I see this isn't documented in the driver...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
