Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0244DE78B
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 12:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240720AbiCSLQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 07:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbiCSLQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 07:16:16 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC4E2C3DCB
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 04:14:55 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2e5e31c34bfso34540477b3.10
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 04:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EPhky8zdCKK20IBumhg7mBiiabJrzdOsRh9Qimd/Qzc=;
        b=KQq0q7iD8oHNdWc9HmH60Z3fMe3PRPF5nIOTDO0qfSXcIwAt8LHzKkYpKDd0dEl+fV
         UH2LE6y9mDrrQxVsh7iV8V/IzTd554FbjwCXetEcm0HQS1dNGgXPB/y7daZauv3GmNdl
         jgExN/Qe0Vtq4nmfu6coPGFX8xvqHiZHxxKnjVLiOoX5AVRI1brS/P+2wz70C4TUsgmW
         vEK7V/S2LKiITaQrxEcMiIIBqXa+hrxa1C7CH4z/ytrtoJ5BMyXWob3p3Vt6Fzy5zjKh
         ww5Dz+Yd/BmcEm6EJVX9JoZiadWkDXNV+xXQlktkAKQl1jY1SLyf6PkCKDuCpK0D2Yor
         r6Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EPhky8zdCKK20IBumhg7mBiiabJrzdOsRh9Qimd/Qzc=;
        b=ymm1Vw0I4OlF9FG6v9sIXxAbuqogaOmX57IDH+ZMH15temGtGJQU8C3QmJuLcHjkFd
         2+3N8Wrpw49ryRjar+LXR2NpZzE4ZasDIEUqJ/B0FQuT0EmMgnbRsE349ocMZRN51z+G
         vqI99yRuOJY20locoC7gvIqn3TUtvDO0gzw12MPRgC+rr4Y+3+UuOJnlMDa3WVvtilVh
         aKLhO5CcpPN5qYunllYnvsAXZZjJijhZ5udrTKeXAzBjp8Dp5CWAUrVT1xiwZMJNixO1
         OaqFCXx/Tx/YZ6YzRIttoFyve+428+A7NWosoEz6ijsExISR6iSgZDqBdPVearuqnAin
         xilg==
X-Gm-Message-State: AOAM533f7E+U2PCgoblv7NmcrwxWs3WKlAjk4qXyxitPza3+9AA4eo5K
        fP3zg6YmvkHJ6f68MaiMKNIKgeUzI3D6IPmPWo9Cqg==
X-Google-Smtp-Source: ABdhPJyUTXXyMkjsGAvt8nI3/nkQGADKDXrq4OHrNR5zP0nWP+LJyjebbJ/ZKks95+f0nb9W0s0DhfplR57zhkkUABE=
X-Received: by 2002:a05:690c:809:b0:2e5:a6cb:bccd with SMTP id
 bx9-20020a05690c080900b002e5a6cbbccdmr15270204ywb.47.1647688494317; Sat, 19
 Mar 2022 04:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220319110422.8261-1-zhouzhouyi@gmail.com>
In-Reply-To: <20220319110422.8261-1-zhouzhouyi@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 19 Mar 2022 04:14:43 -0700
Message-ID: <CANn89iK46rw910CUJV3Kgf=M=HA32_ctd0xragwcRnHCV_VhmQ@mail.gmail.com>
Subject: Re: [PATCH v2] net:ipv4: send an ack when seg.ack > snd.nxt
To:     zhouzhouyi@gmail.com
Cc:     fw@strlen.de, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Xu <xuweihf@ustc.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 19, 2022 at 4:04 AM <zhouzhouyi@gmail.com> wrote:
>
> From: Zhouyi Zhou <zhouzhouyi@gmail.com>
>
> In RFC 793, page 72: "If the ACK acks something not yet sent
> (SEG.ACK > SND.NXT) then send an ACK, drop the segment,
> and return."
>
> Fix Linux's behavior according to RFC 793.
>
> Reported-by: Wei Xu <xuweihf@ustc.edu.cn>
> Signed-off-by: Wei Xu <xuweihf@ustc.edu.cn>
> Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
> ---
> Thank Florian Westphal for pointing out
> the potential duplicated ack bug in patch version 1.

I am travelling this week, but I think your patch is not necessary and
might actually be bad.

Please provide more details of why nobody complained of this until today.

Also I doubt you actually fully tested this patch, sending a V2 30
minutes after V1.

If yes, please provide a packetdrill test.

Thank you.

> --
>  net/ipv4/tcp_input.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index bfe4112e000c..4bbf85d7ea8c 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3771,11 +3771,13 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
>                 goto old_ack;
>         }
>
> -       /* If the ack includes data we haven't sent yet, discard
> -        * this segment (RFC793 Section 3.9).
> +       /* If the ack includes data we haven't sent yet, then send
> +        * an ack, drop this segment, and return (RFC793 Section 3.9 page 72).
>          */
> -       if (after(ack, tp->snd_nxt))
> -               return -1;
> +       if (after(ack, tp->snd_nxt)) {
> +               tcp_send_ack(sk);
> +               return -2;
> +       }
>
>         if (after(ack, prior_snd_una)) {
>                 flag |= FLAG_SND_UNA_ADVANCED;
> @@ -6385,6 +6387,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
>         struct request_sock *req;
>         int queued = 0;
>         bool acceptable;
> +       int ret;
>
>         switch (sk->sk_state) {
>         case TCP_CLOSE:
> @@ -6451,14 +6454,16 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
>                 return 0;
>
>         /* step 5: check the ACK field */
> -       acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH |
> -                                     FLAG_UPDATE_TS_RECENT |
> -                                     FLAG_NO_CHALLENGE_ACK) > 0;
> +       ret = tcp_ack(sk, skb, FLAG_SLOWPATH |
> +                               FLAG_UPDATE_TS_RECENT |
> +                               FLAG_NO_CHALLENGE_ACK);
> +       acceptable = ret > 0;
>
>         if (!acceptable) {
>                 if (sk->sk_state == TCP_SYN_RECV)
>                         return 1;       /* send one RST */
> -               tcp_send_challenge_ack(sk);
> +               if (ret > -2)
> +                       tcp_send_challenge_ack(sk);
>                 goto discard;
>         }
>         switch (sk->sk_state) {
> --
> 2.25.1
>
