Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7834929A35C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 04:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505069AbgJ0Dcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 23:32:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:58213 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442737AbgJ0Dcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 23:32:55 -0400
IronPort-SDR: +ZKM+gL9xpdpaHRd6e42OXbvAXaKXAnS8MTkVMkchcd2Gh/eRNyRflG2rmi/t0Lz2RcuzIPDi5
 IKWvJ+Fibhpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9786"; a="164522268"
X-IronPort-AV: E=Sophos;i="5.77,422,1596524400"; 
   d="scan'208";a="164522268"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 20:32:54 -0700
IronPort-SDR: gDdf5aD0cVHkx3dm0A1nTvfc2YB+fIPjcoCHhXHmO8rJUkNHKa5BLGO5D2NyAOIr+Cud45heXx
 S04aoJCfIZcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,422,1596524400"; 
   d="scan'208";a="361229685"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.141])
  by orsmga007.jf.intel.com with ESMTP; 26 Oct 2020 20:32:51 -0700
Date:   Tue, 27 Oct 2020 11:27:32 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com
Subject: Re: [RFC PATCH 1/6] docs: networking: add the document for DFL Ether
  Group driver
Message-ID: <20201027032732.GC10743@yilunxu-OptiPlex-7050>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
 <20201023153731.GC718124@lunn.ch>
 <20201026085246.GC25281@yilunxu-OptiPlex-7050>
 <20201026130001.GC836546@lunn.ch>
 <20201026173803.GA10743@yilunxu-OptiPlex-7050>
 <20201026191400.GO752111@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026191400.GO752111@lunn.ch>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 08:14:00PM +0100, Andrew Lunn wrote:
> > > > > Do you really mean PHY? I actually expect it is PCS? 
> > > > 
> > > > For this implementation, yes.
> > > 
> > > Yes, you have a PHY? Or Yes, it is PCS?
> > 
> > Sorry, I mean I have a PHY.
> > 
> > > 
> > > To me, the phylib maintainer, having a PHY means you have a base-T
> > > interface, 25Gbase-T, 40Gbase-T?  That would be an odd and expensive
> > > architecture when you should be able to just connect SERDES interfaces
> > > together.
> 
> You really have 25Gbase-T, 40Gbase-T? Between the FPGA & XL710?
> What copper PHYs are using? 

Sorry for the confusing. I'll check with our board designer and reply
later.

> 
> > I see your concerns about the SERDES interface between FPGA & XL710.
> 
> I have no concerns about direct SERDES connections. That is the normal
> way of doing this. It keeps it a lot simpler, since you don't have to
> worry about driving the PHYs.
> 
> > I did some investigation about the DSA, and actually I wrote a
> > experimental DSA driver. It works and almost meets my need, I can make
> > configuration, run pktgen on slave inf.
> 
> Cool. As i said, I don't know if this actually needs to be a DSA
> driver. It might just need to borrow some ideas from DSA.
> 
> > Mm.. seems the hardware should be changed, either let host directly
> > access the QSFP, or re-design the BMC to provide more info for QSFP.
> 
> At a minimum, you need to support ethtool -m. It could be a firmware
> call to the BMC, our you expose the i2c bus somehow. There are plenty
> of MAC drivers which implement eththool -m without using phylink.
> 
> But i think you need to take a step back first, and look at the bigger
> picture. What is Intel's goal? Are they just going to sell complete
> cards? Or do they also want to sell the FPGA as a components anybody
> get put onto their own board?
> 
> If there are only ever going to be compete cards, then you can go the
> firmware direction, push a lot of functionality into the BMC, and have
> the card driver make firmware calls to control the SFP, retimer,
> etc. You can then throw away your mdio and phy driver hacks.
> 
> If however, the FPGA is going to be available as a component, can you
> also assume there is a BMC? Running Intel firmware? Can the customer
> also modify this firmware for their own needs? I think that is going
> to be difficult. So you need to push as much as possible towards
> linux, and let Linux drive all the hardware, the SFP, retimer, FPGA,
> etc.

This is a very helpful. I'll share with our team and reconsider about the
design.

Thanks,
Yilun

> 
> 	Andrew
> 
