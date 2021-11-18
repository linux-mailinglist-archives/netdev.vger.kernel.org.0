Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31E34555C6
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 08:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243964AbhKRHgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 02:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244051AbhKRHfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 02:35:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33D7261269;
        Thu, 18 Nov 2021 07:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637220744;
        bh=2VdstZWq6DPnEC6DxQBReel0V2k00OcC7KSNTUSs0UM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L5+VP4Ka3rsFmALNqTLemtiG0EWqk+dRJRopAI2LWM6KvO3vHptMPQgscHsM3zQWO
         5uvHosaFkH4jIr0zwZ+asDr75n2vrU+231CRqcF+Pw5Sk4EzkPvagD0ZGdC7jiCVuv
         0jXJzMu6YS2U3syEpyvfhPMcnf9lJbLIFEtTGvTjk6ds8oBFjqKC4u1/mPLmspKR/W
         lWyISppbmOhxIE9Ng6ScATnvTBGadUU3KUAiGDXivu/0aCpCbVL86uzYh/sj2nVFuH
         IMPEsOt7MxJ/hTkBPnZcQAmjYxu3Y0epF+vD1ebs2tgLfoVt2x41iaJWw9HrENEdGs
         bQAAsrgAD9Rpg==
Date:   Thu, 18 Nov 2021 09:32:20 +0200
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
Subject: Re: [PATCH net-next 4/6] devlink: Clean registration of devlink port
Message-ID: <YZYBhArHOAbLfOUb@unreal>
References: <cover.1637173517.git.leonro@nvidia.com>
 <9c3eb77a90a2be10d5c637981a8047160845f60f.1637173517.git.leonro@nvidia.com>
 <20211117204929.4bd24597@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117204929.4bd24597@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 08:49:29PM -0800, Jakub Kicinski wrote:
> On Wed, 17 Nov 2021 20:26:20 +0200 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > devlink_port_register() is in-kernel API and as such can't really fail
> > as long as driver author didn't make a mistake by providing already existing
> > port index. Instead of relying on various error prints from the driver,
> > convert the existence check to be WARN_ON(), so such a mistake will be
> > caught easier.
> > 
> > As an outcome of this conversion, it was made clear that this function
> > should be void and devlink->lock was intended to protect addition to
> > port_list.
> 
> Leave this error checking in please.

Are you referring to error checks in the drivers or the below section
from devlink_port_register()?

       mutex_lock(&devlink->lock);
       if (devlink_port_index_exists(devlink, port_index)) {
               mutex_unlock(&devlink->lock);
               return -EEXIST;
       }

Because if it is latter, any driver (I didn't find any) that will rely
on this -EEXIST field should have some sort of locking in top level.
Otherwise nothing will prevent from doing port unregister right
before "return --EXEEXIST".

So change to WARN_ON() will be much more effective in finding wrong
drivers, because they manage port_index and not devlink.

And because this function can't fail, the drivers have a plenty of dead
code.

Thanks
