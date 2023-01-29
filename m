Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27ABA67FC95
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 04:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbjA2DIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 22:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjA2DIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 22:08:42 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1504122A08;
        Sat, 28 Jan 2023 19:08:41 -0800 (PST)
Received: from dggpeml500006.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4P4GP875VWzJqDK;
        Sun, 29 Jan 2023 11:04:12 +0800 (CST)
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sun, 29 Jan 2023 11:08:38 +0800
To:     Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: [Question] neighbor entry doesn't switch to the STALE state after the
 reachable timer expires
Message-ID: <b1d8722e-5660-c38e-848f-3220d642889d@huawei.com>
Date:   Sun, 29 Jan 2023 11:08:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We got the following weird neighbor cache entry on a machine that's been running for over a year:
172.16.1.18 dev bond0 lladdr 0a:0e:0f:01:12:01 ref 1 used 350521/15994171/350520 probes 4 REACHABLE

350520 seconds have elapsed since this entry was last updated, but it is still in the REACHABLE
state (base_reachable_time_ms is 30000), preventing lladdr from being updated through probe.

After some analysis, we found a scenario that may cause such a neighbor entry:

          Entry used          	  DELAY_PROBE_TIME expired
NUD_STALE ------------> NUD_DELAY ------------------------> NUD_PROBE
                            |
                            | DELAY_PROBE_TIME not expired
                            v
                      NUD_REACHABLE

The neigh_timer_handler() use time_before_eq() to compare 'now' with 'neigh->confirmed +
NEIGH_VAR(neigh->parms, DELAY_PROBE_TIME)', but time_before_eq() only works if delta < ULONG_MAX/2.

This means that if an entry stays in the NUD_STALE state for more than ULONG_MAX/2 ticks, it enters
the NUD_RACHABLE state directly when it is used again and cannot be switched to the NUD_STALE state
(the timer is set too long).

On 64-bit machines, ULONG_MAX/2 ticks are a extremely long time, but in my case (32-bit machine and
kernel compiled with CONFIG_HZ=250), ULONG_MAX/2 ticks are about 99.42 days, which is possible in
reality.

Does anyone have a good idea to solve this problem? Or are there other scenarios that might cause
such a neighbor entry?

-----
Best Regards,
Changzhong Zhang
