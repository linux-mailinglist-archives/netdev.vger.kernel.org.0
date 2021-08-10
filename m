Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7CF3E5A0D
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbhHJMhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236886AbhHJMhK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 08:37:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F7E7604DC;
        Tue, 10 Aug 2021 12:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628599008;
        bh=65wwyZ1PzsTjVVRVB8uytBblEiEgZgMvnsoHRtYi+4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h+LM/Sc5HKau/FXlituogSJez40C0Za87secHQ8Y8xGr/etTL57hF7STihj5eAEW0
         vWUwYtq5tUkpP/H1I5WeMU55oAeiPWkFGDVXM31alULgQbOZpKXBhkxd3T6Q2/wZbg
         2F71pgzZ9VKXCO1isfwKcxdmLzQFrEpaWmGQtL3C/ZIj6CU2Yg54lzKMiw8MzaxAql
         EGWA5SKO4EOac5sQZteftPIKBVaOeP03Abs8CqasWtkaTrSOVOSFq5SYa8BZJndS0P
         NJcx8D4d2NfiIxOH7VU1V/kwIITuIXNnOoy2DpGy7c+JJqUJqmHzlmzv1o+bFX3Eke
         BUV0HfJy2xujA==
Date:   Tue, 10 Aug 2021 15:36:44 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-s390@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH v2 net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
Message-ID: <YRJy3F6lXuKNQIpl@unreal>
References: <20210810115024.1629983-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810115024.1629983-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:50:24PM +0300, Vladimir Oltean wrote:
> The blamed commit a new field to struct switchdev_notifier_fdb_info, but
> did not make sure that all call paths set it to something valid. For
> example, a switchdev driver may emit a SWITCHDEV_FDB_ADD_TO_BRIDGE
> notifier, and since the 'is_local' flag is not set, it contains junk
> from the stack, so the bridge might interpret those notifications as
> being for local FDB entries when that was not intended.
> 
> To avoid that now and in the future, zero-initialize all
> switchdev_notifier_fdb_info structures created by drivers such that all
> newly added fields to not need to touch drivers again.
> 
> Fixes: 2c4eca3ef716 ("net: bridge: switchdev: include local flag in FDB notifications")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
> ---
> v1->v2: use an empty struct initializer as opposed to memset, as
>         suggested by Leon Romanovsky
> 
>  drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 4 ++--
>  drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c       | 2 +-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c      | 4 ++--
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 2 +-
>  drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c    | 2 +-
>  drivers/net/ethernet/rocker/rocker_main.c                  | 2 +-
>  drivers/net/ethernet/rocker/rocker_ofdpa.c                 | 2 +-
>  drivers/net/ethernet/ti/am65-cpsw-switchdev.c              | 2 +-
>  drivers/net/ethernet/ti/cpsw_switchdev.c                   | 2 +-
>  drivers/s390/net/qeth_l2_main.c                            | 4 ++--
>  net/dsa/slave.c                                            | 2 +-
>  11 files changed, 14 insertions(+), 14 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
