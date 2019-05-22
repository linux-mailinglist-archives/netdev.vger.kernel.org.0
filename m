Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FED262CF
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 13:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfEVLOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 07:14:05 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42319 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbfEVLOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 07:14:04 -0400
Received: by mail-lj1-f194.google.com with SMTP id 188so1681603ljf.9
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 04:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=QeEniV4EuL0vykr3M1RmwiUo4QSOm5HcAZQKjYBaa1c=;
        b=lXUwiY9qiyeruhpjMPocrK/rdboK0fJnwGxWem1MhPXfdZ8AaAHGkGr+HkwVRZfOWK
         PshLFJXUUtWjc88Jaxco3cXDhykFpY9EVjQnI7Mp6T2bM6yay1ZhNM2SAfs8CrCPzGd/
         FQCvZ4iSUnvZedEAkBrl1DFi6TysqB7imV0cE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=QeEniV4EuL0vykr3M1RmwiUo4QSOm5HcAZQKjYBaa1c=;
        b=bXxGNEV11LhOHqU/z3V6P1SBTV77Lh7lNwtKnlhgCPHjk399G9gevKuP8sV+TvskBo
         xhoLsNOQCA/7M6ru3wJpYZu8VWIXcd6wwoTupJxFCgTV6oOXGLK7300mRWqAO0SbKGJB
         4TrCFvMB8DX6lw/SrudrdBchKNWTEi2nARDK1NpIn734mc9xYMNJyGNGe2x3bMU4E5sE
         fsk7rWBk2+XbjgIe9ohFkNde5ZtMWcmho6URRoL23dcJ84Lka0CgAK6TGkX0Mho5Zhp5
         zMooyjSaGBDZyn/Lcyg3vKqozN0qlIjoQ3w1O7Ee96vIEfScE5CuvFRYsoZoTMcM6M+k
         ByZA==
X-Gm-Message-State: APjAAAXkDDSAGztrcDx5xEgIeHkf1NWdhrEUCRbRGRVmr5xHNkLrG83d
        rWH5StsSs8+xz/zc8ItyfZKRKg==
X-Google-Smtp-Source: APXvYqztRG7GJqRWjeyhozQZ3iHCvMUu78dZl/X0nNeIpBR1UZsUbDXLq2Wdsf3NRnK+ys7tTIzLAQ==
X-Received: by 2002:a2e:4710:: with SMTP id u16mr14811055lja.41.1558523641714;
        Wed, 22 May 2019 04:14:01 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id 11sm4895988lfr.5.2019.05.22.04.14.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 04:14:00 -0700 (PDT)
