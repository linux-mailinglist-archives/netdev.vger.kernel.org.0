Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571B62C46F7
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 18:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbgKYRl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 12:41:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgKYRl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 12:41:59 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D3B206D9;
        Wed, 25 Nov 2020 17:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606326119;
        bh=jHP291mcUPz+K7cQI2VXxA8xVclaRST63TMqUiC+83c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PMG+5LYPAaIdXDPqNkzwhND7p4ssnUqozHoAmZls8rDjymmHNVBqbfVb/YmigkpTh
         IdpwYMg4mVJGaZPIsPSxujbYhh/kUPuEz/CVzmgeIfyYlpZVzpY+c+mdiVzsUnomGq
         Tt0zsCQ+lgI7lCivT/3iOghVU9Mh4a6S88Ec05S4=
Date:   Wed, 25 Nov 2020 09:41:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net 1/2] devlink: Hold rtnl lock while reading netdev
 attributes
Message-ID: <20201125094157.737d37aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB43224D7843C4E83D1100AC53DCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201122061257.60425-1-parav@nvidia.com>
        <20201122061257.60425-2-parav@nvidia.com>
        <20201124142910.14cadc35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43224995BFBAE791FE75552ADCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201125083020.0a26ec0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43224D7843C4E83D1100AC53DCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 17:21:41 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, November 25, 2020 10:00 PM
> > 
> > On Wed, 25 Nov 2020 07:13:40 +0000 Parav Pandit wrote:  
> > > > Maybe even add a check that drivers
> > > > which support reload set namespace local on their netdevs.  
> > > This will break the backward compatibility as orchestration for VFs
> > > are not using devlink reload, which is supported very recently. But
> > > yes, for SF who doesn't have backward compatibility issue, as soon as
> > > initial series is merged, I will mark it as local, so that
> > > orchestration doesn't start on wrong foot.  
> > 
> > Ah, right, that will not work because of the shenanigans you guys play with
> > the uplink port. If all reprs are NETNS_LOCAL it'd not be an issue.  
> I am not sure what secret are you talking about with uplink.

I'm referring to Mellanox conflating PF with uplink. It's not a secret,
we argued about it in the past.

> I am taking about the SF netdevice to have the NETNS_LOCAL not the SF rep.
> SF rep anyway has NETNS_LOCAL set.

All reps build by mlx5e_build_rep_netdev() have NETNS_LOCAL.

> I do not follow your comment - 'that will not work'. Can you please explain?

My half-baked suggestion was to basically add a:

	WARN_ON(ops->reload_down && ops->reload_up &&
		!(netdev->priv & NETIF_F_NETNS_LOCAL));

to devlink_port_type_netdev_checks(). Given if device has a reload
callback devlink is the way to change netns. But yeah, we can't break
existing behavior so your uplink has to be movable and can't have
NETNS_LOCAL. IOW adding the WARN_ON() won't work.

Hope this is crystal clear now.

> Do you mean I should take care for SF's netdevice to have NETNS_LOCAL in first patchset or you mean setting NETNS_LOCAL for VF's Netdev will not work?
> If its later, sure it will break the backward compatibility, so will not do as default.



