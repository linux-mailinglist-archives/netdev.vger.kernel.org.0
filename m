Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14389467F67
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 22:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353990AbhLCVjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 16:39:06 -0500
Received: from www62.your-server.de ([213.133.104.62]:33950 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhLCVjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 16:39:05 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mtGDQ-000Cxm-3H; Fri, 03 Dec 2021 22:35:36 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mtGDP-000Nyo-MR; Fri, 03 Dec 2021 22:35:35 +0100
Subject: Re: [net v4 2/3] net: sched: add check tc_skip_classify in sch egress
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, edumazet@google.com,
        atenart@kernel.org, alexandr.lobakin@intel.com, weiwan@google.com,
        arnd@arndb.de
References: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
 <20211202024723.76257-3-xiangxia.m.yue@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <518bd06a-490c-47f0-652a-756805496063@iogearbox.net>
Date:   Fri, 3 Dec 2021 22:35:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211202024723.76257-3-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26372/Fri Dec  3 10:24:40 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/21 3:47 AM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Try to resolve the issues as below:
> * We look up and then check tc_skip_classify flag in net
>    sched layer, even though skb don't want to be classified.
>    That case may consume a lot of cpu cycles.
> 
>    Install the rules as below:
>    $ for id in $(seq 1 10000); do
>    $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
>    $ done
> 
>    netperf:
>    $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
>    $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
> 
>    Before: 152.04 tps, 0.58 Mbit/s
>    After:  303.07 tps, 1.51 Mbit/s
>    For TCP_RR, there are 99.3% improvement, TCP_STREAM 160.3%.

As it was pointed out earlier by Eric in v3, these numbers are moot since noone
is realistically running such a setup in practice with 10k linear rules.
