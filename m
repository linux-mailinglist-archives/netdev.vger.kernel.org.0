Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA68435425B
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 15:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhDEN1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 09:27:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33956 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhDEN1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 09:27:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTPGL-00EviA-AK; Mon, 05 Apr 2021 15:27:29 +0200
Date:   Mon, 5 Apr 2021 15:27:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Julian Labus <julian@freifunk-rtk.de>
Cc:     netdev@vger.kernel.org, mschiffer@universe-factory.net
Subject: Re: stmmac: zero udp checksum
Message-ID: <YGsQQUHPpuEGIRoh@lunn.ch>
References: <cfc1ede9-4a1c-1a62-bdeb-d1e54c27f2e7@freifunk-rtk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfc1ede9-4a1c-1a62-bdeb-d1e54c27f2e7@freifunk-rtk.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 02:53:15PM +0200, Julian Labus wrote:
> Hi all,
> 
> in our community mesh network we recently discovered that a TP-Link Archer
> C2600 device is unable to receive IPv6 UDP packets with a zero checksum when
> RX checksum offloading is enabled. The device uses ipq806x-gmac-dwmac for
> its ethernet ports.
> 
> According to https://tools.ietf.org/html/rfc2460#section-8.1 this sounds
> like correct behavior as it says a UDP checksum must not be zero for IPv6
> packets. But this definition was relaxed in
> https://tools.ietf.org/html/rfc6935#section-5 to allow zero checksums in
> tunneling protocols like VXLAN where we discovered the problem.
> 
> Can the behavior of the stmmac driver be changed to meet RFC6935 or would it
> be possible to make the (RX) Checksum Offloading Engine configurable via a
> device tree property to disable it in environments were it causes problems?

Hi Julian

I don't know the stmmac driver at all...

Have you played around with ethtool -k/-K? Can use this to turn off
hardware checksums?

I doubt a DT property would be accepted. What you probably want to do
is react on the NETDEV notifiers for when an upper interface is
changed. If a VXLAN interface is added, turn off hardware checksums.

	 Andrew
