Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE276BDB29
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCPV43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCPV42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:56:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20BA38B62
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 14:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LzJVT1YLVSxCwyYJDFQ7AijDbKEfkNXaVr/FyexpV4g=; b=ZPnkfwVee81qlCfWipMdH+IPb9
        Z851th9zA8IaRyynxVNRckhSEGJUp+5eoxxJwuTejp3zvJDBPglDUhkG/K+YJZNW2CrVQkBPMiRGK
        YeqQT6lSq92JCLyJgNI3DDa0g6zrnbCXQZg5gDA9Rdd5UKyZTcY+IsRd1AUGdAheV5YZFT8VwHMcA
        XDuu83i1XUCYctPW+ikU8WJuxBQkpebYTZwFwiMkvdf6iePrVGG5S0dcIp7KuDEcy1n/i0H/cNalf
        dcyl7V89zs2B0Wgz52bjCfwqAIV74xwPeMjUniqOKxjoU5Lcn3o5EGKZgDRKM13vV4v1TNInze0sq
        rIcKFnlQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59080)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pcva2-0001Lk-Du; Thu, 16 Mar 2023 21:56:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pcvZx-0002mv-Fu; Thu, 16 Mar 2023 21:56:09 +0000
Date:   Thu, 16 Mar 2023 21:56:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
Subject: Re: [PATCH 1/1] net: stmmac: start PHY early in __stmmac_open
Message-ID: <ZBOQecR6q5Xgr75F@shell.armlinux.org.uk>
References: <20230316205449.1659395-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316205449.1659395-1-shenwei.wang@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 03:54:49PM -0500, Shenwei Wang wrote:
> By initializing the PHY and establishing the link before setting the
> MAC relating configurations, this change ensures that the PHY is
> operational before the MAC logic starts relying on it. This can
> prevent synchronization errors and improve system stability.
> 
> This change especially applies to the RMII mode, where the PHY may drive
> the REF_CLK signal, which requires the PHY to be started and operational
> before the MAC logic initializes.
> 
> This change should not impact other modes of operation.

NAK. A patch similar to this has already been sent.

The problem with just moving this is that phylink can call the
mac_link_up() method *before* phylink_start() has returned - and as
this driver has not completed the setup, it doesn't expect the link
to come up at that point.

There are several issues with this driver wanting the PHY clock early,
and there have been two people working on addressing this previously,
proposing two different changes to phylink.

I sent them away to talk to each other and come back with a unified
solution. Shock horror, they never came back.

Now we seem to be starting again from the beginning.

stmmac folk really need to get a handle on this so reviewers are not
having to NAK similar patches time and time again, resulting in the
problem not being solved.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
