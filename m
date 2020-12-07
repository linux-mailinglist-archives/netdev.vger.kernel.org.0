Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B692D1CC2
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 23:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgLGWFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 17:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgLGWFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 17:05:34 -0500
Message-ID: <c989ee2f4ea0ab3f48c1a5774f4ab0eaaeb781c9.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607378693;
        bh=HfiLQnV57+1KiTaSrss9wZ19RUsaYNAEyhBzVbzSuVE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EiNG7j0BUV4mATZKZq4FnIhUQ37Ow1cHD67VRH05HJPzfuw8c8tULvYVjox9Ky7r0
         D3uTSXcfR9XEh48RzwVlCgMCH3AFLN9nbh2qeKLRgFWMiuaYprGxwIuPwhImOswGgD
         PiltDN+ZKPfG7CR34JkYkw5hNxK8DOSHqB7vBksbnlls68QJ8m8Ve1rwNWcNpAprun
         1wlYKVHLWEKTQIan6nRZJByPO4tIdnvTgQ5hQpSSZkaZGQr3W+4tj7K6Y3dUDVcPEE
         BnqimAThMyDjzwcLuZIR06CqSBbjHmR4R+YPwsFpnO2CuO77ldQ2Pz6uT4VECflMxx
         unHWIsQxVreCQ==
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Eran Ben Elisha <eranbe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Date:   Mon, 07 Dec 2020 14:04:51 -0800
In-Reply-To: <20201207124233.22540545@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
         <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
         <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <a20290fa3448849e84d2d97b2978d4e05033cd80.camel@kernel.org>
         <20201204162426.650dedfc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <a4a8adc8-4d4c-3b09-6c2f-ce1d12e0b9bc@nvidia.com>
         <20201206170834.GA4342@hoboy.vegasvil.org>
         <a03538c728bf232ccae718d78de43883c4fca70d.camel@kernel.org>
         <20201207151906.GA30105@hoboy.vegasvil.org>
         <20201207124233.22540545@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-07 at 12:42 -0800, Jakub Kicinski wrote:
> On Mon, 7 Dec 2020 07:19:06 -0800 Richard Cochran wrote:
> > On Mon, Dec 07, 2020 at 12:37:45AM -0800, Saeed Mahameed wrote:
> > > we are not adding any new mechanism.  
> > 
> > Sorry, I didn't catch the beginning of this thread.  Are you
> > proposing
> > adding HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY to net_tstamp.h ?
> > 
> > If so, then ...
> > 
> > > Our driver feature is and internal enhancement yes, but the
> > > suggested
> > > flag is very far from indicating any internal enhancement, is
> > > actually
> > > an enhancement to the current API, and is a very simple extension
> > > with
> > > wide range of improvements to all layers.  
> > 
> > No, that would be no enhancement but rather a hack for poorly
> > designed
> > hardware.
> > 

Why ? how is the new flag different from HWTSTAMP_TX_ONESTEP_SYNC ?
it is a way to fine tune the driver .. nothing is hacky about the new
flag.

> > > Our driver can optimize accuracy when this flag is set, other
> > > drivers
> > > might be happy to implement it since they already have a slow
> > > hw  
> > 
> > Name three other drivers that would "be happy" to implement
> > this.  Can
> > you name even one other?
> 
> The behavior is not entirely dissimilar to the time stamps on
> multi-layered devices (e.g. DSA switches). The time stamp can either 
> be generated when the packet enters the device (current mlx5
> behavior)
> or when it actually egresses thru the MAC (what this set adds).
> 
> So while we could find other hardware like this if we squint hard
> enough
> - I'm not sure how much practical use for CPU-side stamps there is in
> DSA.
> 
> 
> My main concern is the user friendliness. I think there is no
> question
> that user running ptp4l would want this mlx5 knob to be enabled.
> Would
> we rather see a patch to ptp4l that turns per driver knob or should
> we
> shoot for some form of an API that tells the kernel that we're
> expecting ns level time accuracy? 
> 
> That's how I would phrase the dilemma here.

This is why i think that the new PTP tx flag to let the driver know
that only PTP EVENT messages are important would be the perfect answer
for all of the above. this flag has a very standard definition, which
could also mean: improved precision for PTP messages if the HW can do
it, why not, ptp4l should always choose this flag if it is present, as
ptp4l shouldn't request ptp hw tstamp on all tx traffic as it is doing
today, it is just an overkill.

other options will be adding knew knob out of the scope of PTP APIs,
which is going to be as ugly as private flag.


