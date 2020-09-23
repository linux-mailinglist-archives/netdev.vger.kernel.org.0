Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0C2275903
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 15:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgIWNoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 09:44:30 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19255 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgIWNoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 09:44:19 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6b51260002>; Wed, 23 Sep 2020 06:44:06 -0700
Received: from [10.21.180.144] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 23 Sep
 2020 13:44:11 +0000
Subject: Re: [PATCH net-next RFC v5 00/15] Add devlink reload action and limit
 level options
To:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <be630005-f2ab-1632-db6f-c40486325f27@nvidia.com>
Date:   Wed, 23 Sep 2020 16:44:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600868646; bh=ztM+dxNwC5iNzN7clw8B9GKxUG4Nljlrim7J50F26Tk=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=NNCjJ+Bh0Du8t3VnF6bzeNSuGz3eEm80IYtyv0z79eGN6zKLYuKW9tQQmC9H5CZ2b
         nQM2fOHKpDIxeQR3ZkYxqr6Igdilmpzi/tH2eXPU7PqPqp+2tskdJnclVCVygZ/x+7
         k43iLEXEen/Eql6qMEg9WB4zvAM97zeisRuphmeeFIvUluucpYmcVKsJ97BWvw+VB+
         oZB3H8GYGpHj6tvA83znbik2Yu1HY3wucUkIzWXYZcPEaaMa1WBr8haI4XzP6OARxR
         djxlYoqn8AWPwwo/N1fRwNwXSamNgzAChRIV4d5pXLY3WhleOHdbj6zo5SfIdPLAXr
         g5BmqZ77yrHxg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I see no more comments, we reached consensus on API.

I will finalize my work and re-send as a feature to net-next.


Thanks,

Moshe.

On 9/18/2020 7:06 PM, Moshe Shemesh wrote:
> Introduce new options on devlink reload API to enable the user to select
> the reload action required and contrains limits on these actions that he
> may want to ensure. Complete support for reload actions in mlx5.
> The following reload actions are supported:
>    driver_reinit: driver entities re-initialization, applying devlink-param
>                   and devlink-resource values.
>    fw_activate: firmware activate.
>
> The uAPI is backward compatible, if the reload action option is omitted
> from the reload command, the driver reinit action will be used.
> Note that when required to do firmware activation some drivers may need
> to reload the driver. On the other hand some drivers may need to reset
> the firmware to reinitialize the driver entities. Therefore, the devlink
> reload command returns the actions which were actually performed.
>
> By default reload actions are not limited and driver implementation may
> include reset or downtime as needed to perform the actions.
> However, if limit_level is selected, the driver should perform only if
> it can do it while keeping the limit level constrains.
> Reload action limit level added:
>    no_reset: No reset allowed, no down time allowed, no link flap and no
>              configuration is lost.
>
> Each driver which supports devlink reload command should expose the
> reload actions and limit levels supported.
>
> Add reload action stats to hold the history per reload action per limit
> level. For example, the number of times fw_activate has been done on
> this device since the driver module was added or if the firmware
> activation was done with or without reset.
>
> Patch 1-2 add the new API reload action and reload action limit level
>            option to devlink reload.
> Patch 3 adds reload actions stats.
> Patch 4 exposes the reload actions stats on devlink dev get.
> Patches 5-10 add support on mlx5 for devlink reload action fw_activate
>              and handle the firmware reset events.
> Patches 11-12 add devlink enable remote dev reset parameter and use it
>               in mlx5.
> Patches 13-14 mlx5 add devlink reload action limit level no_reset
>                support for fw_activate reload action.
> Patch 15 adds documentation file devlink-reload.rst
>
>
> Moshe Shemesh (15):
>    devlink: Add reload action option to devlink reload command
>    devlink: Add reload action limit level
>    devlink: Add reload action stats
>    devlink: Add reload actions stats to dev get
>    net/mlx5: Add functions to set/query MFRL register
>    net/mlx5: Set cap for pci sync for fw update event
>    net/mlx5: Handle sync reset request event
>    net/mlx5: Handle sync reset now event
>    net/mlx5: Handle sync reset abort event
>    net/mlx5: Add support for devlink reload action fw activate
>    devlink: Add enable_remote_dev_reset generic parameter
>    net/mlx5: Add devlink param enable_remote_dev_reset support
>    net/mlx5: Add support for fw live patch event
>    net/mlx5: Add support for devlink reload action limit level no reset
>    devlink: Add Documentation/networking/devlink/devlink-reload.rst
>
>   .../networking/devlink/devlink-params.rst     |   6 +
>   .../networking/devlink/devlink-reload.rst     |  79 +++
>   Documentation/networking/devlink/index.rst    |   1 +
>   drivers/net/ethernet/mellanox/mlx4/main.c     |  16 +-
>   .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>   .../net/ethernet/mellanox/mlx5/core/devlink.c | 122 ++++-
>   .../mellanox/mlx5/core/diag/fw_tracer.c       |  31 ++
>   .../mellanox/mlx5/core/diag/fw_tracer.h       |   1 +
>   .../ethernet/mellanox/mlx5/core/fw_reset.c    | 454 ++++++++++++++++++
>   .../ethernet/mellanox/mlx5/core/fw_reset.h    |  19 +
>   .../net/ethernet/mellanox/mlx5/core/health.c  |  35 +-
>   .../net/ethernet/mellanox/mlx5/core/main.c    |  13 +
>   .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
>   drivers/net/ethernet/mellanox/mlxsw/core.c    |  27 +-
>   drivers/net/netdevsim/dev.c                   |  17 +-
>   include/linux/mlx5/device.h                   |   1 +
>   include/linux/mlx5/driver.h                   |   4 +
>   include/net/devlink.h                         |  21 +-
>   include/uapi/linux/devlink.h                  |  41 ++
>   net/core/devlink.c                            | 339 ++++++++++++-
>   20 files changed, 1179 insertions(+), 52 deletions(-)
>   create mode 100644 Documentation/networking/devlink/devlink-reload.rst
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
>
