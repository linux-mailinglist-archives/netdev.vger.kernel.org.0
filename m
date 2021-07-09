Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93733C24FC
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 15:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhGIN1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 09:27:00 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:33498 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbhGIN07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 09:26:59 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 169DO3nX001804;
        Fri, 9 Jul 2021 08:24:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1625837043;
        bh=dfQOrbQwcVdfqdndcH5DkOiKyvdO4S7foZ+BTVWbXss=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=IIzAz+NMVYCFVN3dJ+pw3HBZg1iVLZVd//qXz1yGDiZVs7R42D4BNqlHLvI+FzjDm
         YyYcvAe7VGTo+0d/IyoOpg8zYdl9k5nOUw1n3TKdT8uKjRqLqQTIEgcHQMzaNoLXZ1
         XlyukJT2eZPv54Qy2RmjpAi+hrJEKQqZlWeVCnpU=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 169DO2Ol116906
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 9 Jul 2021 08:24:03 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 9 Jul
 2021 08:24:02 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 9 Jul 2021 08:24:02 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 169DNxqI113628;
        Fri, 9 Jul 2021 08:23:59 -0500
Subject: Re: [RFC PATCH v2 net-next 02/10] net: bridge: disambiguate
 offload_fwd_mark
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
 <20210703115705.1034112-3-vladimir.oltean@nxp.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <6b4e864a-5509-4cc2-caf3-b6f5f8edc2ed@ti.com>
Date:   Fri, 9 Jul 2021 16:23:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210703115705.1034112-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 03/07/2021 14:56, Vladimir Oltean wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com>
> 
> Before this change, four related - but distinct - concepts where named
> offload_fwd_mark:
> 
> - skb->offload_fwd_mark: Set by the switchdev driver if the underlying
>    hardware has already forwarded this frame to the other ports in the
>    same hardware domain.
> 
> - nbp->offload_fwd_mark: An idetifier used to group ports that share
>    the same hardware forwarding domain.
> 
> - br->offload_fwd_mark: Counter used to make sure that unique IDs are
>    used in cases where a bridge contains ports from multiple hardware
>    domains.
> 
> - skb->cb->offload_fwd_mark: The hardware domain on which the frame
>    ingressed and was forwarded.
> 
> Introduce the term "hardware forwarding domain" ("hwdom") in the
> bridge to denote a set of ports with the following property:
> 
>      If an skb with skb->offload_fwd_mark set, is received on a port
>      belonging to hwdom N, that frame has already been forwarded to all
>      other ports in hwdom N.
> 
> By decoupling the name from "offload_fwd_mark", we can extend the
> term's definition in the future - e.g. to add constraints that
> describe expected egress behavior - without overloading the meaning of
> "offload_fwd_mark".
> 
> - nbp->offload_fwd_mark thus becomes nbp->hwdom.
> 
> - br->offload_fwd_mark becomes br->last_hwdom.
> 
> - skb->cb->offload_fwd_mark becomes skb->cb->src_hwdom. The slight
>    change in naming here mandates a slight change in behavior of the
>    nbp_switchdev_frame_mark() function. Previously, it only set this
>    value in skb->cb for packets with skb->offload_fwd_mark true (ones
>    which were forwarded in hardware). Whereas now we always track the
>    incoming hwdom for all packets coming from a switchdev (even for the
>    packets which weren't forwarded in hardware, such as STP BPDUs, IGMP
>    reports etc). As all uses of skb->cb->offload_fwd_mark were already
>    gated behind checks of skb->offload_fwd_mark, this will not introduce
>    any functional change, but it paves the way for future changes where
>    the ingressing hwdom must be known for frames coming from a switchdev
>    regardless of whether they were forwarded in hardware or not
>    (basically, if the skb comes from a switchdev, skb->cb->src_hwdom now
>    always tracks which one).
> 
>    A typical example where this is relevant: the switchdev has a fixed
>    configuration to trap STP BPDUs, but STP is not running on the bridge
>    and the group_fwd_mask allows them to be forwarded. Say we have this
>    setup:
> 
>          br0
>         / | \
>        /  |  \
>    swp0 swp1 swp2
> 
>    A BPDU comes in on swp0 and is trapped to the CPU; the driver does not
>    set skb->offload_fwd_mark. The bridge determines that the frame should
>    be forwarded to swp{1,2}. It is imperative that forward offloading is
>    _not_ allowed in this case, as the source hwdom is already "poisoned".
> 
>    Recording the source hwdom allows this case to be handled properly.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>   net/bridge/br_if.c        |  2 +-
>   net/bridge/br_private.h   | 10 +++++-----
>   net/bridge/br_switchdev.c | 16 ++++++++--------
>   3 files changed, 14 insertions(+), 14 deletions(-)
> 
[...]

Thank you. I very much like this patch by itself as it clarifies
properly things which caused much headache (at least for me).

I hope it can be moved forward regardless of the rest of the series.
Minor comment - It will good to add in-code doc for added/renamed struct fields.

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
