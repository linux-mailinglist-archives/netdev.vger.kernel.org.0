Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 703A32510D
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 15:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfEUNta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 09:49:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36695 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfEUNt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 09:49:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id j187so2984255wmj.1
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 06:49:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iwI6dv33dhDTJKR9IFcZzhH4iqPm6pf4TcHSpe6e9o0=;
        b=cMR2H7sVEC4d0th+FA+/8VFqjXM1Gi53gX1torPSY8MX+8wpazPUovy4/DF0vqy7pW
         tvm7aQZr2++NdOTG/wsgJzQBqqaOKQwpLvMCpPh685uGNQYRkYNyaOnCCZx+wLTH/dms
         9/KWCM8FrerNCznW/nij/xAUgaJEJ/9Bd20Qm3yAjagBdM2zuQeNWyRt1jsByVCQ7laf
         tIOFops6XagoFq1kqvXf72+VH7ImJIcF+5V8v4zPGrFZKE3Xreq38elk3DcptcoEZ322
         UgjJ/06LmmwXygg5ar70laUeS577rejIu2rhcBICSZexwtFIEN1m1D/qtWsTH82SS8l0
         iYsw==
X-Gm-Message-State: APjAAAV25uPxCAI2xQcgvhN6noxPJxc3NMp6UkhlA1FX0n3DwvP5N/Q/
        pZlBdS2mwfiiXqyJPeoe8MlWiA==
X-Google-Smtp-Source: APXvYqxvRpylp4iEHybQ7cg/NCOtt2MzAJH0MlkI1kGu66bbBRJBRsPdxwyH0dlBSy0wirO/9eTCJQ==
X-Received: by 2002:a7b:cb57:: with SMTP id v23mr2736912wmj.60.1558446567765;
        Tue, 21 May 2019 06:49:27 -0700 (PDT)
Received: from steredhat (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id b12sm6195653wmg.27.2019.05.21.06.49.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 06:49:27 -0700 (PDT)
Date:   Tue, 21 May 2019 15:49:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Question about IRQs during the .remove() of virtio-vsock driver
Message-ID: <20190521134920.pulvy5pqnertbafd@steredhat>
References: <20190521094407.ltij4ggbd7xw25ge@steredhat>
 <20190521055650-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521055650-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 06:05:31AM -0400, Michael S. Tsirkin wrote:
> On Tue, May 21, 2019 at 11:44:07AM +0200, Stefano Garzarella wrote:
> > Hi Micheal, Jason,
> > as suggested by Stefan, I'm checking if we have some races in the
> > virtio-vsock driver. We found some races in the .probe() and .remove()
> > with the upper layer (socket) and I'll fix it.
> > 
> > Now my attention is on the bottom layer (virtio device) and my question is:
> > during the .remove() of virtio-vsock driver (virtio_vsock_remove), could happen
> > that an IRQ comes and one of our callback (e.g. virtio_vsock_rx_done()) is
> > executed, queueing new works?
> > 
> > I tried to follow the code in both cases (device unplugged or module removed)
> > and maybe it couldn't happen because we remove it from bus's knowledge,
> > but I'm not sure and your advice would be very helpful.
> > 
> > Thanks in advance,
> > Stefano
> 
> 
> Great question! This should be better documented: patches welcome!

When I'm clear, I'll be happy to document this.

> 
> Here's my understanding:
> 
> 
> A typical removal flow works like this:
> 
> - prevent linux from sending new kick requests to device
>   and flush such outstanding requests if any
>   (device can still send notifications to linux)
> 
> - call
>           vi->vdev->config->reset(vi->vdev);
>   this will flush all device writes and interrupts.
>   device will not use any more buffers.
>   previously outstanding callbacks might still be active.
> 
> - Then call
>           vdev->config->del_vqs(vdev);
>   to flush outstanding callbacks if any.

Thanks for sharing these useful information.

So, IIUC between step 1 (e.g. in virtio-vsock we flush all work-queues) and
step 2, new IRQs could happen, and in the virtio-vsock driver new work
will be queued.

In order to handle this case, I'm thinking to add a new variable
'work_enabled' in the struct virtio_vsock, put it to false at the start
of the .remove(), then call synchronize_rcu() before to flush all work
queues and use an helper function virtio_transport_queue_work() to queue
a new work, where the check of work_enabled and the queue_work are in the
RCU read critical section.

Here a pseudo code to explain better the idea:

virtio_vsock_remove() {
    vsock->work_enabled = false;

    /* Wait for other CPUs to finish to queue works */
    synchronize_rcu();

    flush_works();

    vdev->config->reset(vdev);

    ...

    vdev->config->del_vqs(vdev);
}

virtio_vsock_queue_work(vsock, work) {
    rcu_read_lock();

    if (!vsock->work_enabled) {
        goto out;
    }

    queue_work(virtio_vsock_workqueue, work);

out:
    rcu_read_unlock();
}


Do you think can work?
Please tell me if there is a better way to handle this case.

Thanks,
Stefano
