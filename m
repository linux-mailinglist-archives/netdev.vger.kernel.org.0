Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA162314142
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbhBHVG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235208AbhBHVGj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 16:06:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF1164E8C;
        Mon,  8 Feb 2021 21:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612818358;
        bh=FK1I/k8wX1BxFESt2f7/PabmUo1u8EhCiol1GuP7Enw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=chwcVp/RravmxujX3V/5ZSkSMQp/n79yAFzPDtuNg5I39lKIW8NNrJPnj0Vqwb+M1
         +Ba/uWsMhkWs1dnN/84I6OK//0U0lpeSmyalZuTNKM+2n8HeItA++9eFfhCVwn5oAE
         trBtEpiZRFPqvxXEKXs9t4kdygg9I8f6VkQg7ecAUgMll4R4PsDdkpDwc9eP6QxLjt
         mWOYl2v1MHePRQCW2nMjgr/BhrtEw/+FfKHNqkCxugDUFZH1jTOm2CyIhyMuUZkAY2
         xzayHH1wdsAbT6bDpYSXwaoBzeEccHv7LE9OiW7ET1qObc7Mb/FIM70VoU2zE3NvyN
         h3vHwW22VINqQ==
Date:   Mon, 8 Feb 2021 13:05:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
Message-ID: <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87v9b249oq.fsf@waldekranz.com>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
        <20210203165458.28717-6-vadym.kochan@plvision.eu>
        <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87v9b249oq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 08 Feb 2021 20:54:29 +0100 Tobias Waldekranz wrote:
> On Thu, Feb 04, 2021 at 21:16, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed,  3 Feb 2021 18:54:56 +0200 Vadym Kochan wrote:  
> >> From: Serhiy Boiko <serhiy.boiko@plvision.eu>
> >> 
> >> The following features are supported:
> >> 
> >>     - LAG basic operations
> >>         - create/delete LAG
> >>         - add/remove a member to LAG
> >>         - enable/disable member in LAG
> >>     - LAG Bridge support
> >>     - LAG VLAN support
> >>     - LAG FDB support
> >> 
> >> Limitations:
> >> 
> >>     - Only HASH lag tx type is supported
> >>     - The Hash parameters are not configurable. They are applied
> >>       during the LAG creation stage.
> >>     - Enslaving a port to the LAG device that already has an
> >>       upper device is not supported.  
> >
> > Tobias, Vladimir, you worked on LAG support recently, would you mind
> > taking a look at this one?  
> 
> I took a quick look at it, and what I found left me very puzzled. I hope
> you do not mind me asking a generic question about the policy around
> switchdev drivers. If someone published a driver using something similar
> to the following configuration flow:
> 
> iproute2  daemon(SDK)
>    |        ^    |
>    :        :    : user/kernel boundary
>    v        |    |
> netlink     |    |
>    |        |    |
>    v        |    |
>  driver     |    |
>    |        |    |
>    '--------'    |
>                  : kernel/hardware boundary
>                  v
>                 ASIC
> 
> My guess is that they would be (rightly IMO) told something along the
> lines of "we do not accept drivers that are just shims for proprietary
> SDKs".
> 
> But it seems like if that same someone has enough area to spare in their
> ASIC to embed a CPU, it is perfectly fine to run that same SDK on it,
> call it "firmware", and then push a shim driver into the kernel tree.
> 
> iproute2
>    |
>    :               user/kernel boundary
>    v
> netlink
>    |
>    v
>  driver
>    |
>    |
>    :               kernel/hardware boundary
>    '-------------.
>                  v
>              daemon(SDK)
>                  |
>                  v
>                 ASIC
> 
> What have we, the community, gained by this? In the old world, the
> vendor usually at least had to ship me the SDK in source form. Having
> seen the inside of some of those sausage factories, they are not the
> kinds of code bases that I want at the bottom of my stack; even less so
> in binary form where I am entirely at the vendor's mercy for bugfixes.
> 
> We are talking about a pure Ethernet fabric here, so there is no fig
> leaf of "regulatory requirements" to hide behind, in contrast to WiFi
> for example.
> 
> Is it the opinion of the netdev community that it is OK for vendors to
> use this model?

I ask myself that question pretty much every day. Sadly I have no clear
answer.

Silicon is cheap, you can embed a reasonable ARM or Risc-V core in the
chip for the area and power draw comparable to one high speed serdes
lane.

The drivers landing in the kernel are increasingly meaningless. My day
job is working for a hyperscaler. Even though we have one of the most
capable kernel teams on the planet most of issues with HW we face
result in "something is wrong with the FW, let's call the vendor".

And even when I say "drivers landing" it is an overstatement.
If you look at high speed anything these days the drivers cover
multiple generations of hardware, seems like ~5 years ago most
NIC vendors reached sufficient FW saturation to cover up differences
between HW generations.

At the same time some FW is necessary. Certain chip functions, are 
best driven by a micro-controller running a tight control loop. 
The complexity of FW is a spectrum, from basic to Qualcomm. 
The problem is there is no way for us to know what FW is hiding
by just looking at the driver.

Where do we draw the line? 

Personally I'd really like to see us pushing back stronger.
