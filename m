Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0570596BDA
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbiHQJMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbiHQJM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:12:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929D267CBD
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 02:12:28 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r4so16636178edi.8
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 02:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc;
        bh=hLU21of0cGMccaxHW7KCtt9n7ww1EHLploL9mLhUimI=;
        b=h2tLDcuaAluzTCh/2uYox8F2BqwHH/cwNGXK61PGy2ukbPBH3yYM+ijTePqzl+ojyP
         +LTrn0Qnj01jH9I+pTa2MTjMn+0ClYfLULK0D1TG5im7R+DrOG+CwRxO0s7RlA3MCCTy
         4VbSt6ScxytQn8apJRSdHoYVdjhXaocL4Tdlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc;
        bh=hLU21of0cGMccaxHW7KCtt9n7ww1EHLploL9mLhUimI=;
        b=PEbmVrb2J2GA0YBTR+NwaNCdZnQJEYyfV3zH2LcqvJZFILioiXrkNxxlMhQjfgVKYD
         H/qAjt7WFmmlLDIp0wPZ0QpCbwXpQOvNBX30+2ReiZYTV28/Z+ulItkI53JGANtXS7rr
         AiwrXp0vjIa5cjg6PW1PImf2nMEduiF4xf4pOI5ElrWuRRUNwQlLBgI5zA7dTgILw6N7
         LUc6H9AyhoeGYDfHH+pGzIzrMpugRHTwOaqtIz5MnaMBTYjFfSAC2GXzIzTwv6CPVdAo
         EpcQQ+E1PxS9UHRWgPUeIKjuNHfFljRdLcpmFgrTc25JqUGYbAe6y3TK/DELrkfODkel
         4K3Q==
X-Gm-Message-State: ACgBeo3xIMOnl2Botvd2RB2h6WdE0B3p762yAj+JsPdRPMXutuZ01VvE
        PGGEBgRYFF3TvT9yeLicVcrhmA==
X-Google-Smtp-Source: AA6agR4cAqVXyyLznxJSp5An7Q5xuljyhx9l/fC38pTot2+Jtf6mm3PMiUncsE6nHeo4W3f+aVr8AQ==
X-Received: by 2002:a05:6402:11cb:b0:43c:c7a3:ff86 with SMTP id j11-20020a05640211cb00b0043cc7a3ff86mr22793522edw.383.1660727547074;
        Wed, 17 Aug 2022 02:12:27 -0700 (PDT)
Received: from cloudflare.com (79.184.200.53.ipv4.supernova.orange.pl. [79.184.200.53])
        by smtp.gmail.com with ESMTPSA id q23-20020a056402041700b0043cfda1368fsm10268523edv.82.2022.08.17.02.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 02:12:26 -0700 (PDT)
References: <20220809094915.150391-1-liujian56@huawei.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2] skmsg: Fix wrong last sg check in
 sk_msg_recvmsg()
Date:   Wed, 17 Aug 2022 11:02:53 +0200
In-reply-to: <20220809094915.150391-1-liujian56@huawei.com>
Message-ID: <87ilmrw7wm.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 05:49 PM +08, Liu Jian wrote:
> Fix one kernel NULL pointer dereference as below:
>
> [  224.462334] Call Trace:
> [  224.462394]  __tcp_bpf_recvmsg+0xd3/0x380
> [  224.462441]  ? sock_has_perm+0x78/0xa0
> [  224.462463]  tcp_bpf_recvmsg+0x12e/0x220
> [  224.462494]  inet_recvmsg+0x5b/0xd0
> [  224.462534]  __sys_recvfrom+0xc8/0x130
> [  224.462574]  ? syscall_trace_enter+0x1df/0x2e0
> [  224.462606]  ? __do_page_fault+0x2de/0x500
> [  224.462635]  __x64_sys_recvfrom+0x24/0x30
> [  224.462660]  do_syscall_64+0x5d/0x1d0
> [  224.462709]  entry_SYSCALL_64_after_hwframe+0x65/0xca
>
> In commit 9974d37ea75f ("skmsg: Fix invalid last sg check in
> sk_msg_recvmsg()"), we change last sg check to sg_is_last(),
> but in sockmap redirection case (without stream_parser/stream_verdict/
> skb_verdict), we did not mark the end of the scatterlist. Check the
> sk_msg_alloc, sk_msg_page_add, and bpf_msg_push_data functions, they all
> do not mark the end of sg. They are expected to use sg.end for end
> judgment. So the judgment of '(i != msg_rx->sg.end)' is added back here.
>
> Fixes: 9974d37ea75f ("skmsg: Fix invalid last sg check in sk_msg_recvmsg()")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> v1->v2: change fix commit info in fixes tag and commit message.
>  net/core/skmsg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 81627892bdd4..385ae23580a5 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -462,7 +462,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  
>  			if (copied == len)
>  				break;
> -		} while (!sg_is_last(sge));
> +		} while ((i != msg_rx->sg.end) && !sg_is_last(sge));
>  
>  		if (unlikely(peek)) {
>  			msg_rx = sk_psock_next_msg(psock, msg_rx);
> @@ -472,7 +472,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  		}
>  
>  		msg_rx->sg.start = i;
> -		if (!sge->length && sg_is_last(sge)) {
> +		if (!sge->length && (i == msg_rx->sg.end || sg_is_last(sge))) {
>  			msg_rx = sk_psock_dequeue_msg(psock);
>  			kfree_sk_msg(msg_rx);
>  		}

Looks to me like I sk_msg_alloc does mark the end of a scatterlist:

sk_msg_alloc
  sg_unmark_end
  sg_set_page
    sg_assign_page <- sets SG_END bit

Why do we unmark the SG end in sk_msg_page_add and bpf_msg_push_data?

John, do you recall?


As it might take a moment to figure it out, and we want to fix the
regression introduced by 9974d37ea75f ("skmsg: Fix invalid last sg check
in sk_msg_recvmsg()"):

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
