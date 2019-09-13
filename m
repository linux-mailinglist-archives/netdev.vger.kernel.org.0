Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A748AB26EC
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 22:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbfIMU4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 16:56:04 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43020 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfIMU4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 16:56:04 -0400
Received: by mail-oi1-f193.google.com with SMTP id t84so3763626oih.10
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ZtcRy6y7UsD8Dvguv2gDIpViUYDH0Xd9HceKAQsZBE=;
        b=gspKMPs9Me0LZ2kWclW41T5G7oxsV8Ojf1izGranZiFIwnwow5b9hflQlUq9NVYJRA
         pI1MnB2/QAAziqfkPtUJXv8H9EgdoNoL7NCjjGTOrbPJzUu3+LhQzJP8dvCx62CRtUTn
         CxzLn7v+pGGP/1CcMXQ7bTcUCMoPEfrTrwW8/MOkUEkFsuTN3RsRK0mmW/bpxrGU1fNH
         8OmpywtCh3BA7qovoxTO4xRy0EdE9K6L1ysp749AYLHRnDZXCrKhlj7mM07z6bD5XMfu
         i6D2Ew1+rehLzsPunX/JRngcVwSa5VARyHTwGAqx1tK0GS0s1G4FVrK06lAfpQlet7w1
         E5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ZtcRy6y7UsD8Dvguv2gDIpViUYDH0Xd9HceKAQsZBE=;
        b=pXMQNLsE79QnWfPFyPqfZjAiCbjClM8nW8hTXmhDTqB83V0vBGQ3HdRQd0312ROguZ
         ZYa+7Pf5NR1ufMMrkKNO2lOwtBVLmW1GJv5AFH+vWFehmUzjnBcTXLJruh6lGL4XM6nk
         eoKpeNiL42PTBLT+HvizzS+NsdHmKwojmP/zobqcdNrFOa1u07Yos08Oeyw+QA+VQaDK
         UICj5nAdkoSE/4K0WOgJng88hjIHsGAowgMTZU+1TRq9N1mI/cmGy7OiyyDlZnXe9b0C
         4Qe1zgYhuTvWwzk2WeFtlhm0tZs3Wy+0YdiLuI8KKc+6x/rY5WZhDw39crtO4tqARbSV
         H1qQ==
X-Gm-Message-State: APjAAAWxMDLq1h00P4smtD0Gg+nq299xboyj79advMI7pszOnq86JSzE
        thI3dIydvOo/BDJaCrp+693wqwvWzDu2MyVjBTXAjw==
X-Google-Smtp-Source: APXvYqw7l/Rmo5hcTv38zawpsU84hZztsnV7zkn7WbC7OP8qObza2LY8jbBvje4p/GMn/87hKHRFy2vjzr1XUhSqt+8=
X-Received: by 2002:aca:578a:: with SMTP id l132mr5255601oib.14.1568408163040;
 Fri, 13 Sep 2019 13:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190913193629.55201-1-tph@fb.com>
In-Reply-To: <20190913193629.55201-1-tph@fb.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 13 Sep 2019 16:55:46 -0400
Message-ID: <CADVnQym9bN55+2m5TKw61sdJ=sEAnTaabX5-=R-Yor6Y9Np78A@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] tcp: Add TCP_INFO counter for packets received out-of-order
To:     Thomas Higdon <tph@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 3:37 PM Thomas Higdon <tph@fb.com> wrote:
>
> For receive-heavy cases on the server-side, we want to track the
> connection quality for individual client IPs. This counter, similar to
> the existing system-wide TCPOFOQueue counter in /proc/net/netstat,
> tracks out-of-order packet reception. By providing this counter in
> TCP_INFO, it will allow understanding to what degree receive-heavy
> sockets are experiencing out-of-order delivery and packet drops
> indicating congestion.
>
> Please note that this is similar to the counter in NetBSD TCP_INFO, and
> has the same name.
>
> Signed-off-by: Thomas Higdon <tph@fb.com>
> ---
>
> no changes from v3
>
>  include/linux/tcp.h      | 2 ++
>  include/uapi/linux/tcp.h | 2 ++
>  net/ipv4/tcp.c           | 2 ++
>  net/ipv4/tcp_input.c     | 1 +
>  4 files changed, 7 insertions(+)
>
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index f3a85a7fb4b1..a01dc78218f1 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -393,6 +393,8 @@ struct tcp_sock {
>          */
>         struct request_sock *fastopen_rsk;
>         u32     *saved_syn;
> +
> +       u32 rcv_ooopack; /* Received out-of-order packets, for tcpinfo */

Thanks for adding this.

A thought: putting the new rcv_ooopack field here makes struct
tcp_sock bigger, and increases the odds of taking a cache miss
(according to "pahole" this field is the only one in a new cache
line).

I'd suggest putting the new rcv_ooopack field immediately before
rcv_rtt_last_tsecr. That would use up a 4-byte hole, and would place
it in a cache line already used on TCP receivers (for rcv_rtt logic).
This would make it less likely this new field causes more cache misses
or uses more space.

Details: looking at the output of "pahole" for tcp_sock in various cases:

net-next before this patch:
-------------------------------------
...
        u8                         bpf_sock_ops_cb_flags; /*  2076     1 */

        /* XXX 3 bytes hole, try to pack */

        u32                        rcv_rtt_last_tsecr;   /*  2080     4 */

        /* XXX 4 bytes hole, try to pack */

        struct {
                u32                rtt_us;               /*  2088     4 */
                u32                seq;                  /*  2092     4 */
                u64                time;                 /*  2096     8 */
        } rcv_rtt_est;                                   /*  2088    16 */
...
        /* size: 2176, cachelines: 34, members: 134 */
        /* sum members: 2164, holes: 4, sum holes: 12 */
        /* paddings: 3, sum paddings: 12 */


net-next with this patch:
-------------------------------------
...
        u32 *                      saved_syn;            /*  2168     8 */
        /* --- cacheline 34 boundary (2176 bytes) --- */
        u32                        rcv_ooopack;          /*  2176     4 */
...
        /* size: 2184, cachelines: 35, members: 135 */
        /* sum members: 2168, holes: 4, sum holes: 12 */
        /* padding: 4 */
        /* paddings: 3, sum paddings: 12 */
        /* last cacheline: 8 bytes */


net-next with this field in the suggested spot:
-------------------------------------
...
       /* XXX 3 bytes hole, try to pack */

        u32                        rcv_ooopack;          /*  2080     4 */
        u32                        rcv_rtt_last_tsecr;   /*  2084     4 */
        struct {
                u32                rtt_us;               /*  2088     4 */
                u32                seq;                  /*  2092     4 */
                u64                time;                 /*  2096     8 */
        } rcv_rtt_est;                                   /*  2088    16 */
...
        /* size: 2176, cachelines: 34, members: 135 */
        /* sum members: 2168, holes: 3, sum holes: 8 */
        /* paddings: 3, sum paddings: 12 */

neal


neal
