Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667AC5FE4EF
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 00:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiJMWCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 18:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiJMWCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 18:02:39 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE756189C12
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 15:02:38 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-357208765adso29947957b3.12
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 15:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hZ05NezorcEtoVNj7unPXrgpx+kKJvY/SBKVBU51cG8=;
        b=kQHWuBMSm95FHVfPYenSVW6q+WXGzYRlH84J7fGwUfg20rFIOhMaUVVZMhexUoMz8g
         C6bk/266XQ7KcD4Kz+kfwGBLHyaPXFU/fXzVg+jXqtc0pU4Tr8XekSa4H4qRIXrdd/7t
         gZIljrpQhjrAQZ3U47fLsU1p9WNYwxqe7Nhz3oNRyaOEfYfd4elXYBf0Z7GeblnjlRPS
         yH0yv/tM1QvkO1efhpc3hFUCRE1pQmxleoj0lFq5tMTsHXNCNAooH7AX6/1YTqo62oIL
         CDJcM0S695bLMAoa1Qtz7OMw8S3o7xrp/JOBVSvzOtIxh9CIMYXDVNA6Hk6wgWU/M9b9
         n4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hZ05NezorcEtoVNj7unPXrgpx+kKJvY/SBKVBU51cG8=;
        b=Dc2ZD29LdUvbOymoxqsWS7aeO16/PjCKOJ9rJqzfsvnbJFaI7DJ6TZbYywWKlVndtw
         ISsXttEwW6CqyIC2vlGHvh7f/qHIdwEIeR4bwtWD+uWjex2hd5Aezh2bhJhKsk+EhC/d
         AhapHxabRclAYQcMCtHrSiXYNdyVWIkTgBkNYzke9+oncpYh55mJdet9Bo76hJauNAz9
         es8dggerR2uKRiXQpKiO5Uxotje0d9MWEU+5uDNRGVIOHkxI2D8cZCx1Ebs1OHHReZVE
         WmLNz1wYv/s5FZ0FmCLhnK58QkFtXuDNFbjY/Fv3i+cCKPwxL34otg5kKVrPsqVVgiFB
         UO8A==
X-Gm-Message-State: ACrzQf2zNJjRj2PY29Cs39PFDUmeJUqthw20DK2u6rL3pQKyJAFB+rSM
        lvNihHWiyQNai2AKlPagn68ugb/xztg3GLk6nOOeHw==
X-Google-Smtp-Source: AMsMyM4v8k3TxWAK7J74yVZadAuceNPbHEFNsa95OWDzDPxn/WmC0hSnpPnttnscsdNxJjD6G/YMPPz5yS0PR+CaU1s=
X-Received: by 2002:a0d:d807:0:b0:356:851e:b8eb with SMTP id
 a7-20020a0dd807000000b00356851eb8ebmr1883720ywe.489.1665698557585; Thu, 13
 Oct 2022 15:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210817194003.2102381-1-weiwan@google.com> <20221012163300.795e7b86@kernel.org>
 <20221013144950.44b52f90@kernel.org>
In-Reply-To: <20221013144950.44b52f90@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 13 Oct 2022 15:02:26 -0700
Message-ID: <CANn89iJ0SYX_oxjZE_2BOLzWXemA2mZeMeOdPoEFiu-AxE2GMQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Wang <weiwan@google.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Neil Spring <ntspring@meta.com>, ycheng@google.com
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

