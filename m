Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251DE5A4D1F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 15:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiH2NLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 09:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiH2NLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 09:11:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B231096;
        Mon, 29 Aug 2022 06:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yMN137tQOiEvCCugp8sfYuKyYpdctIsrHd3N7Y4xCc0=; b=HVYaRpe8Vtcbr+q8D2qz1UeUrA
        ApHFNDSSLiZ2wHmuhVzqrwsX3/lNtzgjy/UfWdtupPVPxRrTOUiJuhkupRQLkVKQAn5caCje96480
        Jt6vaOzi/UHjLAUwOE6YQS/xoYJS+7yuuGDVJzOZyCdBcqxdlgWItzVchN/4+JQlW3Y8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oSeWZ-00ExtK-M7; Mon, 29 Aug 2022 15:09:55 +0200
Date:   Mon, 29 Aug 2022 15:09:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Anand Moon <anand@edgeble.ai>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Sugar Zhang <sugar.zhang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Jagan Teki <jagan@edgeble.ai>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: ethernet: stmicro: stmmac: dwmac-rk: Add rv1126
 support
Message-ID: <Ywy6o2d9j4Z7+WYX@lunn.ch>
References: <20220829065044.1736-1-anand@edgeble.ai>
 <20220829065044.1736-2-anand@edgeble.ai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829065044.1736-2-anand@edgeble.ai>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 06:50:42AM +0000, Anand Moon wrote:
> Rockchip RV1126 has GMAC 10/100/1000M ethernet controller
> via RGMII and RMII interfaces are configured via M0 and M1 pinmux.
> 
> This patch adds rv1126 support by adding delay lines of M0 and M1
> simultaneously.

What does 'delay lines' mean with respect to RGMII?

The RGMII signals need a 2ns delay between the clock and the data
lines. There are three places this can happen:

1) In the PHY
2) Extra long lines on the PCB
3) In the MAC

Generally, 1) is used, and controlled via phy-mode. A value of
PHY_INTERFACE_MODE_RGMII_ID passed to the PHY driver means it will add
these delays.

You don't want both the MAC and the PHY adding delays.

    Andrew
