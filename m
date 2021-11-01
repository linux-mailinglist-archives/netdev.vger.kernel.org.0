Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5EC4420BD
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 20:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhKATZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 15:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbhKATZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 15:25:02 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEF6C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 12:22:28 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id i9so17041027qki.3
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 12:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cn68F3AcLYrb8nMJ8xSM0TLR9A80m1LXeQBBE0KZNgo=;
        b=dGTnH6/3QpH80bmiWodCiS0jeBeJ7NTIywierL6ecDg1Zz9sdXSKmOOdB95NkLUK21
         4flfcpTie3pys4AEg/g1DTWuc2TixYzJA2e27DrbqjVf4e48F4afmUAegjwnUAJa7QCk
         qqOMxC+n5QXWwdNOM0rN1sSpvdDnHQlK/xPnKRuwY1+hWrHU6OnxFjE/Fq0TxTlbSpqg
         P3fioCEwJqvosl7eP36fgLJWPcRDhtAXLF/DnJWmmE7IPTLWQ+d2B/9lGrXLetdfYAdh
         +Yv2NaM9V/VYbmzO3uaWdLNXVjfy178VILbHAba6UVggo0FQsi9lT1SfqeFO/li5RB/4
         yVtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cn68F3AcLYrb8nMJ8xSM0TLR9A80m1LXeQBBE0KZNgo=;
        b=BYbe0Tz1dIeeiQsWpMb1Lrk8f5z6rko+hfFI6/lnQmrWzbnw6zs+fHx3EbaojPI0Uv
         hQqN59Sv36+qzjkSUYsG+xYDb0IRxUinmN5YSYfdWRIMYRa9ROukCTebAToFwrx7vzI1
         bDF43oI6pOurJbu/UiIwvosERZ+KcnrCwUxtoyVEmNYHnZ9GV1+/OPrTB1aPKhuayYEL
         AvJq/YMrXJg2esrVUgTJEbdi4f+7z0t8RyRdKP4P5RyhfUmOnZmItxovYP04Nf1cn2R5
         uT/kDW1K8dVEZw7svCC2ipYPMNdHKNLzZAO5S25Q/8s4FHnOrJMtDgOIzX78AIYg0IhY
         vKIg==
X-Gm-Message-State: AOAM530jqsAny5J7UyY3tBkZY1MtdozygpG4EmqyeNfD01F5kKnpSAK9
        sBMDthGh1g9NoQmem+NDMl8fsG4weNt0HCiGmx/Exg==
X-Google-Smtp-Source: ABdhPJyE7RArczaNdL0D1S1vAPyecuDc91E8gExiBs5AeCrNh8tSBwoegLoi41Fs09DtHsZzljDdRZzMUnILF1z5YGI=
X-Received: by 2002:a37:b7c6:: with SMTP id h189mr24717038qkf.377.1635794547806;
 Mon, 01 Nov 2021 12:22:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1635784253.git.cdleonard@gmail.com> <6097ec24d87efc55962a1bfac9441132f0fc4206.1635784253.git.cdleonard@gmail.com>
In-Reply-To: <6097ec24d87efc55962a1bfac9441132f0fc4206.1635784253.git.cdleonard@gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Mon, 1 Nov 2021 12:22:17 -0700
Message-ID: <CA+HUmGgMAU235hMtTgucVb1GX_Ru83bngHg8-Jvy2g6BA7djsg@mail.gmail.com>
Subject: Re: [PATCH v2 11/25] tcp: authopt: Implement Sequence Number Extension
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Compute SNE for a specific packet (by seq). */
> +static int compute_packet_sne(struct sock *sk, struct tcp_authopt_info *info,
> +                             u32 seq, bool input, __be32 *sne)
> +{
> +       u32 rcv_nxt, snd_nxt;
> +
> +       // We can't use normal SNE computation before reaching TCP_ESTABLISHED
> +       // For TCP_SYN_SENT the dst_isn field is initialized only after we
> +       // validate the remote SYN/ACK
> +       // For TCP_NEW_SYN_RECV there is no tcp_authopt_info at all
> +       if (sk->sk_state == TCP_SYN_SENT ||
> +           sk->sk_state == TCP_NEW_SYN_RECV ||
> +           sk->sk_state == TCP_LISTEN)
> +               return 0;
> +

In case of TCP_NEW_SYN_RECV, if our SYNACK had sequence number
0xffffffff, we will receive an ACK sequence number of 0, which
should have sne = 1.

In a somewhat similar corner case, when we receive a SYNACK to
our SYN in tcp_rcv_synsent_state_process, if the SYNACK has
sequence number 0xffffffff, we set tp->rcv_nxt to 0, and we
should set sne to 1.

There may be more similar corner cases related to a wraparound
during the handshake.

Since as you pointed out all we need is "recent" valid <sne, seq>
pairs as reference, rather than relying on rcv_sne being paired
with tp->rcv_nxt (and similarly for snd_sne and tp->snd_nxt),
would it be easier to maintain reference <sne, seq> pairs for send
and receive in tcp_authopt_info, appropriately handle the different
handshake cases and initialize the pairs, and only then track them
in tcp_rcv_nxt_update and tcp_rcv_snd_update?

>  static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
>  {
>         u32 delta = seq - tp->rcv_nxt;
>
>         sock_owned_by_me((struct sock *)tp);
> +       tcp_authopt_update_rcv_sne(tp, seq);
>         tp->bytes_received += delta;
>         WRITE_ONCE(tp->rcv_nxt, seq);
>  }
>

Since rcv_sne and tp->rcv_nxt are not updated atomically, could
there ever be a case where a reader might use the new sne with
the old rcv_nxt?

Francesco