On Thu, Oct 13, 2022 at 2:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 12 Oct 2022 16:33:00 -0700 Jakub Kicinski wrote:
> > This patch is causing a little bit of pain to us, to workloads running
> > with just memory.max set. After this change the TCP rx path no longer
> > forces the charging.
> >
> > Any recommendation for the fix? Setting memory.high a few MB under
> > memory.max seems to remove the failures.
>
> Eric, is there anything that would make the TCP perform particularly
> poorly under mem pressure?
>
> Dropping and pruning happens a lot here:
>
> # nstat -a | grep -i -E 'Prune|Drop'
> TcpExtPruneCalled               1202577            0.0
> TcpExtOfoPruned                 734606             0.0
> TcpExtTCPOFODrop                64191              0.0
> TcpExtTCPRcvQDrop               384305             0.0
>
> Same workload on 5.6 kernel:
>
> TcpExtPruneCalled               1223043            0.0
> TcpExtOfoPruned                 3377               0.0
> TcpExtListenDrops               10596              0.0
> TcpExtTCPOFODrop                22                 0.0
> TcpExtTCPRcvQDrop               734                0.0
>
> From a quick look at the code and with what Shakeel explained in mind -
> previously we would have "loaded up the cache" after the first failed
> try, so we never got into the loop inside tcp_try_rmem_schedule() which
> most likely nukes the entire OFO queue:
>
> static int tcp_try_rmem_schedule(struct sock *sk, struct sk_buff *skb,
>                                  unsigned int size)
> {
>         if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
>             !sk_rmem_schedule(sk, skb, size)) {
>             /* ^ would fail but "load up the cache" ^ */
>
>                 if (tcp_prune_queue(sk) < 0)
>                         return -1;
>
>                 /* v this one would not fail due to the cache v */
>                 while (!sk_rmem_schedule(sk, skb, size)) {
>                         if (!tcp_prune_ofo_queue(sk))
>                                 return -1;
>
> Neil mentioned that he's seen multi-second stalls when SACKed segments
> get dropped from the OFO queue. Sender waits for a very long time before
> retrying something that was already SACKed if the receiver keeps
> sacking new, later segments. Even when ACK reaches the previously-SACKed
> block which should prove to the sender that something is very wrong.
>
> I tried to repro this with a packet drill and it's not what I see
> exactly, I need to keep shortening the RTT otherwise the retx comes
> out before the next SACK arrives.
>
> I'll try to read the code, and maybe I'll get lucky and manage capture
> the exact impacted flows :S But does anything of this nature ring the
> bell?
>
> `../common/defaults.sh`
>
>     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
>
>    +0 < S 0:0(0) win 65535 <mss 1000,sackOK,nop,nop,nop,wscale 8>
>    +0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK,nop,wscale 8>
>   +.1 < . 1:1(0) ack 1 win 2048
>    +0 accept(3, ..., ...) = 4
>
>    +0 write(4, ..., 60000) = 60000
>    +0 > P. 1:10001(10000) ack 1
>
> // Do some SACK-ing
>   +.1 < . 1:1(0) ack 1 win 513 <sack 1001:2001,nop,nop>
> +.001 < . 1:1(0) ack 1 win 513 <sack 1001:2001 3001:4001 5001:6001,nop,nop>
> // ..and we pretend we lost 1001:2001
> +.001 < . 1:1(0) ack 1 win 513 <sack 2001:10001,nop,nop>
>
> // re-xmit holes and send more
>    +0 > . 10001:11001(1000) ack 1
>    +0 > . 1:1001(1000) ack 1
>    +0 > . 2001:3001(1000) ack 1 win 256
>    +0 > P. 11001:13001(2000) ack 1 win 256
>    +0 > P. 13001:15001(2000) ack 1 win 256
>
>   +.1 < . 1:1(0) ack 1001 win 513 <sack 2001:15001,nop,nop>
>
>    +0 > P. 15001:18001(3000) ack 1 win 256
>    +0 > P. 18001:20001(2000) ack 1 win 256
>    +0 > P. 20001:22001(2000) ack 1 win 256
>
>   +.1 < . 1:1(0) ack 1001 win 513 <sack 2001:22001,nop,nop>
>
>    +0 > P. 22001:24001(2000) ack 1 win 256
>    +0 > P. 24001:26001(2000) ack 1 win 256
>    +0 > P. 26001:28001(2000) ack 1 win 256
>    +0 > .  28001:29001(1000) ack 1 win 256
>
> +0.05 < . 1:1(0) ack 1001 win 257 <sack 2001:29001,nop,nop>
>
>    +0 > P. 29001:31001(2000) ack 1 win 256
>    +0 > P. 31001:33001(2000) ack 1 win 256
>    +0 > P. 33001:35001(2000) ack 1 win 256
>    +0 > . 35001:36001(1000) ack 1 win 256
>
> +0.05 < . 1:1(0) ack 1001 win 257 <sack 2001:36001,nop,nop>
>
>    +0 > P. 36001:38001(2000) ack 1 win 256
>    +0 > P. 38001:40001(2000) ack 1 win 256
>    +0 > P. 40001:42001(2000) ack 1 win 256
>    +0 > .  42001:43001(1000) ack 1 win 256
>
> +0.05 < . 1:1(0) ack 1001 win 257 <sack 2001:43001,nop,nop>
>
>    +0 > P. 43001:45001(2000) ack 1 win 256
>    +0 > P. 45001:47001(2000) ack 1 win 256
>    +0 > P. 47001:49001(2000) ack 1 win 256
>    +0 > .  49001:50001(1000) ack 1 win 256
>
> +0.04 < . 1:1(0) ack 1001 win 257 <sack 2001:50001,nop,nop>
>
>    +0 > P. 50001:52001(2000) ack 1 win 256
>    +0 > P. 52001:54001(2000) ack 1 win 256
>    +0 > P. 54001:56001(2000) ack 1 win 256
>    +0 > .  56001:57001(1000) ack 1 win 256
>
> +0.04 > . 1001:2001(1000) ack 1 win 256
>
>

This is SACK reneging, I would have to double check linux behavior, but
reverting to timeout could very well happen.

>   +.1 < . 1:1(0) ack 1001 win 257 <sack 2001:29001,nop,nop>
>
