Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3559819FDED
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 21:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgDFTPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 15:15:33 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36100 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgDFTPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 15:15:32 -0400
Received: by mail-oi1-f194.google.com with SMTP id k18so14154624oib.3
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 12:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=miv5n/k+feV617mYPhfbVUPV8D5MSyOCPj4Ac3CWtMw=;
        b=MYMwPh61GsI6XsGu3waWGuBT+BFAV4nlTM+8bOVNOvORSLC9/gEEvCPUVQxfcBQJA8
         XDodjyCNKYnd13iQN3dmjxvpJuq2OMKLUKHGYphGSTT7Zwzz7GecUfFA7WsIDkc16nvg
         BdHfFTckVYMzUtMxG+9RBCpQlVZQidM84ypVI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=miv5n/k+feV617mYPhfbVUPV8D5MSyOCPj4Ac3CWtMw=;
        b=bf8u6PQFiTLcHGuT2L9kXdJibxqfup8NnRgtrKk4x2qXzoIFZW37WmaJwMqfFmIdRJ
         OY8ZIALVRGvqwGiUQ/O+l3iXfhbP8KSlOwQ1xAaL5NKgfvXTEOLzutfRIVGSRQaJQr7m
         09tx/h+BXBwFGfibmu0wPSqzxglF+5u5h+AgKhaMq7nFenTqvKh7cUxDEyx9LMG4H27V
         nwt8Nv3sgqNaBhOzqfe9E+AKXeWQ5lai47ksMH/1uawl7ewjXSHXI59QISlm7LlMt1d/
         sDMubyLcStHlfxpsPg4Fenn/wnNYt4Su2or1wvtZFh8r62wMJ2sy9JJsh3G6QwhwTv9I
         Tl+Q==
X-Gm-Message-State: AGi0PuZTabd8sn+TG3a5m3jBp4gbeUDEAIug7QiuNv6oCJ+EdgjOQqN4
        PUogd6YcWcNISHEUsrFval+FJ1J9wcja9v3oadatZg==
X-Google-Smtp-Source: APiQypJ3BCbS26CTzYSKqqpjGSJ6qpi4PpmHmXaX2aIsQQENucRJ+aKdcf/F2DLnCrFw5Bszx9oADxs91d3zg0ZKJ7A=
X-Received: by 2002:aca:dd55:: with SMTP id u82mr618185oig.27.1586200532136;
 Mon, 06 Apr 2020 12:15:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200403150236.74232-1-linux@roeck-us.net>
In-Reply-To: <20200403150236.74232-1-linux@roeck-us.net>
From:   Sonny Sasaka <sonnysasaka@chromium.org>
Date:   Mon, 6 Apr 2020 12:15:19 -0700
Message-ID: <CAOxioNm6pu+WFwDS8oTcBiLaCjHH9QZx5R6rEjUtKPZjqN26+w@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Simplify / fix return values from tk_request
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>

On Fri, Apr 3, 2020 at 8:02 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Some static checker run by 0day reports a variableScope warning.
>
> net/bluetooth/smp.c:870:6: warning:
>         The scope of the variable 'err' can be reduced. [variableScope]
>
> There is no need for two separate variables holding return values.
> Stick with the existing variable. While at it, don't pre-initialize
> 'ret' because it is set in each code path.
>
> tk_request() is supposed to return a negative error code on errors,
> not a bluetooth return code. The calling code converts the return
> value to SMP_UNSPECIFIED if needed.
>
> Fixes: 92516cd97fd4 ("Bluetooth: Always request for user confirmation for Just Works")
> Cc: Sonny Sasaka <sonnysasaka@chromium.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  net/bluetooth/smp.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> index d0b695ee49f6..30e8626dd553 100644
> --- a/net/bluetooth/smp.c
> +++ b/net/bluetooth/smp.c
> @@ -854,8 +854,7 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
>         struct l2cap_chan *chan = conn->smp;
>         struct smp_chan *smp = chan->data;
>         u32 passkey = 0;
> -       int ret = 0;
> -       int err;
> +       int ret;
>
>         /* Initialize key for JUST WORKS */
>         memset(smp->tk, 0, sizeof(smp->tk));
> @@ -887,12 +886,12 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
>         /* If Just Works, Continue with Zero TK and ask user-space for
>          * confirmation */
>         if (smp->method == JUST_WORKS) {
> -               err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
> +               ret = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
>                                                 hcon->type,
>                                                 hcon->dst_type,
>                                                 passkey, 1);
> -               if (err)
> -                       return SMP_UNSPECIFIED;
> +               if (ret)
> +                       return ret;
>                 set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
>                 return 0;
>         }
> --
> 2.17.1
>
