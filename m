Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FC468775C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjBBI1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBBI1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:27:41 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61484A258;
        Thu,  2 Feb 2023 00:27:39 -0800 (PST)
Received: from dggpeml500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4P6sNG3HPBzfYxK;
        Thu,  2 Feb 2023 16:27:26 +0800 (CST)
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 2 Feb 2023 16:27:36 +0800
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
 <9ebd0210-a4bb-afda-8a4d-5041b8395d78@huawei.com>
 <9ac5f4f6-36cc-cc6b-1220-f45db141656c@ssi.bg>
 <1252089d-75db-a45c-d735-6883c772d95a@huawei.com>
 <d95e4afc-3a95-a3a7-edd9-1bd13cdec90@ssi.bg>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <dd4562bf-4663-6f26-ed61-977ade44a969@huawei.com>
Date:   Thu, 2 Feb 2023 16:27:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <d95e4afc-3a95-a3a7-edd9-1bd13cdec90@ssi.bg>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

On 2023/2/1 0:13, Julian Anastasov wrote:
> 
>> Just curious, why did you choose 'jiffies - MAX_JIFFY_OFFSET + 86400 * HZ'
>> as the value of 'mint'?
> 
> 	It is too arbitrary :) Probably, just 'jiffies - MAX_JIFFY_OFFSET'
> is enough or something depending on HZ/USER_HZ. I added 1 day for
> timer to advance without leaving confirmed time behind the
> jiffies - MAX_JIFFY_OFFSET zone but it is not needed.
> 
> 	What limits play here:
> 
> - the HZ/USER_HZ difference: jiffies_to_clock_t reports the 3 times
> to user space, so we want to display values as large as possible.
> Any HZ > 100 for USER_HZ=100 works for the jiffies - MAX_JIFFY_OFFSET.
> HZ=100 does not work.
> 
> - users can use large values for sysctl vars which can keep the timer
> running for long time and reach some outdated confirmed time
> before neigh_add_timer() is called to correct it
> 
> 	If we choose mint = jiffies - MAX_JIFFY_OFFSET,
> for 32-bit we will have:
> 
> Past                     Future
> ++++++++++++++++++++++++++++++++++++++++++++++++++++
> |  49  days   |  49 days  |         99 days        |
> ++++++++++++++^+++++++++++^+++++++++++++++++++++++++
>               ^           ^
> DELAY+PROBE   |           |
>             mint         now
> 
> - used/confirmed times should be up to 49 days behind jiffies but
> we have 49 days to stay in timer without correcting them,
> so they can go up to 99 days in the past before going in
> the future and trigger the problem
> 
> - as we avoid the checks in neigh_timer_handler to save CPU cycles,
> one needs crazy sysctl settings to keep the timer in DELAY+PROBE
> states for 49 days. With default settings, it is no more than
> half minute. In this case even
> mint = jiffies - LONG_MAX + 86400 * HZ should work.
> 
> - REACHABLE state extends while confirmed time advances,
> otherwise PROBE will need ARP reply to recheck the
> times in neigh_add_timer while entering REACHABLE again
> 

Wow, thank you so much for the detailed explanation! Are you planning
to mainline it?

Regards,
Changzhong
