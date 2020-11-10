Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55462AE3D9
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732235AbgKJXF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:05:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47212 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732175AbgKJXF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:05:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcchZ-006Mgq-6a; Wed, 11 Nov 2020 00:05:25 +0100
Date:   Wed, 11 Nov 2020 00:05:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] enetc: Workaround for MDIO register access issue
Message-ID: <20201110230525.GO1456319@lunn.ch>
References: <20201110154304.30871-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110154304.30871-1-claudiu.manoil@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 05:43:04PM +0200, Claudiu Manoil wrote:
> From: Alex Marginean <alexandru.marginean@nxp.com>
> 
> Due to a hardware issue, an access to MDIO registers
> that is concurrent with other ENETC register accesses
> may lead to the MDIO access being dropped or corrupted.
> The workaround introduces locking for all register accesses
> to the ENETC register space.  To reduce performance impact,
> a readers-writers locking scheme has been implemented.
> The writer in this case is the MDIO access code (irrelevant
> whether that MDIO access is a register read or write), and
> the reader is any access code to non-MDIO ENETC registers.
> Also, the datapath functions acquire the read lock fewer times
> and use _hot accessors.  All the rest of the code uses the _wa
> accessors which lock every register access.

Hi Claudiu

The code you are adding makes no comment about the odd using of
read/writer locks. This is going to confused people.

Please could you add helpers, probably as inline functions in a
header, which take/release the read_lock and the write_lock, which
don't use the name read_ or write_. Maybe something like
enetc_lock_mdio()/enetc_unlock_mdio(), enetc_lock_reg(),
enetc_unlock_reg(). Put comments by the helpers explaining what is
going on. That should help avoid future confusion and questions.

Thanks
	Andrew
