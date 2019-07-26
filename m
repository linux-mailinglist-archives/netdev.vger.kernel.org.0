Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1A3768B5
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387970AbfGZNqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:46:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40104 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388682AbfGZNqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:46:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qXlWq4lfRlho7WgoojQ+jlmY1k/y7Ct3O9ELJ9wa0Rw=; b=YrMbPdJTxCrdGj+GMfhs0RQYse
        1rC4KUuact5ZKSb+Csrt9Ldj2rve/oetkxTMV30uns4YoWOBA/dkN7fciQPn+oG3bCiOtC7d/vt5T
        lf5XilRDi9l4/5QVS7uNMsy6P8ebBvE4o3jmrLAxUpK4XsajdzCjYectbkn12eb2RYBE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hr0Y1-0005Lz-3x; Fri, 26 Jul 2019 15:46:13 +0200
Date:   Fri, 26 Jul 2019 15:46:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan.nielsen@microchip.com
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190726134613.GD18223@lunn.ch>
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
 <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
 <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
 <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 02:02:15PM +0200, Horatiu Vultur wrote:
> Hi Nikolay,
> 
> The 07/26/2019 12:26, Nikolay Aleksandrov wrote:
> > External E-Mail
> > 
> > 
> > On 26/07/2019 11:41, Nikolay Aleksandrov wrote:
> > > On 25/07/2019 17:21, Horatiu Vultur wrote:
> > >> Hi Nikolay,
> > >>
> > >> The 07/25/2019 16:21, Nikolay Aleksandrov wrote:
> > >>> External E-Mail
> > >>>
> > >>>
> > >>> On 25/07/2019 16:06, Nikolay Aleksandrov wrote:
> > >>>> On 25/07/2019 14:44, Horatiu Vultur wrote:
> > >>>>> There is no way to configure the bridge, to receive only specific link
> > >>>>> layer multicast addresses. From the description of the command 'bridge
> > >>>>> fdb append' is supposed to do that, but there was no way to notify the
> > >>>>> network driver that the bridge joined a group, because LLADDR was added
> > >>>>> to the unicast netdev_hw_addr_list.
> > >>>>>
> > >>>>> Therefore update fdb_add_entry to check if the NLM_F_APPEND flag is set
> > >>>>> and if the source is NULL, which represent the bridge itself. Then add
> > >>>>> address to multicast netdev_hw_addr_list for each bridge interfaces.
> > >>>>> And then the .ndo_set_rx_mode function on the driver is called. To notify
> > >>>>> the driver that the list of multicast mac addresses changed.
> > >>>>>
> > >>>>> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > >>>>> ---
> > >>>>>  net/bridge/br_fdb.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
> > >>>>>  1 file changed, 46 insertions(+), 3 deletions(-)
> > >>>>>
> > >>>>
> > >>>> Hi,
> > >>>> I'm sorry but this patch is wrong on many levels, some notes below. In general
> > >>>> NLM_F_APPEND is only used in vxlan, the bridge does not handle that flag at all.
> > >>>> FDB is only for *unicast*, nothing is joined and no multicast should be used with fdbs.
> > >>>> MDB is used for multicast handling, but both of these are used for forwarding.
> > >>>> The reason the static fdbs are added to the filter is for non-promisc ports, so they can
> > >>>> receive traffic destined for these FDBs for forwarding.
> > >>>> If you'd like to join any multicast group please use the standard way, if you'd like to join
> > >>>> it only on a specific port - join it only on that port (or ports) and the bridge and you'll
> > >>>
> > >>> And obviously this is for the case where you're not enabling port promisc mode (non-default).
> > >>> In general you'll only need to join the group on the bridge to receive traffic for it
> > >>> or add it as an mdb entry to forward it.
> > >>>
> > >>>> have the effect that you're describing. What do you mean there's no way ?
> > >>
> > >> Thanks for the explanation.
> > >> There are few things that are not 100% clear to me and maybe you can
> > >> explain them, not to go totally in the wrong direction. Currently I am
> > >> writing a network driver on which I added switchdev support. Then I was
> > >> looking for a way to configure the network driver to copy link layer
> > >> multicast address to the CPU port.
> > >>
> > >> If I am using bridge mdb I can do it only for IP multicast addreses,
> > >> but how should I do it if I want non IP frames with link layer multicast
> > >> address to be copy to CPU? For example: all frames with multicast
> > >> address '01-21-6C-00-00-01' to be copy to CPU. What is the user space
> > >> command for that?
> > >>
> > > 
> > > Check SIOCADDMULTI (ip maddr from iproute2), f.e. add that mac to the port
> > > which needs to receive it and the bridge will send it up automatically since
> > > it's unknown mcast (note that if there's a querier, you'll have to make the
> > > bridge mcast router if it is not the querier itself). It would also flood it to all
> > 
> > Actually you mentioned non-IP traffic, so the querier stuff is not a problem. This
> > traffic will always be flooded by the bridge (and also a copy will be locally sent up).
> > Thus only the flooding may need to be controlled.
> 
> OK, I see, but the part which is not clear to me is, which bridge
> command(from iproute2) to use so the bridge would notify the network
> driver(using swichdev or not) to configure the HW to copy all the frames
> with dmac '01-21-6C-00-00-01' to CPU? So that the bridge can receive
> those frames and then just to pass them up.

Hi Horatiu

Something to keep in mind.

My default, multicast should be flooded, and that includes the CPU
port for a DSA driver. Adding an MDB entry allows for optimisations,
limiting which ports a multicast frame goes out of. But it is just an
optimisation.

	Andrew
