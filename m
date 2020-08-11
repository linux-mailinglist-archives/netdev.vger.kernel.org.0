Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC2E241E84
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 18:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgHKQm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 12:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbgHKQm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 12:42:57 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19747206DC;
        Tue, 11 Aug 2020 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597164176;
        bh=GI6OEs1EfIlNFpfrrNWl3O0cjrdYTbDR04UTKujfyXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RZBca4EWElRWJlHtTDeWGhKFRJVENyEt/Hllb0Llzwu6v+APOx2fBW3d1tiHbm/sH
         BVyaYaGxrgceaNfydKWpeqKem4u07/v7bTtL3EbQ0BzHtt8z1lA66dUArDrY8id0lC
         SiiaPJhBFhy31BOx4BCTpIuzKAHJyEnBNu8vdbJs=
Date:   Tue, 11 Aug 2020 12:42:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 03/60] net: mscc: ocelot: fix encoding
 destination ports into multicast IPv4 address
Message-ID: <20200811164255.GJ2975990@sasha-vm>
References: <20200810191028.3793884-1-sashal@kernel.org>
 <20200810191028.3793884-3-sashal@kernel.org>
 <20200810210108.ystlnglj4atyfrfh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200810210108.ystlnglj4atyfrfh@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 12:01:08AM +0300, Vladimir Oltean wrote:
>Hi Sasha,
>
>On Mon, Aug 10, 2020 at 03:09:31PM -0400, Sasha Levin wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> [ Upstream commit 0897ecf7532577bda3dbcb043ce046a96948889d ]
>>
>> The ocelot hardware designers have made some hacks to support multicast
>> IPv4 and IPv6 addresses. Normally, the MAC table matches on MAC
>> addresses and the destination ports are selected through the DEST_IDX
>> field of the respective MAC table entry. The DEST_IDX points to a Port
>> Group ID (PGID) which contains the bit mask of ports that frames should
>> be forwarded to. But there aren't a lot of PGIDs (only 80 or so) and
>> there are clearly many more IP multicast addresses than that, so it
>> doesn't scale to use this PGID mechanism, so something else was done.
>> Since the first portion of the MAC address is known, the hack they did
>> was to use a single PGID for _flooding_ unknown IPv4 multicast
>> (PGID_MCIPV4 == 62), but for known IP multicast, embed the destination
>> ports into the first 3 bytes of the MAC address recorded in the MAC
>> table.
>>
>> The VSC7514 datasheet explains it like this:
>>
>>     3.9.1.5 IPv4 Multicast Entries
>>
>>     MAC table entries with the ENTRY_TYPE = 2 settings are interpreted
>>     as IPv4 multicast entries.
>>     IPv4 multicasts entries match IPv4 frames, which are classified to
>>     the specified VID, and which have DMAC = 0x01005Exxxxxx, where
>>     xxxxxx is the lower 24 bits of the MAC address in the entry.
>>     Instead of a lookup in the destination mask table (PGID), the
>>     destination set is programmed as part of the entry MAC address. This
>>     is shown in the following table.
>>
>>     Table 78: IPv4 Multicast Destination Mask
>>
>>         Destination Ports            Record Bit Field
>>         ---------------------------------------------
>>         Ports 10-0                   MAC[34-24]
>>
>>     Example: All IPv4 multicast frames in VLAN 12 with MAC 01005E112233 are
>>     to be forwarded to ports 3, 8, and 9. This is done by inserting the
>>     following entry in the MAC table entry:
>>     VALID = 1
>>     VID = 12
>>     MAC = 0x000308112233
>>     ENTRY_TYPE = 2
>>     DEST_IDX = 0
>>
>> But this procedure is not at all what's going on in the driver. In fact,
>> the code that embeds the ports into the MAC address looks like it hasn't
>> actually been tested. This patch applies the procedure described in the
>> datasheet.
>>
>> Since there are many other fixes to be made around multicast forwarding
>> until it works properly, there is no real reason for this patch to be
>> backported to stable trees, or considered a real fix of something that
>> should have worked.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>Could you please drop this patch from the 'stable' queues for 5.7 and
>5.8? I haven't tested it on older kernels and without the other patches
>sent in that series. I would like to avoid unexpected regressions if
>possible.

Will do, thanks!

-- 
Thanks,
Sasha
