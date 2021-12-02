Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3A8466909
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 18:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376292AbhLBR1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 12:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242092AbhLBR1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 12:27:45 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF8EC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 09:24:22 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id 131so1549238ybc.7
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 09:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qMteKLxxWZIbMF68B5UDKV/rkpcwWnnS8TTYuWJf4hA=;
        b=tJAtUh4DvOOIFyFQ5KKaRqRH/F9qRXlqqfqzAihO3m6KcqIUiqVrOEl7eYM5V3VY5e
         uiXIQ8RWRlN0TLh+9g7b7kP2HQFiy6GO8HJkHsC6AvZcOe7uACz0GHPGNYPjIPA53UIE
         bkDM+Kfkr0F/yRvuqF+Mgmp4d8mvK2M2AdhqraKIyfFMfeB0iA6Q32W7XexeEamamxCk
         JcwB8gEsWIN6nYvLZZVUh7ai//GG23oGxi20WCz/q02oRkEXw5mFdJ7gxyl5oY7PBe0w
         mi2Zkj3fU1pACM/lhxv6ZKlKJ4/rlf5Xyrg6EyQfESe4Pm3CX21VhvT0dW0Qsg/7euDg
         WbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qMteKLxxWZIbMF68B5UDKV/rkpcwWnnS8TTYuWJf4hA=;
        b=lVeKV6+T4IlDVWEbysx6SYrdza5u+mrwkjcjC60zN49MoDosUKedX8hsF8tlSAvKlM
         4wVc3WI0j8JJXxuPJveBP6qAk704Z0bBmqOnJplRiVTVdPkyA3vyx+U6hQGiFOJ9WUVy
         /rriw81KkSFxZLdbti1vkPAOln08p1ojSWMjkzwszmQCFx7a1pmbJ7WVcyNzo3s8q8AW
         45Ztygbq78tj1FyRAWl+mCFIEeFcW/FSqQPcB7ldZirvvh/e1EhuqpHpGvkFjKyQFmml
         UCtr5VoJQ7KnhKdkrrgQMxnxyNH4BgF0Ln2K6FvcJw4oCOz52C6UzP9cnYo4RqZ02KwB
         3wkw==
X-Gm-Message-State: AOAM532DPyBGdWn4EKXj9WIF+eFI9Z7YBQJAeHCHbCFI3uEKhJLpGosp
        88n7Pv2DxecpwnAVjZZHXpx2qy0wHFchqPUVzDSYRA==
X-Google-Smtp-Source: ABdhPJyrLwSG2+cOha6iaJWHs7ijIsk/XPVkICJTf5UOeEhqZ3Ql5J5mg2oaBOyN43CWL4M2l1LPg9woy8a2wFZpMDg=
X-Received: by 2002:a25:760d:: with SMTP id r13mr17944040ybc.296.1638465861444;
 Thu, 02 Dec 2021 09:24:21 -0800 (PST)
MIME-Version: 1.0
References: <5c7100d2-8327-1e5d-d04b-3db1bb86227a@gmail.com>
 <20211202164031.18134-1-hmukos@yandex-team.ru> <20211202164031.18134-5-hmukos@yandex-team.ru>
In-Reply-To: <20211202164031.18134-5-hmukos@yandex-team.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Dec 2021 09:24:10 -0800
Message-ID: <CANn89iKsq6fghsyfoeOjN8f7bpREq48tGAQSXz54Q2tp_J9DTQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 net-next 4/4] tcp: change SYN ACK retransmit
 behaviour to account for rehash
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 8:41 AM Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>
> Disabling rehash behavior did not affect SYN ACK retransmits because hash
> was forcefully changed bypassing the sk_rethink_hash function. This patch
> adds a condition which checks for rehash mode before resetting hash.
>
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>  net/ipv4/tcp_output.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 6d72f3ea48c4..7d54bbe00cde 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -4108,7 +4108,8 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
>         struct flowi fl;
>         int res;
>
> -       tcp_rsk(req)->txhash = net_tx_rndhash();
> +       if (sk->sk_txrehash == SOCK_TXREHASH_ENABLED)

Since you add a new sk->sk_txrehash, you probably want to add
READ_ONCE()/WRITE_ONCE() over the reads/writes,
because at this point the listener socket lock is not held.

      /* Paired with WRITE_ONCE() in sock_setsockopt() */
       if (READ_ONCE(sk->sk_txrehash) == SOCK_TXREHASH_ENABLED)

sock_setsockopt() would need a similar comment
    /* Paired with READ_ONCE() in tcp_rtx_synack() */
     WRITE_ONCE(sk->sk_txrehash, val);



> +               tcp_rsk(req)->txhash = net_tx_rndhash();
>         res = af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL,
>                                   NULL);
>         if (!res) {
> --
> 2.17.1
>
