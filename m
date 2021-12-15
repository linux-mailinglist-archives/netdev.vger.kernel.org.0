Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DF247664B
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhLOXEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhLOXEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:04:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94F0C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 15:04:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82A46B82237
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 23:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC87C36AE3;
        Wed, 15 Dec 2021 23:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639609471;
        bh=lOxiSSeRILJmNkeKH0wOAn05UbM36Nf2R4udLPxeKNo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A4E3wXpaGkpHvjdk2ct68Uz54BPxM2OHqyeUDGo0A3Y4HIPUeQl2uC5vzuOFsHgdX
         Kg/eptBQuUnYTiwKhnAHBZFPgMVFuvsYaH5jcJUqfhOqsMSqD8zV/L3p3p3m95eqzb
         PRg5wifNPbr5LNnBku7VpPTiXp/qRZ147PRjXUoX/xwNWxMN7mVq6IEvk2Ns4kGlLx
         1qQ++ehYlvHMVRFwq+8gotrh9XhT35UU5COsLyHZ0vEkB6cF0HcsIu/URLeyr1VDks
         2muux03sjoE9HeR9QUPtWnrH98C7w+O2kcmY2VSX4x7sNA3EAvAV/BR9tzSQMvOdSl
         M8BruiMbiyyOA==
Date:   Wed, 15 Dec 2021 15:04:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211122144307.218021-2-sunrani@nvidia.com>
        <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 22:15:10 +0000 Saeed Mahameed wrote:
> On Wed, 2021-12-15 at 11:22 -0800, Jakub Kicinski wrote:
> > On Wed, 15 Dec 2021 18:19:16 +0000 Saeed Mahameed wrote:  
> > > After some internal discussions, the plan is to not push new
> > > interfaces, but to utilize the existing devlink params interface
> > > for
> > > devlink port functions.
> > > 
> > > We will suggest a more fine grained parameters to control a port
> > > function (SF/VF) well-defined capabilities.
> > > 
> > > devlink port function param set/get DEV/PORT_INDEX name PARAMETER
> > > value
> > > VALUE cmode { runtime | driverinit | permanent }
> > > 
> > > Jiri is already on-board. Jakub I hope you are ok with this, let us
> > > know if you have any concerns before we start implementation.  
> > 
> > You can use mail pigeon to configure this, my questions were about 
> > the feature itself not the interface.  
> 
> We will have a parameter per feature we want to enable/disable instead
> of a global "trust" knob.

So you're just asking me if I'm okay with devlink params regardless if
I'm okay with what they control? Not really, I prefer an API as created
by this patches.
