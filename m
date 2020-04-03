Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D841919D9DB
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 17:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404166AbgDCPNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 11:13:53 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43005 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404130AbgDCPNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 11:13:53 -0400
Received: by mail-lj1-f193.google.com with SMTP id q19so7258732ljp.9
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 08:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DSB/s+jkbmzG+872wg2P5RsXw25dw+k96VoLRNM+xIk=;
        b=NnJYHcrEmoB8qNXKZ3slYqn5PMbvp36PsylL6He+9olAxu//fFL0pW4XIUIvD8cMrC
         Y6yJUUkqD6a9+uUEcC8JRoRzvnPwwrxRCwu5cm7XKxdFF0A/t/nmcgJKXjWTTn4txEwc
         Zq2lnpBvjQjY0ThdGLJ6pNVSru7mBNvrD2SWMqXXZmWfZHKPmHXm4eNcwAw8ElBj/jT3
         cNeyUrYOt0SLmx7WShfQxs1JwZ5G+ZKdS5bWF08a2A6lsdVXeADyUkvgW+k9aHrbsLSu
         +O5s8Z35IVJrBBcJYxOOQJRSxgQpvskRgy5RHSR0ueUphiBEl+Tl3s1X/15Em29ndTdH
         X6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DSB/s+jkbmzG+872wg2P5RsXw25dw+k96VoLRNM+xIk=;
        b=fwf4vPTFycJfpqBN/kqDua5uLLPYirXEkRRJ/vTcg9pn2DN0TeIitMWeAV0fdiH6kf
         jrSeNrfUMgu0nvTDOGNV4IO/GkMCYlpIxer32kD469L/u/inO/B0/lBy2+a6AIfupsTk
         48L/ZLwJp/Q/YJVJt82ikiUpNww+8zFMrEHAXJ8rFqesFYp4eXXU5zC27/52R+8Dp6Tu
         S7+R1RZ4E1iBGozKotbcL9YVBSQ64l32dKZxqbE7A7Q5zb2j6ikngazL0neefuIaCsh0
         rsRMdO5rL5CTQL2pGP7TePyjLQZMLQUPA6fzg3DH9VacnVwNbh4MUkEq+nSlbpGlV86m
         pcng==
X-Gm-Message-State: AGi0PualmWqpEgyvaKfFt3cxOtTFpHciQLfBAPVpaRqUXnyFLrX0DG0/
        t2M42qEYUmvFOU1OzRqsx6tYCvuljzwYTtYBQTvXMQ==
X-Google-Smtp-Source: APiQypLtONB4lTDIuQGKUYhKGtjTQQxubEMFFX2sH19d1M6w/MHAofyXnuV7Dw13bDwXeScnw2+wB73K329En9qbzbE=
X-Received: by 2002:a2e:9084:: with SMTP id l4mr5287406ljg.277.1585926830857;
 Fri, 03 Apr 2020 08:13:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200403150236.74232-1-linux@roeck-us.net>
In-Reply-To: <20200403150236.74232-1-linux@roeck-us.net>
From:   Alain Michaud <alainmichaud@google.com>
Date:   Fri, 3 Apr 2020 11:13:39 -0400
Message-ID: <CALWDO_WK2Vcq+92isabfsn8+=0UPoexF4pxbnEcJJPGas62-yw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Simplify / fix return values from tk_request
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guenter/Marcel,


On Fri, Apr 3, 2020 at 11:03 AM Guenter Roeck <linux@roeck-us.net> wrote:
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
I think there may be some miss match between expected types of error
codes here.  The SMP error code type seems to be expected throughout
this code base, so this change would propagate a potential negative
value while the rest of the SMP protocol expects strictly positive
error codes.

>                 set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
>                 return 0;
>         }
> --
> 2.17.1
>

Thanks,
Alain
