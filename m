Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822D01CEF21
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 10:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgELI27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 04:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbgELI26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 04:28:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 901BB207FF;
        Tue, 12 May 2020 08:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589272138;
        bh=njpDdm0ei3wLE4fag30griz3nGE2HvH4gTYqWN2cPCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Br6Ur28N7qvreO6eMeGli0A2o5+jsl0caJg+EtNBINXVHTrmoy9FM6OFGR2SPXEqw
         +2OkbSMvg6KumldeCuPiMNL/GMh20WB/NvI17u+Kee9ynrKK+1l5bDnVsjRLW6z3+f
         NDaPzva8aCCkYr7aVSYKkgD7/z/sel8BNylY7fHk=
Date:   Tue, 12 May 2020 10:27:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guillaume Tucker <guillaume.tucker@collabora.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: stable/linux-4.4.y bisection: baseline.login on
 at91-sama5d4_xplained
Message-ID: <20200512082744.GB3526567@kroah.com>
References: <5eb8399a.1c69fb81.c5a60.8316@mx.google.com>
 <2db7e52e-86ae-7c87-1782-8c0cafcbadd8@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2db7e52e-86ae-7c87-1782-8c0cafcbadd8@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 06:54:29AM +0100, Guillaume Tucker wrote:
> Please see the bisection report below about a boot failure.
> 
> Reports aren't automatically sent to the public while we're
> trialing new bisection features on kernelci.org but this one
> looks valid.
> 
> It appears to be due to the fact that the network interface is
> failing to get brought up:
> 
> [  114.385000] Waiting up to 10 more seconds for network.
> [  124.355000] Sending DHCP requests ...#
> ..#
> .#
>  timed out!
> [  212.355000] IP-Config: Reopening network devices...
> [  212.365000] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> #
> 
> 
> I guess the board would boot fine without network if it didn't
> have ip=dhcp in the command line, so it's not strictly a kernel
> boot failure but still an ethernet issue.
> 
> There wasn't any failure reported by kernelci on linux-4.9.y so
> maybe this patch was applied by mistake on linux-4.4.y but I
> haven't investigated enough to prove this.

It wasn't applied "by mistake", as the commit log for this says it
resolves an issue that was created in 2c7b49212a86 ("phy: fix the use of
PHY_IGNORE_INTERRUPT") which was in 3.11.

I'll go revert this now, as regressions are not good, perhaps some other
change that happened between 4.5 and 4.9 in this area keeps the error
you are seeing from happening.

thanks,

greg k-h
