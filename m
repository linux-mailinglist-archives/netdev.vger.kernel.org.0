Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1D13DF3A7
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237708AbhHCRMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:12:34 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47872 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237565AbhHCRMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:12:33 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 173HC1XQ103845;
        Tue, 3 Aug 2021 12:12:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628010721;
        bh=cKNVwrRwyfjgdxjPu8NHBl/yZWhtD7oeVBEJNdJOeRQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=k7newXhUAoT7ljItjq62bwWsw63DYdcVx5/spe6iZj2jDBnb4Tl2WrBTKByoVBNc2
         yY25nFFk7NzST9jCeHh6zipqIk8HftPBBV+TPQHsVA9F08BvJ5D9j3caOTLIHC/LlH
         42MYxarR8sB1Z053WQa5dE3rstMfi1cv0O4xApJs=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 173HC1Ss107972
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Aug 2021 12:12:01 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 3 Aug
 2021 12:12:01 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Tue, 3 Aug 2021 12:12:01 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 173HBvCI016332;
        Tue, 3 Aug 2021 12:11:58 -0500
Subject: Re: [PATCH net-next 0/2] Convert switchdev_bridge_port_{,un}offload
 to notifiers
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        <bridge@lists.linux-foundation.org>,
        Arnd Bergmann <arnd@kernel.org>
References: <20210803143624.1135002-1-vladimir.oltean@nxp.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <00acb107-8ff6-9c98-e6c3-f6718d5ce9f4@ti.com>
Date:   Tue, 3 Aug 2021 20:11:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210803143624.1135002-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/08/2021 17:36, Vladimir Oltean wrote:
> The introduction of the explicit switchdev bridge port offloading API
> has introduced dependency regressions between switchdev drivers and the
> bridge, with some drivers where switchdev support was optional before
> being now compiled as a module when the bridge is a module, or worse.
> 
> This patch makes the switchdev bridge port offload/unoffload events
> visible on the blocking notifier call chain, so that the bridge can
> indirectly do something when those events happen, without the driver
> explicitly calling a symbol exported by the bridge driver.
> 
> Vladimir Oltean (2):
>    net: make switchdev_bridge_port_{,unoffload} loosely coupled with the
>      bridge
>    Revert "net: build all switchdev drivers as modules when the bridge is
>      a module"
> 
>   drivers/net/ethernet/microchip/sparx5/Kconfig |  1 -
>   drivers/net/ethernet/ti/Kconfig               |  2 -
>   drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
>   drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
>   include/linux/if_bridge.h                     | 35 -------------
>   include/net/switchdev.h                       | 46 +++++++++++++++++
>   net/bridge/br.c                               | 51 ++++++++++++++++++-
>   net/bridge/br_private.h                       | 30 +++++++++++
>   net/bridge/br_switchdev.c                     | 36 ++++---------
>   net/switchdev/switchdev.c                     | 48 +++++++++++++++++
>   10 files changed, 185 insertions(+), 68 deletions(-)
> 

I've tested builds, but was not able to test bridge itself on TI am57x platform.

1) See warning
[    3.958496] ------------[ cut here ]------------
[    3.963165] WARNING: CPU: 0 PID: 1 at lib/refcount.c:25 fib_create_info+0xae8/0xbd4
[    3.970855] refcount_t: addition on 0; use-after-free.
[    3.976043] Modules linked in: autofs4
[    3.979827] CPU: 0 PID: 1 Comm: systemd Not tainted 5.14.0-rc4-next-20210802-00002-g5003e4ac441d-dirty #5
[    3.989440] Hardware name: Generic DRA72X (Flattened Device Tree)
[    3.995574] [<c0111098>] (unwind_backtrace) from [<c010b834>] (show_stack+0x10/0x14)
[    4.003356] [<c010b834>] (show_stack) from [<c09da808>] (dump_stack_lvl+0x40/0x4c)
[    4.010986] [<c09da808>] (dump_stack_lvl) from [<c0137b44>] (__warn+0xd8/0x100)
[    4.018341] [<c0137b44>] (__warn) from [<c09d6368>] (warn_slowpath_fmt+0x94/0xbc)
[    4.025848] [<c09d6368>] (warn_slowpath_fmt) from [<c08f68d4>] (fib_create_info+0xae8/0xbd4)
[    4.034332] [<c08f68d4>] (fib_create_info) from [<c08f99c4>] (fib_table_insert+0x5c/0x604¢·AËÕìÍ_¡

2) see warnings and "ip link add name br0 type bridge" just stuck
[  158.032135] unregister_netdevice: waiting for lo to become free. Usage count = 3

It might not be related to this series.


-- 
Best regards,
grygorii
