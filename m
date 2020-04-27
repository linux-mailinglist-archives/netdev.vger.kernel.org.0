Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945871BB0CB
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgD0VwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:52:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39414 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgD0VwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 17:52:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W2nZ/AC5SYD3gcSLnbu+uo46QTDRbgde6kyBr7kf65w=; b=myO0Z0y7uA7IYjQSpJDZiHP6eR
        v7l8GAGKiYVIh4ccDQEYAVCdjTcJI31ofPk9qlKiDkdyu8EkUOrnb9h6w36dKhnvozNRYlT+1NG1P
        taC4kHc12w1jW/EBdq7wYOWozb5usI5P5cQ7IYdrkxof4irOz74+K9NRmcp/ri+BdkvM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTBfd-005I0E-Ky; Mon, 27 Apr 2020 23:52:09 +0200
Date:   Mon, 27 Apr 2020 23:52:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed_phy support
Message-ID: <20200427215209.GP1250287@lunn.ch>
References: <rberg@berg-solutions.de>
 <20200425234320.32588-1-rberg@berg-solutions.de>
 <20200426143116.GC1140627@lunn.ch>
 <6C2E44BB-F4D1-4BC3-9FCB-55F01DA4A3C9@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6C2E44BB-F4D1-4BC3-9FCB-55F01DA4A3C9@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 11:37:07PM +0200, Roelof Berg wrote:
> Hello Andrew,
> 
> thanks for working together on this. Our target system is an embedded linux device for vehicles, that has all three components as single chips on one PCB: The MCU, the lan743x MAC and a KSZ9893 switch.

What is the MCU? ARM?

> Four options:
> a) We offer this kernel configuration and the next embedded system designer can use phyless MII mode.
> b) We change this to a runtime configuration that somehow auto-detects that phyless MII mode is desired.
>     (Then the EEPROM/OTP needs to provide baud rate, MII mode and duplex mode by user-register access).
> c) We move the configuration of the phyless mode to somewhere like dev-fs
> d) We avoid compiled fixed_phy and use a newer method. Like device-tree configuration of fixed_phy (is it working allready ?) or phylink as you originally suggested. Unfortunately I have no test-hardware here that uses a phy.
> e) We leave this one away from the kernel if it is unlikely that other embedded systems would use lan8431 in direct (phyless) MII mode as well. Microchip (on cc) could know more about this likelihood.

If you are using ARM, device tree is the way to go. In systems like
this, you know exactly which PCIe bus the lan743x will be hanging
off. So you can add a DT node for it. It is not done very often, but
look at arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi. That board has an
intel i210 on its PCIe bus, and we need a phandle for it. But you can
add any properties you want. For what you are doing, you should be
looking at:

Documentation/devicetree/bindings/net/ethernet-controller.yaml:

phy-mode and fixed-link.

	  Andrew
