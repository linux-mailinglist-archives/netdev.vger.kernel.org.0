Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C73D2E1FB6
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 18:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgLWRG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 12:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgLWRG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 12:06:58 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57470C061794
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 09:06:18 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id r5so16789313eda.12
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 09:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uqtqep8MBRBnMvoqlrSmq9TH+EkPmSEzHGyxTzebhLQ=;
        b=KTqKohe/TXnxaN/Svnn4kby9voX4gttm0mqyior0aZWCPbzuM89rEjL5KRhG2mYs4p
         e6FRBOQlcdnvJG434mJ4Md8qfJcyU321XsCMv6l+0r45f0sBT1lI8gaJbX+RzodZnQ5R
         jcA03EZZxBzU/L1damoS8mZOHYzRPs1JrHKupFwv78aVD6KwVeVsvPqbwQ5LZIbESBYb
         0XD3m8ePeqIawPew2hwdpPPSv294qu+LkEJl2oeJ3QfBldHZtqOncxS0N2rpBlZd9w9U
         pJpOTKPRHMvUytd1DGLcPsA9gEfA9nSXinX29h2tFpjHud30vYpcHgudpHrSpqMqZYa/
         Y0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uqtqep8MBRBnMvoqlrSmq9TH+EkPmSEzHGyxTzebhLQ=;
        b=qlrS1gOaANMlsM6tBjFTwbfbYRn2AjxmfbLD1b2eWz1rqqByJ+rs3TD4C2Gl/KGoW7
         smq0bs6xoRiz2KfHaqOHPwU8g5atit//KLqcQlxXB/Wlf/DRQkRUsXyoO05DdmLwEZiU
         LjWydo0ZDr7yYy00vXh/EjIDGWLzNzlwvuvJ5PnFNr1/xjOghIBeCC9pPE9nMMWjVZ01
         2D4ZDTpCHCle9pFN1UypyXTCsjjtq4ZRuFlLOCLujTluZ8vFxaXbs5uqhAEZXRaQG091
         +Idq+D+xDmTmkJMYZfcRdQW7eHzX9EvMW+82fJ31hmYhaq1gCweBuPHLQJqCWMsu8FgH
         BbwQ==
X-Gm-Message-State: AOAM531dKSzipksnHHTPQ6kwWTRuWLAT/piozmx1iZoY2ZXnHh9sgh7h
        2I8vdr0AISObxHqnVcdTxW4nS0G2BlC0yncmh+4=
X-Google-Smtp-Source: ABdhPJwVwS1JuWFuvRUzcl9/I/UR7jRHWd5L/5jdHvD6ja745mMoTitrtSe3P9DvcViaYnz4FeCKY8jzUr0Huj6+86Y=
X-Received: by 2002:a05:6402:1386:: with SMTP id b6mr25566353edv.42.1608743177109;
 Wed, 23 Dec 2020 09:06:17 -0800 (PST)
MIME-Version: 1.0
References: <1608734856-12516-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1608734856-12516-1-git-send-email-wangyunjian@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 23 Dec 2020 12:05:38 -0500
Message-ID: <CAF=yD-KSm4fTWUZy1F2gFOw-qLmMV76rHmzcr05Upz9WV=SXvg@mail.gmail.com>
Subject: Re: [PATCH net v3 2/2] vhost_net: fix tx queue stuck when sendmsg fails
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

On Wed, Dec 23, 2020 at 9:47 AM wangyunjian <wangyunjian@huawei.com> wrote:
>
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently the driver don't drop a packet which can't be send by tun
>
> (e.g bad packet). In this case, the driver will always process the
> same packet lead to the tx queue stuck.
>
> To fix this issue:
> 1. in the case of persistent failure (e.g bad packet), the driver
> can skip this descriptior by ignoring the error.
> 2. in the case of transient failure (e.g -EAGAIN and -ENOMEM), the
> driver schedules the worker to try again.
>

Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")

Since I have a few other comments, a few minor typo corrections too:
don't -> doesn't, send -> sent, descriptior -> descriptor.

> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
>
>  drivers/vhost/net.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index c8784dfafdd7..e49dd64d086a 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -827,9 +827,8 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>                                 msg.msg_flags &= ~MSG_MORE;
>                 }
>
> -               /* TODO: Check specific error and bomb out unless ENOBUFS? */
>                 err = sock->ops->sendmsg(sock, &msg, len);
> -               if (unlikely(err < 0)) {
> +               if (unlikely(err == -EAGAIN || err == -ENOMEM)) {
>                         vhost_discard_vq_desc(vq, 1);
>                         vhost_net_enable_vq(net, vq);
>                         break;
> @@ -922,7 +921,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>                         msg.msg_flags &= ~MSG_MORE;
>                 }
>
> -               /* TODO: Check specific error and bomb out unless ENOBUFS? */
>                 err = sock->ops->sendmsg(sock, &msg, len);
>                 if (unlikely(err < 0)) {
>                         if (zcopy_used) {
> @@ -931,9 +929,11 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>                                 nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>                                         % UIO_MAXIOV;
>                         }
> -                       vhost_discard_vq_desc(vq, 1);
> -                       vhost_net_enable_vq(net, vq);
> -                       break;
> +                       if (err == -EAGAIN || err == -ENOMEM) {
> +                               vhost_discard_vq_desc(vq, 1);
> +                               vhost_net_enable_vq(net, vq);
> +                               break;
> +                       }
>                 }
>                 if (err != len)
>                         pr_debug("Truncated TX packet: "

Probably my bad for feedback in patch 2/2, but now vhost will
incorrectly log bad packets as truncated packets.

This will need to be if (err >= 0 && err != len).

It would be nice if we could notify the guest in the transmit
descriptor when a packet was dropped due to failing integrity checks
(bad packet). But I don't think we easily can, so out of scope for
this fix.
