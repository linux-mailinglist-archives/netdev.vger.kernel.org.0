Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CAC43B807
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237583AbhJZRTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhJZRTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:19:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920A260F9D;
        Tue, 26 Oct 2021 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635268596;
        bh=qtVGbeV6A+Xh4nF76VBzqr3d/d+/0uljYidHwq/zXec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qV/pHKP7EwBQhmG5KUaaq9ZW7w24gst6chl0b/jLGh0kZCAsPm34EFWZJaiI69HUn
         XEoq6Jna5ut0xtX8j+L7WbuVqgJdAQDL/QvekddmQwlcd+raR29uMahgZVyG6hb4So
         WQlDmO4NaFxQoWUfkB2RoXMO8ji/zxFSagTY+jkMYfbfMwMXmPFB468SDepniH84nH
         Z34+PXEd3v4qscUO1R5pIlW9uBpweJ65JPN3p79FbtuPaFcffxL33usM5vvRChlHeZ
         6uROBNz9StPYY4NLVgHzD9/UCTpJ5A2RfG9WfDvNuZHEQS3EJ4gI6bMZ18Es4Bshtx
         ph6u6eFHGUung==
Date:   Tue, 26 Oct 2021 10:16:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 10/14] net/mlx5: Let user configure io_eq_size param
Message-ID: <20211026101635.7fc1097d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <91f1f7126508db9687e4a0754b5a6d1696d6994c.camel@nvidia.com>
References: <20211025205431.365080-1-saeed@kernel.org>
        <20211025205431.365080-11-saeed@kernel.org>
        <20211026080535.1793e18c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <91f1f7126508db9687e4a0754b5a6d1696d6994c.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 15:54:28 +0000 Saeed Mahameed wrote:
> On Tue, 2021-10-26 at 08:05 -0700, Jakub Kicinski wrote:
> > On Mon, 25 Oct 2021 13:54:27 -0700 Saeed Mahameed wrote:  
> > > From: Shay Drory <shayd@nvidia.com>
> > > 
> > > Currently, each I/O EQ is taking 128KB of memory. This size
> > > is not needed in all use cases, and is critical with large scale.
> > > Hence, allow user to configure the size of I/O EQs.
> > > 
> > > For example, to reduce I/O EQ size to 64, execute:
> > > $ devlink resource set pci/0000:00:0b.0 path /io_eq_size/ size 64
> > > $ devlink dev reload pci/0000:00:0b.0  
> > 
> > This sort of config is needed by more drivers,
> > we need a standard way of configuring this.
>
> We had a debate internally about the same thing, Jiri and I thought
> that EQ might be a ConnectX only thing (maybe some other vendors have
> it) but it is not really popular

I thought it's a RDMA thing. At least according to grep there's 
a handful of non-MLX drivers which have eqs. Are these not actual
event queues? (huawei/hinic, ibm/ehea, microsoft/mana, qlogic/qed)

> we thought, until other vendors start contributing or asking for 
> the same thing, maybe then we can standardize.

Yeah, like the standardization part ever happens :/ 

Look at the EQE/CQE interrupt generation thing. New vendor comes in and
copies best known practice (which is some driver-specific garbage,
ethtool priv-flags in that case). The maintainer (me) has to be the
policeman remember all those knobs with prior art and push back. Most
of the time the vendor decides to just keep the knob out of tree at
this point, kudos to Hauwei for not giving up. New vendor implements
the API, none of the existing vendors provide reviews or feedback.
Then none of the existing vendors implements the now-standard API.
Someone working for a large customer (me, again) has to go and ask 
for the API to be implemented. Which takes months even tho the patches
should be trivial.

If the initial patches adding the cqe/eqe interrupt modes to priv-flags
were nacked and the standard API created we'd all have saved much time.

> > Sorry, I didn't have the time to look thru your patches
> > yesterday, I'm sending a revert for all your new devlink
> > params.  
> 
> Sure, we will submit a RFC to give other vendors a chance to comment,
> it will be basically the same patch (devlink resource) while making the
> parameters vendor generic.

IDK if resource is a right fit (as mentioned to Parav in the discussion
on the revert).
