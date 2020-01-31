Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C0C14EEE9
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgAaPBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:01:34 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33239 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729071AbgAaPBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:01:34 -0500
Received: by mail-yw1-f67.google.com with SMTP id 192so4972403ywy.0
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 07:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lP6TzEP91d7hLsESfdMqNdtjrOfbthLJkOU6UXoqTVs=;
        b=JjC9sj0bkY+d7wSCXaj+o8kYk69s9tJNc3C2A70tF2dKMLJG5FFvog7iey+EBH5tkS
         R2aSMJpoMMRCHqY17xrSS5Cr6n0aReHPNRY3UI1Q2jNoC28C+IB6ZSKLOi2Ljy3ucS8i
         VbZ7wosy2IjQCeQQRaYpJ8CIuxVesucU1Ll0y323e9Fp4ZPxPB1VSSDMuAlFeShpoVJ2
         Zp/zpk9vDLlIvK1X6Xrs/P5eKsJhXpaHJy4chljIaOzmj9gXt8yeNTN7HueQPSF93WJN
         bBfbkKkvNhAGzoUiF6pP4gzT1Glae++rA5nYHhRAa1zXKG8rCazvnGSwwk+05bmdG2uG
         PwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lP6TzEP91d7hLsESfdMqNdtjrOfbthLJkOU6UXoqTVs=;
        b=bhMoP7hrd0SSjMf+c5Dw4Sxkku2OFBS5O4TMZStroIY0zxZ7XDArfIMslmu0Vg4gAi
         QsGj50FybtiT/ShCuj80IITPddmyAn2tcf9F90XMLr4wANMugbSkcZVUkoR4Cw0O4EUS
         UEf3KtGk62cO03XdYsfFg0c5sWZRXkWhQ5moVyF3FQfBQ68fKl/7cLOne+YLfb+C3VCl
         ACuKYTuwvbQt76k4oSMj32qJcv3g4eNGa8gpDDyYcADZ9pwPpRMYt4dLQhyqGNYVxmpw
         Rlv5i8GSq5gdtPbKmygrefSgBbDIhOu26mDz+iuLsVRMHINmRSCb0KiqAOE4iIR/JEUC
         WXsQ==
X-Gm-Message-State: APjAAAWmFXxwGLgjqvWqmm7HuCFXzd1TXTJhIiyi+xUtNTE+Y1SrgjeD
        EUnHauNyJmiro1UO7B7uRqbUtWUFMIMvI52ji+4EYg==
X-Google-Smtp-Source: APXvYqzs7gtN6z+3DwxRauYOyBeJ0zMKdNI1QZWw5WgJpiiQ/ixWmcWH3ZOyJ2v3tzlLqA2ss5ytj9xF+z66rXG7cCs=
X-Received: by 2002:a81:b38a:: with SMTP id r132mr8677745ywh.114.1580482892732;
 Fri, 31 Jan 2020 07:01:32 -0800 (PST)
MIME-Version: 1.0
References: <20200131122421.23286-1-sjpark@amazon.com> <20200131122421.23286-3-sjpark@amazon.com>
In-Reply-To: <20200131122421.23286-3-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Jan 2020 07:01:21 -0800
Message-ID: <CANn89i+rKfAhUjYLoEhyYj8OsRBtHC+ukPcE6CuTAJjb183GRQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is received
To:     sjpark@amazon.com
Cc:     David Miller <davem@davemloft.net>, Shuah Khan <shuah@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, sj38.park@gmail.com,
        aams@amazon.com, SeongJae Park <sjpark@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 4:25 AM <sjpark@amazon.com> wrote:

> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> ---
>  net/ipv4/tcp_input.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 2a976f57f7e7..b168e29e1ad1 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5893,8 +5893,12 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
>                  *        the segment and return)"
>                  */
>                 if (!after(TCP_SKB_CB(skb)->ack_seq, tp->snd_una) ||
> -                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
> +                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
> +                       /* Previous FIN/ACK or RST/ACK might be ignore. */
> +                       inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
> +                                                 TCP_ATO_MIN, TCP_RTO_MAX);

This is not what I suggested.

I suggested implementing a strategy where only the _first_ retransmit
would be done earlier.

So you need to look at the current counter of retransmit attempts,
then reset the timer if this SYN_SENT
socket never resent a SYN.

We do not want to trigger packet storms, if for some reason the remote
peer constantly sends
us the same packet.

Thanks.

>                         goto reset_and_undo;
> +               }
>
>                 if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
>                     !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
> --
> 2.17.1
>
