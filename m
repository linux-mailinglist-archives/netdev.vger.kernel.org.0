Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866E4456795
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhKSBvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231176AbhKSBvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 20:51:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E54A761401;
        Fri, 19 Nov 2021 01:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637286495;
        bh=4d92tHYFCLa5amrWHWA76Kj8uMX5dGltn+NbKmez1tU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d0ewhYM2pOC/SgWaoIHlstPfakFQuTIfgMjCvqYt8IA4Ry0RWvoRa2wQ21EebHMwg
         2dzonFBqs8HDNANLbTRKjzTGNTLjs+25PJuReseLTgdIlGV/H/TEM1DRvcsmzKFoCy
         uyJAOjRB6MVBnPH29MEXFkqA+IWlBHp2eou4zEzEkdlnyZAC7ETqVuJOJfoiKcAVrf
         eAnT5wbHq3p/ovYz4OgsLfAbgr4WZ9J0MqDCekPrf/U8LNpUYdf4NlCxLRmbsQJghn
         d8lJuVUfdbw5d5p+Hv8sLFgQsisbblajIACHMjfmlM38qxhi/78duZ6cnMOVt82mzv
         DjpXRH9pxl6Og==
Date:   Thu, 18 Nov 2021 17:48:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Message-ID: <20211118174813.54c3731f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZYFvIK9mkP107tD@unreal>
References: <cover.1637173517.git.leonro@nvidia.com>
        <6176a137a4ded48501e8a06fda0e305f9cfc787c.1637173517.git.leonro@nvidia.com>
        <20211117204956.6a36963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZYFvIK9mkP107tD@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 09:50:20 +0200 Leon Romanovsky wrote:
> And it shouldn't. devlink_resource_find() will return valid resource only
> if there driver is completely bogus with races or incorrect allocations of
> resource_id.
> 
> devlink_*_register(..)
>  mutex_lock(&devlink->lock);
>  if (devlink_*_find(...)) {
>     mutex_unlock(&devlink->lock);
>     return ....;
>  }
>  .....
> 
> It is almost always wrong from locking and layering perspective the pattern above,
> as it is racy by definition if not protected by top layer.
> 
> There are exceptions from the rule above, but devlink is clearly not the
> one of such exceptions.

Just drop the unnecessary "cleanup" patches and limit the amount 
of driver code we'll have to revert if your approach fails.

I spent enough time going back and forth with you.

Please.
