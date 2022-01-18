Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E023492BC5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 17:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346896AbiARQ7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 11:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiARQ7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 11:59:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AE3C061574;
        Tue, 18 Jan 2022 08:59:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48FF0B8171C;
        Tue, 18 Jan 2022 16:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67828C340E2;
        Tue, 18 Jan 2022 16:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642525182;
        bh=feAW4kiFfFgSFrMRkupJB3hsbvw2wxhEdeQQ6HaHkGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IA9DZ6eg6yunfTl7aAbdbFz+kRnBBR6VKR3ocD1RQdjaUxeBHcM5alw91UkzTtVE5
         65oJPfSJUJWEPr3EeVKpEJsp1Zy8FaYFAm95Ir9oNOoRFXJLbyfPOcpWhdXHdYxgbi
         vVc871vRhMOdw6nNpFxJWO+OjbDAgjgKWognCPKgiCoJ8QSwI+utsKbpOAsvc7RuJ8
         BhAcNd5B6WfKGLwRjYfFEpbCH4+X7UrT8prV2wkrm76zpazw4Fupgcui1VpjVhHnPu
         kYhcPGNG+7IkaoxpoDp6jfm96ZwcvIhdTrunlePEXDNyBUdaapGDktu5F4h4x2+npc
         el6rtmT4lzf1g==
Date:   Tue, 18 Jan 2022 08:59:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xu xin <xu.xin16@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Joanne Koong <joannekoong@fb.com>,
        "David S . Miller" <davem@davemloft.net>, daniel@iogearbox.net,
        dsahern@kernel.org, roopa@nvidia.com, edumazet@google.com,
        chinagar@codeaurora.org, yajun.deng@linux.dev,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 118/217] net: Enable neighbor sysctls that
 is save for userns root
Message-ID: <20220118085940.6d7b4a88@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118021940.1942199-118-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
        <20220118021940.1942199-118-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jan 2022 21:18:01 -0500 Sasha Levin wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> [ Upstream commit 8c8b7aa7fb0cf9e1cc9204e6bc6e1353b8393502 ]
> 
> Inside netns owned by non-init userns, sysctls about ARP/neighbor is
> currently not visible and configurable.
> 
> For the attributes these sysctls correspond to, any modifications make
> effects on the performance of networking(ARP, especilly) only in the
> scope of netns, which does not affect other netns.
> 
> Actually, some tools via netlink can modify these attribute. iproute2 is
> an example. see as follows:
> 
> $ unshare -ur -n
> $ cat /proc/sys/net/ipv4/neigh/lo/retrans_time
> cat: can't open '/proc/sys/net/ipv4/neigh/lo/retrans_time': No such file
> or directory
> $ ip ntable show dev lo
> inet arp_cache
>     dev lo
>     refcnt 1 reachable 19494 base_reachable 30000 retrans 1000
>     gc_stale 60000 delay_probe 5000 queue 101
>     app_probes 0 ucast_probes 3 mcast_probes 3
>     anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 1000
> 
> inet6 ndisc_cache
>     dev lo
>     refcnt 1 reachable 42394 base_reachable 30000 retrans 1000
>     gc_stale 60000 delay_probe 5000 queue 101
>     app_probes 0 ucast_probes 3 mcast_probes 3
>     anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 0
> $ ip ntable change name arp_cache dev <if> retrans 2000
> inet arp_cache
>     dev lo
>     refcnt 1 reachable 22917 base_reachable 30000 retrans 2000
>     gc_stale 60000 delay_probe 5000 queue 101
>     app_probes 0 ucast_probes 3 mcast_probes 3
>     anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 1000
> 
> inet6 ndisc_cache
>     dev lo
>     refcnt 1 reachable 35524 base_reachable 30000 retrans 1000
>     gc_stale 60000 delay_probe 5000 queue 101
>     app_probes 0 ucast_probes 3 mcast_probes 3
>     anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 0
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> Acked-by: Joanne Koong <joannekoong@fb.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Not a fix, IDK how the "Zeal Robot" "reported" that a sysctl is not
exposed under uesr ns, that's probably what throws off matchers :/
Anyway - it's a feature.
