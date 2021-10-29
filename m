Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA3943FD9F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhJ2N5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231548AbhJ2N5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 09:57:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1FB16108F;
        Fri, 29 Oct 2021 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635515665;
        bh=qlcPpg2MIOEebv+ihjRrlmheaAPPkfcf8eJStaF1g+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cPw7cUyxcZkThUiqKVMPRRfPaK5rFRZq+DcY2dkxHWs5W7dJqukwb1mQ427a8WQ30
         JaVCTxIAskDTzQD1G0Y4qoB4ZsXQ8tCvj0dd9wkaueCkT5vITNx7qgExV6eTczDrDt
         CULbPN9VnW7qTRyPvN53T32tMrueAGmY/T+4zr9JaKr1YgSqr8jhaqy7zp/8l2QhNT
         0s4gJCWM9O8wX0EW/ZtZuiQq0J0QPJSXklksagL2KoH+iHFqKeA/72Y8rjAYSlAjpK
         eByGTIuoVFwLAlO1d7p76OxPR+o6Zx8wHhoSHTi60ieUzAU5gjWXw3H8NZsapui2UG
         D2AJJARPhtggA==
Date:   Fri, 29 Oct 2021 06:54:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 net-next 07/10] net: dsa: microchip: add support for
 ethtool port counters
Message-ID: <20211029065423.493801d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211029052256.144739-8-prasanna.vengateshan@microchip.com>
References: <20211029052256.144739-1-prasanna.vengateshan@microchip.com>
        <20211029052256.144739-8-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Oct 2021 10:52:53 +0530 Prasanna Vengateshan wrote:
> Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
> along with relevant lan937x hooks for KSZ common layer and added
> support for get_strings()
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

>  static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
>  				       u8 state)
>  {
> @@ -426,6 +441,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
>  	.phy_read = lan937x_phy_read16,
>  	.phy_write = lan937x_phy_write16,
>  	.port_enable = ksz_enable_port,
> +	.get_strings = lan937x_get_strings,
> +	.get_ethtool_stats = ksz_get_ethtool_stats,
> +	.get_sset_count = ksz_sset_count,
>  	.port_bridge_join = ksz_port_bridge_join,
>  	.port_bridge_leave = ksz_port_bridge_leave,
>  	.port_stp_state_set = lan937x_port_stp_state_set,

Recent commit 487d3855b641 ("net: dsa: allow reporting of standard
ethtool stats for slave devices") plumbed thru all the standard stats ops.
You must report standard stats (get_eth_*_stats and get_stats64) before
implementing get_ethtool_stats.
