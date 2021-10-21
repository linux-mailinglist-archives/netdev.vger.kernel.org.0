Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A186435811
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 03:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhJUBNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 21:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhJUBNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 21:13:23 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A03C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 18:11:06 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id s64so19256276yba.11
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 18:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=59+7vYZvVeE11Od3F0Lfi0fRFVyktXzOm+nlhxMfCew=;
        b=UYB4ksJC2CmvyFAuJCYud6lA9hfnrEV6XZHX0QgNcPhyM5FELde1LLAtnhak5w3aW+
         1cyOIj1hA/EzOuaNHEYcA7BU6v7oP3BWfKwdWEJEDVxCPYR2LslnfUJEh0K++9UjFrWe
         d585HpM1Zxmf5Ww012naPzNOkB5NvVOv9dmphh4e8hFnqCjVnf5UH2wY95QbSi7xgrL+
         1M1ck4miCcnCml8A2s0HXVhaE5xDLqv38IVzEdT1m4YESSf7aKuZboeDj1en2ag0l0Cp
         TFApW+hyLKxGt42UW3f9j8ptkFI53Bxssxk3aaNky5hb8R07Ovls+0agdWqwpjjPlQXV
         tXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=59+7vYZvVeE11Od3F0Lfi0fRFVyktXzOm+nlhxMfCew=;
        b=f2RbI/Mp23BAk9mDRWDbqpibYwdFbKE5UPquLUzHCU9Q9v06qZjPfWcg8aR2qq5Afi
         q7P4XTB4FmI1GMA3Ca9w+vxjqGgWOhdaBeuwFN+RD6sMHS7CChHIIbomgLRiTLMnY4W7
         c2Pij2drDLy6X9dxwiz+4g3hMGShycyRMpgKNPANe0AY7uM5rscbcxjY46FX6LYiZGA8
         dyADJToNo8yuc7w9fpO+kmir6VUFg4bCgmEj9bY006lU2lKNMI00ugTjyLTjWGyhKE9p
         2v6N+Pzq/3Qc4MZ6wMQHWgomIwgDdKlv9ufeZW8/I62dabBiri4k5pULAjHhT6+uEtba
         0VXw==
X-Gm-Message-State: AOAM532WXE2TCiWy3KtMQ6pcUbW41ZVPJZRBDWYdUM1tAEtWVhBOT6Y8
        hbQERzhMTFqRlmpsJN6L6/y6jFWXUkTB2+APOOiU/g==
X-Google-Smtp-Source: ABdhPJzxDOO5cEKor5o0fjq7bAxEaFc4s3TFw7ViyTtVVA5SMg8u9so/4/TXuvCCZ9lJbTbbb6JOiygeOqeyjo+/+As=
X-Received: by 2002:a25:918e:: with SMTP id w14mr2654210ybl.225.1634778665329;
 Wed, 20 Oct 2021 18:11:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211020232447.9548-1-jmaxwell37@gmail.com>
In-Reply-To: <20211020232447.9548-1-jmaxwell37@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Oct 2021 18:10:54 -0700
Message-ID: <CANn89i+e3n6RveyuOhdfnQdJESdFvjgkgMjXSHCyuTRDB-E8Bw@mail.gmail.com>
Subject: Re: [net-next] tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()
To:     Jon Maxwell <jmaxwell37@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 4:25 PM Jon Maxwell <jmaxwell37@gmail.com> wrote:
>
> A customer reported sockets stuck in the CLOSING state. A Vmcore revealed=
 that
> the write_queue was not empty as determined by tcp_write_queue_empty() bu=
t the
> sk_buff containing the FIN flag had been freed and the socket was zombied=
 in
> that state. Corresponding pcaps show no FIN from the Linux kernel on the =
wire.
>
> Some instrumentation was added to the kernel and it was found that there =
is a
> timing window where tcp_sendmsg() can run after tcp_send_fin().
>
> tcp_sendmsg() will hit an error, for example:
>
> 1269 =E2=96=B9       if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))=
=E2=86=A9
> 1270 =E2=96=B9       =E2=96=B9       goto do_error;=E2=86=A9
>
> tcp_remove_empty_skb() will then free the FIN sk_buff as "skb->len =3D=3D=
 0". The
> TCP socket is now wedged in the FIN-WAIT-1 state because the FIN is never=
 sent.
>
> If the other side sends a FIN packet the socket will transition to CLOSIN=
G and
> remain that way until the system is rebooted.
>
> Fix this by checking for the FIN flag in the sk_buff and don't free it if=
 that
> is the case. Testing confirmed that fixed the issue.
>
> Fixes: fdfc5c8594c2 ("tcp: remove empty skb from write queue in error cas=
es")
> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> ---
>  net/ipv4/tcp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index c2d9830136d2..d2b06d8f0c37 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -938,7 +938,7 @@ int tcp_send_mss(struct sock *sk, int *size_goal, int=
 flags)
>   */
>  void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
>  {
> -       if (skb && !skb->len) {
> +       if (skb && !skb->len && !TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)=
 {
>                 tcp_unlink_write_queue(skb, sk);
>                 if (tcp_write_queue_empty(sk))
>                         tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
>

Very nice catch !

The FIN flag is a really special case here.

What we need is to make sure the skb is 'empty' .

What about using a single condition ?

if (skb && TCP_SKB_CB(skb)->seq =3D=3D TCP_SKB_CB(skb)->end_seq)
