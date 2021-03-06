Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7AB32FB30
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 15:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhCFOcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 09:32:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230455AbhCFOc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 09:32:28 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lIXyh-009X3e-0t; Sat, 06 Mar 2021 15:32:23 +0100
Date:   Sat, 6 Mar 2021 15:32:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: Query on new ethtool RSS hashing options
Message-ID: <YEOSd09MDm6G2S3/@lunn.ch>
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
 <20210305150702.1c652fe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YELKIZzkU9LxpEE9@lunn.ch>
 <CA+sq2CfAsyFHEj=w3=ewTKk-qbF60FcCQNtk9e7_1wxf=tB7QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2CfAsyFHEj=w3=ewTKk-qbF60FcCQNtk9e7_1wxf=tB7QA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 06:04:14PM +0530, Sunil Kovvuri wrote:
> On Sat, Mar 6, 2021 at 5:47 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Fri, Mar 05, 2021 at 03:07:02PM -0800, Jakub Kicinski wrote:
> > > On Fri, 5 Mar 2021 16:15:51 +0530 Sunil Kovvuri wrote:
> > > > Hi,
> > > >
> > > > We have a requirement where in we want RSS hashing to be done on packet fields
> > > > which are not currently supported by the ethtool.
> > > >
> > > > Current options:
> > > > ehtool -n <dev> rx-flow-hash
> > > > tcp4|udp4|ah4|esp4|sctp4|tcp6|udp6|ah6|esp6|sctp6 m|v|t|s|d|f|n|r
> > > >
> > > > Specifically our requirement is to calculate hash with DSA tag (which
> > > > is inserted by switch) plus the TCP/UDP 4-tuple as input.
> > >
> > > Can you share the format of the DSA tag? Is there a driver for it
> > > upstream? Do we need to represent it in union ethtool_flow_union?
> >
> > Sorry, i missed the original question, there was no hint in the
> > subject line that DSA was involved.
> >
> > Why do you want to include DSA tag in the hash? What normally happens
> > with DSA tag drivers is we detect the frame has been received from a
> > switch, and modify where the core flow dissect code looks in the frame
> > to skip over the DSA header and parse the IP header etc as normal.
> 
> I understand your point.
> The requirement to add DSA tag into RSS hashing is coming from one of
> our customer.

So what is the customer requirement? Why does the customer want to do
this? Please explain the real use case.

> > Take a look at net/core/flow_dissect.c:__skb_flow_dissect()
> >
> > This fits with the core ideas of the network stack and offloads. Hide
> > the fact an offload is being used, it should just look like a normal
> > interface.
> >
> >         Andrew
> 
> Yes, the pkt will look like a normal packet itself.
> In our case HW strips the DSA tag from the packet and forwards it to a VF.

So this flow hash will be used only inside the hardware? There is no
software equivalent of it? But the DSA header represents the ingress
port. So why cannot you identify the traffic based on netdev? Isn't
the -n dev equivalent to the DSA header?

    Andrew
