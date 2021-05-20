Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA2F389AA2
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 02:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhETAqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 20:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhETAqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 20:46:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB5560C41;
        Thu, 20 May 2021 00:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621471484;
        bh=rGWrNR8ypB/67UncpSfVNpvDlWiSPIxH7vvSYJq4gcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HSBEW7YELZ+VyH5M4GJO1XuoRyZzIV65QO8CLgkncTMhMwxyO4Ura1L6ek5Gk9L+O
         zgaMB5UCtQz6nGByNre9Iqsl5fvXeU8ytmXcRdmOojEGTw9T7PxGVcVacaGSpezSil
         pc50VdrV22OTYglkTbZ4XvfXEvKeb+/3nMxoTqzMHIN6JW3FZu1Cp4n3G45qykc6j+
         deaYEnCm2w6pObnQkuElMXKW9+KWrjBR+QGcdem6wU7R+UHDWZjx3Y4883mTIVTGSI
         6Bjt9JWIgOE6vTan28om+51TmwT5o4u/Hc7PzPi7Cl+PCFFrwcmPtafAlwErhTcou2
         /GXyh5NQ7s3cg==
Date:   Wed, 19 May 2021 17:44:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mlx5: count all link events
Message-ID: <20210519174443.39b7cec9@kicinski-fedora-PC1C0HJN>
In-Reply-To: <35937fe6d371a43aa0bfe70c9fab549b62089592.camel@kernel.org>
References: <20210519171825.600110-1-kuba@kernel.org>
        <f48c950330996dcbb11f1a78b7c0a0445c656a20.camel@kernel.org>
        <20210519140659.30c3813c@kicinski-fedora-PC1C0HJN>
        <35937fe6d371a43aa0bfe70c9fab549b62089592.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 May 2021 17:07:00 -0700 Saeed Mahameed wrote:
> On Wed, 2021-05-19 at 14:06 -0700, Jakub Kicinski wrote:
> > On Wed, 19 May 2021 13:49:00 -0700 Saeed Mahameed wrote:  
> > > Can you share more on the actual scenario that has happened ? 
> > > in mlx5 i know of situations where fw might generate such events,
> > > just
> > > as FYI for virtual ports (vports) on some configuration changes.
> > > 
> > > another explanation is that in the driver we explicitly query the
> > > link
> > > state and we never take the event value, so it could have been that
> > > the
> > > link flapped so fast we missed the intermediate state.  
> > 
> > The link flaps quite a bit, this is likely a bad cable or port.
> > I scanned the fleet a little bit more and I see a couple machines 
> > in such state, in each case the switch is also seeing the link flaps,
> > not just the NIC. Without this patch the driver registers a full flap
> > once every ~15min, with the patch it's once a second. That's much
> > closer to what the switch registers.
> > 
> > Also the issue affects all hosts in MH, and persists across reboots
> > of a single host (hence I could test this patch).
> 
> reproduces on reboots even with a good cable ? 

I don't have access to the machines so the cable stays the same. I was
just saying that it doesn't seem like a driver issue since it persists
across reboots.

> you reboot the peer machine or the DUT (under test) machine ?

DUT

> > > According to HW spec for some reason we should always query and not
> > > rely on the event. 
> > > 
> > > <quote>
> > > If software retrieves this indication (port state change event),
> > > this
> > > signifies that the state has been
> > > changed and a QUERY_VPORT_STATE command should be performed to get
> > > the
> > > new state.
> > > </quote>  
> > 
> > I see, seems reasonable. I'm guessing the FW generates only one of
> > the
> > events on minor type of faults? I don't think the link goes fully
> > down,
> > because I can SSH to those machines, they just periodically drop
> > traffic. But the can't fully retrain the link at such high rate, 
> > I don't think.
> >   
> 
> hmm, Then i would like to get to the bottom of this, so i will have to
> consult with FW.
> But regardless, we can progress with the patch, I think the HW spec
> description forces us to do so.. 

SGTM :)
