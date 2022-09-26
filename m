Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F84E5EB331
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiIZVdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiIZVdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:33:45 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB11A284A;
        Mon, 26 Sep 2022 14:33:44 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id d42so12999707lfv.0;
        Mon, 26 Sep 2022 14:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=wOCqP9mDpJwt9v/xIiVkrBeoGQeF5SHuPiddJ/jF30o=;
        b=f079x/7PD0ooMx+BbwrbuX0TF3RU75GJ6QOH1nuQoTYa0EXa3s58yyQe2cQ6SPCMf/
         WYLLvlMlWz/TGqtyGLpKgsvBOObSVyqwsChs94mu1nZxY7cwh+E67HLSC18szX3simPa
         yHzlzj6wgMRcYjGQ91KJpDmjvHHQo6NOoDFheimghpZ1qkMyNe6TrSh3JAswI0JLdeML
         /MQqQ221RcTNtTcHndGO7OXYL7EFNX658cArw0Z+TVAHzsnPFJ4K/u45UlfGR52LT8zz
         WgkWc4030DVq0GwfktGBRdnOC1fGf39T0Uh5wtLEO3jg30FyIaYDPzUwLpFcTIG1IPYG
         Qikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=wOCqP9mDpJwt9v/xIiVkrBeoGQeF5SHuPiddJ/jF30o=;
        b=ewl9eMiEJ7wHtXStofRig8JwbUF8tTssSHerTqEWAjgZ6Xy+zcGMXlIgk8DbU3VI19
         4r9tu7ERtdVM+7v7JqyphcVKpuWxGYfOLKEoUDQ1HaYAAi46C+KnUdJTV8JIcI2ZKc0J
         rvRqphk3ZILatvDbSy4RdfpjlIJM5Pb16JBrBFS2SQgZC6iMxWHw4XacLz2Kq/wSm7sl
         5k9ul62kvBkKA0Znj6BdBxL2PIDfJsYA11S98Z9ONhk/catiNkDYcO63aKA9XWt2TJ2a
         TQWr2hzTscoOna2VoknMDiWBYt4pJ6OgENkU3GDETZLUsW5hAUz1DPMfOHMxQxsXzVk3
         dl8g==
X-Gm-Message-State: ACrzQf0o7mP7QAKxURnJdVRoLQ0Yt1zHDBmTWF5b/SSz0N7VnY+jl9GD
        /gkOFPHjSH/Gtz7KBO2VdKu0mAO04HH6YVkY/gg=
X-Google-Smtp-Source: AMsMyM7ef1LCR3BaddJpiESFTNWER5KCPdHyc5N6UPqHxJueL+Yb8w4KqBrFLfbrCltOUj+5WGyJJ4OCkn7Lh4EIcxE=
X-Received: by 2002:a05:6512:687:b0:4a1:d59f:dc7c with SMTP id
 t7-20020a056512068700b004a1d59fdc7cmr2400329lfe.564.1664228022638; Mon, 26
 Sep 2022 14:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220926204657.3147968-1-iam@sung-woo.kim>
In-Reply-To: <20220926204657.3147968-1-iam@sung-woo.kim>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 26 Sep 2022 14:33:30 -0700
Message-ID: <CABBYNZLdvOzTwnHp4GX9PiXVMr2SDjD1NCXLRJw1_XLvSuZyjw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: L2CAP: fix an illegal state transition from BT_DISCONN
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     syzkaller@googlegroups.com, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kim,

On Mon, Sep 26, 2022 at 1:47 PM Sungwoo Kim <iam@sung-woo.kim> wrote:
>
> Prevent an illegal state transition from BT_DISCONN to BT_CONFIG.
> L2CAP_CONN_RSP and L2CAP_CREATE_CHAN_RSP events should be ignored
> for BT_DISCONN state according to the Bluetooth Core v5.3 p.1096.
> It is found by BTFuzz, a modified version of syzkaller.
>
> Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
> ---
>  net/bluetooth/l2cap_core.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 2c9de67da..a15d64b13 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -4307,6 +4307,9 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
>                 }
>         }

Perhaps it would be better to switch to use l2cap_get_chan_by_scid and
l2cap_get_chan_by_ident, since I suspect this is caused by the socket
being terminated while the response is in course so the chan reference
is already 0 thus why l2cap_chan_hold_unless_zero is probably
preferable instead of checking the state directly.

> +       if (chan->state == BT_DISCONN)
> +               goto unlock;
> +
>         err = 0;
>
>         l2cap_chan_lock(chan);
> --
> 2.25.1
>


-- 
Luiz Augusto von Dentz
