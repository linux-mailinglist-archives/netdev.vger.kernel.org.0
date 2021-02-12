Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E0B31A346
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 18:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhBLRGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 12:06:15 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51090 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhBLRFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 12:05:53 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11CH3p59044501;
        Fri, 12 Feb 2021 11:03:51 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1613149431;
        bh=Z3TcTypt+Mt5FAf3Iq7QLSvCNUViIN7BJJlQSIOTRD8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=bApGhzs/wsXy2YufD9ZW9l+z7nBZf2YNSQdfdC1FaAKSr0UiM6bYTuVvBZRRIXMIg
         inYbJ/ZK48K1YECAa3Nus0j+mcFKAOIg0JnYOT3/MCSI3UlVuhu9+lojhYPtE2ihyP
         zcpzi3ARqT7Yo/Id/jbjYaEnJyCXaWIbrn6iv9Ls=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11CH3ovR058671
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 12 Feb 2021 11:03:50 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 12
 Feb 2021 11:03:50 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 12 Feb 2021 11:03:50 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11CH3iPe083194;
        Fri, 12 Feb 2021 11:03:45 -0600
Subject: Re: [PATCH v5 net-next 01/10] net: switchdev: propagate extack to
 port attributes
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
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20210212151600.3357121-1-olteanv@gmail.com>
 <20210212151600.3357121-2-olteanv@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <0765d09e-2088-247e-7053-86e73abcceef@ti.com>
Date:   Fri, 12 Feb 2021 19:03:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210212151600.3357121-2-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/02/2021 17:15, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When a struct switchdev_attr is notified through switchdev, there is no
> way to report informational messages, unlike for struct switchdev_obj.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v5:
> Rebased on top of AM65 CPSW driver merge.
> 
> Changes in v4:
> None.
> 
> Changes in v3:
> None.
> 
> Changes in v2:
> Patch is new.
> 
>   .../ethernet/marvell/prestera/prestera_switchdev.c    |  3 ++-
>   .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c  |  3 ++-
>   drivers/net/ethernet/mscc/ocelot_net.c                |  3 ++-
>   drivers/net/ethernet/ti/am65-cpsw-switchdev.c         |  3 ++-
>   drivers/net/ethernet/ti/cpsw_switchdev.c              |  3 ++-
>   include/net/switchdev.h                               |  6 ++++--
>   net/dsa/slave.c                                       |  3 ++-
>   net/switchdev/switchdev.c                             | 11 ++++++++---
>   8 files changed, 24 insertions(+), 11 deletions(-)
> 

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
