Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED47F3F1BB9
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 16:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240577AbhHSOjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 10:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240520AbhHSOjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 10:39:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5084661157;
        Thu, 19 Aug 2021 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629383903;
        bh=f9XDu/3QHunrGsMxI3TfvqVa7AjtQAmEK7TqQdQMep0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pJGL+m1sFlRBWVgc31A5GB4Sb/pbrpmyM4e2sL4K0j63pYmM9CbWcDQW1JxsNhbuB
         tbI4o2NXjYncgS0q/U81lMwSE1HlLveO1zfhYw4hZw1xTyMknoiJv1LekROw7EQnV2
         zv03b5L/KBjIf4Vbum5w8vUIYR6AVS8WTeFIcdLQoZ/9TvYWbiKy9znrjyMzDyJXTP
         p/rCNMLQsbiNEyCIUpeulBiM+YUdHhMBGo8921IYFr8N081AE6HNZTEiYB3zb+Tl9V
         7+lcQr6m9M7h4T+k4A/eo9TvKVdCnaswec72sskJp/SIVHDBur6mG+Q7UzSEI4trja
         GSfoij9+KTcVQ==
Date:   Thu, 19 Aug 2021 07:38:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <20210819073822.0f205af3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YR4Md0MJeAPOuuQw@shredder>
References: <20210818155202.1278177-1-idosch@idosch.org>
        <20210818155202.1278177-2-idosch@idosch.org>
        <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YR4Md0MJeAPOuuQw@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Aug 2021 10:47:03 +0300 Ido Schimmel wrote:
> > > + * enum ethtool_module_power_mode_policy - plug-in module power mode policy
> > > + * @ETHTOOL_MODULE_POWER_MODE_POLICY_LOW: Module is always in low power mode.  
> > 
> > Did you have a use case for this one or is it for completeness? Seems
> > like user can just bring the port down if they want no carrier? My
> > understanding was you primarily wanted the latter two, and those can
> > be freely changed when netdev is running, right?  
> 
> In all the implementations I could find (3), the user interface is
> high/low (on/off). The proposed interface is more flexible as it
> contains both the 'high' / 'low' policies in addition to the more user
> friendly 'high-on-up' ('auto') policy.

on/off is probably due to blindly setting the SFP bit. Our intention
here is to set a policy with respect to the netdev state (or integrate
the setting with the rest of the stack, if you will) not just control 
the bit.

IMO we should leave the value out of the enum until the use case for 
it becomes clear. Adding it later is simple enough.

> Given that keeping the 'low' policy does not complicate the
> implementation / maintenance

I'd argue it does. The netif_running() check is exactly to prevent
carrier from going away, so it only makes sense if the low setting 
exists. We can switch between 'auto' and 'high' any time.

> and that it provides users with a similar interface to what they are
> used to from other implementations, I would like to keep it in
> addition to the other two policies.

IIUC the existing interfaces are build around the architecture where
driver/fw do not control the SFP automatically IOW 'auto' does not
exist. 'low' is there for disabling the SFP when interface is down.

The interface where 'low' can't be set while the netdev is up is
*already* not 1:1 with the out of tree APIs, right?

I'd bet that if you convert users of existing APIs to map 'on' to
(always-)high and 'off' to auto everyone will be happy.
