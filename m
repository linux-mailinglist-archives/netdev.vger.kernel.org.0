Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55EA12A864
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 16:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfLYPI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 10:08:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfLYPI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Dec 2019 10:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jQM1mPv2ronZJbcInLqrwGfsm7Z5m5AylYfzZgE2JXA=; b=zTEfMuOoUE9MwHB3sP2D4Xd29U
        B+ejTbVH8L+m+Y7bydqkF8Dm/oDIF0kTrd+TKU5JrmBdJkTJbF1cPtIa5qlI4XdJcYZcJR2eZKCfI
        NTTb5UzoFmrjvo0NuqfqIaHH1JhkSOviMTwD8hDle1tN/hewSV9OhQeSRTHZtCZwz6aw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ik8HF-0004Zd-42; Wed, 25 Dec 2019 16:08:45 +0100
Date:   Wed, 25 Dec 2019 16:08:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, khilman@baylibre.com,
        linus.luessing@c0d3.blue, balbes-150@yandex.ru,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ingrassia@epigenesys.com, jbrunet@baylibre.com
Subject: Re: [PATCH 1/3] net: stmmac: dwmac-meson8b: Fix the RGMII TX delay
 on Meson8b/8m2 SoCs
Message-ID: <20191225150845.GA16671@lunn.ch>
References: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
 <20191225005655.1502037-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191225005655.1502037-2-martin.blumenstingl@googlemail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 01:56:53AM +0100, Martin Blumenstingl wrote:
> GXBB and newer SoCs use the fixed FCLK_DIV2 (1GHz) clock as input for
> the m250_sel clock. Meson8b and Meson8m2 use MPLL2 instead, whose rate
> can be adjusted at runtime.
> 
> So far we have been running MPLL2 with ~250MHz (and the internal
> m250_div with value 1), which worked enough that we could transfer data
> with an TX delay of 4ns. Unfortunately there is high packet loss with
> an RGMII PHY when transferring data (receiving data works fine though).
> Odroid-C1's u-boot is running with a TX delay of only 2ns as well as
> the internal m250_div set to 2 - no lost (TX) packets can be observed
> with that setting in u-boot.
> 
> Manual testing has shown that the TX packet loss goes away when using
> the following settings in Linux:
> - MPLL2 clock set to ~500MHz
> - m250_div set to 2
> - TX delay set to 2ns

Hi Martin

The delay will depend on the PHY, the value of phy-mode, and the PCB
layout.

https://ethernetfmc.com/rgmii-interface-timing-considerations/

RGMII requires a delay of 2ns between the data and the clock
signal. There are at least three ways this can happen.

1) The MAC adds the delay

2) The PCB adds the delay by making the clock line longer than the
data line.

3) The PHY adds the delay.

In linux you configure this using the phy-mode in DT.

      # RX and TX delays are added by the MAC when required
      - rgmii

      # RGMII with internal RX and TX delays provided by the PHY,
      # the MAC should not add the RX or TX delays in this case
      - rgmii-id

      # RGMII with internal RX delay provided by the PHY, the MAC
      # should not add an RX delay in this case
      - rgmii-rxid

      # RGMII with internal TX delay provided by the PHY, the MAC
      # should not add an TX delay in this case
      - rgmii-txid

So ideally, you want the MAC to add no delay at all, and then use the
correct phy-mode so the PHY adds the correct delay. This gives you the
most flexibility in terms of PHY and PCB design. This does however
require that the PHY implements the delay, which not all do.

Looking at patches 2 and 3, the phy-mode is set to rgmii. What you
might actually need to do is set this to rgmii-txid, or maybe
rgmii-id, once you have the MAC not inserting any delay.

With MAC/PHY issues, it is a good idea to Cc: the PHY maintainers.

	Andrew

