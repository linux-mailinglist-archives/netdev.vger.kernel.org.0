Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22615492CF0
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 19:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347715AbiARSCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 13:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347572AbiARSCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 13:02:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B9AC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 10:02:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 355BD614F3
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FBFC340E0;
        Tue, 18 Jan 2022 18:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642528956;
        bh=aDQBLhgjwYCpl1+nGtH3fiWuWpD7aPGYeQMMQdWCfyE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mb3Gl8APXA7/r1X4JBvDNH3gKNi4hhlmppYczjKumF9LPbA4dJIWSgx6NwokMd+jT
         1JX9Zr5REgrcedao9t5LkQL4jgJDx7RwkPk0/QaZblIlVVcYLeoh7IMl66Tg6D2XEw
         zluIsy3tg4Ihfbm13M90k+nW9oYY3Bgvg2yrmxZOkjk9qOYLKal0NA/aCim76i4BcF
         hvrff9CWxP+SlR92AYcaP69bXbat00uvUqf73tS2UD0jTRhdDutB1BolfFHt7nR38G
         8ECXVg1BCRbotYJY7uDzPCJkJ+Vwf7/nafVAvMt6CaJVtL4TSPVnpXFtTuTL/DV71C
         Sxo31iYry2RtQ==
Date:   Tue, 18 Jan 2022 10:02:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220115061548.4o2uldqzqd4rjcz5@sx1>
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
        <20220115061548.4o2uldqzqd4rjcz5@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 22:15:48 -0800 Saeed Mahameed wrote:
> On 14 Jan 18:34, Jakub Kicinski wrote:
> >> HV is composing the device before giving it to the VM.
> >> VM can always disable certain feature if it doesn't want to use by ethtool or other means.
> >> But here we are discussing about offering/not offering the feature to the VF from HV.
> >> HV can choose to not offer certain features based on some instruction received from orchestration.  
> >
> >I'm still missing why go thru orchestration and HV rather than making
> >the driver load more clever to avoid wasting time on initializing
> >unnecessary caps.  
> 
> unfortunately for "smartnics" of this era, many of these initilizations
> and resources are only manged by FW and the details are hidden away from
> drivers, we need the knobs to tell the FW, hey we don't need all of these
> features for this particular vf, save the resources for something else.
> After all VF users need only a small portion of all the features we offer
> to them, but again unfortunately the FW pre-allocates precious HW
> resources to allow such features per VFs.
> 
> I know in this case smartnic === dumb FW, and sometimes there is no way
> around it, this is the hw arch we have currently, not everything is a
> nice generic flexible resources, not when it has to be wrapped with FW
> "__awesome__" logic ;), and for proper virtualization we need this FW.
> 
> But i totally agree with your point, when we can limit with resources, we
> should limit with resources, otherwise we need a knob to communicate to FW
> what is the user intention for this VF.
> 
> >> Privilege.
> >> VFs have SMFS today, but by default it is disabled. The proposed knob will enable it.  
> >
> >Could you rephrase? What does it mean that VFs have SMFS but it's
> >disabled? Again - privilege means security, I'd think that it can't have
> >security implications if you're freely admitting that it's exposed.  
> 
> I think the term privilege is misused here, due to the global knob proposed
> initially. Anyway the issue is exactly as I explained above, SW steering requires
> FW pre-allocated resources and initializations, for VFs it is disabled
> since there was no demand for it and FW wanted to save on resources.
> 
> Now as SW steering is catching up with FW steering in terms of
> functionality, people want it also on VFs to help with rule insertion rate
> for use cases other than switchdev and TC, e.g TLS, connection tracking,
> etc .. 

Sorry long weekend here, thanks for the explanation!

Where do we stand? Are you okay with an explicit API for enabling /
disabling VF features? If SMFS really is about conntrack and TLS maybe
it can be implied by the delegation of appropriate bits meaningful to
netdev world?
