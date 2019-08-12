Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B605F8A03D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfHLN5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:57:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfHLN5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 09:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d+WbDGHWK1bv6un2kiH7eS6pfMuc4M5sJiRdTV3G+xM=; b=VAEQ/fXYa8Hcpl+nn8HZZH8Byp
        h+HkfITIfaeJ8nGM+q8WYDnRuJmTyaE6c5j8G56KYgIbs3cFAy0vxfH9uGOS16hBDT57fHI1bPcm+
        SrCavP4EVRjNi/EFSUgwfPWaBKLSlDSftJGvAQ/F/0ejnGxb+n6wqcjS2ky4g9wqA7oY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxApW-0000YC-2r; Mon, 12 Aug 2019 15:57:46 +0200
Date:   Mon, 12 Aug 2019 15:57:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out
 of staging
Message-ID: <20190812135746.GL14290@lunn.ch>
References: <1565366213-20063-1-git-send-email-ioana.ciornei@nxp.com>
 <20190809190459.GW27917@lunn.ch>
 <VI1PR0402MB2800FF2E5C4DE24B25E7D843E0D10@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB2800FF2E5C4DE24B25E7D843E0D10@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In the DPAA2 architecture MACs are not the only entities that can be 
> connected to a switch port.
> Below is an exemple of a 4 port DPAA2 switch which is configured to 
> interconnect 2 DPNIs (network interfaces) and 2 DPMACs.
> 
> 
>   [ethA]     [ethB]     [ethC]     [ethD]     [ethE]     [ethF]
>      :          :          :          :          :          :
>      :          :          :          :          :          :
> [eth drv]  [eth drv]  [                ethsw drv              ]
>      :          :          :          :          :          :        kernel
> ========================================================================
>      :          :          :          :          :          : 
> hardware
>   [DPNI]      [DPNI]     [============= DPSW =================]
>      |          |          |          |          |          |
>      |           ----------           |       [DPMAC]    [DPMAC]
>       -------------------------------            |          |
>                                                  |          |
>                                                [PHY]      [PHY]
> 
> You can see it as a hardware-accelerated software bridge where
> forwarding rules are managed from the host software partition.

Hi Ioana

What are the use cases for this?

Configuration is rather unintuitive. To bridge etha and ethb you need
to

ip link add name br0 type bridge
ip link set ethc master br0
ip link set ethd master br0

And once you make ethc and ethd actually send/receive frames, etha and
ethc become equivalent.

If this was a PCI device, i could imagine passing etha into a VM as a
PCI VF. But i don't think it is PCI?

I'm not sure moving etha into a different name space makes much sense
either. My guess would be, a veth pair with one end connected to the
software bridge would be more efficient than DMAing the packet out and
then back in again.

     Thanks
	Andrew
