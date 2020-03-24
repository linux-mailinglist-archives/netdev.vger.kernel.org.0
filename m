Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B64D4190625
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 08:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgCXHRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 03:17:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:48632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgCXHRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 03:17:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 58C58AD77;
        Tue, 24 Mar 2020 07:17:07 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 12D3DE0FD3; Tue, 24 Mar 2020 08:17:06 +0100 (CET)
Date:   Tue, 24 Mar 2020 08:17:06 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 07/14] net: ks8851: Use 16-bit writes to program MAC
 address
Message-ID: <20200324071706.GI31519@unicorn.suse.cz>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-8-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-8-marex@denx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:56AM +0100, Marek Vasut wrote:
> On the SPI variant of KS8851, the MAC address can be programmed with
> either 8/16/32-bit writes. To make it easier to support the 16-bit
> parallel option of KS8851 too, switch both the MAC address programming
> and readout to 16-bit operations.
> 
> Remove ks8851_wrreg8() as it is not used anywhere anymore.
> 
> There should be no functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>
> ---
[...]
> +
> +	for (i = 0; i < ETH_ALEN; i += 2) {
> +		val = (dev->dev_addr[i] << 8) | dev->dev_addr[i + 1];
> +		ks8851_wrreg16(ks, KS_MAR(i + 1), val);
> +	}
[...]
> +	for (i = 0; i < ETH_ALEN; i += 2) {
> +		reg = ks8851_rdreg16(ks, KS_MAR(i + 1));
> +		dev->dev_addr[i] = reg & 0xff;
> +		dev->dev_addr[i + 1] = reg >> 8;
> +	}

I know nothing about the hardware but this seems inconsistent: while
writing, you put addr[i] into upper part of the 16-bit value and
addr[i+1] into lower but for read you do the opposite. Is it correct?

Michal Kubecek
