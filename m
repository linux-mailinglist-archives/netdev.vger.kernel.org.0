Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4E414F22F
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgAaSaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:30:23 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:46863 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgAaSaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 13:30:23 -0500
Received: by mail-ua1-f68.google.com with SMTP id l6so2900443uap.13
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 10:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QpTXkLzrGLzRu1mvZf9U7k44ZV0shloEWFdv3sQlIHA=;
        b=jrJ6eZmifu8It5r4d8t1mOjtTKLdpSzzEv+0C58MTLWBB+xHLjh2Fsb/v0iPy9T9ek
         PjRKpvnnfPXilL9NiVq7gK8wdS73DVYfRe8efG7NBNfdRs9wz7fRu0rdNM+0wZmhzNJm
         oF2Q/qx9807p/Y15yYssPqV9XHLpSWSlgNogCD/HSsAFNPTMRTfvOCcI8aNsbJDIV/HJ
         4RBCOgCrJTkid2MqEhg3Uk3UQFhl86/uuKGERhT5NL0MjiuP5IH2OxP0Gaku8DudK4cF
         4eq4LNFKmKp0yAfB4gdxscDVP6SWhi1ifTmnPdUeWupy9QnG6zcRt0mVb7VYqmfulGqy
         icrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QpTXkLzrGLzRu1mvZf9U7k44ZV0shloEWFdv3sQlIHA=;
        b=pZDgUqChooEbmiuMo/AJeHmNluPyag4kgBG6AOS2BJlO8KvpeEBqY46sRdcWz2par8
         Xe6JUfVyYRPfSWI8Rm8IwzUbKLiI5MM1tpAJGayNMilMZU3DrB4rxnbgKbCUKuC7Mx4B
         8yydMLmI36vH4+44vEPe661WfhLJ9jtsI2Hns3sVTXyEp2fJFa9pxeRpez66CUB4Kyf7
         g2s5niZYDB4dX+16Uj4Pv2lufFyBrrDMJ9xCDLa484aRT8llgRdCv3IKTCjQnImP7Ujc
         F/D3BFMx+w5vh5+5e6PCMtJETt0Dg9JiZ0tOD5ES5Supe5amf7n3F77qee2D9SsnySZC
         UnVg==
X-Gm-Message-State: APjAAAXOpj0tFpWUisNj7lK4W1E4aSG2gP/7KjKjHiA5IrLF7hVmHBPq
        3hhFy6XeMXfD6PHUHoOO1w6Cz3WhsOTUQMTzYLg45g==
X-Google-Smtp-Source: APXvYqwc93zJ0Ph6wvcx8wZsY6eeA3X5AHeMP1T9Or7bTIo9+tlxCbx1cMXdQWBxJAhMG9DckTjW0xUbTFlTU76kJvU=
X-Received: by 2002:ab0:2505:: with SMTP id j5mr7179888uan.87.1580495421612;
 Fri, 31 Jan 2020 10:30:21 -0800 (PST)
MIME-Version: 1.0
References: <20200131182247.126058-1-edumazet@google.com>
In-Reply-To: <20200131182247.126058-1-edumazet@google.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 31 Jan 2020 10:29:45 -0800
Message-ID: <CAK6E8=fLvRRWktYV33q-f84rcWEyh3Jd6vonRnhkSGF7UUp8Xg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: clear tp->delivered in tcp_disconnect()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 10:22 AM Eric Dumazet <edumazet@google.com> wrote:
>
> tp->delivered needs to be cleared in tcp_disconnect().
>
> tcp_disconnect() is rarely used, but it is worth fixing it.
>
> Fixes: ddf1af6fa00e ("tcp: new delivery accounting")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
thanks Eric
> Cc: Neal Cardwell <ncardwell@google.com>
> ---
>  net/ipv4/tcp.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index dd57f1e3618160c1e51d6ff54afa984292614e5c..a8ffdfb61f422228d4af1de600b756c9d3894ef5 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2622,6 +2622,7 @@ int tcp_disconnect(struct sock *sk, int flags)
>         tp->snd_cwnd = TCP_INIT_CWND;
>         tp->snd_cwnd_cnt = 0;
>         tp->window_clamp = 0;
> +       tp->delivered = 0;
>         tp->delivered_ce = 0;
>         tcp_set_ca_state(sk, TCP_CA_Open);
>         tp->is_sack_reneg = 0;
> --
> 2.25.0.341.g760bfbb309-goog
>
