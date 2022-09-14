Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923145B8C50
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiINPyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiINPyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:54:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873A380B53;
        Wed, 14 Sep 2022 08:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6ENqpZ1rhLgHpjcT3PmRqlF4gjvOUVH5mvvBR/bPYHo=; b=cO74HYqs6GJqXZtgFqaSIyeorm
        IFMq+32ym2GLMgV8kebbk0NkqM5ST1RkSnzZcAPjs8Bi5wFsIsYuqlVY42htpCF05R4fsLLGa1qti
        RQ9hEEnM5uoLxoCldpV+6+G27aVXu8Gckj0HUybnhwwqcFBMt938zEabaLyR6+5TEjtDIAM77jFJV
        MNeZDWyMTK/KvwUMpipF2s6ZrpY7zhO9vtS5lctG8qhRCP+rem1O6ZAG3PPELS2iEuEui81N2252O
        6OVniWb/ivPn7l9JocGV6DwTMI/UvsC19meSj/WgY58ENTmJtzq6XTJpoJAsIW0epFZ3IIcJLBncl
        sTe67ZOQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34328)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYUiH-0004Zt-2W; Wed, 14 Sep 2022 16:54:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYUiG-0001mK-DU; Wed, 14 Sep 2022 16:54:08 +0100
Date:   Wed, 14 Sep 2022 16:54:08 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com
Subject: Re: [PATCH 4/8] net: ethernet: ti: am65-cpsw: Add mac enable link
 function
Message-ID: <YyH5IO6dUJtYFQS8@shell.armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-5-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914095053.189851-5-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 03:20:49PM +0530, Siddharth Vadapalli wrote:
> Add function am65_cpsw_nuss_mac_enable_link() to invoke
> am65_cpsw_enable_phy(), cpsw_ale_control_set(), am65_cpsw_qos_link_up()
> and netif_tx_wake_all_queues() to prevent duplicate code. The above
> set of function calls are currently invoked by the
> am65_cpsw_nuss_mac_link_up() function. In a later patch in this series
> meant for adding fixed-link support, even the am65_cpsw_nuss_mac_config()
> function will invoke the same set of functions.

I don't think you will need this patch once you've debugged why
mac_link_up() doesn't get called for a fixed link (it should be
called.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
