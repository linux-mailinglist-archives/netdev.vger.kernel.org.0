Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0432D680440
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 04:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbjA3DTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 22:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjA3DTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 22:19:54 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6E51E1E7;
        Sun, 29 Jan 2023 19:19:53 -0800 (PST)
Received: from dggpeml500006.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4P4thb6thdzfYxV;
        Mon, 30 Jan 2023 11:19:43 +0800 (CST)
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 30 Jan 2023 11:19:50 +0800
Subject: Re: [Question] neighbor entry doesn't switch to the STALE state after
 the reachable timer expires
To:     Julian Anastasov <ja@ssi.bg>
CC:     Network Development <netdev@vger.kernel.org>,
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
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
References: <b1d8722e-5660-c38e-848f-3220d642889d@huawei.com>
 <99532c7f-161e-6d39-7680-ccc1f20349@ssi.bg>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <9ebd0210-a4bb-afda-8a4d-5041b8395d78@huawei.com>
Date:   Mon, 30 Jan 2023 11:19:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <99532c7f-161e-6d39-7680-ccc1f20349@ssi.bg>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/1/30 3:43, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Sun, 29 Jan 2023, Zhang Changzhong wrote:
> 
>> Hi,
>>
>> We got the following weird neighbor cache entry on a machine that's been running for over a year:
>> 172.16.1.18 dev bond0 lladdr 0a:0e:0f:01:12:01 ref 1 used 350521/15994171/350520 probes 4 REACHABLE
> 
> 	confirmed time (15994171) is 13 days in the future, more likely
> 185 days behind (very outdated), anything above 99 days is invalid
> 
>> 350520 seconds have elapsed since this entry was last updated, but it is still in the REACHABLE
>> state (base_reachable_time_ms is 30000), preventing lladdr from being updated through probe.
>>
>> After some analysis, we found a scenario that may cause such a neighbor entry:
>>
>>           Entry used          	  DELAY_PROBE_TIME expired
>> NUD_STALE ------------> NUD_DELAY ------------------------> NUD_PROBE
>>                             |
>>                             | DELAY_PROBE_TIME not expired
>>                             v
>>                       NUD_REACHABLE
>>
>> The neigh_timer_handler() use time_before_eq() to compare 'now' with 'neigh->confirmed +
>> NEIGH_VAR(neigh->parms, DELAY_PROBE_TIME)', but time_before_eq() only works if delta < ULONG_MAX/2.
>>
>> This means that if an entry stays in the NUD_STALE state for more than ULONG_MAX/2 ticks, it enters
>> the NUD_RACHABLE state directly when it is used again and cannot be switched to the NUD_STALE state
>> (the timer is set too long).
>>
>> On 64-bit machines, ULONG_MAX/2 ticks are a extremely long time, but in my case (32-bit machine and
>> kernel compiled with CONFIG_HZ=250), ULONG_MAX/2 ticks are about 99.42 days, which is possible in
>> reality.
>>
>> Does anyone have a good idea to solve this problem? Or are there other scenarios that might cause
>> such a neighbor entry?
> 
> 	Is the neigh entry modified somehow, for example,
> with 'arp -s' or 'ip neigh change' ? Or is bond0 reconfigured
> after initial setup? I mean, 4 days ago?>

So far, we haven't found any user-space program that modifies the neigh
entry or bond0.

In fact, the neigh entry has been rarely used since initialization.
4 days ago, our machine just needed to download files from 172.16.1.18.
However, the laddr has changed, and the neigh entry wrongly switched to
NUD_REACHABLE state, causing the laddr to fail to update.

> 	Looking at __neigh_update, there are few cases that
> can assign NUD_STALE without touching neigh->confirmed:
> lladdr = neigh->ha should be called, NEIGH_UPDATE_F_ADMIN
> should be provided. Later, as you explain, it can wrongly
> switch to NUD_REACHABLE state for long time.
> 
> 	May be there should be some measures to keep
> neigh->confirmed valid during admin modifications.
> 

This problem can also occur if the neigh entry stays in NUD_STALE state
for more than 99 days, even if it is not modified by the administrator.

> 	What is the kernel version?
> 

We encountered this problem in 4.4 LTS, and the mainline doesn't seem
to fix it yet.

Regards,
Changzhong Zhang
