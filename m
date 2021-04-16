Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4A9361DCF
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 12:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbhDPKMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 06:12:07 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:35422 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbhDPKMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 06:12:06 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13GABPdm080049;
        Fri, 16 Apr 2021 05:11:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618567885;
        bh=Tv2LpEewNe2bQ7IX9JcrH/n0K/2mfKwFDjxPXCP0Ki0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=lkpyKTuUp7FXpEvjs+ivEUGlDCWfn6rN8oobRHUirRdWx2e4ULg9+/mIl6TpZtJ+l
         d2P9NEG4LXENUUdya4mP+Rdct4X7cAeTcosEriE31t/i9++gXy67AzjCdn59hg7aLq
         DisfxLJ36cen2V1hCGRpKfkwq8k9XH8CjKFD7kL8=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13GABPwS116880
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Apr 2021 05:11:25 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 16
 Apr 2021 05:11:25 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 16 Apr 2021 05:11:25 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13GABKDU048542;
        Fri, 16 Apr 2021 05:11:21 -0500
Subject: Re: [PATCH resend net-next 2/2] net: bridge: switchdev: include local
 flag in FDB notifications
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-omap@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20210414165256.1837753-1-olteanv@gmail.com>
 <20210414165256.1837753-3-olteanv@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <1aadef14-f89e-ab08-84aa-a027425d26c0@ti.com>
Date:   Fri, 16 Apr 2021 13:11:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210414165256.1837753-3-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/04/2021 19:52, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As explained in bugfix commit 6ab4c3117aec ("net: bridge: don't notify
> switchdev for local FDB addresses") as well as in this discussion:
> https://lore.kernel.org/netdev/20210117193009.io3nungdwuzmo5f7@skbuf/
> 
> the switchdev notifiers for FDB entries managed to have a zero-day bug,
> which was that drivers would not know what to do with local FDB entries,
> because they were not told that they are local. The bug fix was to
> simply not notify them of those addresses.
> 
> Let us now add the 'is_local' bit to bridge FDB entries, and make all
> drivers ignore these entries by their own choice.
> 
> Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>   drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c        | 4 ++--
>   drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 2 +-
>   drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 5 +++--
>   drivers/net/ethernet/rocker/rocker_main.c                  | 4 ++--
>   drivers/net/ethernet/ti/am65-cpsw-switchdev.c              | 4 ++--
>   drivers/net/ethernet/ti/cpsw_switchdev.c                   | 4 ++--
>   include/net/switchdev.h                                    | 1 +
>   net/bridge/br_switchdev.c                                  | 3 +--
>   net/dsa/slave.c                                            | 2 +-
>   9 files changed, 15 insertions(+), 14 deletions(-)

For cpsw:
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

Thank you.

-- 
Best regards,
grygorii
