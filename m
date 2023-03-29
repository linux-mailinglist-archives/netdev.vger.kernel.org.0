Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69A96CD84A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjC2LSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2LSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:18:32 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF37423C
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:18:25 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w9so61744575edc.3
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680088704;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=N5CohG6Xp3aoYNlsfgUXnFLV896u1ewiB5jAiiO+FJI=;
        b=NWYnam7DcNtw+KI6l5gg8Ud/Yu9CFRMEP0PF6Iy98lYqzSE1EUw5UaPkZbZpgjxGgM
         n6Ai2XaI2pV8Yf3EtpHZJkS5qnXrhwjzFqze03qbK5fJ3idyYjff17V8KcePJvTEcpum
         BB4QF6iWL7Zb6hhzH0SKunYUmM8ygzj2d35M4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680088704;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5CohG6Xp3aoYNlsfgUXnFLV896u1ewiB5jAiiO+FJI=;
        b=nAYjHGKi434SloI3uH4tyssatSCz9mCAqAXY9ztPBwXbU3lEKjmFpVaEIMd25F8gnw
         OpMpPXgXqUqj7o5YvOeDdadDG9IGpLsy6B7wyeTxvhcbsJp94nwwT4/p0chLhw62DMbk
         22CTSACg5ihP1HVxtdR1DMSnioT6Zwqgi/3dyOxHqFOE8xfSlDsdQqnFcX09DyLi4pb0
         ICfuVxCTX8vNZBwMDln2g6oUkMLw31sOLR0cAfLmUiSZKUFqrGWUJm703MTrdml5Jd/c
         zjxPGXkgStcfTwdyyxZ0Au7yEN6nOF6YuwWLmVLzeqUs/0joesdMKiSEznYVGf2ROs8x
         52KA==
X-Gm-Message-State: AAQBX9f/KksueOnS5nZ5xuxYTHQf6804OvCZ3sTOkBP65FhZLLJ91Q0J
        1barH68VcTbdLZAVyv8Uyam4rQ==
X-Google-Smtp-Source: AKy350YwT5vle5IWLw83lYuPTrwS8zEFnWxmq0FTdED5tmddZp6tIA0UGpb6cy5lLMplk79JOA55Bw==
X-Received: by 2002:a17:907:8a08:b0:944:44d:c736 with SMTP id sc8-20020a1709078a0800b00944044dc736mr16272991ejc.64.1680088704277;
        Wed, 29 Mar 2023 04:18:24 -0700 (PDT)
Received: from cloudflare.com (79.184.147.137.ipv4.supernova.orange.pl. [79.184.147.137])
        by smtp.gmail.com with ESMTPSA id ch19-20020a170906c2d300b00933d64cd447sm13723918ejb.121.2023.03.29.04.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 04:18:23 -0700 (PDT)
References: <20230327175446.98151-1-john.fastabend@gmail.com>
 <20230327175446.98151-3-john.fastabend@gmail.com>
 <87tty55aou.fsf@cloudflare.com> <642362a1403ee_286af20850@john.notmuch>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     cong.wang@bytedance.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        ast@kernel.org, andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v2 02/12] bpf: sockmap, convert schedule_work into
 delayed_work
