Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569EF61DDAF
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 20:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiKETXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 15:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiKETX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 15:23:29 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Nov 2022 12:23:27 PDT
Received: from shiva-su1.sorbonne-universite.fr (shiva-su1.sorbonne-universite.fr [134.157.0.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20ACDBC83;
        Sat,  5 Nov 2022 12:23:26 -0700 (PDT)
Received: from nirriti.ent.upmc.fr (nirriti.dsi.upmc.fr [134.157.0.215])
        by shiva-su1.sorbonne-universite.fr (Postfix) with ESMTP id 7E061414EC8B;
        Sat,  5 Nov 2022 20:07:03 +0100 (CET)
Received: from [44.168.19.230] (lfbn-idf1-1-1846-125.w90-91.abo.wanadoo.fr [90.91.31.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pidoux)
        by nirriti.ent.upmc.fr (Postfix) with ESMTPSA id 568F112973D9A;
        Sat,  5 Nov 2022 20:07:03 +0100 (CET)
Message-ID: <0549f15a-181c-1719-987c-d5641fac3f8e@free.fr>
Date:   Sat, 5 Nov 2022 20:07:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] rose: Fix NULL pointer dereference in rose_send_frame()
Content-Language: fr
To:     Zhang Qilong <zhangqilong3@huawei.com>, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org
References: <20221028161049.113625-1-zhangqilong3@huawei.com>
From:   F6BVP <f6bvp@free.fr>
In-Reply-To: <20221028161049.113625-1-zhangqilong3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NEUTRAL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ZhangQilong ni hao,

I have just pulled net-next 6.1.0-rc3 including  the rose_link.c patch 
on my FPAC/ROSE hamradio node F6BVP.

Xie xie ni

Zaitien

Bernard,

http://f6bvp.org

Le 28/10/2022 à 18:10, Zhang Qilong a écrit :
> The syzkaller reported an issue:
>
> KASAN: null-ptr-deref in range [0x0000000000000380-0x0000000000000387]
> CPU: 0 PID: 4069 Comm: kworker/0:15 Not tainted 6.0.0-syzkaller-02734-g0326074ff465 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
> Workqueue: rcu_gp srcu_invoke_callbacks
> RIP: 0010:rose_send_frame+0x1dd/0x2f0 net/rose/rose_link.c:101
> Call Trace:
>   <IRQ>
>   rose_transmit_clear_request+0x1d5/0x290 net/rose/rose_link.c:255
>   rose_rx_call_request+0x4c0/0x1bc0 net/rose/af_rose.c:1009
>   rose_loopback_timer+0x19e/0x590 net/rose/rose_loopback.c:111
>   call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
>   expire_timers kernel/time/timer.c:1519 [inline]
>   __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
>   __run_timers kernel/time/timer.c:1768 [inline]
>   run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
>   __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
>   [...]
>   </IRQ>
>
> It triggers NULL pointer dereference when 'neigh->dev->dev_addr' is
> called in the rose_send_frame(). It's the first occurrence of the
> `neigh` is in rose_loopback_timer() as `rose_loopback_neigh', and
> the 'dev' in 'rose_loopback_neigh' is initialized sa nullptr.
>
> It had been fixed by commit 3b3fd068c56e3fbea30090859216a368398e39bf
> ("rose: Fix Null pointer dereference in rose_send_frame()") ever.
> But it's introduced by commit 3c53cd65dece47dd1f9d3a809f32e59d1d87b2b8
> ("rose: check NULL rose_loopback_neigh->loopback") again.
>
> We fix it by add NULL check in rose_transmit_clear_request(). When
> the 'dev' in 'neigh' is NULL, we don't reply the request and just
> clear it.
>
> syzkaller don't provide repro, and I provide a syz repro like:
> r0 = syz_init_net_socket$bt_sco(0x1f, 0x5, 0x2)
> ioctl$sock_inet_SIOCSIFFLAGS(r0, 0x8914, &(0x7f0000000180)={'rose0\x00', 0x201})
> r1 = syz_init_net_socket$rose(0xb, 0x5, 0x0)
> bind$rose(r1, &(0x7f00000000c0)=@full={0xb, @dev, @null, 0x0, [@null, @null, @netrom, @netrom, @default, @null]}, 0x40)
> connect$rose(r1, &(0x7f0000000240)=@short={0xb, @dev={0xbb, 0xbb, 0xbb, 0x1, 0x0}, @remote={0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0x1}, 0x1, @netrom={0xbb, 0xbb, 0xbb, 0xbb, 0xbb, 0x0, 0x0}}, 0x1c)
>
> Fixes: 3c53cd65dece ("rose: check NULL rose_loopback_neigh->loopback")
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>   net/rose/rose_link.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> index 8b96a56d3a49..0f77ae8ef944 100644
> --- a/net/rose/rose_link.c
> +++ b/net/rose/rose_link.c
> @@ -236,6 +236,9 @@ void rose_transmit_clear_request(struct rose_neigh *neigh, unsigned int lci, uns
>   	unsigned char *dptr;
>   	int len;
>   
> +	if (!neigh->dev)
> +		return;
> +
>   	len = AX25_BPQ_HEADER_LEN + AX25_MAX_HEADER_LEN + ROSE_MIN_LEN + 3;
>   
>   	if ((skb = alloc_skb(len, GFP_ATOMIC)) == NULL)
