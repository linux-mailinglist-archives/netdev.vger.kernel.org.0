Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C97F25C986
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgICTba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728304AbgICTb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 15:31:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9419320722;
        Thu,  3 Sep 2020 19:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599161486;
        bh=3l0JRzmsPy9Q0ZQ7mtR9eKJTnZmVEXsg+gipltyqX6A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YFsN76VT9ihDfzxc9omxO6nR8bedoRWbCpHRfeaKH1whBtuYvLrFzA39TynYqS6yw
         r1dDGubhjb7LpHLmwlUROexSK5itWDZ40uM1qid4dr+uQQoaC0rKEdQy6TRD0e7Dlp
         j5j3ZOPPpwgf7H536mLb8WWLjeuOFn+hWRrfQMcM=
Date:   Thu, 3 Sep 2020 12:31:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Parav Pandit <parav@nvidia.com>, Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Message-ID: <20200903123123.7e6025ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903055439.GA2997@nanopsycho.orion>
References: <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901081906.GE3794@nanopsycho.orion>
        <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901091742.GF3794@nanopsycho.orion>
        <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200902080011.GI3794@nanopsycho.orion>
        <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200903055439.GA2997@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 07:54:39 +0200 Jiri Pirko wrote:
> Wed, Sep 02, 2020 at 05:23:58PM CEST, kuba@kernel.org wrote:
> >On Wed, 2 Sep 2020 10:00:11 +0200 Jiri Pirko wrote:  
> >>>> I didn't quite get the fact that you want to not show controller ID on the local
> >>>> port, initially.    
> >>> Mainly to not_break current users.    
> >> 
> >> You don't have to take it to the name, unless "external" flag is set.
> >> 
> >> But I don't really see the point of showing !external, cause such
> >> controller number would be always 0. Jakub, why do you think it is
> >> needed?  
> >
> >It may seem reasonable for a smartNIC where there are only two
> >controllers, and all you really need is that external flag. 
> >
> >In a general case when users are trying to figure out the topology
> >not knowing which controller they are sitting at looks like a serious
> >limitation.  
> 
> I think we misunderstood each other. I never proposed just "external"
> flag.

Sorry, I was just saying that assuming a single host SmartNIC the
controller ID is not necessary at all. You never suggested that, I did. 
Looks like I just confused everyone with that comment :(

Different controller ID for different PFs but the same PCIe link would
be very wrong. So please clarify - if I have a 2 port smartNIC, with on
PCIe link to the host, and the embedded controller - what would I see?

> What I propose is either:
> 1) ecnum attribute absent for local
>    ecnum attribute absent set to 0 for external controller X
>    ecnum attribute absent set to 1 for external controller Y
>    ...
> 
> or:
> 2) ecnum attribute absent for local, external flag set to false
>    ecnum attribute absent set to 0 for external controller X, external flag set to true
>    ecnum attribute absent set to 1 for external controller Y, external flag set to true

I'm saying that I do want to see the the controller ID for all ports.

So:

3) local:   { "controller ID": x }
   remote1: { "controller ID": y, "external": true }
   remote1: { "controller ID": z, "external": true }

We don't have to put the controller ID in the name for local ports, but
the attribute should be reported. AFAIU name was your main concern, no?

> >Example - multi-host system and you want to know which controller you
> >are to run power cycle from the BMC side.
> >
> >We won't be able to change that because it'd change the names for you.  
