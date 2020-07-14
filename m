Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3173A21F752
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgGNQ3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:29:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgGNQ3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 12:29:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B70D8223AB;
        Tue, 14 Jul 2020 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594744145;
        bh=4odRCreeBpRWf9k9xWiKzOUUUo8g02gshG5+keJQUpI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SsC/k4KH0RiKnJyANHzdOQq2xkfSIzMcUbenVPrxpqUdLls+fCuP/Te4F3n2mT6ES
         Ksiq2dUy9HseBQclYz3xZf23DYiDtkE3PciLBNK4A248cYbmVaCAc4KLQ/LyYNx6o1
         tOvT3MOvsF7BlEZ4t/IRK7luPGIQAsZR1fodbsXo=
Date:   Tue, 14 Jul 2020 09:29:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Westergreen, Dalon" <dalon.westergreen@intel.com>
Cc:     "Ooi, Joyce" <joyce.ooi@intel.com>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thor.thayer@linux.intel.com" <thor.thayer@linux.intel.com>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Message-ID: <20200714092903.38581b74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3bcb9020f0a3836f41036ddc3c8034b96e183197.camel@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
        <20200708072401.169150-10-joyce.ooi@intel.com>
        <20200708144900.058a8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CY4PR11MB12537DA07C73574B82A239BDF2610@CY4PR11MB1253.namprd11.prod.outlook.com>
        <20200714085526.2bb89dc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3bcb9020f0a3836f41036ddc3c8034b96e183197.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 15:58:53 +0000 Westergreen, Dalon wrote:
> On Tue, 2020-07-14 at 08:55 -0700, Jakub Kicinski wrote:
> > On Tue, 14 Jul 2020 14:35:16 +0000 Ooi, Joyce wrote:  
> > > > I'm no device tree expert but these look like config options rather than
> > > > HW
> > > > description. They also don't appear to be documented in the next patch.    
> > > 
> > > The poll_freq are part of the msgdma prefetcher IP, whereby it
> > > specifies the frequency of descriptor polling operation. I can add
> > > the poll_freq description in the next patch.  
> > 
> > Is the value decided at the time of synthesis or can the driver choose 
> > the value it wants?  
> 
> It is not controlled at synthesis, this parameter should likely not be a
> devicetree parameter, perhaps just make it a module parameter with a default
> value.

Let's see if I understand the feature - instead of using a doorbell the
HW periodically checks the contents of the next-to-use descriptor to
see if it contains a valid tx frame or rx buffer?

I've seen vendors abuse fields of ethtool --coalesce to configure
similar settings. tx-usecs-irq and rx-usecs-irq, I think. Since this
part of ethtool API has been ported to netlink, could we perhaps add 
a new field to ethtool --coalesce?
