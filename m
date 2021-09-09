Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13FC4043C2
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 04:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348203AbhIICyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 22:54:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347175AbhIICyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 22:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631155992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Dd9/A9sFeDep6pwypkyHRy6LbqeJ+nHZSlHUWD9puM=;
        b=LwwwRfEb7kSUSqx9BJpdwrHPpPVXHy7UaQmVJGxgm5Ey6DM+ucc8DTOM7UJOKgkd3p4OKe
        0ODdoXV1Edg/HRfx+4AjS/4HzIN7CygC621zy4sU8y+hQlTJNaoeZAA15SPVz3h2t1imw7
        PYknWeW+4DsMiomc8MT98G2KbvNRCG4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-LMhjinA4P120imOf6Mydxw-1; Wed, 08 Sep 2021 22:53:11 -0400
X-MC-Unique: LMhjinA4P120imOf6Mydxw-1
Received: by mail-lf1-f69.google.com with SMTP id w18-20020ac25d520000b02903c5ff81b281so175273lfd.3
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 19:53:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Dd9/A9sFeDep6pwypkyHRy6LbqeJ+nHZSlHUWD9puM=;
        b=VaIW4NcvAyQcRLttKHqTHdHa53QSPpfYN/0A96YEZUb93kbU33SkQyu2xfFZUjFssE
         MBeT2/W5lHPyvzD8Kwc6xfaZHIZKPUZiOXvjAIk17BKDxdtNMoRbcL7dgjDTv4p5x81Q
         U8DIRnoUKzjhZCzpE8lJwjqmyiFjMnDpbzGeR7CAqdorM9oS7pzdMrpURV1b3OmIflQu
         6UUaoomvtkSYciX0KD+iYEImMOvAWN5oQaFzwjj6WbRvw7J6bm0+aJxKFskkaQfyW3PS
         Xg9OR5e5MqiLgryrMa93Q8BUJAhoFo/YeDYAebnVQbhkplJ12smzy419rQkDR3ergcyU
         HzBA==
X-Gm-Message-State: AOAM532t7VBElGe568+o5lEFCP8TgRn40OvqHQCgtx5YYpqr7iVYaTSJ
        oD1Q0b/VTwDG3gOfMpUDNdizQkzxxc0Njw+vJo9d9JpoXouam7UhCqboFr6E9x8ERv3pbYKAvdz
        GaYzgsJ8H+6xF1zyw3z26gw/3fCvL7eOX
X-Received: by 2002:a2e:99d9:: with SMTP id l25mr425105ljj.217.1631155990093;
        Wed, 08 Sep 2021 19:53:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo1QiSnPNV+uG69sTm5YphTzwX2AqVXNZlrZDd69Dbr+lA7ndwSZ8/FU/at8ix62m9YeVPMnUYQ2Rz6NMek4E=
X-Received: by 2002:a2e:99d9:: with SMTP id l25mr425099ljj.217.1631155989914;
 Wed, 08 Sep 2021 19:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <463c1b02ca6f65fc1183431d8d85ec8154a2c28e.1631090797.git.pabeni@redhat.com>
In-Reply-To: <463c1b02ca6f65fc1183431d8d85ec8154a2c28e.1631090797.git.pabeni@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 9 Sep 2021 10:52:59 +0800
Message-ID: <CACGkMEvTBt3WSJnxvGN0-gsZNXE1eRqx4ZV7X+d9gar1VfwArA@mail.gmail.com>
Subject: Re: [PATCH] vhost_net: fix OoB on sendmsg() failure.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 7:42 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> If the sendmsg() call in vhost_tx_batch() fails, both the 'batched_xdp'
> and 'done_idx' indexes are left unchanged. If such failure happens
> when batched_xdp == VHOST_NET_BATCH, the next call to
> vhost_net_build_xdp() will access and write memory outside the xdp
> buffers area.
>
> Since sendmsg() can only error with EBADFD, this change addresses the
> issue explicitly freeing the XDP buffers batch on error.
>
> Fixes: 0a0be13b8fe2 ("vhost_net: batch submitting XDP buffers to underlayer sockets")
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> Note: my understanding is that this should go through MST's tree, please
> educate me otherwise, thanks!
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks!

>  drivers/vhost/net.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 3a249ee7e144..28ef323882fb 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -467,7 +467,7 @@ static void vhost_tx_batch(struct vhost_net *net,
>                 .num = nvq->batched_xdp,
>                 .ptr = nvq->xdp,
>         };
> -       int err;
> +       int i, err;
>
>         if (nvq->batched_xdp == 0)
>                 goto signal_used;
> @@ -476,6 +476,15 @@ static void vhost_tx_batch(struct vhost_net *net,
>         err = sock->ops->sendmsg(sock, msghdr, 0);
>         if (unlikely(err < 0)) {
>                 vq_err(&nvq->vq, "Fail to batch sending packets\n");
> +
> +               /* free pages owned by XDP; since this is an unlikely error path,
> +                * keep it simple and avoid more complex bulk update for the
> +                * used pages
> +                */
> +               for (i = 0; i < nvq->batched_xdp; ++i)
> +                       put_page(virt_to_head_page(nvq->xdp[i].data));
> +               nvq->batched_xdp = 0;
> +               nvq->done_idx = 0;
>                 return;
>         }
>
> --
> 2.26.3
>

