Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6C33D9737
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 23:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhG1VFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 17:05:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50710 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231350AbhG1VFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 17:05:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BtZW607qNOD3e0gMonQVnWRfeBOSie9refbYyYzzrg4=; b=V6RnpvzICovOVmaf/kU4yalbwp
        hnL8jzaq33Q5ynBKTNGEvmOOIc9dQpUSVda9cqKnlPLxJ7DIw4HYTr9VWfVh/49Ryx8rw4uvfFIZd
        hhkrUdHgxwHsVlvQB/TMr4C6yC7ocVcwxp70h7slt8YglylnPAW12vQqqI8nf+gxt4e0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8qjb-00FEZb-Tk; Wed, 28 Jul 2021 23:04:59 +0200
Date:   Wed, 28 Jul 2021 23:04:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: net: dsa: mv88e6xxx: no multicasts rx'd after enabling hw time
 stamping
Message-ID: <YQHGe6Rv9T4+E3AG@lunn.ch>
References: <CAFSKS=Pv4qjfikHcvyycneAkQWTXQkKS_0oEVQ3JyE5UL6H=MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=Pv4qjfikHcvyycneAkQWTXQkKS_0oEVQ3JyE5UL6H=MQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 03:44:24PM -0500, George McCollister wrote:
> If I do the following on one of my mv88e6390 switch ports I stop
> receiving multicast frames.
> hwstamp_ctl -i lan0 -t 1 -r 12
> 
> Has anyone seen anything like this or have any ideas what might be
> going on? Does anyone have PTP working on the mv88e6390?
> 
> I tried this but it doesn't help:
> ip maddr add 01:xx:xx:xx:xx:xx dev lan0
> 
> I've tried sending 01:1B:19:00:00:00, 01:80:C2:00:00:0E as well as
> other random ll multicast addresses. Nothing gets through once
> hardware timestamping is switched on. The switch counters indicate
> they're making it into the outward facing switch port but are not
> being sent out the CPU facing switch port. I ran into this while
> trying to get ptp4l to work.

Hi George

All my testing was i think on 6352.

I assume you get multicast before using hwstamp_ctl?

Maybe use:

https://github.com/lunn/mv88e6xxx_dump

and dump the ATU before and afterwards.

The 6390 family introduced a new way to configured which reserved
management addresses get forwarded to the CPU. Maybe take a look at
mv88e6390_g1_mgmt_rsvd2cpu() and see if you can spot anything odd
going on.

You might also want to check if mv88e6352_port_set_mcast_flood() is
being called.

      Andrew