Date:   Wed, 29 Mar 2023 13:09:37 +0200
In-reply-to: <642362a1403ee_286af20850@john.notmuch>
Message-ID: <874jq3dcw1.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 02:56 PM -07, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Mon, Mar 27, 2023 at 10:54 AM -07, John Fastabend wrote:
>> > Sk_buffs are fed into sockmap verdict programs either from a strparser
>> > (when the user might want to decide how framing of skb is done by attaching
>> > another parser program) or directly through tcp_read_sock. The
>> > tcp_read_sock is the preferred method for performance when the BPF logic is
>> > a stream parser.
>> >
>> > The flow for Cilium's common use case with a stream parser is,
>> >
>> >  tcp_read_sock()
>> >   sk_psock_verdict_recv
>> >     ret = bpf_prog_run_pin_on_cpu()
>> >     sk_psock_verdict_apply(sock, skb, ret)
>> >      // if system is under memory pressure or app is slow we may
>> >      // need to queue skb. Do this queuing through ingress_skb and
>> >      // then kick timer to wake up handler
>> >      skb_queue_tail(ingress_skb, skb)
>> >      schedule_work(work);
>> >
>> >
>> > The work queue is wired up to sk_psock_backlog(). This will then walk the
>> > ingress_skb skb list that holds our sk_buffs that could not be handled,
>> > but should be OK to run at some later point. However, its possible that
>> > the workqueue doing this work still hits an error when sending the skb.
>> > When this happens the skbuff is requeued on a temporary 'state' struct
>> > kept with the workqueue. This is necessary because its possible to
>> > partially send an skbuff before hitting an error and we need to know how
>> > and where to restart when the workqueue runs next.
>> >
>> > Now for the trouble, we don't rekick the workqueue. This can cause a
>> > stall where the skbuff we just cached on the state variable might never
>> > be sent. This happens when its the last packet in a flow and no further
>> > packets come along that would cause the system to kick the workqueue from
>> > that side.
>> >
>> > To fix we could do simple schedule_work(), but while under memory pressure
>> > it makes sense to back off some instead of continue to retry repeatedly. So
>> > instead to fix convert schedule_work to schedule_delayed_work and add
>> > backoff logic to reschedule from backlog queue on errors. Its not obvious
>> > though what a good backoff is so use '1'.
>> >
>> > To test we observed some flakes whil running NGINX compliance test with
>> > sockmap we attributed these failed test to this bug and subsequent issue.
>> >
>> > Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
>> > Tested-by: William Findlay <will@isovalent.com>
>> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>> > ---
>
> [...]
>
>> > --- a/net/core/skmsg.c
>> > +++ b/net/core/skmsg.c
>> > @@ -481,7 +481,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>> >  	}
>> >  out:
>> >  	if (psock->work_state.skb && copied > 0)
>> > -		schedule_work(&psock->work);
>> > +		schedule_delayed_work(&psock->work, 0);
>> >  	return copied;
>> >  }
>> >  EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
>> > @@ -639,7 +639,8 @@ static void sk_psock_skb_state(struct sk_psock *psock,
>> >  
>> >  static void sk_psock_backlog(struct work_struct *work)
>> >  {
>> > -	struct sk_psock *psock = container_of(work, struct sk_psock, work);
>> > +	struct delayed_work *dwork = to_delayed_work(work);
>> > +	struct sk_psock *psock = container_of(dwork, struct sk_psock, work);
>> >  	struct sk_psock_work_state *state = &psock->work_state;
>> >  	struct sk_buff *skb = NULL;
>> >  	bool ingress;
>> > @@ -679,6 +680,10 @@ static void sk_psock_backlog(struct work_struct *work)
>> >  				if (ret == -EAGAIN) {
>> >  					sk_psock_skb_state(psock, state, skb,
>> >  							   len, off);
>> > +
>> > +					// Delay slightly to prioritize any
>> > +					// other work that might be here.
>> > +					schedule_delayed_work(&psock->work, 1);
>> 
>> Do IIUC that this means we can back out changes from commit bec217197b41
>> ("skmsg: Schedule psock work if the cached skb exists on the psock")?
>
> Yeah I think so this is a more direct way to get the same result. I'm also
> thinking this check,
>
>        if (psock->work_state.skb && copied > 0)
>                schedule_work(&psock->work)
>
> is not correct copied=0 which could happen on empty queue could be the
> result of a skb stuck from this eagain error in backlog.

I suspect the 'copied > 0' check is there to handle the 0-length read
scenario. But I think you're right, that the empty queue scenario is not
being handled properly.

> I think its OK to revert that patch in a separate patch. And ideally we
> could get some way to load up the stack to hit these corner cases without
> running long stress tests.
>
> WDYT?

Yeah, the revert can wait. I was just curious if my thinking was
right. There is plenty of material in this series as is :-)
