Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264EF24F03D
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 00:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHWW0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 18:26:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40886 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgHWW0t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 18:26:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9yRn-00BSfu-Td; Mon, 24 Aug 2020 00:26:43 +0200
Date:   Mon, 24 Aug 2020 00:26:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: dsa: change PHY error message again
Message-ID: <20200823222643.GL2588906@lunn.ch>
References: <20200823213520.2445615-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823213520.2445615-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 12:35:20AM +0300, Vladimir Oltean wrote:
> slave_dev->name is only populated at this stage if it was specified
> through a label in the device tree. However that is not mandatory.

Hi Vladimir

It is not mandatory, but it is normal.

> When it isn't, the error message looks like this:
> 
> [    5.037057] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.044672] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.052275] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.059877] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> 
> which is especially confusing since the error gets printed on behalf of
> the DSA master (fsl_enetc in this case).
> 
> Printing an error message that contains a valid reference to the DSA
> port's name is difficult at this point in the initialization stage, so
> at least we should print some info that is more reliable, even if less
> user-friendly. That may be the driver name and the hardware port index.
> 
> After this change, the error is printed as:
> 
> [    4.957403] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 0
> [    4.964231] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 1
> [    4.971055] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 2
> [    4.977871] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 3

I would prefer both the port number and the interface name. With
setups using D in DSA, there are examples where port 1 on the first
switch is lan1, and port 1 of the second switch is lan5. Having both
avoids some confusion.

Another option would be to call dev_alloc_name() after
alloc_netdev_mqs() if there is no label. The eth%d will then get
replaced with a unique name.

> Fixes: 65951a9eb65e ("net: dsa: Improve subordinate PHY error message")

I'm not sure this actually meets the stable criteria.

       Andrew
