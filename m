Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D3C39EA91
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 02:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhFHANJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 20:13:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50428 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhFHANJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 20:13:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=05DaucKpLaWDMZMRKqIQSDjq8NRLBaInvCAfb+gp9rQ=; b=MB
        Y5Cflh8hrDUpvoKzmQH0euWAHwhN9O9ywI1F8GkvgzS+medKzZCB80TKntOcnbRhOgMctW2yLyOO2
        8hpUU+RxJxtrdQpcapw3EcIdVmbmS17b4Zp2x73NwyyiVz8BIffeK+KdWTeaIHQXm+g9ABPPb/Tn5
        gIiGbUpQ/PNXmd0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lqPKs-008Gj2-Sf; Tue, 08 Jun 2021 02:11:14 +0200
Date:   Tue, 8 Jun 2021 02:11:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Johannes =?iso-8859-1?Q?Brandst=E4tter?= <jbrandst@2ds.eu>,
        netdev@vger.kernel.org
Subject: Re: Load on RTL8168g/8111g stalls network for multiple seconds
Message-ID: <YL61ojQeppA471Lw@lunn.ch>
References: <5b08afe02cb0baa7ae3e19fd0bc9d1cbe9ea89c9.camel@2ds.eu>
 <a4e4902d-5534-6c66-63f5-d88059604c78@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4e4902d-5534-6c66-63f5-d88059604c78@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 10:39:06PM +0200, Heiner Kallweit wrote:
> On 07.06.2021 15:11, Johannes Brandstätter wrote:
> > Hi,
> > 
> > just the other day I wanted to set up a bridge between an external 2.5G
> > RTL8156 USB Ethernet adapter (using r8152) and the built in dual
> > RTL8168g/8111g Ethernet chip (using r8169).
> > I compiled the kernel as of 5.13.0-rc4 because of the r8125 supporting
> > the RTL8156.
> > This was done using the Debian kernel config of 5.10.0-4 as a base and
> > left the rest as default.
> > 
> > So this setup was working the way I wanted it to, but unfortunately
> > when running iperf3 against the machine it would rather quickly stall
> > all communications on the internal RTL8168g.
> > I was still able to communicate fine over the external RTL8156 link
> > with the machine.
> > Even without the generated network load, it would occasionally become
> > stalled.
> > 
> > The only information I could really gather were that the rx_missed
> > counter was going up, and this kernel message some time after the stall
> > was happening:
> > 
> > [81853.129107] r8169 0000:02:00.0 enp2s0: rtl_rxtx_empty_cond == 0
> > (loop: 42, delay: 100).
> > 
> > Which has apparently to do with the wait for an empty fifo within the
> > r8169 driver.
> > 
> > Until that the machine (an UP² board) using the RTL8168g ran without
> > any issues for multiple years in different configurations.
> > Only bridging immediately showed the issue when given enough network
> > load.
> > 
> > After many hours of trying out different things, nothing of which
> > showed any difference whatsoever, I tried to replace the internal
> > RTL8168g with an additional external USB Ethernet adapter which I had
> > laying around, having a RTL8153 inside.
> > 
> > Once the RTL8168g was removed and the RTL8153 added to the bridge, I
> > was unable to reproduce the issue.
> > Of course I'd rather like to make use of the two internal Ethernet
> > ports if I somehow can.
> > 
> > So is there anything I could try to do?

Using a bridge means the interface is in promiscuous mode. That is not
something typically used. What could be interesting is keep the
interface out of the bridge, but do:

ip link set [interface] promisc on

Then do some iperf test etc to see if you can reproduce the issue.

     Andrew
