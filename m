Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB8CF02A1
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390163AbfKEQZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:25:38 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:38606 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390104AbfKEQZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:25:38 -0500
Received: by mail-io1-f68.google.com with SMTP id u8so23291888iom.5
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 08:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SQBtLoiyX30CmNNlPo8+fKnPMZWx9HZgWJxlaU6V+H0=;
        b=YHBd0MfbIpvUwtJJxv88JmgWV6Rj78i4e3crBWO/zG1OCHJNeuiTJV6bhKPyNMHAH5
         rZZX+FdeuGDAvbViD/pj+H3IR9z7cP/ynX0ZCJwwtkex6Kc7uXmP0rCDTWe93o2ERZjF
         Ro1AlulFIZOyIEBkDrYOyhKhTvT1/PBWVSFkYTJ5LkcPVjXGSMW079t3bK66Qox34SrR
         xRGoTPXggCqKNaD8s7l93pELYjvZAaPBOwMo2f8pt1z0DnWRHxYinPB5KhCDxY6nrUY4
         Yfku7AGD9wQ/TK4J5vCldiIedbqEyoiAfmhcgLACZxf0zBl4XwTHGy0ALiGwhqF9XdH3
         3T1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SQBtLoiyX30CmNNlPo8+fKnPMZWx9HZgWJxlaU6V+H0=;
        b=YGrZLYq/CbET2BWwC0+vZ5dmRKKVpwFCkJyDkJWknyeyq6RInwfQFNjx/8si732Bsk
         TdEjArhwJxuPO32fVK303T8qgz4em2hZOCtC4lLq7jzLtgL5xAV4YvYBF3/+FAqd2Ef+
         b5QO7wek1LisKdLjumUrYDaYnstz46GmQQd5YiVj45VWUvv8GPjhwbRRjBwu0YQwzU6R
         B0muHU4xUDOv0mDYBWVQ9mfapTmJcX+AAS9JZcE4Z6d8tiEND4M5GcGT5JQyMcMBhWMM
         w8PkIaI1aQhh3IZm6VyDzTaQembE5Xzcb4teNaIj1oAVPxgmoARFKl8NIeoFBT2S7G2n
         adtw==
X-Gm-Message-State: APjAAAUWqMNJ9uhKeSX+lHAwK3mpVhKCEuv3dCusteolxoIYtXkKINCk
        JqYKNmUUKzbtdb9JeelumNaC36kUis+R/4Vr5NA=
X-Google-Smtp-Source: APXvYqxAPZogSWlhhMsc1D/HOFBxCyop4mS1Fk69iyzGgk3f53Q0iQqh/xhWOYupAgoaG5SNQlpJB6oWrfylKwjJVRU=
X-Received: by 2002:a02:3f10:: with SMTP id d16mr3109258jaa.139.1572971135616;
 Tue, 05 Nov 2019 08:25:35 -0800 (PST)
MIME-Version: 1.0
References: <20191105053843.181176-1-edumazet@google.com>
In-Reply-To: <20191105053843.181176-1-edumazet@google.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Tue, 5 Nov 2019 08:25:24 -0800
Message-ID: <CABeXuvqRoAYKn6vg7t7O6nA4BCEHjkMwYp9EvVGEEkFV_EonsA@mail.gmail.com>
Subject: Re: [PATCH net] net: prevent load/store tearing on sk->sk_stamp
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 4, 2019 at 9:38 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Add a couple of READ_ONCE() and WRITE_ONCE() to prevent
> load-tearing and store-tearing in sock_read_timestamp()
> and sock_write_timestamp()
>
> This might prevent another KCSAN report.
>
> Fixes: 3a0ed3e96197 ("sock: Make sock->sk_stamp thread-safe")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Deepa Dinamani <deepa.kernel@gmail.com>
> ---
>  include/net/sock.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 8f9adcfac41bea7e46062851a25c042261323679..718e62fbe869db3ee7e8994bd1bfd559ab9c61c7 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2342,7 +2342,7 @@ static inline ktime_t sock_read_timestamp(struct sock *sk)
>
>         return kt;
>  #else
> -       return sk->sk_stamp;
> +       return READ_ONCE(sk->sk_stamp);
>  #endif
>  }
>
> @@ -2353,7 +2353,7 @@ static inline void sock_write_timestamp(struct sock *sk, ktime_t kt)
>         sk->sk_stamp = kt;
>         write_sequnlock(&sk->sk_stamp_seq);
>  #else
> -       sk->sk_stamp = kt;
> +       WRITE_ONCE(sk->sk_stamp, kt);
>  #endif
>  }
>
> --
> 2.24.0.rc1.363.gb1bccd3e3d-goog

I do not see any harm with this. Does it cause performance degradation?

Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>

-Deepa
