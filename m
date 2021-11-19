Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765F94571C4
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhKSPl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:41:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235250AbhKSPl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 10:41:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34B9A6112E;
        Fri, 19 Nov 2021 15:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637336337;
        bh=SiDyJ/VKAeOoI+SIN4+qGK8ta2JLIbvMWVnitDoSmOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SHoopEN12ABnOJrQbGs8O4BbaND7QMXx48wiMBfW/8wzoXRR2ZcjeK7A1l1VuChGU
         Fuvl9doTKs+BETnCb+vWs32+C6Is7JnTr00XR3VcWVsnMd1DtxETI4xwPJgPbtzNo3
         pW4hnUxqvm5DJDMd6QDv+KL0OJpRdwOkNW1HZ4NilDKCcLoT963XPkoicDMbI/pDR9
         PYZML153hA+AxUyOvmTwJNfnBVfUfcebUttiMN6eaCN2WZ4kCbfTM9hMWoC8bUER3V
         ZXeBu1SjuFEwMAWoe8ghOZ+MbxJZhwjCGWB2YnA8Wzwn0z0vOjPI/tgdVSzjCf2sHp
         ruRiK3XHBQl2A==
Date:   Fri, 19 Nov 2021 17:38:53 +0200
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
Message-ID: <YZfFDSnnjOG+wSyK@unreal>
References: <cover.1637173517.git.leonro@nvidia.com>
 <6176a137a4ded48501e8a06fda0e305f9cfc787c.1637173517.git.leonro@nvidia.com>
 <20211117204956.6a36963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZYFvIK9mkP107tD@unreal>
 <20211118174813.54c3731f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118174813.54c3731f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 05:48:13PM -0800, Jakub Kicinski wrote:
> On Thu, 18 Nov 2021 09:50:20 +0200 Leon Romanovsky wrote:
> > And it shouldn't. devlink_resource_find() will return valid resource only
> > if there driver is completely bogus with races or incorrect allocations of
> > resource_id.
> > 
> > devlink_*_register(..)
> >  mutex_lock(&devlink->lock);
> >  if (devlink_*_find(...)) {
> >     mutex_unlock(&devlink->lock);
> >     return ....;
> >  }
> >  .....
> > 
> > It is almost always wrong from locking and layering perspective the pattern above,
> > as it is racy by definition if not protected by top layer.
> > 
> > There are exceptions from the rule above, but devlink is clearly not the
> > one of such exceptions.
> 
> Just drop the unnecessary "cleanup" patches and limit the amount 
> of driver code we'll have to revert if your approach fails.

My approach works, exactly like it works in other subsystems.
https://lore.kernel.org/netdev/cover.1636390483.git.leonro@nvidia.com/

We are waiting to see your proposal extended to support parallel devlink
execution and to be applied to real drivers.
https://lore.kernel.org/netdev/20211030231254.2477599-1-kuba@kernel.org/

Anyway, you are maintainer, you want half work, you will get half work.

> 
> I spent enough time going back and forth with you.
> 
> Please.

Disagreements are hard for everyone, not only for you.

Thanks
