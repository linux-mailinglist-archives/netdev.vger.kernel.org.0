Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BAF3469CC
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 21:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhCWU0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 16:26:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhCWU00 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 16:26:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOnba-00CeYx-RS; Tue, 23 Mar 2021 21:26:22 +0100
Date:   Tue, 23 Mar 2021 21:26:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 0/8] configuration support for switch headers &
 phy
Message-ID: <YFpO7n9uDt167ANk@lunn.ch>
References: <MWHPR18MB14217B983EFC521DAA2EEAD2DE649@MWHPR18MB1421.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR18MB14217B983EFC521DAA2EEAD2DE649@MWHPR18MB1421.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 06:13:28PM +0000, Hariprasad Kelam wrote:
> 
> Hi Andrew ,
> 
> Please see inline,

No need to say that. That is the correct way to right emails.

> > Hi Hariprasad
> > 
> > Private flags sound very wrong here. I would expect to see some integration
> > between the switchdev/DSA driver and the MAC driver.
> > Please show how this works in combination with drivers/net/dsa/mv88e6xxx
> > or drivers/net/ethernet/marvell/prestera.
> > 
> 	Octeontx2 silicon supports NPC (network parser and cam) unit , through which packet parsing and packet classification is achieved.
>               Packet parsing extracting different fields from each layer.
> 				  DMAC + SMAC  --> LA
> 		                               VLAN ID --> LB
> 		                               SIP + DIP --> LC
>                                                             TCP SPORT + DPORT --> LD
>     And packet classification is achieved through  flow identification in key extraction and mcam search key . User can install mcam rules
>     With action as  
> 		forward packet to PF and to receive  queue 0
> 		forward packet to VF and  with as RSS ( Receive side scaling)
> 		drop the packet 
> 		etc..
> 
>    Now with switch header ( EDSA /FDSA) and HIGIG2 appended to regular packet , NPC can not parse these
>    Ingress packets as these headers does not have fixed headers. To achieve this Special PKIND( port kind) is allocated in hardware
>    which will help NPC to parse the packets.
> 
>  For example incase of EDSA 8 byte header which is placed right after SMAC , special PKIND reserved for EDSA helps NPC to 
>  Identify the  input packet is EDSA . Such that NPC can extract fields in this header and forward to 
>  Parse rest of the headers.
> 
>  Same is the case with higig2 header where 16 bytes header is placed at start of the packet.
> 
> In this case private flags helps user to configure interface in EDSA/FDSA or HIGIG2. Such that special
> PKIND reserved for that header are assigned to the interface.  The scope of the patch series is how
> User can configure interface mode as switch header(HIGIG2/EDSA etc) .In our case no DSA logical
> Ports are created as these headers can be stripped by NPC.

So you completely skipped how this works with mv88e6xxx or
prestera. If you need this private flag for some out of mainline
Marvell SDK, it is very unlikely to be accepted.

	Andrew
