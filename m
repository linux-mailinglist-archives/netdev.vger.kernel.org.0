Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36383140C75
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 15:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgAQO27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 09:28:59 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39172 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgAQO27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 09:28:59 -0500
Received: by mail-oi1-f193.google.com with SMTP id a67so22331098oib.6
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 06:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wx4YHHjEIs92WXguLwylQ65bmTpEJbutpC1Q71wXrBE=;
        b=p06gb2hXYIMEDQpGF7mdZEZrZWYjtpQ1BEfPre6zr33CM9N+acDO34sBaYwzGDByue
         wPLnKvVOpaIJ/A87KPmeFsERTpl/aCaUzbx+6Sy6TDbj8uzqbWocREvhCtUjbiAkgfCY
         WE8fbNUggQFye5KHjGGeNsM7MF415Of+515a+sBJDRDb037aeNwoSPd5PXItviYFlVB/
         Hmg9Ii+VK8RyJVix4RB2JKlhQfOA5/TNL4izlQlGPFwArX7KAiNSPMoHbr6aPR7HEnnN
         UgpUooHsPlCXKGw+Y/D+zLI5qDzFsiNANBh3dp4xs3tgmlyFQGe2rH2mEuNyAWhly0G5
         f3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wx4YHHjEIs92WXguLwylQ65bmTpEJbutpC1Q71wXrBE=;
        b=YipyfsseRtMR3rJ07HQf+U2PPdVMABG536DayLpI8H6sJ03jKuCP3tSR2vzsKFxYTv
         m+N1y7EdOrHCNlFWArC+ZB+X7j/bA9Pk0XUUnDMEk+++mi1mjAj6Mp3+3gtOb1/W/C3s
         z3FW4TGM22JZtbFpPZ2mdjXfdMfV+XCU6IeC8XN6gvdFLthef70C00tNe3SUmVSg/IsE
         igjKnFv6vFQMaeNBGrtbQAkWfvYiB4IVIruyCNUp0FTrWUKEtWnBe6PMRO29Ry2RC7Wo
         LS3ZlFC1wHy0I749hPDuGltbGwM8UJa028XpMmyfctak4Oa7oVfZBht7jHAfDL3COkcV
         niRg==
X-Gm-Message-State: APjAAAVoMMxGaeIl920SAwxIOoH1NHq3ouMrF1KMsxTcE9ua3xbzGQRR
        brN478dPbqp+MUXHJsZX0XSby+x+/FYMtMcLtUQQJQ==
X-Google-Smtp-Source: APXvYqyj18+lg03nqliskH8h7SVrSTN6fS4lw6uzfLiAmC/Mh4BQKZwSDccwQPDUX7KHk9ITXarRCiAeGDogQ0SHA6Y=
X-Received: by 2002:a05:6808:2c4:: with SMTP id a4mr3493809oid.22.1579271338082;
 Fri, 17 Jan 2020 06:28:58 -0800 (PST)
MIME-Version: 1.0
References: <1579255425-29273-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1579255425-29273-1-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 17 Jan 2020 09:28:41 -0500
Message-ID: <CADVnQynRGvRYpPAyLG7hDX-yVK29sHAV4vUSAYxEm-8s9dNV1A@mail.gmail.com>
Subject: Re: [PATCH] tcp: Use REXMIT_NEW instead of 2
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 5:04 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> Use REXMIT_NEW instead of the confusing 2 in tcp_xmit_recovery()
>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  net/ipv4/tcp_input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 5347ab2..de07439 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3554,7 +3554,7 @@ static void tcp_xmit_recovery(struct sock *sk, int rexmit)
>         if (rexmit == REXMIT_NONE || sk->sk_state == TCP_SYN_SENT)
>                 return;
>
> -       if (unlikely(rexmit == 2)) {
> +       if (unlikely(rexmit == REXMIT_NEW)) {
>                 __tcp_push_pending_frames(sk, tcp_current_mss(sk),
>                                           TCP_NAGLE_OFF);
>                 if (after(tp->snd_nxt, tp->high_seq))
> --

This change was already made recently in the net-next branch (see
below). To avoid duplicate work like this, please submit improvement
patches like this as patches against the very latest net-next branch
(or net branch, for bug fixes).

thanks,
neal

--

commit d0e8bcafc8aff5553beffe55046795f9bab9fe7b
Author: Mao Wenan <maowenan@huawei.com>
Date:   Thu Jan 2 22:02:27 2020 +0800

    tcp: use REXMIT_NEW instead of magic number

    REXMIT_NEW is a macro for "FRTO-style
    transmit of unsent/new packets", this patch
    makes it more readable.

    Signed-off-by: Mao Wenan <maowenan@huawei.com>
    Acked-by: Neal Cardwell <ncardwell@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 88b987ca9ebb..1d1e3493965f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3550,7 +3550,7 @@ static void tcp_xmit_recovery(struct sock *sk, int rexmit)
        if (rexmit == REXMIT_NONE || sk->sk_state == TCP_SYN_SENT)
                return;

-       if (unlikely(rexmit == 2)) {
+       if (unlikely(rexmit == REXMIT_NEW)) {
                __tcp_push_pending_frames(sk, tcp_current_mss(sk),
                                          TCP_NAGLE_OFF);
                if (after(tp->snd_nxt, tp->high_seq))
