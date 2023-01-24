Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE8F678D1A
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 02:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbjAXBEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 20:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjAXBEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 20:04:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F481303C8;
        Mon, 23 Jan 2023 17:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YLRZgPgm6zFTbHxaOInUyu4eJC7xlh91Tt1JwAy9PRk=; b=nlVxWqq0PB30WEGxiirjxXsV1T
        m+t9c5zpijwC9nE8FbSu1H2x/XYasgNgzfYSy6u/XoOgXVkf6S531YbAwX5b6WmljqvcV1E7QLsfj
        6yiozCFkBHz9xgrmg/T+Vzhq2w50IKLG/ZifSu4dQ4nvHOUQ6DsLvDmNkiB7wihOdO3o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pK7jZ-002xyX-QM; Tue, 24 Jan 2023 02:04:21 +0100
Date:   Tue, 24 Jan 2023 02:04:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrey Konovalov <andrey.konovalov@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] net: stmmac: add DT parameter to keep RX_CLK running
 in LPI state
Message-ID: <Y88uleBK5zROcpgc@lunn.ch>
References: <20230123133747.18896-1-andrey.konovalov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123133747.18896-1-andrey.konovalov@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 04:37:45PM +0300, Andrey Konovalov wrote:
> On my qcs404 based board the ethernet MAC has issues with handling
> Rx LPI exit / Rx LPI entry interrupts.
> 
> When in LPI mode the "refresh transmission" is received, the driver may
> see both "Rx LPI exit", and "Rx LPI entry" bits set in the single read from
> GMAC4_LPI_CTRL_STATUS register (vs "Rx LPI exit" first, and "Rx LPI entry"
> then). In this case an interrupt storm happens: the LPI interrupt is
> triggered every few microseconds - with all the status bits in the
> GMAC4_LPI_CTRL_STATUS register being read as zeros. This interrupt storm
> continues until a normal non-zero status is read from GMAC4_LPI_CTRL_STATUS
> register (single "Rx LPI exit", or "Tx LPI exit").
> 
> The reason seems to be in the hardware not being able to properly clear
> the "Rx LPI exit" interrupt if GMAC4_LPI_CTRL_STATUS register is read
> after Rx LPI mode is entered again.
> 
> The current driver unconditionally sets the "Clock-stop enable" bit
> (bit 10 in PHY's PCS Control 1 register) when calling phy_init_eee().
> Not setting this bit - so that the PHY continues to provide RX_CLK
> to the ethernet controller during Rx LPI state - prevents the LPI
> interrupt storm.
> 
> This patch set adds a new parameter to the stmmac DT:
> snps,rx-clk-runs-in-lpi.
> If this parameter is present in the device tree, the driver configures
> the PHY not to stop RX_CLK after entering Rx LPI state.

Do we really need yet another device tree parameter? Could
dwmac-qcom-ethqos.c just do this unconditionally? Is the interrupt
controller part of the licensed IP, or is it from QCOM? If it is part
of the licensed IP, it is probably broken for other devices as well,
so maybe it should be a quirk for all devices of a particular version
of the IP?

   Andrew
