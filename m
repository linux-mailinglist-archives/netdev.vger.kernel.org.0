Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6BED603F
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbfJNKcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:32:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39750 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731127AbfJNKcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 06:32:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id p12so528388pgn.6;
        Mon, 14 Oct 2019 03:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oUxiYEyAMUiFlWbyACYeVt4wto4jVAv/PYKjqVKaLG8=;
        b=XICH1u057uohUq/74Alm2nHi/+fOFgDV9WgjiihVfT5Sg76syBDQB3ZizG8huP+Yqk
         o821IEmlgdEDJyukPm/4YrmYKCkR0RMC0E7iFXRbAWBXXOc9Xl0m3ft6nVju7VuSvJ7B
         69PzTbwPmu3Rp4LVY8Sk87PE/6NEGvbB5PWT+UbOobPlpn9YcfrulAkpId+OH/Mbe7P3
         BivHa4t5N5eQKSHmVk+NuQejn4ttzhysNf0KBjesKMH+xz1zduMXH9LdprxgihaPPWnk
         xyivPrh4aAvXUWB/FL/ZO1as5PHUK91l/iDsn131+Lq4sMUXUpTtsX/qqrqf9ZotcohT
         13bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oUxiYEyAMUiFlWbyACYeVt4wto4jVAv/PYKjqVKaLG8=;
        b=TKj5Eu36VTEFPff/y3Y9JzZdDUrlOJzJ/1b9EV6V/mwlXTe6xrkm0dkv9Dr502JNuX
         3+nFuSDvvcm5cpnpSvdAwHSvmOI1g7hFDj4/ntazfn8vuoKTg+lKsrt/wVTwv7lRGcDs
         X69Eisf8XMl/cKxQElKwDYWOr6neIIOW1N2oPGt6GvpihLpotX8gADgZtLr3GZP+5g5e
         5M4OR9uw9BtLY6wnGnBfDugORwyDAHshHBbnQna9N4fx84KRIQbzsoGsZRmacQxRt1+K
         FAl4NCED3+HRzPA0fLq36QkyRgmBHgWEYHKKowOf3JpInRgzhKDEg+5RihnkexLTZl//
         Bm9w==
X-Gm-Message-State: APjAAAXhFwKDgeLn4Q9HBMWfjmD+7bAM4JtvxuStFQIp+9LhtZ7/kIrk
        G34vvDH/+NSVq0umEzwpoiO+qPLq7NB6Illo/e+rLtFI1CiVBw==
X-Google-Smtp-Source: APXvYqysfkJBTv2Dw4llgWLXQHvvNBR+K9ynrLKorQlC8QRg5naab0Mh9FSNkA9wPHO01T9BqLztip8qsulciJzZkLU=
X-Received: by 2002:a63:82:: with SMTP id 124mr33805671pga.112.1571049171202;
 Mon, 14 Oct 2019 03:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191014090910.9701-1-jgross@suse.com> <20191014090910.9701-3-jgross@suse.com>
In-Reply-To: <20191014090910.9701-3-jgross@suse.com>
From:   Paul Durrant <pdurrant@gmail.com>
Date:   Mon, 14 Oct 2019 11:32:40 +0100
Message-ID: <CACCGGhAYRk6gy7dDqP5QqNJBJamT4wSc5muwR0LUoUEVv_O+=g@mail.gmail.com>
Subject: Re: [PATCH 2/2] xen/netback: cleanup init and deinit code
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel <xen-devel@lists.xenproject.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Oct 2019 at 10:09, Juergen Gross <jgross@suse.com> wrote:
>
> Do some cleanup of the netback init and deinit code:
>
> - add an omnipotent queue deinit function usable from
>   xenvif_disconnect_data() and the error path of xenvif_connect_data()
> - only install the irq handlers after initializing all relevant items
>   (especially the kthreads related to the queue)
> - there is no need to use get_task_struct() after creating a kthread
>   and using put_task_struct() again after having stopped it.
> - use kthread_run() instead of kthread_create() to spare the call of
>   wake_up_process().

I guess the reason it was done that way was to ensure that queue->task
and queue->dealloc_task would be set before the relevant threads
executed, but I don't see anywhere relying on this so I guess change
is safe. The rest of it looks fine.

>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Paul Durrant <paul@xen.org>

