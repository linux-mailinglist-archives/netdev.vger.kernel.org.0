Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C837448C8F4
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349734AbiALRBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:01:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52094 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242094AbiALRBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:01:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD484B81FC5
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 17:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44664C36AE5;
        Wed, 12 Jan 2022 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642006890;
        bh=DmPqMLhjB9dvA4iQ9+LAfSmp3xRqhVvWN1ndq+SUeug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a4sPqo8F8W6m0QGZbg9Pd/ZmW9VRNovOSPsJXkyMfaJGB3bMfiQFJ42tg2VZK1+H5
         ZTSBVomSGVNK9TmPfgZSW6JQbdesd5gIR8p4PWoCG3dy0ue/iwl7pVlsg7E4y6A+ZT
         ahy6szSsj0Yf4ca9/F6plbeEYUF/OVEQ3QN6OC27IVpEIE1T7jdaEnLorhxINcm4Fy
         rh3ehSzO35RxWvUjW9RJoms71ykkR/wq8UYxjxsqhsWub8RZeXkp2fWcHlTyK0KwfD
         25w8xXKDmbZOCRyjw1JPPr7iKU4Lse74y7rjCFGcmJDudNViY2ZEd4kbI4TziDsk7Y
         Q1RY9tbmna08g==
Date:   Wed, 12 Jan 2022 09:01:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net 6/7] net: axienet: fix for TX busy handling
Message-ID: <20220112090128.082f7477@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <e3b5c842272de17865477110ee55625464113cda.camel@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
        <20220111211358.2699350-7-robert.hancock@calian.com>
        <20220111194948.056c7211@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <e3b5c842272de17865477110ee55625464113cda.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 16:45:18 +0000 Robert Hancock wrote:
> On Tue, 2022-01-11 at 19:49 -0800, Jakub Kicinski wrote:
> > On Tue, 11 Jan 2022 15:13:57 -0600 Robert Hancock wrote:  
> > > We should be avoiding returning NETDEV_TX_BUSY from ndo_start_xmit in
> > > normal cases. Move the main check for a full TX ring to the end of the
> > > function so that we stop the queue after the last available space is used
> > > up, and only wake up the queue if enough space is available for a full
> > > maximally fragmented packet. Print a warning if there is insufficient
> > > space at the start of start_xmit, since this should no longer happen.
> > > 
> > > Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI
> > > Ethernet driver")
> > > Signed-off-by: Robert Hancock <robert.hancock@calian.com>  
> > 
> > Feels a little more like an optimization than strictly a fix.
> > Can we apply this and the following patch to net-next in two
> > week's time? It's not too much of a stretch to take it in now
> > if it's a bit convenience but I don't think the Fixes tags should 
> > stay.  
> 
> Well it's a fix in the sense that it complies with what
> Documentation/networking/driver.rst says drivers should do - I'm not too
> familiar with the consequences of not doing that are, I guess mostly
> performance from having to requeue the packet?

Yes, it's just the re-queuing overhead AFAIU.

> From that standpoint, I guess the concern with breaking those two patches out
> is that the previous patches can introduce a bit of a performance hit (by
> actually caring about the state of the TX ring instead of trampling over it in
> some cases) and so without the last two you might end up with some performance 
> regression. So I'd probably prefer to keep them together with the rest of the
> patch set.

Alright, if you have any numbers on this it'd be great to include them
in the commit message.
