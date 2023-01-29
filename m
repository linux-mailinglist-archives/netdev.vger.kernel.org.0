Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A9B680136
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 20:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjA2ToS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 14:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjA2ToR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 14:44:17 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FBEC196B6;
        Sun, 29 Jan 2023 11:44:14 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 920B23CD80;
        Sun, 29 Jan 2023 21:44:12 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 1C8513CD35;
        Sun, 29 Jan 2023 21:44:11 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 6A2123C0435;
        Sun, 29 Jan 2023 21:44:00 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 30TJhtRl037792;
        Sun, 29 Jan 2023 21:43:57 +0200
Date:   Sun, 29 Jan 2023 21:43:55 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
cc:     Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [Question] neighbor entry doesn't switch to the STALE state
 after the reachable timer expires
In-Reply-To: <b1d8722e-5660-c38e-848f-3220d642889d@huawei.com>
Message-ID: <99532c7f-161e-6d39-7680-ccc1f20349@ssi.bg>
References: <b1d8722e-5660-c38e-848f-3220d642889d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Sun, 29 Jan 2023, Zhang Changzhong wrote:

> Hi,
> 
> We got the following weird neighbor cache entry on a machine that's been running for over a year:
> 172.16.1.18 dev bond0 lladdr 0a:0e:0f:01:12:01 ref 1 used 350521/15994171/350520 probes 4 REACHABLE

	confirmed time (15994171) is 13 days in the future, more likely
185 days behind (very outdated), anything above 99 days is invalid

> 350520 seconds have elapsed since this entry was last updated, but it is still in the REACHABLE
> state (base_reachable_time_ms is 30000), preventing lladdr from being updated through probe.
> 
> After some analysis, we found a scenario that may cause such a neighbor entry:
> 
>           Entry used          	  DELAY_PROBE_TIME expired
> NUD_STALE ------------> NUD_DELAY ------------------------> NUD_PROBE
>                             |
>                             | DELAY_PROBE_TIME not expired
>                             v
>                       NUD_REACHABLE
> 
> The neigh_timer_handler() use time_before_eq() to compare 'now' with 'neigh->confirmed +
> NEIGH_VAR(neigh->parms, DELAY_PROBE_TIME)', but time_before_eq() only works if delta < ULONG_MAX/2.
> 
> This means that if an entry stays in the NUD_STALE state for more than ULONG_MAX/2 ticks, it enters
> the NUD_RACHABLE state directly when it is used again and cannot be switched to the NUD_STALE state
> (the timer is set too long).
> 
> On 64-bit machines, ULONG_MAX/2 ticks are a extremely long time, but in my case (32-bit machine and
> kernel compiled with CONFIG_HZ=250), ULONG_MAX/2 ticks are about 99.42 days, which is possible in
> reality.
> 
> Does anyone have a good idea to solve this problem? Or are there other scenarios that might cause
> such a neighbor entry?

	Is the neigh entry modified somehow, for example,
with 'arp -s' or 'ip neigh change' ? Or is bond0 reconfigured
after initial setup? I mean, 4 days ago?

	Looking at __neigh_update, there are few cases that
can assign NUD_STALE without touching neigh->confirmed:
lladdr = neigh->ha should be called, NEIGH_UPDATE_F_ADMIN
should be provided. Later, as you explain, it can wrongly
switch to NUD_REACHABLE state for long time.

	May be there should be some measures to keep
neigh->confirmed valid during admin modifications.

	What is the kernel version?

Regards

--
Julian Anastasov <ja@ssi.bg>

