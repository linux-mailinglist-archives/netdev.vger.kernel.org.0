Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4178F3C241B
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhGINT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 09:19:26 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:59392 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhGINT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 09:19:26 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 169DGHgd073398;
        Fri, 9 Jul 2021 08:16:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1625836577;
        bh=CUUFEgN3xsuhwmhWlIEAb6/KOqMMPnE+U548owx+oss=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qjxo13jXQtpDYCi25Vlw+KgE7Ewhslkw3RoPZhVy0CqNAG1ceCYEa3Be/cUNtQHRh
         y0R2pycGxKXS4OAuuunOd2aLyTU6rEeASES3Kz4Mt9XkcWrr1/xSMiIvKhNBrqEdoJ
         ggdf2WaSNoZK5uZc4ecn9UXpgTLI+ynABNpbJYm8=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 169DGHUh101437
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 9 Jul 2021 08:16:17 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 9 Jul
 2021 08:16:17 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 9 Jul 2021 08:16:17 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 169DGEeX015573;
        Fri, 9 Jul 2021 08:16:14 -0500
Subject: Re: [RFC PATCH v2 net-next 04/10] net: bridge: switchdev: allow the
 data plane forwarding to be offloaded
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        <bridge@lists.linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
 <20210703115705.1034112-5-vladimir.oltean@nxp.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <3686cff1-2a80-687e-7c64-cf070a0f5324@ti.com>
Date:   Fri, 9 Jul 2021 16:16:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210703115705.1034112-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/07/2021 14:56, Vladimir Oltean wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com>
> 
> Allow switchdevs to forward frames from the CPU in accordance with the
> bridge configuration in the same way as is done between bridge
> ports. This means that the bridge will only send a single skb towards
> one of the ports under the switchdev's control, and expects the driver
> to deliver the packet to all eligible ports in its domain.
> 
> Primarily this improves the performance of multicast flows with
> multiple subscribers, as it allows the hardware to perform the frame
> replication.
> 
> The basic flow between the driver and the bridge is as follows:
> 
> - The switchdev accepts the offload by returning a non-null pointer
>    from .ndo_dfwd_add_station when the port is added to the bridge.
> 
> - The bridge sends offloadable skbs to one of the ports under the
>    switchdev's control using dev_queue_xmit_accel.
> 
> - The switchdev notices the offload by checking for a non-NULL
>    "sb_dev" in the core's call to .ndo_select_queue.

Sry, I could be missing smth.

Is there any possibility to just mark skb itself as "fwd_offload" (or smth), so driver can
just check it and decide what to do. Following you series:
- BR itself will send packet only once to one port if fwd offload possible and supported
- switchdev driver can check/negotiate BR_FWD_OFFLOAD flag

In our case, TI CPSW can send directed packet (default now), by specifying port_id if DMA desc
or keep port_id == 0 which will allow HW to process packet internally, including MC duplication.

Sry, again, but necessity to add 3 callbacks and manipulate with "virtual" queue to achieve
MC offload (seems like one of the primary goals) from BR itself looks a bit over-complicated :(

> 
> v1->v2:
> - convert br_input_skb_cb::fwd_hwdoms to a plain unsigned long
> - introduce a static key "br_switchdev_fwd_offload_used" to minimize the
>    impact of the newly introduced feature on all the setups which don't
>    have hardware that can make use of it
> - introduce a check for nbp->flags & BR_FWD_OFFLOAD to optimize cache
>    line access
> - reorder nbp_switchdev_frame_mark_accel() and br_handle_vlan() in
>    __br_forward()
> - do not strip VLAN on egress if forwarding offload on VLAN-aware bridge
>    is being used
> - propagate errors from .ndo_dfwd_add_station() if not EOPNOTSUPP
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>   include/linux/if_bridge.h |  1 +
>   net/bridge/br_forward.c   | 18 +++++++-
>   net/bridge/br_private.h   | 24 +++++++++++
>   net/bridge/br_switchdev.c | 87 +++++++++++++++++++++++++++++++++++++--

[...]

-- 
Best regards,
grygorii
