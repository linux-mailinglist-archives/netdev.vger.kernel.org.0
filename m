Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7425C5150B1
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379001AbiD2Q0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378193AbiD2Q0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:26:45 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CB7D115C
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 09:23:25 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2f7d19cac0bso90291937b3.13
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 09:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ufwf5nPmiGWY02TSHqw711Kb8Y/qjOIHYQ3CbZBh4GE=;
        b=LUbHWaGJ4DUjKQYdHytl3Z0D6PuKsyN4ozozVtpdc21c8IUQ+EwLWXoGIRVMtzeQri
         FnDMPEVThANe9OEav/BKzBV8GxjAK/rDugxdpguEq9P+QXxj7/iQfKifditRw7bYv2ID
         4cImlrlI5GOrNG6CQxuA56s4nMDuCnUfnPTbLoSl4SQMjsgWyw+f0f6X8aGU7g79dUUr
         L0JE+g+AIKy3k4XKDQjxCCXkUits/XdtJOGnSZHfYDzvcmC88krN5qasjw3VE8hdUwAW
         y1MfqyyXEaw8zVwbDowDS3eC/HaKQ2lalJjjBIoyL5uryTijhgVP6CXoUOKY0j301IMs
         wvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ufwf5nPmiGWY02TSHqw711Kb8Y/qjOIHYQ3CbZBh4GE=;
        b=z/aneyqk0bcMbnTYmThJHd/3CdOz3QoNCmGHDLMOpJ+B7Bxvrx5Ay/lrXI2xMG6O+3
         i5fNhgSS418jdp+CR+xPY8JL5uTTwIzWg3Slg1Z8UBaerEZSW08OzavnSsb8EsDD2s6j
         pSm20jCW4gxYVsGBy/hK1c9JibGuOyFEDixUtlN7IuC7CnsdQliJobezeC4Y9xkOk5uD
         RBcxNSa9SF4kd1pwPucF3Ioi3/zZcZoALBM34cIJ4v6V09Dizr2qMEMY9ygmJRvN4OQM
         lkBSFJH82UVOtDmWsGV8mTXs90iJ9Ppc6U5rf3KTLFjmhiEQHCQysxLlB3tDdTzg8oN/
         C5Dw==
X-Gm-Message-State: AOAM530FuDGCTQZwLg2wMQjUA7wXGlA2IrrqSNbxdT6yOg47coVA1+Pc
        nITN4wjDsAgZn3guUA9wwLl2E5p2QeyR9Vl3/uvBRA==
X-Google-Smtp-Source: ABdhPJye0INZ7S6kaRngVFkeD8mlUAgAvUewhN42c04F0KIemmCeYgYN8ibMHFRllLJ0kt2NmeOC7xx9WVZHA5qiGcA=
X-Received: by 2002:a81:1d4e:0:b0:2f7:be8b:502e with SMTP id
 d75-20020a811d4e000000b002f7be8b502emr42794ywd.278.1651249404316; Fri, 29 Apr
 2022 09:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220422201237.416238-1-eric.dumazet@gmail.com> <20220429161810.GA175@qian>
In-Reply-To: <20220429161810.GA175@qian>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 29 Apr 2022 09:23:13 -0700
Message-ID: <CANn89iLNpxXJMyDM-xLE_=N5jZ4jw6tfu+U++LSduUmnX7UE+g@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
To:     Qian Cai <quic_qiancai@quicinc.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 9:18 AM Qian Cai <quic_qiancai@quicinc.com> wrote:
>
> On Fri, Apr 22, 2022 at 01:12:37PM -0700, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Logic added in commit f35f821935d8 ("tcp: defer skb freeing after socket
> > lock is released") helped bulk TCP flows to move the cost of skbs
> > frees outside of critical section where socket lock was held.
> >
> > But for RPC traffic, or hosts with RFS enabled, the solution is far from
> > being ideal.
> >
> > For RPC traffic, recvmsg() has to return to user space right after
> > skb payload has been consumed, meaning that BH handler has no chance
> > to pick the skb before recvmsg() thread. This issue is more visible
> > with BIG TCP, as more RPC fit one skb.
> >
> > For RFS, even if BH handler picks the skbs, they are still picked
> > from the cpu on which user thread is running.
> >
> > Ideally, it is better to free the skbs (and associated page frags)
> > on the cpu that originally allocated them.
> >
> > This patch removes the per socket anchor (sk->defer_list) and
> > instead uses a per-cpu list, which will hold more skbs per round.
> >
> > This new per-cpu list is drained at the end of net_action_rx(),
> > after incoming packets have been processed, to lower latencies.
> >
> > In normal conditions, skbs are added to the per-cpu list with
> > no further action. In the (unlikely) cases where the cpu does not
> > run net_action_rx() handler fast enough, we use an IPI to raise
> > NET_RX_SOFTIRQ on the remote cpu.
> >
> > Also, we do not bother draining the per-cpu list from dev_cpu_dead()
> > This is because skbs in this list have no requirement on how fast
> > they should be freed.
> >
> > Note that we can add in the future a small per-cpu cache
> > if we see any contention on sd->defer_lock.
>
> Hmm, we started to see some memory leak reports from kmemleak that have
> been around for hours without being freed since yesterday's linux-next
> tree which included this commit. Any thoughts?
>
> unreferenced object 0xffff400610f55cc0 (size 216):
>   comm "git-remote-http", pid 781180, jiffies 4314091475 (age 4323.740s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 c0 7e 87 ff 3f ff ff 00 00 00 00 00 00 00 00  ..~..?..........
>   backtrace:
>      kmem_cache_alloc_node
>      __alloc_skb
>      __tcp_send_ack.part.0
>      tcp_send_ack
>      tcp_cleanup_rbuf
>      tcp_recvmsg_locked
>      tcp_recvmsg
>      inet_recvmsg
>      __sys_recvfrom
>      __arm64_sys_recvfrom
>      invoke_syscall
>      el0_svc_common.constprop.0
>      do_el0_svc
>      el0_svc
>      el0t_64_sync_handler
>      el0t_64_sync
> unreferenced object 0xffff4001e58f0c40 (size 216):
>   comm "git-remote-http", pid 781180, jiffies 4314091483 (age 4323.968s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 c0 7e 87 ff 3f ff ff 00 00 00 00 00 00 00 00  ..~..?..........
>   backtrace:
>      kmem_cache_alloc_node
>      __alloc_skb
>      __tcp_send_ack.part.0
>      tcp_send_ack
>      tcp_cleanup_rbuf
>      tcp_recvmsg_locked
>      tcp_recvmsg
>      inet_recvmsg
>      __sys_recvfrom
>      __arm64_sys_recvfrom
>      invoke_syscall
>      el0_svc_common.constprop.0
>      do_el0_svc
>      el0_svc
>      el0t_64_sync_handler
>      el0t_64_sync

Which tree are you using ?

Ido said the leak has been fixed in
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=f3412b3879b4f7c4313b186b03940d4791345534
