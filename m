Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1123629A2B8
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 03:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgJ0CjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 22:39:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:53965 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgJ0CjE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 22:39:04 -0400
IronPort-SDR: iM/8/tU0pEVZlMwTRkqLxcZQBfXgitxTa8y55HCCzAZnDyvmq8kLMVfa3X+iOTA9G7H3qx53Zq
 nDlHJP+PyTag==
X-IronPort-AV: E=McAfee;i="6000,8403,9786"; a="229654143"
X-IronPort-AV: E=Sophos;i="5.77,422,1596524400"; 
   d="scan'208";a="229654143"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 19:39:03 -0700
IronPort-SDR: dGxjWQwCTVLj1uQPrbtsN/moj71jVwos+OHzw9al21xHLh17oCZJ00hL0PB7nt2roPy6VkHY3c
 YDARziN33ykQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,422,1596524400"; 
   d="scan'208";a="361219355"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.141])
  by orsmga007.jf.intel.com with ESMTP; 26 Oct 2020 19:38:59 -0700
Date:   Tue, 27 Oct 2020 10:33:41 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, mdf@kernel.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com,
        yilun.xu@intel.com
Subject: Re: [RFC PATCH 1/6] docs: networking: add the document for DFL
  Ether  Group driver
Message-ID: <20201027023341.GB10743@yilunxu-OptiPlex-7050>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
 <20201023153731.GC718124@lunn.ch>
 <20201026085246.GC25281@yilunxu-OptiPlex-7050>
 <20201026130001.GC836546@lunn.ch>
 <20201026173803.GA10743@yilunxu-OptiPlex-7050>
 <20201026113552.78e7a2b4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026113552.78e7a2b4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 11:35:52AM -0700, Jakub Kicinski wrote:
> On Tue, 27 Oct 2020 01:38:04 +0800 Xu Yilun wrote:
> > > > The line/host side Ether Group is not the terminal of the network data stream.
> > > > Eth1 will not paticipate in the network data exchange to host.
> > > > 
> > > > The main purposes for eth1 are:
> > > > 1. For users to monitor the network statistics on Line Side, and by comparing the
> > > > statistics between eth0 & eth1, users could get some knowledge of how the User
> > > > logic is taking function.
> > > > 
> > > > 2. Get the link state of the front panel. The XL710 is now connected to
> > > > Host Side of the FPGA and the its link state would be always on. So to
> > > > check the link state of the front panel, we need to query eth1.  
> > > 
> > > This is very non-intuitive. We try to avoid this in the kernel and the
> > > API to userspace. Ethernet switches are always modelled as
> > > accelerators for what the Linux network stack can already do. You
> > > configure an Ethernet switch port in just the same way configure any
> > > other netdev. You add an IP address to the switch port, you get the
> > > Ethernet statistics from the switch port, routing protocols use the
> > > switch port.
> > > 
> > > You design needs to be the same. All configuration needs to happen via
> > > eth1.
> > > 
> > > Please look at the DSA architecture. What you have here is very
> > > similar to a two port DSA switch. In DSA terminology, we would call
> > > eth0 the master interface.  It needs to be up, but otherwise the user
> > > does not configure it. eth1 is the slave interface. It is the user
> > > facing interface of the switch. All configuration happens on this
> > > interface. Linux can also send/receive packets on this netdev. The
> > > slave TX function forwards the frame to the master interface netdev,
> > > via a DSA tagger. Frames which eth0 receive are passed through the
> > > tagger and then passed to the slave interface.
> > > 
> > > All the infrastructure you need is already in place. Please use
> > > it. I'm not saying you need to write a DSA driver, but you should make
> > > use of the same ideas and low level hooks in the network stack which
> > > DSA uses.  
> > 
> > I did some investigation about the DSA, and actually I wrote a
> > experimental DSA driver. It works and almost meets my need, I can make
> > configuration, run pktgen on slave inf.
> > 
> > A main concern for dsa is the wiring from slave inf to master inf depends
> > on the user logic. If FPGA users want to make their own user logic, they
> > may need a new driver. But our original design for the FPGA is, kernel
> > drivers support the fundamental parts - FPGA FIU (where Ether Group is in)
> > & other peripherals on board, and userspace direct I/O access for User
> > logic. Then FPGA user don't have to write & compile a driver for their
> > user logic change.
> > It seems not that case for netdev. The user logic is a part of the whole
> > functionality of the netdev, we cannot split part of the hardware
> > component to userspace and the rest in kernel. I really need to
> > reconsider this.
> 
> This is obviously on purpose. Your design as it stands will not fly
> upstream, sorry.
> 
> >From netdev perspective the user should not care how many hardware
> blocks are in the pipeline, and on which piece of silicon. You have 
> a 2 port (modulo port splitting) card, there should be 2 netdevs, and
> the link config and forwarding should be configured through those.
> 
> Please let folks at Intel know that we don't like the "SDK in user
> space with reuse [/abuse] of parts of netdev infra" architecture.
> This is a second of those we see in a short time. Kernel is not a
> library for your SDK to use. 

I get your point. I'll share the information internally and reconsider
the design.

Thanks,
Yilun
