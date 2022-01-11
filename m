Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9914348B74D
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 20:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiAKTYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 14:24:24 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37818 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiAKTYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 14:24:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5556ACE1B7C
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 19:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53141C36AE3;
        Tue, 11 Jan 2022 19:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641929060;
        bh=FY6f2xhW++GL4L4MhVckdOBkid3N6SdjPwCswWijusU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ctw792B89Ft1eSCUORBVtAXYTV5oHz88XRBW4YSJmnHNVTJ+AEgh7oYV6WX7P1gkU
         PKZfXeCmpTkxaKE9vWKRhylpUpXOWkBLWtDf/tJKAUdnT4n/rBc/jTivOjVBMNeyWK
         PpgYBAnsKsWYoxJKc2b/x6ceSfhTEftPLKFZgY8dl2yDvz2xIRAjLV66lpKQVF1HaW
         O7nwvJoh7/Z1MTRzyL5tK40rIic4LhyW4Cl1U6ifS2u4hM3YYdGl6qV24AqbDxBHH6
         yGssGIsCGqjdDa2lR/kP49Cq5UeJ7Gm3wRUPUVP1wYk3DLjbbP6w4jZIy3JmjU3GPh
         mTnifvmMG7A2g==
Date:   Tue, 11 Jan 2022 11:24:18 -0800
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
Message-ID: <20220111112418.2bbc0db4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 18:26:16 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, January 11, 2022 11:50 PM
> > > This discussed got paused in yet another year-end holidays. :)
> > > Resuming now and refreshing everyone's cache.
> > >
> > > We need to set/clear the capabilities of the function before deploying such  
> > > function. As you suggested we discussed the granular approach and at present we  
> > > have following features to on/off.  
> > >
> > > Generic features:
> > > 1. ipsec offload  
> > 
> > Why is ipsec offload a trusted feature?
>
> It isn't trusted feature. The scope in few weeks got expanded from
> trusted to more granular at controlling capabilities. One that came
> up was ipsec or other offloads that consumes more device resources. 

That's what I thought. Resource control is different than privileges,
and requires a different API.

> > > 2. ptp device
> > 
> > Makes sense.
> >   
> > > Device specific:
> > > 1. sw steering  
> > 
> > No idea what that is/entails.
> >   
> :) it the device specific knob.
> 
> > > 2. physical port counters query  
> > 
> > Still don't know why VF needs to know phy counters.
>
> A prometheous kind of monitoring software wants to monitor the
> physical port counters, running in a container. Such container
> doesn't have direct access to the PF or physical representor. Just
> for sake of monitoring counters, user doesn't want to run the
> monitoring container in root net ns.

Containerizing monitors seems very counter-intuitive to me.

> > > It was implicit that a driver API callback addition for both
> > > types of features is not good.  
> > > Devlink port function params enables to achieve both generic and
> > > device specific features.  
> > > Shall we proceed with port function params? What do you think?  
> > 
> > I already addressed this. I don't like devlink params. They muddy
> > the water between vendor specific gunk and bona fide Linux uAPI.
> > Build a normal dedicated API.  
> For sure we prefer the bona fide Linux uAPI for standard features.
> But internal knobs of how to do steering etc, is something not
> generic enough. May be only those quirks live in the port function
> params and rest in standard uAPIs?

Something talks to that steering API, and it's not netdev. So please
don't push problems which are not ours onto us.
