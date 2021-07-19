Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2793CCC58
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhGSCqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGSCqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:46:25 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694BBC061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:43:25 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso16717978otu.10
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jibvRJ8x4gDFYeeL7+2QzukIzWDDAy7tWepHyOMPSYk=;
        b=WmzljnzfdyCKejRVwaGUTWf32CFVrEe05Hp/D3gKkNwRLzGfz5I2l3tw6eQbc4NgTr
         +B7WFDq93w/dbGeQWaoLroU4EwWddE/Scvdk09ShsO3fS1+SCSOHiYBvm92eRG/vjwy6
         HgfGFB8GGLrzwzuUfLOdXC1B3fux4Vc5ljWM/CDnUStO+0cLMjz/eJbRyh8s1Z/QcQSr
         IQx858KvB/hHrsYxFGFwC46i/pppFrZDHH4bE+2OoczE7ZRTlTQxlHx9i96g3XfQ7p9m
         7ErdnFXVMDI1F66a8bvOZreteFp/MOVfknYym74WMcQJm7RicSF0FkVWmgZoh5wura9B
         5zKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jibvRJ8x4gDFYeeL7+2QzukIzWDDAy7tWepHyOMPSYk=;
        b=MYKZpt9ahbY+ucy5EzzCE7aiBRzcG4mx8hkVfQlmPSPMFC3aLEuvxTlocYV3JF0ZMA
         X3YDalqNvQh0W831Lq5Wz3Dm40bFSA+kZYodLMIKm+tbi8b8QPGlNh2g8WO5glQppX2z
         KayugS/whydyJzfiqCj70ydiYSXqeNGzDIFOVBwy7Jd0hGuUOfMFHPn0bQP3MRH3Ljrz
         GHl9fNB/R2ZDFUoem9cfV+gWKebjfmhcaodOhMh6k6ftSofmZKnVF/Ef7asYjlVvb/uY
         O03ewie7c9igWVA1Rt3VSZlxcdQzwwVeSxo0vnBsO+Aek8fxbNj4eAXT422jrWrO3hmb
         3a1w==
X-Gm-Message-State: AOAM532lx8SuMd8VUB9/ISrxikJO1JfnpPlhSiWEs2+eqXk5ldsLxEaZ
        RtUxQJvhX233ypoy3aZBo3Y=
X-Google-Smtp-Source: ABdhPJz9mwIVizqcEYhpcU+r73xr823GQCEsHeE/sNkp+C7nCZ6fwD3mXmBa69bm5UfMtPvXdl9sjQ==
X-Received: by 2002:a05:6830:1f3b:: with SMTP id e27mr17111375oth.311.1626662604688;
        Sun, 18 Jul 2021 19:43:24 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:49e1:751f:b992:b4f3? ([2600:1700:dfe0:49f0:49e1:751f:b992:b4f3])
        by smtp.gmail.com with ESMTPSA id o26sm3404180otk.77.2021.07.18.19.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 19:43:24 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 11/15] net: bridge: switchdev: allow the TX
 data plane forwarding to be offloaded
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-12-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d81cf0d4-3680-8f87-63ba-d2d843394d5b@gmail.com>
Date:   Sun, 18 Jul 2021 19:43:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210718214434.3938850-12-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2021 2:44 PM, Vladimir Oltean wrote:
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
> - When joining a bridge port, the switchdev driver calls
>    switchdev_bridge_port_offload() with tx_fwd_offload = true.
> 
> - The bridge sends offloadable skbs to one of the ports under the
>    switchdev's control using skb->offload_fwd_mark = true.
> 
> - The switchdev driver checks the skb->offload_fwd_mark field and lets
>    its FDB lookup select the destination port mask for this packet.
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
> v2->v3:
> - replace the solution based on .ndo_dfwd_add_station with a solution
>    based on switchdev_bridge_port_offload
> - rename BR_FWD_OFFLOAD to BR_TX_FWD_OFFLOAD
> v3->v4: rebase
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
