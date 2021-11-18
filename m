Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF445455613
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 08:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244030AbhKRHyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 02:54:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244093AbhKRHxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 02:53:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D6C61AF0;
        Thu, 18 Nov 2021 07:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637221824;
        bh=KAG7SN0Nsukz5N3+M2JeOStH3aani0FQz1yVYpMxlI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U/rCN1F5P7OJGKozjYIbfysxd1GNoJ7r2XbViuikvAKkPDKKnksCbzJa2IlbHnRax
         GoWEfisdL0drlW2opov+3kvSMtdymX3KwC9CSx24ibrIoE2wHpH/c7irksbGH7gCXW
         Q0h6qL7SSdphsv4RS+Mfpa5oRKD4q0K89KOfSTE4myt5TH3/fTYkWlEfO4FLCP3sP+
         0zdH/5WvExcVwBbWzxoMWRPvlXY+fKCPsUn24Llx2zkf79eennDsgYutbug/fZ1agB
         KhkNMnssPhXu7tzV+BBf3QYXcyhYEGTax+k0QCz2kH4UZ+pBEFmZQ+Et0intFBkLWn
         4KRAyyeFsgTjA==
Date:   Thu, 18 Nov 2021 09:50:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Aya Levin <ayal@mellanox.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, drivers@pensando.io,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 5/6] devlink: Reshuffle resource registration
 logic
Message-ID: <YZYFvIK9mkP107tD@unreal>
References: <cover.1637173517.git.leonro@nvidia.com>
 <6176a137a4ded48501e8a06fda0e305f9cfc787c.1637173517.git.leonro@nvidia.com>
 <20211117204956.6a36963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117204956.6a36963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 08:49:56PM -0800, Jakub Kicinski wrote:
> On Wed, 17 Nov 2021 20:26:21 +0200 Leon Romanovsky wrote:
> > -	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
> > -
> > -	mutex_lock(&devlink->lock);
> > -	resource = devlink_resource_find(devlink, NULL, resource_id);
> > -	if (resource) {
> > -		err = -EINVAL;
> > -		goto out;
> > -	}
> > +	WARN_ON(devlink_resource_find(devlink, NULL, resource_id));
> 
> This is not atomic with the add now.

And it shouldn't. devlink_resource_find() will return valid resource only
if there driver is completely bogus with races or incorrect allocations of
resource_id.

devlink_*_register(..)
 mutex_lock(&devlink->lock);
 if (devlink_*_find(...)) {
    mutex_unlock(&devlink->lock);
    return ....;
 }
 .....

It is almost always wrong from locking and layering perspective the pattern above,
as it is racy by definition if not protected by top layer.

There are exceptions from the rule above, but devlink is clearly not the
one of such exceptions.

Thanks
