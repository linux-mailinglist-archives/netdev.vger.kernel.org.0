Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4D4337F1A
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhCKUd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:33:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhCKUdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:33:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64E7964ECD;
        Thu, 11 Mar 2021 20:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615494795;
        bh=e6yQMlzLM3Zx5M9FQ/wZu/xICC5IVVwqDRVUpsW4INM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XIMmDpPUo/l975V5mNFU2c0yBmIPMviPeWlWV3ckho83Qbhqxllq1gItIkinp5TYQ
         WqOmxLfuJcRf8Y/RccZcMTaYmbNXJ4ov4z5BbU5kaNhKU5bDmg+MbZFJ9lQb8EoC9E
         a5x7gVADojbEuin43UyPJAp28611gwtgt3XbDkU2eknohFUIOTxYcfSaLTz2clPQHn
         k/HF2VtGIyqgVsoAbqY/TCCZ7QGOHUzKkjsBRyT3juyyyYg1kQYOyrLLzMM+Os18eS
         4doDUo/nJsQmvKGYBdrnmEdRFXWi085LTk9n5LOSk6leTZ0oI5vTUfJbZP02C11Pbm
         4AvPVDOERzMag==
Date:   Thu, 11 Mar 2021 12:33:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>, <andrew@lunn.ch>,
        <rmk+kernel@armlinux.org.uk>, <atenart@kernel.org>,
        <rabeeh@solid-run.com>
Subject: Re: [V2 net-next] net: mvpp2: Add reserved port private flag
 configuration
Message-ID: <20210311123313.0f5e7f80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
References: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 18:43:27 +0200 stefanc@marvell.com wrote:
> According to Armada SoC architecture and design, all the PPv2 ports
> which are populated on the same communication processor silicon die
> (CP11x) share the same Classifier and Parser engines.
> 
> Armada is an embedded platform and therefore there is a need to reserve
> some of the PPv2 ports for different use cases.
> 
> For example, a port can be reserved for a CM3 CPU running FreeRTOS for
> management purposes or by user-space data plane application.
> 
> During port reservation all common configurations are preserved and
> only RXQ, TXQ, and interrupt vectors are disabled.
> Since TXQ's are disabled, the Kernel won't transmit any packet
> from this port, and to due the closed RXQ interrupts, the Kernel won't
> receive any packet.
> The port MAC address and administrative UP/DOWN state can still
> be changed.
> The only permitted configuration in this mode is MTU change.
> The driver's .ndo_change_mtu callback has logic that switches between
> percpu_pools and shared pools buffer mode, since the buffer management
> not done by Kernel this should be permitted.

Andrew asks good questions. This looks like a strange construct.

IMO Linux should either not see the port (like it doesn't see NC-SI),
or we need representors for physical and logical ports and explicit
forwarding rules.
