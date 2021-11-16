Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214DD452959
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 06:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbhKPFEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 00:04:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237189AbhKPFEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 00:04:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637038865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NZbJVFSsiYxk6JEYO0Xpu55G92qAXMwmH+tm+8XpReU=;
        b=NB6hh+FGiPwku2/wiMi9NwyVVAOUiF0fgCnPHoVcYd5m58moRIvgAwxc3353c1JTRFTtyF
        GraPW4LObSO39nkBALnG0bs40jyU4YxWJ+cxIh1e2UyhZ+wwVHT1nwQU9Y1Qw2C6Xf11Je
        7afVPm3/KXbo+7bUD0pByy6wy9EpsGo=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-_sHJb4BlMCm9JBClD8BSHg-1; Tue, 16 Nov 2021 00:01:02 -0500
X-MC-Unique: _sHJb4BlMCm9JBClD8BSHg-1
Received: by mail-lf1-f69.google.com with SMTP id u20-20020a056512129400b0040373ffc60bso7701318lfs.15
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 21:01:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NZbJVFSsiYxk6JEYO0Xpu55G92qAXMwmH+tm+8XpReU=;
        b=C5yjTAUQZDVqGwnpsgUK9LKMf+4zvKG0C+0JYdmz8xjCc/mA6XCdnYzDk5RVhphE1H
         ldLdswKrrx9AqivheSe5yEVgnb8Mh1MDt70x6y+3uKDsB6Uf6wRwvZN89scxHilf4YGq
         /3sOQn1CYjn4+CMvQ9JPmFxcOx33D6dEr8XIk4/vkCotZgP8nwTzg0OZyfYq4A1HGmDG
         Loi8TcgrCqs+v4XuZXMn/fCUq/l9cjncf9yJJmIH1KGyNC7JvRnGZ1I1//rt4TICOp4n
         RmUOQFjLMa3ZCn98jaQtnkyOardRXj15FStRx1dq4qY4+bI7mCpEeE5J7nYSotbwe1Ii
         BvwA==
X-Gm-Message-State: AOAM531EIrjehZ5xe+YfuXi1e7vR715hC9qiZyf5oEJur3RMHkkchwtG
        iBCD3/U9zm3DfMPmuU3iy9OFLgaAM6qtixRw7TeOJ6lmzB45xNmJigZqhOJfVxV0qEQ0ztFUYyb
        45JkIQrTc+1PnnORLBc5L2jwW+Nncg3wG
X-Received: by 2002:ac2:518b:: with SMTP id u11mr3980767lfi.498.1637038861143;
        Mon, 15 Nov 2021 21:01:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmwi8ZBJDwkdhthf+6U7z0+K409Zl2U1G1z4cKoLh4WJGn9JeAOqnszcmQh+p5V5nQXwNj+ySZvlSCNDXcV2U=
X-Received: by 2002:ac2:518b:: with SMTP id u11mr3980732lfi.498.1637038860836;
 Mon, 15 Nov 2021 21:01:00 -0800 (PST)
MIME-Version: 1.0
References: <20211115153003.9140-1-arbn@yandex-team.com> <20211115153003.9140-6-arbn@yandex-team.com>
In-Reply-To: <20211115153003.9140-6-arbn@yandex-team.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 16 Nov 2021 13:00:50 +0800
Message-ID: <CACGkMEumax9RFVNgWLv5GyoeQAmwo-UgAq=DrUd4yLxPAUUqBw@mail.gmail.com>
Subject: Re: [PATCH 6/6] vhost_net: use RCU callbacks instead of synchronize_rcu()
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 11:32 PM Andrey Ryabinin <arbn@yandex-team.com> wrote:
>
> Currently vhost_net_release() uses synchronize_rcu() to synchronize
> freeing with vhost_zerocopy_callback(). However synchronize_rcu()
> is quite costly operation. It take more than 10 seconds
> to shutdown qemu launched with couple net devices like this:
>         -netdev tap,id=tap0,..,vhost=on,queues=80
> because we end up calling synchronize_rcu() netdev_count*queues times.
>
> Free vhost net structures in rcu callback instead of using
> synchronize_rcu() to fix the problem.

I admit the release code is somehow hard to understand. But I wonder
if the following case can still happen with this:

CPU 0 (vhost_dev_cleanup)   CPU1
(vhost_net_zerocopy_callback()->vhost_work_queue())
                                                if (!dev->worker)
dev->worker = NULL

wake_up_process(dev->worker)

If this is true. It seems the fix is to move RCU synchronization stuff
in vhost_net_ubuf_put_and_wait()?

Thanks

>
> Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
> ---
>  drivers/vhost/net.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 97a209d6a527..0699d30e83d5 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -132,6 +132,7 @@ struct vhost_net {
>         struct vhost_dev dev;
>         struct vhost_net_virtqueue vqs[VHOST_NET_VQ_MAX];
>         struct vhost_poll poll[VHOST_NET_VQ_MAX];
> +       struct rcu_head rcu;
>         /* Number of TX recently submitted.
>          * Protected by tx vq lock. */
>         unsigned tx_packets;
> @@ -1389,6 +1390,18 @@ static void vhost_net_flush(struct vhost_net *n)
>         }
>  }
>
> +static void vhost_net_free(struct rcu_head *rcu_head)
> +{
> +       struct vhost_net *n = container_of(rcu_head, struct vhost_net, rcu);
> +
> +       kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
> +       kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
> +       kfree(n->dev.vqs);
> +       if (n->page_frag.page)
> +               __page_frag_cache_drain(n->page_frag.page, n->refcnt_bias);
> +       kvfree(n);
> +}
> +
>  static int vhost_net_release(struct inode *inode, struct file *f)
>  {
>         struct vhost_net *n = f->private_data;
> @@ -1404,15 +1417,8 @@ static int vhost_net_release(struct inode *inode, struct file *f)
>                 sockfd_put(tx_sock);
>         if (rx_sock)
>                 sockfd_put(rx_sock);
> -       /* Make sure no callbacks are outstanding */
> -       synchronize_rcu();
>
> -       kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
> -       kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
> -       kfree(n->dev.vqs);
> -       if (n->page_frag.page)
> -               __page_frag_cache_drain(n->page_frag.page, n->refcnt_bias);
> -       kvfree(n);
> +       call_rcu(&n->rcu, vhost_net_free);
>         return 0;
>  }
>
> --
> 2.32.0
>

