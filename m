Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F4A4553F1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243052AbhKRExC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:53:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243045AbhKREw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:52:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18D1361AA9;
        Thu, 18 Nov 2021 04:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637210998;
        bh=EdrBJtFyZU7Qsg46P7CP2x6ybwCyntc4rOKfRN5PTCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PmzPjN/jxDGfJftekaTpHykA7zQk2URTVYqxqz9gXuHOoXVjRAKxwVSOYfRnsW9l+
         lLSEMrhv/MPzmXZEwcIyWTV7J2rQbsI6C+yOWwuqI5/IHLzpp+raDDL90D621AN8j9
         po40W2jKmfAdtfk2Iunz6QjyySIapO7YYovfnew7st3mLlGvXX1tbKC+Xzh5IpbLE3
         tGiTBdnDaoI87yyoz7uVgRu1TYP/i6NYk2QawfY+eHnj5hBl74LYmMfcz7tnaDfMjc
         DOACU3B5zLCX9GjPo8tTqte/v8wGBDduCwfVzc43KXelAppK8Zr7VYVZLLj6muKZcL
         4IeY5EpVgFG6w==
Date:   Wed, 17 Nov 2021 20:49:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
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
Message-ID: <20211117204956.6a36963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6176a137a4ded48501e8a06fda0e305f9cfc787c.1637173517.git.leonro@nvidia.com>
References: <cover.1637173517.git.leonro@nvidia.com>
        <6176a137a4ded48501e8a06fda0e305f9cfc787c.1637173517.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 20:26:21 +0200 Leon Romanovsky wrote:
> -	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
> -
> -	mutex_lock(&devlink->lock);
> -	resource = devlink_resource_find(devlink, NULL, resource_id);
> -	if (resource) {
> -		err = -EINVAL;
> -		goto out;
> -	}
> +	WARN_ON(devlink_resource_find(devlink, NULL, resource_id));

This is not atomic with the add now.

>  	resource = kzalloc(sizeof(*resource), GFP_KERNEL);
>  	if (!resource) {
> @@ -9851,7 +9843,17 @@ int devlink_resource_register(struct devlink *devlink,
>  		goto out;
>  	}
>  
> -	if (top_hierarchy) {
> +	resource->name = resource_name;
> +	resource->size = resource_size;
> +	resource->size_new = resource_size;
> +	resource->id = resource_id;
> +	resource->size_valid = true;
> +	memcpy(&resource->size_params, size_params,
> +	       sizeof(resource->size_params));
> +	INIT_LIST_HEAD(&resource->resource_list);
> +
> +	mutex_lock(&devlink->lock);
