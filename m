Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4992D8A3F
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 23:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408044AbgLLWHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 17:07:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLLWHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 17:07:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1koD2H-00BgI9-Cx; Sat, 12 Dec 2020 23:06:41 +0100
Date:   Sat, 12 Dec 2020 23:06:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next] net: dsa: reference count the host mdb
 addresses
Message-ID: <20201212220641.GA2781095@lunn.ch>
References: <20201212203901.351331-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212203901.351331-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* Complication created by the fact that addition has two phases, but
> +	 * deletion only has one phase, and we need reference counting.
> +	 * The strategy is to do the memory allocation in the prepare phase,
> +	 * but initialize the refcount in the commit phase.
> +	 *
> +	 * Have mdb	| mdb has refcount > 0	| Commit phase	| Resolution
> +	 * -------------+-----------------------+---------------+---------------
> +	 * no		| -			| no		| Alloc & proceed

This does not look right.

The point of the prepare phase is to allow all the different layers
involved to allocate whatever they need and to validate they can do
the requested action. Any layer can say, No, stop, i cannot do
this. The commit phase will then not happen. But that also means the
prepare phase should not do any state changes. So you should not be
proceeding here, just allocating.

And you need some way to cleanup the allocated memory when the commit
never happens because some other layer has said No!

     Andrew
