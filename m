Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F826556B3
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiLXA3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiLXA3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:29:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0FA1A39D;
        Fri, 23 Dec 2022 16:29:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DA6161FA3;
        Sat, 24 Dec 2022 00:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBA3C433EF;
        Sat, 24 Dec 2022 00:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671841762;
        bh=D8/RRmXxBlCJ2dVDP24Osx4Ge5pXkhUGS6I0xtbmJAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kNN9dy/dfj7FTGUzLGg1SoUiugSuLsPVjUWqAixbaBX1u6JyoukzydQA/PdNV6oN0
         rOZRD65ZuHZFS1UzhiJa3iHgJV3Za1/xQyw0u28069NFlgomZFpMOI7DNOguECforX
         J63jA1GEB9qzpowrMJYpA1SMVHmrDthJiavxffL4j/7yK+nZsLgOSeSWOh2jWb7K6q
         8jFhYFW+ANVqEGPmXdecOG82dLwqpV7jZdkFXgQygfBuSnmCUYn0CQHrsFGN23bF3b
         DFMPCT34BiC8AEFlZzVfxgw6EB/+ICogP51r/rnM8gBakBYpEBPRQAHB8eAihCLaXF
         Z4sRcJ3SxZtzQ==
Date:   Fri, 23 Dec 2022 19:29:21 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 41/46] net: dpaa2: publish MAC stringset to
 ethtool -S even if MAC is missing
Message-ID: <Y6ZH4YCuBSiPDMNd@sashalap>
References: <20221218161244.930785-1-sashal@kernel.org>
 <20221218161244.930785-41-sashal@kernel.org>
 <20221219115402.evv5x2dzrb7tlwmn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221219115402.evv5x2dzrb7tlwmn@skbuf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 01:54:02PM +0200, Vladimir Oltean wrote:
>Hi Sasha,
>
>On Sun, Dec 18, 2022 at 11:12:39AM -0500, Sasha Levin wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> [ Upstream commit 29811d6e19d795efcf26644b66c4152abbac35a6 ]
>>
>> DPNIs and DPSW objects can connect and disconnect at runtime from DPMAC
>> objects on the same fsl-mc bus. The DPMAC object also holds "ethtool -S"
>> unstructured counters. Those counters are only shown for the entity
>> owning the netdev (DPNI, DPSW) if it's connected to a DPMAC.
>>
>> The ethtool stringset code path is split into multiple callbacks, but
>> currently, connecting and disconnecting the DPMAC takes the rtnl_lock().
>> This blocks the entire ethtool code path from running, see
>> ethnl_default_doit() -> rtnl_lock() -> ops->prepare_data() ->
>> strset_prepare_data().
>>
>> This is going to be a problem if we are going to no longer require
>> rtnl_lock() when connecting/disconnecting the DPMAC, because the DPMAC
>> could appear between ops->get_sset_count() and ops->get_strings().
>> If it appears out of the blue, we will provide a stringset into an array
>> that was dimensioned thinking the DPMAC wouldn't be there => array
>> accessed out of bounds.
>>
>> There isn't really a good way to work around that, and I don't want to
>> put too much pressure on the ethtool framework by playing locking games.
>> Just make the DPMAC counters be always available. They'll be zeroes if
>> the DPNI or DPSW isn't connected to a DPMAC.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>> Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>I think the algorithm has a problem in that it has a tendency to
>auto-pick preparatory patches which eliminate limitations that are
>preventing future development from taking place, rather than patches
>which fix present issues in the given code base.

Yeah, I'd agree. I think that the tricky part is that preperatory
patches usually resolve an issue, but it's not clear whether it's
something that affects users, or is just a theoretical limitation needed
by future patches.

>In this case, the patch is part of a larger series which was at the
>boundary between "next" work and "stable" work (patch 07/12 of this)
>https://patchwork.kernel.org/project/netdevbpf/cover/20221129141221.872653-1-vladimir.oltean@nxp.com/
>
>Due to the volume of that rework, I intended it to go to "next", even
>though backporting the entire series to "stable" could have its own
>merits. But picking just patch 07/12 out of that series is pointless,
>so please drop this patch from the queue for 5.15, 6.0 and 6.1, please.

Now dropped, thanks!

-- 
Thanks,
Sasha