> ---
>  drivers/net/xen-netback/interface.c | 114 +++++++++++++++++-------------------
>  1 file changed, 54 insertions(+), 60 deletions(-)
>
> diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
> index 103ed00775eb..68dd7bb07ca6 100644
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -626,6 +626,38 @@ int xenvif_connect_ctrl(struct xenvif *vif, grant_ref_t ring_ref,
>         return err;
>  }
>
> +static void xenvif_disconnect_queue(struct xenvif_queue *queue)
> +{
> +       if (queue->tx_irq) {
> +               unbind_from_irqhandler(queue->tx_irq, queue);
> +               if (queue->tx_irq == queue->rx_irq)
> +                       queue->rx_irq = 0;
> +               queue->tx_irq = 0;
> +       }
> +
> +       if (queue->rx_irq) {
> +               unbind_from_irqhandler(queue->rx_irq, queue);
> +               queue->rx_irq = 0;
> +       }
> +
> +       if (queue->task) {
> +               kthread_stop(queue->task);
> +               queue->task = NULL;
> +       }
> +
> +       if (queue->dealloc_task) {
> +               kthread_stop(queue->dealloc_task);
> +               queue->dealloc_task = NULL;
> +       }
> +
> +       if (queue->napi.poll) {
> +               netif_napi_del(&queue->napi);
> +               queue->napi.poll = NULL;
> +       }
> +
> +       xenvif_unmap_frontend_data_rings(queue);
> +}
> +
>  int xenvif_connect_data(struct xenvif_queue *queue,
>                         unsigned long tx_ring_ref,
>                         unsigned long rx_ring_ref,
> @@ -651,13 +683,27 @@ int xenvif_connect_data(struct xenvif_queue *queue,
>         netif_napi_add(queue->vif->dev, &queue->napi, xenvif_poll,
>                         XENVIF_NAPI_WEIGHT);
>
> +       queue->stalled = true;
> +
> +       task = kthread_run(xenvif_kthread_guest_rx, queue,
> +                          "%s-guest-rx", queue->name);
> +       if (IS_ERR(task))
> +               goto kthread_err;
> +       queue->task = task;
> +
> +       task = kthread_run(xenvif_dealloc_kthread, queue,
> +                          "%s-dealloc", queue->name);
> +       if (IS_ERR(task))
> +               goto kthread_err;
> +       queue->dealloc_task = task;
> +
>         if (tx_evtchn == rx_evtchn) {
>                 /* feature-split-event-channels == 0 */
>                 err = bind_interdomain_evtchn_to_irqhandler(
>                         queue->vif->domid, tx_evtchn, xenvif_interrupt, 0,
>                         queue->name, queue);
>                 if (err < 0)
> -                       goto err_unmap;
> +                       goto err;
>                 queue->tx_irq = queue->rx_irq = err;
>                 disable_irq(queue->tx_irq);
>         } else {
> @@ -668,7 +714,7 @@ int xenvif_connect_data(struct xenvif_queue *queue,
>                         queue->vif->domid, tx_evtchn, xenvif_tx_interrupt, 0,
>                         queue->tx_irq_name, queue);
>                 if (err < 0)
> -                       goto err_unmap;
> +                       goto err;
>                 queue->tx_irq = err;
>                 disable_irq(queue->tx_irq);
>
> @@ -678,47 +724,18 @@ int xenvif_connect_data(struct xenvif_queue *queue,
>                         queue->vif->domid, rx_evtchn, xenvif_rx_interrupt, 0,
>                         queue->rx_irq_name, queue);
>                 if (err < 0)
> -                       goto err_tx_unbind;
> +                       goto err;
>                 queue->rx_irq = err;
>                 disable_irq(queue->rx_irq);
>         }
>
> -       queue->stalled = true;
> -
> -       task = kthread_create(xenvif_kthread_guest_rx,
> -                             (void *)queue, "%s-guest-rx", queue->name);
> -       if (IS_ERR(task)) {
> -               pr_warn("Could not allocate kthread for %s\n", queue->name);
> -               err = PTR_ERR(task);
> -               goto err_rx_unbind;
> -       }
> -       queue->task = task;
> -       get_task_struct(task);
> -
> -       task = kthread_create(xenvif_dealloc_kthread,
> -                             (void *)queue, "%s-dealloc", queue->name);
> -       if (IS_ERR(task)) {
> -               pr_warn("Could not allocate kthread for %s\n", queue->name);
> -               err = PTR_ERR(task);
> -               goto err_rx_unbind;
> -       }
> -       queue->dealloc_task = task;
> -
> -       wake_up_process(queue->task);
> -       wake_up_process(queue->dealloc_task);
> -
>         return 0;
>
> -err_rx_unbind:
> -       unbind_from_irqhandler(queue->rx_irq, queue);
> -       queue->rx_irq = 0;
> -err_tx_unbind:
> -       unbind_from_irqhandler(queue->tx_irq, queue);
> -       queue->tx_irq = 0;
> -err_unmap:
> -       xenvif_unmap_frontend_data_rings(queue);
> -       netif_napi_del(&queue->napi);
> +kthread_err:
> +       pr_warn("Could not allocate kthread for %s\n", queue->name);
> +       err = PTR_ERR(task);
>  err:
> +       xenvif_disconnect_queue(queue);
>         return err;
>  }
>
> @@ -746,30 +763,7 @@ void xenvif_disconnect_data(struct xenvif *vif)
>         for (queue_index = 0; queue_index < num_queues; ++queue_index) {
>                 queue = &vif->queues[queue_index];
>
> -               netif_napi_del(&queue->napi);
> -
> -               if (queue->task) {
> -                       kthread_stop(queue->task);
> -                       put_task_struct(queue->task);
> -                       queue->task = NULL;
> -               }
> -
> -               if (queue->dealloc_task) {
> -                       kthread_stop(queue->dealloc_task);
> -                       queue->dealloc_task = NULL;
> -               }
> -
> -               if (queue->tx_irq) {
> -                       if (queue->tx_irq == queue->rx_irq)
> -                               unbind_from_irqhandler(queue->tx_irq, queue);
> -                       else {
> -                               unbind_from_irqhandler(queue->tx_irq, queue);
> -                               unbind_from_irqhandler(queue->rx_irq, queue);
> -                       }
> -                       queue->tx_irq = 0;
> -               }
> -
> -               xenvif_unmap_frontend_data_rings(queue);
> +               xenvif_disconnect_queue(queue);
>         }
>
>         xenvif_mcast_addr_list_free(vif);
> --
> 2.16.4
>
