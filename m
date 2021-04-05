Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EFC354574
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbhDEQnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:43:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34414 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233727AbhDEQnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 12:43:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTSJR-00Ex9M-EP; Mon, 05 Apr 2021 18:42:53 +0200
Date:   Mon, 5 Apr 2021 18:42:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Julian Labus <julian@freifunk-rtk.de>
Cc:     netdev@vger.kernel.org, mschiffer@universe-factory.net
Subject: Re: stmmac: zero udp checksum
Message-ID: <YGs+DeFzhVh7UlEh@lunn.ch>
References: <cfc1ede9-4a1c-1a62-bdeb-d1e54c27f2e7@freifunk-rtk.de>
 <YGsQQUHPpuEGIRoh@lunn.ch>
 <98fcc1a7-8ce2-ac15-92a1-8c53b0e12658@freifunk-rtk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98fcc1a7-8ce2-ac15-92a1-8c53b0e12658@freifunk-rtk.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But was is still a bit strange to me is that it seems like the stmmac driver
> behaves different than other ethernet drivers which do not drop UDP packets
> with zero checksums when rx checksumming is enabled.

To answer that, you need somebody with more knowledge of the stmmac
hardware. It is actually quite hard to do. It means you need to parse
more of the frame to determine if the frame contains a VXLAN
encapsulated frame. Probably the stmmac cannot do that. It sees the
checksum is wrong and drops the packet.

Have you looked at where it actually drops the packet?
Is it one of

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/stmicro/stmmac/norm_desc.c#L95

or

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/stmicro/stmmac/enh_desc.c#L87

It could be, you need to see if the checksum has fail, then check if
the checksum is actually zero, and then go deeper into the frame and
check if it is a vxlan frame. It could be the linux software checksum
code knows about this vxlan exception, so you can just run that before
deciding to drop the frame.

	Andrew
