Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8371948F479
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiAOCes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:34:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60970 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiAOCes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:34:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8C3961994
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 02:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB902C36AE9;
        Sat, 15 Jan 2022 02:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642214087;
        bh=EQVutiLe/nZbj8PWlhJLvK1GEdH0t7yGDeyKJJYDXLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fr7MjDhBEx+ncpuKJpXfNTj3wJv8+yccO3bHivTcjuFMuaZQY9nVrrTHaDqY7LI5q
         w1vLkNxIbIEv/sc6iyvKyaoFOupmgDSMIHL6+bjNHk+d9Rwc7Sl6g2FTCWfI7l5Iho
         ATFhaNhXMhLoguEhg2lq/JZjcBoLg6jh8LeDgA59XwYRJD/0w3MXO63oiJxuY1kzE/
         6iA/fJIe4jSDP9JcTVv1IFMJajUMEoy7ZwdrJd23jPQK9bSXoGb7UCxuQeypaOD4iW
         G6QMw7x+6PjljQjqQOfY8rkbMXeKX4z6uyrt5T32nlqZtozuxfNfv5z05INiDJ3Zpm
         3g8ZD4i4skFag==
Date:   Fri, 14 Jan 2022 18:34:45 -0800
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
Message-ID: <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111112418.2bbc0db4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 04:52:24 +0000 Parav Pandit wrote:
> > > Each enabled feature consumes
> > > (a) driver level memory resource such as querying ip sec capabilities and more later,
> > > (b) time in querying those capabilities,  
> > 
> > These are on the VM's side, it's not hypervisors responsibility to help the client
> > by stripping features.
> >   
> HV is composing the device before giving it to the VM.
> VM can always disable certain feature if it doesn't want to use by ethtool or other means.
> But here we are discussing about offering/not offering the feature to the VF from HV.
> HV can choose to not offer certain features based on some instruction received from orchestration.

I'm still missing why go thru orchestration and HV rather than making
the driver load more clever to avoid wasting time on initializing
unnecessary caps.

> > > (c) device level initialization in supporting this capability
> > >
> > > So for light weight devices which doesn't need it we want to keep it disabled.  
> > 
> > You need to explain this better. We are pretty far from "trust"
> > settings, which are about privilege and not breaking isolation.
> 
> We split the abstract trust to more granular settings, some related to privilege and some to capabilities.
>  
> > "device level initialization" tells me nothing.
> >  
> Above one belongs to capabilities bucket. Sw_steering belongs to trust bucket.
>
> > > No it is limited to tc offloads.
> > > A VF netdev inserts flow steering rss rules on nic rx table.
> > > This also uses the same smfs/dmfs when a VF is capable to do so.  
> > 
> > Given the above are you concerned about privilege or also just resources use
> > here? Do VFs have SMFS today?  
> Privilege.
> VFs have SMFS today, but by default it is disabled. The proposed knob will enable it.

Could you rephrase? What does it mean that VFs have SMFS but it's
disabled? Again - privilege means security, I'd think that it can't have
security implications if you're freely admitting that it's exposed.
