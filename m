Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9123E48F571
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 07:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiAOGPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 01:15:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39434 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiAOGPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 01:15:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60A3660A76
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 06:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8F6C36AE3;
        Sat, 15 Jan 2022 06:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642227349;
        bh=iM1oCA2s3y2tYDWu/upTl2KbFuqHhIS7ULas9Qw3qBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YjyMATqi5ATkwZwtpt7teD3NizbIowil/gP1+EYqQgCJ7zbeRCM1P0oJUoMsi3c01
         AvBICLsskVZvwAD2Dz1cTNLhi++7hTAsbXnbp5eNOASTnCXfA3Upb6eoY9ANrvFasK
         rE90z9+PSwCwP+DUnE6XfoenMP9ES/XyccJCIzy9Ik7D4+kmhJs5mSe9x+3GDI71wz
         JtrTU9BeDYmA4UBf4i0TiQ9ApZLwPXE8ctVgjnSs2RN/+qPA1YopCbpOH6TGDzc8rm
         rIbjwlsWtWvzcsV+3Pf+zbnJBmbtacdXu3ZyOdNVaW0cMuRj7xARCnQb3kDzfLpExZ
         vewtKhMHkPYew==
Date:   Fri, 14 Jan 2022 22:15:48 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20220115061548.4o2uldqzqd4rjcz5@sx1>
References: <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220111112418.2bbc0db4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Jan 18:34, Jakub Kicinski wrote:
>On Fri, 14 Jan 2022 04:52:24 +0000 Parav Pandit wrote:
>> > > Each enabled feature consumes
>> > > (a) driver level memory resource such as querying ip sec capabilities and more later,
>> > > (b) time in querying those capabilities,
>> >
>> > These are on the VM's side, it's not hypervisors responsibility to help the client
>> > by stripping features.
>> >
>> HV is composing the device before giving it to the VM.
>> VM can always disable certain feature if it doesn't want to use by ethtool or other means.
>> But here we are discussing about offering/not offering the feature to the VF from HV.
>> HV can choose to not offer certain features based on some instruction received from orchestration.
>
>I'm still missing why go thru orchestration and HV rather than making
>the driver load more clever to avoid wasting time on initializing
>unnecessary caps.

unfortunately for "smartnics" of this era, many of these initilizations
and resources are only manged by FW and the details are hidden away from
drivers, we need the knobs to tell the FW, hey we don't need all of these
features for this particular vf, save the resources for something else.
After all VF users need only a small portion of all the features we offer
to them, but again unfortunately the FW pre-allocates precious HW
resources to allow such features per VFs.

I know in this case smartnic === dumb FW, and sometimes there is no way
around it, this is the hw arch we have currently, not everything is a
nice generic flexible resources, not when it has to be wrapped with FW
"__awesome__" logic ;), and for proper virtualization we need this FW.

But i totally agree with your point, when we can limit with resources, we
should limit with resources, otherwise we need a knob to communicate to FW
what is the user intention for this VF.

>
>> > > (c) device level initialization in supporting this capability
>> > >
>> > > So for light weight devices which doesn't need it we want to keep it disabled.
>> >
>> > You need to explain this better. We are pretty far from "trust"
>> > settings, which are about privilege and not breaking isolation.
>>
>> We split the abstract trust to more granular settings, some related to privilege and some to capabilities.
>>
>> > "device level initialization" tells me nothing.
>> >
>> Above one belongs to capabilities bucket. Sw_steering belongs to trust bucket.
>>
>> > > No it is limited to tc offloads.
>> > > A VF netdev inserts flow steering rss rules on nic rx table.
>> > > This also uses the same smfs/dmfs when a VF is capable to do so.
>> >
>> > Given the above are you concerned about privilege or also just resources use
>> > here? Do VFs have SMFS today?
>> Privilege.
>> VFs have SMFS today, but by default it is disabled. The proposed knob will enable it.
>
>Could you rephrase? What does it mean that VFs have SMFS but it's
>disabled? Again - privilege means security, I'd think that it can't have
>security implications if you're freely admitting that it's exposed.

I think the term privilege is misused here, due to the global knob proposed
initially. Anyway the issue is exactly as I explained above, SW steering requires
FW pre-allocated resources and initializations, for VFs it is disabled
since there was no demand for it and FW wanted to save on resources.

Now as SW steering is catching up with FW steering in terms of
functionality, people want it also on VFs to help with rule insertion rate
for use cases other than switchdev and TC, e.g TLS, connection tracking,
etc .. 




