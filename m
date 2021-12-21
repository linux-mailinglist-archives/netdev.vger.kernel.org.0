Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E4947C8D7
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 22:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhLUVj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 16:39:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37786 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236211AbhLUVj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 16:39:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=J90jJ/PQZ7rP+AOxEosRKXwCqR49g27LiWjTYNDJYE0=; b=XzIyTK6LP7sUQsFbT5zlVref/M
        dklj8T4mhn6rAwUQVaywZI60QK8wN5LcDdmZ3W6xWxWIeaIi5QOYZUGN5k+P7dyzhUOglzguPV0Cw
        EAm1ydKf7ngyIjxIuoz+7glC8teF4qaA3ig229RSFSjYf315cj584IT3LcbXwkFN8TV8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzmqt-00HAdP-IW; Tue, 21 Dec 2021 22:39:19 +0100
Date:   Tue, 21 Dec 2021 22:39:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Message-ID: <YcJJh9e2QCJOoEB/@lunn.ch>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcGkILZxGLEUVVgU@lunn.ch>
 <CO1PR11MB51705AE8B072576F31FEC18CD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB51705AE8B072576F31FEC18CD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 08:56:42PM +0000, Chen, Mike Ximing wrote:
> 
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Tuesday, December 21, 2021 4:54 AM
> > To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> > Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; gregkh@linuxfoundation.org; Williams, Dan J
> > <dan.j.williams@intel.com>; pierre-louis.bossart@linux.intel.com; netdev@vger.kernel.org;
> > davem@davemloft.net; kuba@kernel.org
> > Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
> > 
> > > +The following diagram shows a typical packet processing pipeline with the Intel DLB.
> > > +
> > > +                              WC1              WC4
> > > + +-----+   +----+   +---+  /      \  +---+  /      \  +---+   +----+   +-----+
> > > + |NIC  |   |Rx  |   |DLB| /        \ |DLB| /        \ |DLB|   |Tx  |   |NIC  |
> > > + |Ports|---|Core|---|   |-----WC2----|   |-----WC5----|   |---|Core|---|Ports|
> > > + +-----+   -----+   +---+ \        / +---+ \        / +---+   +----+   ------+
> > > +                           \      /         \      /
> > > +                              WC3              WC6
> > 
> > This is the only mention of NIC here. Does the application interface to the network stack in the usual way
> > to receive packets from the TCP/IP stack up into user space and then copy it back down into the MMIO
> > block for it to enter the DLB for the first time? And at the end of the path, does the application copy it
> > from the MMIO into a standard socket for TCP/IP processing to be send out the NIC?
> > 
> For load balancing and distribution purposes, we do not handle packets directly in DLB. Instead, we only
> send QEs (queue events) to MMIO for DLB to process. In an network application, QEs (64 bytes each) can
> contain pointers to the actual packets. The worker cores can use these pointers to process packets and
> forward them to the next stage. At the end of the path, the last work core can send the packets out to NIC.

Sorry for asking so many questions, but i'm trying to understand the
architecture. As a network maintainer, and somebody who reviews
network drivers, i was trying to be sure there is not an actual
network MAC and PHY driver hiding in this code.

So you talk about packets. Do you actually mean frames? As in Ethernet
frames? TCP/IP processing has not occurred? Or does this plug into the
network stack at some level? After TCP reassembly has occurred? Are
these pointers to skbufs?

> > Do you even needs NICs here? Could the data be coming of a video camera and you are distributing image
> > processing over a number of cores?
> No, the diagram is just an example for packet processing applications. The data can come from other sources
> such video cameras. The DLB can schedule up to 100 million packets/events per seconds. The frame rate from
> a single camera is normally much, much lower than that.

So i'm trying to understand the scope of this accelerator. Is it just
a network accelerator? If so, are you pointing to skbufs? How are the
lifetimes of skbufs managed? How do you get skbufs out of the NIC? Are
you using XDP?

    Andrew
