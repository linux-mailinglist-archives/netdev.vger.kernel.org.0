Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BFC48CFBE
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 01:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiAMAfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 19:35:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59398 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiAMAfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 19:35:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B40FDB82017
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 00:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF88C36AE9;
        Thu, 13 Jan 2022 00:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642034141;
        bh=kUjQg5yyVH1jd+aH/YTe7o1HV/ayZ93IsL45DI4Z6zM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JMFTNFhujyJuJVbKXWrk1oe+72cpKTNHafKI6DR92IW+AunSOBMz3RvJUB+JDuuzG
         AcVoA8OuP7hl2YuztLA9f0T5RqxiYaV4U954QUFA7ylYCKpRJxNTv5CnhleVro4zy5
         V5L4No2qjN51nTSit3TXwg3W83IdA/A3qTg8rNJ8tReCNSBmhdB/W8hrYAPFzUF8YA
         i7fFVGuy6a4F+89Ee+XFBZdQXQRKRSxJh4CO5gPE2DJnmqTpwzUE3DOigxtcY2KUwr
         HIqF/fbHmto/u5CVHdXQ/ZbBFP7ct2fa9LsqeSHypv7OHFxkSBhSJvcUGGVt3KvTBh
         JxLIzksX0wr5w==
Date:   Wed, 12 Jan 2022 16:35:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111112418.2bbc0db4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 04:40:01 +0000 Parav Pandit wrote:
> > > It's the capability that is turned on/off.
> > > A device is composed based on what is needed. ipsec offload is not always needed.  
> > > Its counter intuitive to expose some low level hardware resource to disable ipsec indirectly.  
> > > So it is better to do as capability/param rather than some resource.
> > > It is capability is more than just resource.  
> > 
> > Wouldn't there be some limitation on the number of SAs or max throughput or
> > such to limit on VF hogging the entire crypto path?
> 
> The fairness among VFs is present via the QoS knobs. Hence it doesn't hogg the entire crypto path.

Why do you want to disable it, then?

> > I was expecting such a knob, and then turning it to 0 would effectively remove
> > the capability (FW can completely hide it or driver ignore it).
> > 
> > > May be. But it is in use at [1] for a long time now.
> > >
> > > [1] docker run -p 9090:9090 prom/prometheus  
> > 
> > How is it "in use" if we haven't merged the patch to enable it? :) What does it
> > monitor? PHYs port does not include east-west traffic, exposing just the PHYs
> > stats seems like a half measure.
>
> Containerized monitors are in use by running in monitor in same net ns of the PF having full access to the PF.
> The monitor is interested in physical port counters related to link transitions, link errors, buffer overruns etc.

I don't think we should support this use case. VFs and PFs are not
the same thing.

> > > Not sure I follow you.
> > > Netdev of a mlx5 function talks to the driver internal steering API in
> > > addition to other drivers operating this mlx5 function.  
> > 
> > But there is no such thing as "steering API" in netdev. We can expose the
> > functionality we do have, if say PTP requires some steering then enabling PTP
> > implies the required steering is enabled. "steering API"
> > as an entity is meaningless to a netdev user.  
> It is the internal mlx5 implementation of how to do steering, triggered by netdev ndo's and other devices callback.
> There are multiple options on how steering is done.
> Such as sw_steering or dev managed steering.
> There is already a control knob to choose sw vs dev steering as devlink param on the PF at [1].
> This [1] device specific param is only limited to PF. For VFs, HV need to enable/disable this capability on selected VF.
> API wise nothing drastic is getting added here, it's only on different object. (instead of device, it is port function).
> 
> [1] https://www.kernel.org/doc/html/v5.8/networking/device_drivers/mellanox/mlx5.html#devlink-parameters

Ah, that thing. IIRC this was added for TC offloads, VFs don't own 
the eswitch so what rules are they inserting to require "high insertion
rate"? My suspicion is that since it's not TC it'd be mostly for the
"DR" feature you have hence my comment on it not being netdev.
