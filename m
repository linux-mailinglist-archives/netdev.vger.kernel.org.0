Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7EF31A085
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhBLOTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:19:20 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37516 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhBLOS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 09:18:59 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11CEHfop130522;
        Fri, 12 Feb 2021 08:17:41 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1613139461;
        bh=WmmabalXCESs8CB8uP8Q8SZk6UzlgxTihvQdHBSNYEE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=B01aH85eMVZcznf05o/MpJBbBbhq35/60uIfToXQC5MvJiznqGwr3hUF/4FhXJqf8
         9Y37zCucS8ilU8l3Y66TBH2gAvMQj1KyXG78ec4bI4I9EY2WOy34vz58mze3RgeOny
         qbn0s6WykcQ3ngtuvvuNp6WHIg4RZvmgpiy270JI=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11CEHfmd039187
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 12 Feb 2021 08:17:41 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 12
 Feb 2021 08:17:41 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 12 Feb 2021 08:17:41 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11CEHaDu075950;
        Fri, 12 Feb 2021 08:17:37 -0600
Subject: Re: [PATCH v4 net-next 0/9] Cleanup in brport flags switchdev offload
 for DSA
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20210212010531.2722925-1-olteanv@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <97ae293a-f59d-cc7c-21a6-f83880c69c71@ti.com>
Date:   Fri, 12 Feb 2021 16:17:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210212010531.2722925-1-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/02/2021 03:05, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The initial goal of this series was to have better support for
> standalone ports mode on the DSA drivers like ocelot/felix and sja1105.
> This turned out to require some API adjustments in both directions:
> to the information presented to and by the switchdev notifier, and to
> the API presented to the switch drivers by the DSA layer.
> 
> Vladimir Oltean (9):
>    net: switchdev: propagate extack to port attributes
>    net: bridge: offload all port flags at once in br_setport
>    net: bridge: don't print in br_switchdev_set_port_flag
>    net: dsa: configure better brport flags when ports leave the bridge
>    net: switchdev: pass flags and mask to both {PRE_,}BRIDGE_FLAGS
>      attributes
>    net: dsa: act as ass passthrough for bridge port flags
>    net: mscc: ocelot: use separate flooding PGID for broadcast
>    net: mscc: ocelot: offload bridge port flags to device
>    net: dsa: sja1105: offload bridge port flags to device
> 
>   drivers/net/dsa/b53/b53_common.c              |  91 ++++---
>   drivers/net/dsa/b53/b53_priv.h                |   2 -
>   drivers/net/dsa/mv88e6xxx/chip.c              | 163 ++++++++++---
>   drivers/net/dsa/mv88e6xxx/chip.h              |   6 +-
>   drivers/net/dsa/mv88e6xxx/port.c              |  52 ++--
>   drivers/net/dsa/mv88e6xxx/port.h              |  19 +-
>   drivers/net/dsa/ocelot/felix.c                |  22 ++
>   drivers/net/dsa/sja1105/sja1105.h             |   2 +
>   drivers/net/dsa/sja1105/sja1105_main.c        | 222 +++++++++++++++++-
>   drivers/net/dsa/sja1105/sja1105_spi.c         |   6 +
>   .../marvell/prestera/prestera_switchdev.c     |  26 +-
>   .../mellanox/mlxsw/spectrum_switchdev.c       |  53 +++--
>   drivers/net/ethernet/mscc/ocelot.c            | 100 +++++++-
>   drivers/net/ethernet/mscc/ocelot_net.c        |  52 +++-
>   drivers/net/ethernet/rocker/rocker_main.c     |  10 +-
>   drivers/net/ethernet/ti/cpsw_switchdev.c      |  27 ++-
>   drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  34 ++-
>   include/net/dsa.h                             |  10 +-
>   include/net/switchdev.h                       |  13 +-
>   include/soc/mscc/ocelot.h                     |  20 +-
>   net/bridge/br_netlink.c                       | 116 +++------
>   net/bridge/br_private.h                       |   6 +-
>   net/bridge/br_switchdev.c                     |  23 +-
>   net/bridge/br_sysfs_if.c                      |   7 +-
>   net/dsa/dsa_priv.h                            |  11 +-
>   net/dsa/port.c                                |  76 ++++--
>   net/dsa/slave.c                               |  10 +-
>   net/switchdev/switchdev.c                     |  11 +-
>   28 files changed, 870 insertions(+), 320 deletions(-)
> 

Sorry, but we seems just added more work for you.
https://lore.kernel.org/patchwork/cover/1379380/

-- 
Best regards,
grygorii
