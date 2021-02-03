Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F9E30E4EF
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 22:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhBCV0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 16:26:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231709AbhBCV0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 16:26:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD77564F5F;
        Wed,  3 Feb 2021 21:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612387567;
        bh=4UmJ66kt6LrH5hseYMX6YsFUM2xR/8M+Fm9LGmK3D74=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Eg6mWIKc3dLqTV2wamxx+pDCAB+Kqo9uL/2e4FGsVVj/qs9GYEZja6P2q0oLP0w6C
         Wsj/0/lP5gcDwcz5yKEaazTszEStwTPPyGF1p+0lTFT9+SDcrMii5Tlf/W50aFJiVB
         0jeOZLIKbou3zpp8d6Edfd5AAsBgZ5NPKowwOEbQGETswc543fhtfriXPR/Ilq6r+O
         3jthzPi61vPBZ4j0+DwKegwiY+V2qJ3FkZfLiy744fFmHMwkb091RZVZu5QvVbpDh/
         CRRowW3RDrDyhXF3cu/jp6oQOmcdBhxhlakifoitlYTyUaZUUaShay3Gfsh/aa9SUn
         KG6Obo9wH0RGw==
Date:   Wed, 3 Feb 2021 13:26:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, parav@nvidia.com
Subject: Re: [PATCH net-next 0/2] devlink: Add port function attribute to
 enable/disable roce
Message-ID: <20210203132605.7faf8ca0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <38d73470cd4faac0dc6c09697f33c5fb90d13f4e.camel@kernel.org>
References: <20210201175152.11280-1-yishaih@nvidia.com>
        <20210202181401.66f4359f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d01dfcc6f46f2c70c4921139543e5823582678c8.camel@kernel.org>
        <20210203105102.71e6fa2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <38d73470cd4faac0dc6c09697f33c5fb90d13f4e.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 03 Feb 2021 11:22:44 -0800 Saeed Mahameed wrote:
> On Wed, 2021-02-03 at 10:51 -0800, Jakub Kicinski wrote:
> > On Tue, 02 Feb 2021 20:13:48 -0800 Saeed Mahameed wrote:  
> > > yes, user in this case is the admin, who controls the provisioned
> > > network function SF/VFs.. by turning off this knob it allows to
> > > create
> > > more of that resource in case the user/admin is limited by memory.  
> > 
> > Ah, so in case of the SmartNIC this extra memory is allocated on the
> > control system, not where the function resides?
> 
> most of the memeory are actually allocated from where the function
> resides, some are on the management system but it is not as critical.
> SFs for now can only be probed on the management system, so the main
> issue will be on the SmartNIC side for now.

Why not leave the decision whether to allocate that memory or not to
the SF itself? If user never binds the RDMA driver to the SF they
clearly don't care for RDMA. No extra knobs needed.

> > My next question is regarding the behavior on the target system -
> > what
> > does "that user" see? Can we expect they will understand that the
> > limitation was imposed by the admin and not due to some
> > initialization
> > failure or SW incompatibility?
>
> the whole thing works with only real HW capabilities, there is no
> synthetic SW capabilities. 
> 
> when mlx5 instance driver loads, it doesn't assume anything about
> underlying HW, and it queries for the advertised FW capability
> according to the HW spec before it enables a feature.
> 
> so this patch adds the ability for admin to enforce a specific HW cap
> "off" for a VF/SF hca slice.
> 
> > > RAW eth QP, i think you already know this one, it is a very thin
> > > layer
> > > that doesn't require the whole rdma stack.  
> > 
> > Sorry for asking a leading question. You know how we'll feel about
> > that one, do we need to talk this out or can we save ourselves the
> > battle? :S  
> 
> I know, I know :/
> 
> So, there is no rdma bit/cap in HW.. to disable non-RoCE commands we
> will have to disable etherent capability. 

It's your driver, you can make it do what you need to. Why does 
the RDMA driver bind successfully to a non-RoCE Ethernet device 
in the first place?

> The user interface here has no synthetic semantics, all knobs will
> eventually be mapped to real HW/FW capabilities to get disabled.
> 
> the whole feature is about allowing admin to ship network functions
> with different capabilities that are actually enforced by FW/HW.. 
> so the user of the VF will see, RDMA/ETH only cards or both.

RDMA-only, ETH-only, RDMA+ETH makes sense to me. Having an ETH-only
device also exposed though rdma subsystem does not.
