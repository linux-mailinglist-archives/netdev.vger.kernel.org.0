Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4B64B7F91
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244238AbiBPEkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:40:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240265AbiBPEkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:40:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB2BF1EBB;
        Tue, 15 Feb 2022 20:40:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF934CE24B2;
        Wed, 16 Feb 2022 04:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC81AC004E1;
        Wed, 16 Feb 2022 04:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644986397;
        bh=TRr0KbHGQ6VSMXeClTJJpeHHqHgnwq8p1DX2o2QIs4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QcvuhjqbAglbz0SNpwprhw39RnVThqGeht23o2gi2Vx67yX25E82uUW2Ypqb3MqrE
         EuQaMoyhIGLOfZRjOF3E5K+YXILn2M4P9lxAMBh1JR73ymlX6FIGqT0eIWDcas6Qv8
         XFYBegm7ew/nywWU534yPd8iK47jBrRzOu71uXoEK7Qf0w7rLP1PPHHqQ+ySdSxWu/
         VojONYFcTonO4eRTxwJCo7Wuzyhwz5ciJ7FOljtl4Or6rpxmWJU0Mso6WQc19mzz4t
         lhvrIKwagr8ktHBksEUXFm7PW3UTnGimzcp7PmFR914/RQYsosIdhPQ+O2pDtT9ghs
         QAEtQpfGVxLpw==
Date:   Tue, 15 Feb 2022 20:39:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, ajk@comnets.uni-bremen.de,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: hamradio: 6pack: fix UAF bug caused by
 mod_timer()
Message-ID: <20220215203955.7d7a3eed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220216023549.50223-1-duoming@zju.edu.cn>
References: <20220216023549.50223-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 10:35:49 +0800 Duoming Zhou wrote:
> Although del_timer_sync() in sixpack_close() waits for the timer handler
> to finish its execution and then releases the timer, the mod_timer()
> in sp_xmit_on_air() could be called by userspace syscall such as
> ax25_sendmsg(), ax25_connect() and ax25_ioctl() and wakes up the timer
> again. If the timer uses sp_xmit_on_air() to write data on pty work queue
> that already released by unregister_netdev(), the UAF bug will happen.

Do you mean sp->xbuff access? It's released right before the netdev
itself is freed. Checking dev->something is also a UAF.

> One of the possible race conditions is shown below:
> 
>       (USE)                     |      (FREE)
> ax25_sendmsg()                  |
>   ax25_queue_xmit()             |
>     ...                         |
>     sp_encaps()                 |  sixpack_close()
>       sp_xmit_on_air()          |    del_timer_sync(&sp->tx_t)
>         mod_timer(&sp->tx_t,..) |    ...
>         (wait a while)          |    unregister_netdev(sp->dev)) //FREE

Please clarify what is getting freed. 

>       sp_xmit_on_air()          |    ...
>         pty_write()             |
>           queue_work_on() //USE |
> 
> The corresponding fail log is shown below:
> ===============================================================
> BUG: KASAN: use-after-free in __run_timers.part.0+0x170/0x470
> Write of size 8 at addr ffff88800a652ab8 by task swapper/2/0
> ...
> Call Trace:
>   ...
>   queue_work_on+0x3f/0x50
>   pty_write+0xcd/0xe0pty_write+0xcd/0xe0
>   sp_xmit_on_air+0xb2/0x1f0
>   call_timer_fn+0x28/0x150
>   __run_timers.part.0+0x3c2/0x470
>   run_timer_softirq+0x3b/0x80
>   __do_softirq+0xf1/0x380
>   ...
> 
> This patch add condition check in sp_xmit_on_air(). If the
> registration status of net_device is not equal to NETREG_REGISTERED,
> the sp_xmit_on_air() will not write data to pty work queue and
> return instead.

I don't think this works as mentioned above. The question is why the tx
queue is not stopped.

> diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
> index b1fc153125d..7ee25e06915 100644
> --- a/drivers/net/hamradio/6pack.c
> +++ b/drivers/net/hamradio/6pack.c
> @@ -141,7 +141,8 @@ static void sp_xmit_on_air(struct timer_list *t)
>  	struct sixpack *sp = from_timer(sp, t, tx_t);
>  	int actual, when = sp->slottime;
>  	static unsigned char random;
> -
> +	if (sp->dev->reg_state !=  NETREG_REGISTERED)
> +		return;
>  	random = random * 17 + 41;
>  
>  	if (((sp->status1 & SIXP_DCD_MASK) == 0) && (random < sp->persistence)) {