References: <20190211090949.18560-1-jakub@cloudflare.com> <5439765e-1288-c379-0ead-75597092a404@iogearbox.net> <871s423i6d.fsf@cloudflare.com> <5ce45a6fcd82d_48b72ac3337c45b85f@john-XPS-13-9360.notmuch>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH net] sk_msg: Keep reference on socket file while psock lives
In-reply-to: <5ce45a6fcd82d_48b72ac3337c45b85f@john-XPS-13-9360.notmuch>
Date:   Wed, 22 May 2019 13:14:00 +0200
Message-ID: <87v9y2zqpz.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On Tue, May 21, 2019 at 10:07 PM CEST, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> Hi Daniel,
>>
>> On Tue, Feb 19, 2019 at 05:00 PM CET, Daniel Borkmann wrote:
>> > On 02/11/2019 10:09 AM, Jakub Sitnicki wrote:
>> >> Backlog work for psock (sk_psock_backlog) might sleep while waiting for
>> >> memory to free up when sending packets. While sleeping, socket can
>> >> disappear from under our feet together with its wait queue because the
>> >> userspace has closed it.
>> >>
>> >> This breaks an assumption in sk_stream_wait_memory, which expects the
>> >> wait queue to be still there when it wakes up resulting in a
>> >> use-after-free:
>> >>
>> >> ==================================================================
>> >> BUG: KASAN: use-after-free in remove_wait_queue+0x31/0x70
>> >> Write of size 8 at addr ffff888069a0c4e8 by task kworker/0:2/110
>> >>
>> >> CPU: 0 PID: 110 Comm: kworker/0:2 Not tainted 5.0.0-rc2-00335-g28f9d1a3d4fe-dirty #14
>> >> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
>> >> Workqueue: events sk_psock_backlog
>> >> Call Trace:
>> >>  print_address_description+0x6e/0x2b0
>> >>  ? remove_wait_queue+0x31/0x70
>> >>  kasan_report+0xfd/0x177
>> >>  ? remove_wait_queue+0x31/0x70
>> >>  ? remove_wait_queue+0x31/0x70
>> >>  remove_wait_queue+0x31/0x70
>> >>  sk_stream_wait_memory+0x4dd/0x5f0
>> >>  ? sk_stream_wait_close+0x1b0/0x1b0
>> >>  ? wait_woken+0xc0/0xc0
>> >>  ? tcp_current_mss+0xc5/0x110
>> >>  tcp_sendmsg_locked+0x634/0x15d0
>
> [...]
>
>> >>
>> >> Avoid it by keeping a reference to the socket file until the psock gets
>> >> destroyed.
>> >>
>> >> While at it, rearrange the order of reference grabbing and
>> >> initialization to match the destructor in reverse.
>> >>
>> >> Reported-by: Marek Majkowski <marek@cloudflare.com>
>> >> Link: https://lore.kernel.org/netdev/CAJPywTLwgXNEZ2dZVoa=udiZmtrWJ0q5SuBW64aYs0Y1khXX3A@mail.gmail.com
>> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> >> ---
>> >>  net/core/skmsg.c | 8 +++++++-
>> >>  1 file changed, 7 insertions(+), 1 deletion(-)
>> >>
>> >> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
>> >> index 8c826603bf36..a38442b8580b 100644
>> >> --- a/net/core/skmsg.c
>> >> +++ b/net/core/skmsg.c
>> >> @@ -493,8 +493,13 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
>> >>  	sk_psock_set_state(psock, SK_PSOCK_TX_ENABLED);
>> >>  	refcount_set(&psock->refcnt, 1);
>> >>
>> >> -	rcu_assign_sk_user_data(sk, psock);
>> >> +	/* Hold on to socket wait queue. Backlog work waits on it for
>> >> +	 * memory when sending. We must cancel work before socket wait
>> >> +	 * queue can go away.
>> >> +	 */
>> >> +	get_file(sk->sk_socket->file);
>> >>  	sock_hold(sk);
>> >> +	rcu_assign_sk_user_data(sk, psock);
>> >>
>> >>  	return psock;
>> >>  }
>> >> @@ -558,6 +563,7 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
>> >>  	if (psock->sk_redir)
>> >>  		sock_put(psock->sk_redir);
>> >>  	sock_put(psock->sk);
>> >> +	fput(psock->sk->sk_socket->file);
>> >
>> > Thanks for the report (and sorry for the late reply). I think holding ref on
>> > the struct file just so we keep it alive till deferred destruction might be
>> > papering over the actual underlying bug. Nothing obvious pops out from staring
>> > at the code right now; as a reproducer to run, did you use the prog in the link
>> > above and hit it after your strparser fix?
>>
>> I get you, I actually sat on this fix for a moment because I had a
>> similar concern, that holding a file ref is a heavy-handed fix and I'm
>> not seeing the real problem.
>>
>> For me it came down to this:
>
>> 1. tcp_sendmsg_locked that we call from psock backlog work can end up
>>    waiting for memory. We somehow need to ensure that the socket wait
>>    queue does not disappear until tcp_sendmsg_locked returns.
>>
>> 2. KCM, which I assume must have the same problem, holds a reference on
>>    the socket file.
>>
>> I'm curious if there is another angle to it.
>>
>> To answer your actual questions - your guesses are correct on both
>> accounts.
>>
>> For the reproducer, I've used the TCP echo program from Marek [1]. On
>> the client side, I had something like:
>>
>>   while :; do
>>     nc 10.0.0.1 12345 > /dev/null < /dev/zero &
>>     pid=$!
>>     sleep 0.1
>>     kill $pid
>>   done
>>
>> I can dig out the test scripts or help testing any patches.
>>
>> I was testing with the strparser fix applied, 1d79895aef18 ("sk_msg:
>> Always cancel strp work before freeing the psock"), which unfortunately
>> was not enough.
>>
>> The explanation there was that the socket descriptor can get closed, and
>> in consequence the socket file can get destroyed, before the deferred
>> destructor for psock runs. So psock backlog work can be still very much
>> alive and running while the socket file is gone.
>>
>> Thanks for looking into it,
>> -Jakub
>>
>> [1] https://gist.github.com/majek/a09bcbeb8ab548cde6c18c930895c3f2
>
> In the sendpage case we set the MSG_DONTWAIT flag, I think we should
> set it in the sendmsg case as well. This would result in
> tcp_sendmsg_locked() setting timeo via sock_sndtimeo to zero and should
> avoid any waiting. And then we avoid above use after free bug.
>
> Then handle the error in sk_psock_backlog() correctly it returns an
> EAGAIN (I think?) in this case so we will deduct any sent bytes and
> increment the offset as needed and try again here. Except we will
> have purged the ingress_skb list so we should abort.
>
> And the work queue should be flushed before destroying psock so we
> can be assured that the psock reference is not lost.
>
> Here is what I'm thinking still untested. Because skmsg is the only
> user of skb_send_sock_locked() this should be OK to do. If you have
> time running your tests again would be great. I can also try to
> repro.
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index e89be6282693..eadfd16be7db 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2337,6 +2337,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
>                 kv.iov_base = skb->data + offset;
>                 kv.iov_len = slen;
>                 memset(&msg, 0, sizeof(msg));
> +               msg->flags = MSG_DONTWAIT;
>
>                 ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
>                 if (ret <= 0)

Thanks for taking a look at it. Setting MSG_DONTWAIT works great for
me. No more crashes in sk_stream_wait_memory. I've tested it on top of
current bpf-next (f49aa1de9836). Here's my:

  Tested-by: Jakub Sitnicki <jakub@cloudflare.com>

The actual I've tested is below, for completeness.

BTW. I've ran into another crash which I haven't seen before while
testing sockmap-echo, but it looks unrelated:

  https://lore.kernel.org/netdev/20190522100142.28925-1-jakub@cloudflare.com/

-Jakub

--- 8< ---

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e89be6282693..4a7c656b195b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2337,6 +2337,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
                kv.iov_base = skb->data + offset;
                kv.iov_len = slen;
                memset(&msg, 0, sizeof(msg));
+               msg.msg_flags = MSG_DONTWAIT;

                ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
                if (ret <= 0)
