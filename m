Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D8B429762
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 21:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhJKTQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 15:16:01 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:27314 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234447AbhJKTQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 15:16:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1633979453;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=isDX4gxvzsSFnMxjqxVHmA92I/egBpGCy8mWWkvJadU=;
    b=Oewhzq1o0y5xPL4Z5eBmpJL2mQ8lqCqxzkVQ8xZngFB7hzuDc3HGeK/v9/ZeqL38qm
    WkaMLty7x81AYKIZUT+JJVnOl3lrrQjx5TAy1lbCek4RXj9RXhrodYk8vnoVwrERQeEB
    4k9jk/4/3ajcqzfcNgVzviEwjIpYtnGBgcP0anGVr4K3OFm57E167FLrbfG20i7+jDBr
    SxyHvJTc1s5EGs2plx7rUWwvh0UTki1SCJZ/jBwxfMzHvo82HZZBj/0NUFomyVHKOA5i
    CcFVBQ1ZTXojkJKnE+6ycO+V17VplMcIVnuUULK+NFHHiaPcvc8JFkMR2slwWF6cJlIT
    Jzow==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVvBOfXT2V6Q=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f904::b82]
    by smtp.strato.de (RZmta 47.33.8 AUTH)
    with ESMTPSA id 900f80x9BJAqwnd
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 11 Oct 2021 21:10:52 +0200 (CEST)
Subject: Re: [PATCH net v2 1/2] can: isotp: add result check for
 wait_event_interruptible()
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, mkl@pengutronix.de
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1633764159.git.william.xuanziyang@huawei.com>
 <10ca695732c9dd267c76a3c30f37aefe1ff7e32f.1633764159.git.william.xuanziyang@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <d811c05a-59f6-947b-7c1b-dfec1a69d42d@hartkopp.net>
Date:   Mon, 11 Oct 2021 21:10:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <10ca695732c9dd267c76a3c30f37aefe1ff7e32f.1633764159.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.10.21 09:40, Ziyang Xuan wrote:
> Using wait_event_interruptible() to wait for complete transmission,
> but do not check the result of wait_event_interruptible() which can
> be interrupted. It will result in tx buffer has multiple accessers
> and the later process interferes with the previous process.
> 
> Following is one of the problems reported by syzbot.
> 
> =============================================================
> WARNING: CPU: 0 PID: 0 at net/can/isotp.c:840 isotp_tx_timer_handler+0x2e0/0x4c0
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc7+ #68
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> RIP: 0010:isotp_tx_timer_handler+0x2e0/0x4c0
> Call Trace:
>   <IRQ>
>   ? isotp_setsockopt+0x390/0x390
>   __hrtimer_run_queues+0xb8/0x610
>   hrtimer_run_softirq+0x91/0xd0
>   ? rcu_read_lock_sched_held+0x4d/0x80
>   __do_softirq+0xe8/0x553
>   irq_exit_rcu+0xf8/0x100
>   sysvec_apic_timer_interrupt+0x9e/0xc0
>   </IRQ>
>   asm_sysvec_apic_timer_interrupt+0x12/0x20
> 
> Add result check for wait_event_interruptible() in isotp_sendmsg()
> to avoid multiple accessers for tx buffer.
> 
> Reported-by: syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Many thanks!
Oliver

> ---
>   net/can/isotp.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index caaa532ece94..2ac29c2b2ca6 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -865,7 +865,9 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   			return -EAGAIN;
>   
>   		/* wait for complete transmission of current pdu */
> -		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
> +		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
> +		if (err)
> +			return err;
>   	}
>   
>   	if (!size || size > MAX_MSG_LENGTH)
> 
