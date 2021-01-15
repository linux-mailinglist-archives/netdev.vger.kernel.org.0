Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1F42F7E66
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbhAOOj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:39:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42820 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbhAOOj4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 09:39:56 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0QFr-000lIY-0u; Fri, 15 Jan 2021 15:39:11 +0100
Date:   Fri, 15 Jan 2021 15:39:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Only allow LAG offload
 on supported hardware
Message-ID: <YAGpD33Gy9R/wheo@lunn.ch>
References: <20210115105834.559-1-tobias@waldekranz.com>
 <20210115105834.559-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115105834.559-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline bool mv88e6xxx_has_lag(struct mv88e6xxx_chip *chip)
> +{
> +#if (defined(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2))
> +	return chip->info->global2_addr != 0;
> +#else
> +	return false;
> +#endif

Given Vladimirs comments, this is just FYI:

You should not use #if like this. Use

	if (IS_ENABLED(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2))
		return chip->info->global2_addr != 0;
	return false;

The advantage of this is it all gets compiled, so syntax errors in the
mostly unused leg get found quickly. The generated code should still
be optimal, since at build time it can evaluate the if and completely
remove it.

       Andrew
