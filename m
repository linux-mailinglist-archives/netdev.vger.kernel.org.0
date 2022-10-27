Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3851160F5DE
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbiJ0LEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiJ0LEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:04:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511FF5F4D;
        Thu, 27 Oct 2022 04:04:33 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MyjVT4VnbzHv0F;
        Thu, 27 Oct 2022 19:04:17 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 19:04:30 +0800
Subject: Re: [PATCH net v2] tcp: reset tp->sacked_out when sack is enabled
From:   "luwei (O)" <luwei32@huawei.com>
To:     <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <xemul@parallels.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <ovzxemul@gmail.com>, <ptikhomirov@virtuozzo.com>,
        <den@virtuozzo.com>
References: <20221027114930.137735-1-luwei32@huawei.com>
Message-ID: <a4a6186e-e5e7-f9e9-3ba9-b9b8a9a1f37e@huawei.com>
Date:   Thu, 27 Oct 2022 19:04:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20221027114930.137735-1-luwei32@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

please ignore this patch£¬ I forgot to change the title

ÔÚ 2022/10/27 7:49 PM, Lu Wei Ð´µÀ:
> If setsockopt with option name of TCP_REPAIR_OPTIONS and opt_code
> of TCPOPT_SACK_PERM is called to enable sack after data is sent
> and before data is acked, it will trigger a warning in function
> tcp_verify_left_out() as follows:
>
> ============================================
> WARNING: CPU: 8 PID: 0 at net/ipv4/tcp_input.c:2132
> tcp_timeout_mark_lost+0x154/0x160
> tcp_enter_loss+0x2b/0x290
> tcp_retransmit_timer+0x50b/0x640
> tcp_write_timer_handler+0x1c8/0x340
> tcp_write_timer+0xe5/0x140
> call_timer_fn+0x3a/0x1b0
> __run_timers.part.0+0x1bf/0x2d0
> run_timer_softirq+0x43/0xb0
> __do_softirq+0xfd/0x373
> __irq_exit_rcu+0xf6/0x140
>
> This warning occurs in several steps:
> Step1. If sack is not enabled, when server receives dup-ack,
>         it calls tcp_add_reno_sack() to increase tp->sacked_out.
>
> Step2. Setsockopt() is called to enable sack
>
> Step3. The retransmit timer expires, it calls tcp_timeout_mark_lost()
>         to increase tp->lost_out but not clear tp->sacked_out because
>         sack is enabled and tcp_is_reno() is false.
>
> So tp->left_out is increased repeatly in Step1 and Step3 and it is
> greater than tp->packets_out and trigger the warning. In function
> tcp_timeout_mark_lost(), tp->sacked_out will be cleared if Step2 not
> happen and the warning will not be triggered. As suggested by Denis
> and Eric, TCP_REPAIR_OPTIONS should be prohibited if data was already
> sent.
>
> socket-tcp tests in CRIU has been tested as follows:
> $ sudo ./test/zdtm.py run -t zdtm/static/socket-tcp*  --keep-going \
>         --ignore-taint
>
> socket-tcp* represent all socket-tcp tests in test/zdtm/static/.
>
> Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameters")
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>   net/ipv4/tcp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index ef14efa1fb70..ef876e70f7fe 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3647,7 +3647,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
>   	case TCP_REPAIR_OPTIONS:
>   		if (!tp->repair)
>   			err = -EINVAL;
> -		else if (sk->sk_state == TCP_ESTABLISHED)
> +		else if (sk->sk_state == TCP_ESTABLISHED && !tp->packets_out)
>   			err = tcp_repair_options_est(sk, optval, optlen);
>   		else
>   			err = -EPERM;

-- 
Best Regards,
Lu Wei

