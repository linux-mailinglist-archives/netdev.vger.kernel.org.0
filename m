Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F80680050
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 17:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbjA2QwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 11:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2QwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 11:52:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C637199E4;
        Sun, 29 Jan 2023 08:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=loe6zYoEnP/MUhESYQA4cmRuiS4ozpW2WWxXFcKEAC0=; b=6FxHhcpkpDR5txGRZKHeS2LSi5
        kiGxT8C2VWCYMp3XeU6S23uLB7TU/+qdGDqAIYoxgePlfcFHXPlj1QCRI3GK/DeRM6OSM+QVWct/K
        fw+iEC0AqgtAZyrxmmQMNGvqatDbbxKq/WCSQd8ovtQMtl/+foUVCQVeaSA4NfayQywg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pMAuL-003Vri-Si; Sun, 29 Jan 2023 17:51:57 +0100
Date:   Sun, 29 Jan 2023 17:51:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com, Chris Healy <healych@amazon.com>
Subject: Re: [PATCH 1/1] net: phy: meson-gxl: Add generic dummy stubs for MMD
 register access
Message-ID: <Y9akLWJfigajMuQP@lunn.ch>
References: <20230129022615.379711-1-cphealy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230129022615.379711-1-cphealy@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 06:26:15PM -0800, Chris Healy wrote:
> From: Chris Healy <healych@amazon.com>
> 
> The Meson G12A Internal PHY does not support standard IEEE MMD extended
> register access, therefore add generic dummy stubs to fail the read and
> write MMD calls. This is necessary to prevent the core PHY code from
> erroneously believing that EEE is supported by this PHY even though this
> PHY does not support EEE, as MMD register access returns all FFFFs.

Hi Chris

This change in itself makes sense. But i wounder if we should also
change phy_init_eee(). It reads the EEE Ability register. The 2018
version of the standard indicates the top two bits are reserved and
should be zero. We also don't have any PHY which supports 100GBase-R
through to 100Base-TX. So a read of 0xffff suggests the PHY does not
support EEE and returning -EPROTONOSUPPORT would be good.

	Andrew
