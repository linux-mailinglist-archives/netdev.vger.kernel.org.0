Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0799521E234
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 23:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgGMVbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 17:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgGMVbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 17:31:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED51C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 14:31:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 1so6603766pfn.9
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 14:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oNhbkcb7ihjBx515Q/JOzDwzOtsLAQZqfKTqUdes+dA=;
        b=nspXuFEbMOkNoTV9NroOu1kRehVUDBnDddr49qVCI+S6QawOK49yyikIcE2xcz/eEy
         8dbMW+InQspIF0laaVI/sWf5ZZhvTUV+06uPZ7wsDhrrFphmII/6yzzTHn03qHJHCJWL
         PZFK4IuQjpQpq2bcq4l0cqWydrypul4OozziGNF2Vo6BfSgulcaGp9bQ+wsnaOUhi9EH
         V0L5LOIwalmkXqS8Q9kkUGjjd+s6HMwhCdmwvm2bVWBBl5vZERyF4fuK3kf1cuX+u59E
         GyKJpOfBr8/zxP2MVVhTlVn0JvGSiH5pN+5IVUC1iUMyqvf/aUwVDZ6IQEBWUMbgFwam
         XXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oNhbkcb7ihjBx515Q/JOzDwzOtsLAQZqfKTqUdes+dA=;
        b=qOjQONibm5JZlPgIBoQH04CHsJnE8PN7MAXsvSpHvR/v+ZAjXmRWorTScafTShD1TU
         oWpb7Lse1RdQ7kVAzzCtG8nb0t/fbFvjPVNzwpZl2xJiWfKroKRVvVm4EKwbEozdMS7c
         dd8oIN+8k6jK1kpvzVZMy9nUMOm4hIvIldSEl8f7xrY8FtgeTn/KiDcNNhvU657OYOAI
         cdh6XRsz8js053bZ6qjU5xrWJgyGccq0+0mZZ7VcoTJCly7zUy5Vj7dVOZNk53DS40Ot
         Bpx0Rd8AqoGZSTLu+3NIIIwjn2w60aS7cPYnMqV+6crw63eRwe0pkyn5ol9W6A67yjx9
         7Tag==
X-Gm-Message-State: AOAM530P4cP3j2CjhRF1lj0QB/rcz81q86bQglglh2lEgAf/R5J2fWNN
        8wG7Hv79WfiDWVyn+jzi88ZFMlkt
X-Google-Smtp-Source: ABdhPJybvoZyc0mjhb1AU1rUMyn3xCazgvJ4+WjZK7+k4iUVeHnLY8Sb0VjcNeu3tMOHDMoI9K7WTg==
X-Received: by 2002:a62:3744:: with SMTP id e65mr1701423pfa.20.1594675880906;
        Mon, 13 Jul 2020 14:31:20 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n11sm13455023pgm.1.2020.07.13.14.31.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:31:20 -0700 (PDT)
Subject: Re: PATCH ax25: Don't hold skb lock while doing blocking read
To:     Thomas Habets <thomas@habets.se>, netdev@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
References: <CA+kHd+cdzU2qxvHxUNcPtEZiwrDHFCgraOd=BdksMs-snZRUXQ@mail.gmail.com>
 <CA+kHd+ejR-WcVj_PGz9OHXOvSH51R2hQA+NQiLUnqoxE6QQd+g@mail.gmail.com>
 <CA+kHd+cTpqDa+-42Mg1FfNTD9rK7UXR7qjjQUwxta8EO2ahxjg@mail.gmail.com>
 <CA+kHd+fh2UW4FvxL4v_rd8mQ=avuzHxb=n_ogpVwCMSXVTCeAg@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b5303087-f8af-ec9b-afb5-101b8238d523@gmail.com>
Date:   Mon, 13 Jul 2020 14:31:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CA+kHd+fh2UW4FvxL4v_rd8mQ=avuzHxb=n_ogpVwCMSXVTCeAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch title has a typo : there is no skb lock.

On 7/9/20 12:49 PM, Thomas Habets wrote:
> Here's a test program that illustrates the problem:
> https://github.com/ThomasHabets/radiostuff/blob/master/ax25/axftp/examples/client_lockcheck.cc
> 
> Before this patch, this hangs, because the read(2) blocks the
> write(2).
> 
> I see that calling skb_recv_datagram without this lock is done in
> pep_sock_accept() and atalk_recvmsg() and others, which is what makes
> me think it's safe to do here too. But I'm far from an expert on skb
> lock semantics.

Again, do not mix skb and socket ;)

> 
> I see some other socket types are also locking during
> read. E.g. qrtr_recvmsg. Maybe they need to be fixed too.
> 
> Before:
> strace -f -eread,write ./examples/client_lockcheck M0THC-9 M0THC-0 M0THC-2
> strace: Process 3888 attached
> [pid  3888] read(3,  <unfinished ...>
> [pid  3887] write(3, "hello world", 11
> [hang]
> 
> After:
> strace -f -eread,write ./examples/client_lockcheck M0THC-9 M0THC-0 M0THC-2
> strace: Process 2433 attached
> [pid  2433] read(3,  <unfinished ...>
> [pid  2432] write(3, "hello world", 11) = 11
> [pid  2433] <... read resumed> "yo", 1000) = 2
> [pid  2433] write(1, "yo\n", 3yo
> )         = 3
> [successful exit]
> 
> 
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index fd91cd34f25e..378ee132e4d0 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -1617,22 +1617,22 @@ static int ax25_recvmsg(struct socket *sock,
> struct msghdr *msg, size_t size,
>         int copied;
>         int err = 0;
> 
> -       lock_sock(sk);
>         /*
>          *      This works for seqpacket too. The receiver has ordered the
>          *      queue for us! We do one quick check first though
>          */
>         if (sk->sk_type == SOCK_SEQPACKET && sk->sk_state != TCP_ESTABLISHED) {

This would be racy, but maybe we do not care.

>                 err =  -ENOTCONN;
> -               goto out;
> +               goto out_nolock;
>         }
> 
>         /* Now we can treat all alike */
>         skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
>                                 flags & MSG_DONTWAIT, &err);

Or you could use a smaller change and make this look like net/x25/af_x25.c ?

In any case, this will open gates for syzbot fun I am sure ;)


