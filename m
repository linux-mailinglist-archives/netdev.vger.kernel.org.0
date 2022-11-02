Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF54616551
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 15:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiKBOrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 10:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKBOrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 10:47:08 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AF02A716
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 07:47:04 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-13d604e207aso3105974fac.11
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 07:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VshapdH3qET+2A6w1tOn4K606r3mUYcBf7u3/yyiKmk=;
        b=X1ZE7dBE8BaXuX49QNjyAiYn/xRrnl37HJQP+g4AAanP5xN2owJH/6UXFJIyxXomaA
         U9vHvAqFOSeZxeXKizH32CmTQKnDecpwP6keQSD2cVWUa2xRtOsTEiPjpg/fr+5CQ4dH
         8UvcafbvgUU7l7nJ+ihSc8hKhRMs38ogZaoM+eLCcBPdjYeOxo9qCFQrOPs5YBzRhiEZ
         T7nUuIFGkBCxWDcdSxNH7XyE68DAiVl5s7SRysSDGVuoVokC0j0SoxQtuU547mDFFO5H
         DXW4P4QEehA03BUO/uJpRdW8e2g7Vai6zERny4iD35McHq63cSQVclhMwd7QX4repfk3
         PvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VshapdH3qET+2A6w1tOn4K606r3mUYcBf7u3/yyiKmk=;
        b=ZfJjY05leCR71r3SaXyqU6yapvan4ETRNKZkP118nYJmPW/JpQQznapAAMr1lAFC9T
         T6JXtJpQildfPuBbN8/To/DueuusT1cvpH2Xv4TllLMLaKn4yFYH2I+sBy0QZMdGbwz+
         JMRNRl4ApKjcrqdJ9cuqPtRxme9NnqtOZ17gZk4mQMu3c3WCux1JSc+6SnLqi1SwLbl/
         4Jsp17iVPG4lRhjJ/hopE4NRjd64kkl/qM/Fc3nBEOTLaLR3pg9i8LoajzNL79TlObTT
         BrAGsEl89HuBjBu2hu8gezwPhdINe86CSOtNj4mehM4FIA5ccw3ahVFr1OIVsB+WFXLc
         Zbuw==
X-Gm-Message-State: ACrzQf2xYfB8Eb4flikuSc4+gYVcs9QdTkzB5dImQxo2jMac+KI1jVR+
        l/7LIvVz56FarOvHpwDnyws1mNol2MPIeHK9TbvspA==
X-Google-Smtp-Source: AMsMyM6QxPwtfVBskW0LjxpxIYQ2c4UogHIRy9qjgf9g6nZKZhC3zZ4Y6yQoBx5UEqAXzC3o99IvOnndpchatQK0HJY=
X-Received: by 2002:a05:6870:9a05:b0:132:ebf:dc61 with SMTP id
 fo5-20020a0568709a0500b001320ebfdc61mr14579207oab.76.1667400423352; Wed, 02
 Nov 2022 07:47:03 -0700 (PDT)
MIME-Version: 1.0
References: <20221102132811.70858-1-luwei32@huawei.com>
In-Reply-To: <20221102132811.70858-1-luwei32@huawei.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 2 Nov 2022 10:46:36 -0400
Message-ID: <CADVnQy=uE68AWKuSddKEt3T2X=HUYzs0SQPX31+HgafuysJzkA@mail.gmail.com>
Subject: Re: [patch net v3] tcp: prohibit TCP_REPAIR_OPTIONS if data was
 already sent
To:     Lu Wei <luwei32@huawei.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        xemul@parallels.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, Nov 2, 2022 at 8:23 AM Lu Wei <luwei32@huawei.com> wrote:
>
> If setsockopt with option name of TCP_REPAIR_OPTIONS and opt_code
> of TCPOPT_SACK_PERM is called to enable sack after data is sent
> and before data is acked, ...

This "before data is acked" phrase does not quite seem to match the
sequence below, AFAICT?

How about something like:

 If setsockopt TCP_REPAIR_OPTIONS with opt_code TCPOPT_SACK_PERM
 is called to enable SACK after data is sent and the data sender receives a
 dupack, ...


> ... it will trigger a warning in function
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
> The warning is caused in the following steps:
> 1. a socket named socketA is created
> 2. socketA enters repair mode without build a connection
> 3. socketA calls connect() and its state is changed to TCP_ESTABLISHED
>    directly
> 4. socketA leaves repair mode
> 5. socketA calls sendmsg() to send data, packets_out and sack_outs(dup
>    ack receives) increase
> 6. socketA enters repair mode again
> 7. socketA calls setsockopt with TCPOPT_SACK_PERM to enable sack
> 8. retransmit timer expires, it calls tcp_timeout_mark_lost(), lost_out
>    increases
> 9. sack_outs + lost_out > packets_out triggers since lost_out and
>    sack_outs increase repeatly
>
> In function tcp_timeout_mark_lost(), tp->sacked_out will be cleared if
> Step7 not happen and the warning will not be triggered. As suggested by
> Denis and Eric, TCP_REPAIR_OPTIONS should be prohibited if data was
> already sent. So this patch checks tp->segs_out, only TCP_REPAIR_OPTIONS
> can be set only if tp->segs_out is 0.
>
> socket-tcp tests in CRIU has been tested as follows:
> $ sudo ./test/zdtm.py run -t zdtm/static/socket-tcp*  --keep-going \
>        --ignore-taint
>
> socket-tcp* represent all socket-tcp tests in test/zdtm/static/.
>
> Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameters")
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  net/ipv4/tcp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index ef14efa1fb70..1f5cc32cf0cc 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3647,7 +3647,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
>         case TCP_REPAIR_OPTIONS:
>                 if (!tp->repair)
>                         err = -EINVAL;
> -               else if (sk->sk_state == TCP_ESTABLISHED)
> +               else if (sk->sk_state == TCP_ESTABLISHED && !tp->segs_out)

The tp->segs_out field is only 32 bits wide. By my math, at 200
Gbit/sec with 1500 byte MTU it can wrap roughly every 260 secs. So a
caller could get unlucky or carefully sequence its call to
TCP_REPAIR_OPTIONS (based on packets sent so far) to mess up the
accounting and trigger the kernel warning.

How about using some other method to determine if this is safe?
Perhaps using tp->bytes_sent, which is a 64-bit field, which by my
math would take 23 years to wrap at 200 Gbit/sec?

If we're more paranoid about wrapping we could also check
tp->packets_out, and refuse to allow TCP_REPAIR_OPTIONS if either
tp->bytes_sent or tp->packets_out are non-zero. (Or if we're even more
paranoid I suppose we could have a special new bit to track whether
we've ever sent something, but that probably seems like overkill?)

neal
