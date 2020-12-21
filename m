Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DC82E02D3
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 00:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgLUXJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 18:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgLUXJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 18:09:13 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F1FC0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 15:08:33 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ce23so15730281ejb.8
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 15:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dfp0aeh95IYaI3WntgsOUL8ePUaBZUTKkfG2ztR0Dg8=;
        b=gjNEIlynThzH0yxjpGAH2/5ztcMfcATo7ZnSsX5g5uq1zBY+naL0Sapke3nBbEwwpQ
         vLehjn6aI86q/DJUCLSWeHd6pbH483Ac5MRlPyACI2WSNWUz+APwtl37BnqxSqNjJtWA
         AXhwoif1EhT4K1UDXx2KVKAAHJTcYi+S67kzJ1E0o/fVlwzFuci25+ymq0IbaO28+ulV
         R/DzVoQmLbLtwWPTPtGpZRaGqXbtBZ3lbvewovu5KVeoKj6AQXXuFTqzXpcA+kutokCC
         IO/vvIAmsI2voC5ytpYrdcIRE7DPuYzOsCThad1jhyvVZKndzbupI1ggOYb4QwgbLAmf
         dnog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dfp0aeh95IYaI3WntgsOUL8ePUaBZUTKkfG2ztR0Dg8=;
        b=trxots9SHfhvVhDBfpzd0KkXxVpU+ZfymweUpffHD5tp2WkMP2jWCTDGwV+kmEPYqn
         f1gO3S1JfBl7sE+C/YbG/T6k7pSxN/DkLHVQD/3CgfS5+jl3BylzcaMmCqEOHkm01dvt
         kCx/a9t+ibp+NKwk9T454AUj5CNgkFH9BkgJ6gamunNAvMF1Tj8hsXb5A4dOSXD23Oor
         HsE0hYhamQeur/eXGWaUJugNDkDv01GtGSq41YbsvoQmFo5Y+zouDsWgchRi5GcQzMU1
         gqcQxr4i4lK7eTTrDq5DmLR5WTa2LHuOg/1KCXgtTcmdRShIV49jxpIiJayPr24o+O43
         9xBg==
X-Gm-Message-State: AOAM533XOz5xxhhph3YxPEVZ6OFy4aH6SWKoI7SrbBlH8vkpN4P7q4K7
        vmOG29FsCVIRuONvbdE9wjckFa4RV1HbQbGWDCM=
X-Google-Smtp-Source: ABdhPJxDMz3qQZBnj6GmuTexP76QmGK6S3OM30XwZUu0QNwDeL0K6D7QLp0JFVQ50AjKgibUkyUxKZsmm6yCAhlDeTQ=
X-Received: by 2002:a17:906:52d9:: with SMTP id w25mr17106619ejn.504.1608592111925;
 Mon, 21 Dec 2020 15:08:31 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608065644.git.wangyunjian@huawei.com> <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
In-Reply-To: <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 21 Dec 2020 18:07:54 -0500
Message-ID: <CAF=yD-K6EM3zfZtEh=305P4Z6ehO6TzfQC4cxp5+gHYrxEtXSg@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg fails
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 3:20 AM wangyunjian <wangyunjian@huawei.com> wrote:
>
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently we break the loop and wake up the vhost_worker when
> sendmsg fails. When the worker wakes up again, we'll meet the
> same error.

The patch is based on the assumption that such error cases always
return EAGAIN. Can it not also be ENOMEM, such as from tun_build_skb?

> This will cause high CPU load. To fix this issue,
> we can skip this description by ignoring the error. When we
> exceeds sndbuf, the return value of sendmsg is -EAGAIN. In
> the case we don't skip the description and don't drop packet.

the -> that

here and above: description -> descriptor

Perhaps slightly revise to more explicitly state that

1. in the case of persistent failure (i.e., bad packet), the driver
drops the packet
2. in the case of transient failure (e.g,. memory pressure) the driver
schedules the worker to try again later


> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>  drivers/vhost/net.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index c8784dfafdd7..3d33f3183abe 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -827,16 +827,13 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>                                 msg.msg_flags &= ~MSG_MORE;
>                 }
>
> -               /* TODO: Check specific error and bomb out unless ENOBUFS? */
>                 err = sock->ops->sendmsg(sock, &msg, len);
> -               if (unlikely(err < 0)) {
> +               if (unlikely(err == -EAGAIN)) {
>                         vhost_discard_vq_desc(vq, 1);
>                         vhost_net_enable_vq(net, vq);
>                         break;
> -               }
> -               if (err != len)
> -                       pr_debug("Truncated TX packet: len %d != %zd\n",
> -                                err, len);
> +               } else if (unlikely(err != len))
> +                       vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);

sending -> send

Even though vq_err is a wrapper around pr_debug, I agree with Michael
that such a change should be a separate patch to net-next, does not
belong in a fix.

More importantly, the error message is now the same for persistent
errors and for truncated packets. But on truncation the packet was
sent, so that is not entirely correct.

>  done:
>                 vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
>                 vq->heads[nvq->done_idx].len = 0;
> @@ -922,7 +919,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>                         msg.msg_flags &= ~MSG_MORE;
>                 }
>
> -               /* TODO: Check specific error and bomb out unless ENOBUFS? */
>                 err = sock->ops->sendmsg(sock, &msg, len);
>                 if (unlikely(err < 0)) {
>                         if (zcopy_used) {
> @@ -931,13 +927,14 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>                                 nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>                                         % UIO_MAXIOV;
>                         }
> -                       vhost_discard_vq_desc(vq, 1);
> -                       vhost_net_enable_vq(net, vq);
> -                       break;
> +                       if (err == -EAGAIN) {
> +                               vhost_discard_vq_desc(vq, 1);
> +                               vhost_net_enable_vq(net, vq);
> +                               break;
> +                       }
>                 }
>                 if (err != len)
> -                       pr_debug("Truncated TX packet: "
> -                                " len %d != %zd\n", err, len);
> +                       vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);
>                 if (!zcopy_used)
>                         vhost_add_used_and_signal(&net->dev, vq, head, 0);
>                 else
> --
> 2.23.0
>
