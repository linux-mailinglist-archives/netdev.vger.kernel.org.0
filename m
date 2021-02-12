Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF7B31A34C
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 18:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBLRIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 12:08:38 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51682 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhBLRId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 12:08:33 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11CH6bsR045358;
        Fri, 12 Feb 2021 11:06:37 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1613149597;
        bh=hf5kWh4b5xDP8/ITjPs8a9MASJP8ofalTmmZo5fWH2Q=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=DFIbWSgCQWA/CFtOEJ9k6ghvxRwb+jnjL17WQaQzmdbVY076+UvXHAUFzLS48kByX
         zLkAcl0JgDJ5E9jOkPdBqFDC3SbZhZ2wbIMLYqtHLNrISr7PiwcctLXU5+kGpWdj9s
         xfqcIlJtilCmH6Ndtu6kbSryqd88COz3EjUOy7MQ=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11CH6bUm081026
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 12 Feb 2021 11:06:37 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 12
 Feb 2021 11:06:37 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 12 Feb 2021 11:06:36 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11CH6Wj1016094;
        Fri, 12 Feb 2021 11:06:32 -0600
Subject: Re: [PATCH v5 net-next 05/10] net: switchdev: pass flags and mask to
 both {PRE_,}BRIDGE_FLAGS attributes
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
 <20210212151600.3357121-6-olteanv@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <d06efa97-f9cf-3a3a-963b-3b15e7803e87@ti.com>
Date:   Fri, 12 Feb 2021 19:06:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210212151600.3357121-6-olteanv@gmail.com>
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
> This switchdev attribute offers a counterproductive API for a driver
> writer, because although br_switchdev_set_port_flag gets passed a
> "flags" and a "mask", those are passed piecemeal to the driver, so while
> the PRE_BRIDGE_FLAGS listener knows what changed because it has the
> "mask", the BRIDGE_FLAGS listener doesn't, because it only has the final
> value. But certain drivers can offload only certain combinations of
> settings, like for example they cannot change unicast flooding
> independently of multicast flooding - they must be both on or both off.
> The way the information is passed to switchdev makes drivers not
> expressive enough, and unable to reject this request ahead of time, in
> the PRE_BRIDGE_FLAGS notifier, so they are forced to reject it during
> the deferred BRIDGE_FLAGS attribute, where the rejection is currently
> ignored.
> 
> This patch also changes drivers to make use of the "mask" field for edge
> detection when possible.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v5:
> Rebased on top of AM65 CPSW driver.
> 
> Changes in v4:
> Patch is new.
> 
>   .../marvell/prestera/prestera_switchdev.c     | 23 +++++----
>   .../mellanox/mlxsw/spectrum_switchdev.c       | 50 +++++++++++--------
>   drivers/net/ethernet/rocker/rocker_main.c     | 10 ++--
>   drivers/net/ethernet/ti/am65-cpsw-switchdev.c | 24 +++++----
>   drivers/net/ethernet/ti/cpsw_switchdev.c      | 24 +++++----
>   drivers/staging/fsl-dpaa2/ethsw/ethsw.c       | 34 ++++++++-----
>   include/net/switchdev.h                       |  7 ++-
>   net/bridge/br_switchdev.c                     |  6 +--
>   net/dsa/dsa_priv.h                            |  6 ++-
>   net/dsa/port.c                                | 34 +++++++------
>   10 files changed, 129 insertions(+), 89 deletions(-)
> 

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
