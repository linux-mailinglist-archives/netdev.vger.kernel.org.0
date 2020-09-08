Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DCE261B08
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbgIHSwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgIHSuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 14:50:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1DC2067C;
        Tue,  8 Sep 2020 18:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599591008;
        bh=voXxilmhkYPYQ5Z7f5rN9GxX8n8POHXdRLscYxWLJa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R7nG8sfcxe7vlJkhN8P7WQNgIAATDpguIRYuUAl+0tPSMwgi8g4NGAX4EPaaj415U
         dZrmW+bObw2eJR1EB0RJuY2EEqVJQ7oytOJMJ7iPwO8dGoW89XTa6seOgo3jSppd1G
         htGlV2aSq8TI7D99BiyN9vGDUEhonwQQiXr8s5f8=
Date:   Tue, 8 Sep 2020 11:50:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 5/6] devlink: Introduce controller number
Message-ID: <20200908115006.3b9ba943@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908144241.21673-6-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200908144241.21673-1-parav@mellanox.com>
        <20200908144241.21673-6-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 17:42:40 +0300 Parav Pandit wrote:
> A devlink port may be for a controller consist of PCI device.

Humm?

> A devlink instance holds ports of two types of controllers.
> (1) controller discovered on same system where eswitch resides
> This is the case where PCI PF/VF of a controller and devlink eswitch
> instance both are located on a single system.
> (2) controller located on external host system.
> This is the case where a controller is located in one system and its
> devlink eswitch ports are located in a different system.
> 
> When a devlink eswitch instance serves the devlink ports of both
> controllers together, PCI PF/VF numbers may overlap.
> Due to this a unique phys_port_name cannot be constructed.
> 
> For example in below such system controller-A and controller-B, each has
> PCI PF pf0 whose eswitch ports are present in controller-A.
> These results in phys_port_name as "pf0" for both.
> Similar problem exists for VFs and upcoming Sub functions.
> 
> An example view of two controller systems:
> 
>                 -----------------------------------------------------
>                 |                                                   |
>                 |           --------- ---------                     |
> -------------   |           | vf(s) | | sf(s) |                     |
> | server    |   | -------   ----/---- ---/-----  -------            |
> | pci rc    |=====| pf0 |______/________/        | pf1 |            |
> | connection|   | -------                        -------            |
> -------------   |     | controller-B (no eswitch) (controller num=1)|
>                 ------|----------------------------------------------
>                 (internal wire)
>                       |
>                 -----------------------------------------------------
>                 |  devlink eswitch ports and reps                   |
>                 |  ---------------------------------------------    |
>                 |  |ctrl-A | ctrl-B | ctrl-A | ctrl-B | ctrl-B |    |
>                 |  |pf0    | pf0    | pf0vfN | pf0vfN | pf0sfN |    |
>                 |  ---------------------------------------------    |

                                       ^^^^^^^^

ctrl-A doesn't have VFs, but sfs below.

pf1 reprs are not listed.

Perhaps it'd be clearer if controllers where not interleaved?

>                 |                                                   |
>                 |           ---------                               |
>                 |           | sf(s) |                               |
>                 | -------   ---/-----    -------                    |
>                 | | pf0 |_____/          | pf1 |                    |
>                 | -------                -------                    |
>                 |                                                   |
>                 |  local controller-A (eswitch) (controller num=0)  |
>                 -----------------------------------------------------
