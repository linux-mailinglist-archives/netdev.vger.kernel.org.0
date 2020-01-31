Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A19014F233
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgAaSb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:31:56 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35760 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgAaSb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 13:31:56 -0500
Received: by mail-oi1-f193.google.com with SMTP id b18so8233926oie.2
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 10:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+EOpzG/jT5UVOc5yPyXKRysOgujhRwVFjCr78FsrzTQ=;
        b=ER6AX1bSIdiYktJaBLtjGu3zIjMWmuiOvjmYQ/TRc8c8oq4Ir4HBhJFwZl/XVCQZVt
         OSD3opFWQnZHnelfsAKUtKlTBQzClzS0oPI3SMEb19HVzc+xVen0y4KnSJ/nsIJ87qKI
         QDMmDIHg14hMkG3wB5Cir+nESxMRHHtKou68ktcZdQ6kuo40qpvZ9wi2Ioa1ZnFFyq6J
         HkMidMpBumCjpnvUdYbetJtdhTR2ciVSKVdZGSJDZodV/uMO9aOQG4HQGDtMg0sO56er
         SVmHWb35HBOKUq78uBAyzwI6sE2a7X219iQXFPgFI7JiK/rr65FZHZbe0Ha+Brtxje8n
         w68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+EOpzG/jT5UVOc5yPyXKRysOgujhRwVFjCr78FsrzTQ=;
        b=ICjVIkvqtFHAodiaJv9w9ppw+XmmTwIJqv3nbuTy3bkEu1IdjYINEC0cGIRYNuky1u
         3oD5LPm9kicucZ+Ot0qbdQW/jdpuE1dnBn82Ky6264wbV8YI93lGtH3Aw9OekEoLZ4j3
         LH231hDzlxBJPgEOm+Iomth8S5fZvTgbviXZQA0Usm7SpnYtR4ubyxoa2OgP4QYZCAs9
         mYWsW4Fl4ZTbzn/2/de4NZS+J5gb2EuDPZl2U9VUSlCOaXyGCC8fAyYRbApotBN9ioR9
         P81SMJc65RlRSXhOp84yQSn/jv/541ODwbZtZ/6371LX8bdXhYmvfVmQDmExG+PvXa6r
         o72w==
X-Gm-Message-State: APjAAAXJlrzQwJYOy49LKUUGesedKBMbqrbcTqqHYyB5DMxaeitS9nNS
        rho6rMmqQoENUyZ9cMtSXjKPicsEqlUgpav5VUW3aQ==
X-Google-Smtp-Source: APXvYqwKF7GosKsWOCkrMLXb2fFiHkLr+8UYsiU7INXI7vIhZN+XpsxIQz3nvN+Z1H3+xtRdSOc65+iWKQSwlwrVySM=
X-Received: by 2002:aca:2407:: with SMTP id n7mr7306241oic.14.1580495515232;
 Fri, 31 Jan 2020 10:31:55 -0800 (PST)
MIME-Version: 1.0
References: <20200131182247.126058-1-edumazet@google.com>
In-Reply-To: <20200131182247.126058-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 31 Jan 2020 13:31:39 -0500
Message-ID: <CADVnQy==XFxLXmJtmx3tnsscpUGr_sRNGFaRwg+64o7Dkwq2zg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: clear tp->delivered in tcp_disconnect()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 1:22 PM Eric Dumazet <edumazet@google.com> wrote:
>
> tp->delivered needs to be cleared in tcp_disconnect().
>
> tcp_disconnect() is rarely used, but it is worth fixing it.
>
> Fixes: ddf1af6fa00e ("tcp: new delivery accounting")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
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

Thanks, Eric!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
