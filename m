Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3599C2CF76D
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 00:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgLDXZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 18:25:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLDXZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 18:25:38 -0500
Date:   Fri, 4 Dec 2020 15:24:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607124297;
        bh=W4DgIKA8fUXuOQ3qFucixeZIaJgsASGHjFYuF59z0f0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gj3xCSqe7FEkfA6gw+ltNvvw3vhaGTYDOj2WF4LHgwVxdUlFnJJoZPZo/YWwFcS3s
         AfV8Ckd5okxcHymBg6TnHbsIS01HAs75SiHa0psxnrFWxtPxJrt5nMs4C8DAau4qCX
         TzBrYiZndwoqmV9s0OnTGUa4QaM1WMqTSKsd3okZpRiCJeCb50DLOtSH595BOhBG1u
         hrUk+jKiOKQWJHYhMyTpJP3RObiQQc7sF/ILLtVcGVqd6E4C+RnUKUIWu50GFGsDBy
         hyzt2yOpDzKCs/3MX8d1AjBCln+R65hab8LYKfujcSRc9IE5FnhZSxztUIx9CPcmpR
         d1G+M4+1uDIug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1] net: dsa: ksz8795: use correct number of
 physical ports
Message-ID: <20201204152456.247769b1@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203214645.31217-1-TheSven73@gmail.com>
References: <20201203214645.31217-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Dec 2020 16:46:45 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> The ksz8795 has five physical ports, but the driver assumes
> it has only four. This prevents the driver from working correctly.
> 
> Fix by indicating the correct number of physical ports.
> 
> Fixes: e66f840c08a23 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # ksz8795
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

All the port counts here are -1 compared to datasheets, so I'm assuming
the are not supposed to include the host facing port or something?

Can you describe the exact problem you're trying to solve?

DSA devices are not supposed to have a netdev for the host facing port
on the switch (sorry for stating the obvious).

> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 1e101ab56cea..367cebe37ae6 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1194,7 +1194,7 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
>  		.num_alus = 0,
>  		.num_statics = 8,
>  		.cpu_ports = 0x10,	/* can be configured as cpu port */
> -		.port_cnt = 4,		/* total physical port count */
> +		.port_cnt = 5,		/* total physical port count */
>  	},
>  	{
>  		.chip_id = 0x8794,

