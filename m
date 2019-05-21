Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8323F2513F
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 15:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfEUN4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 09:56:51 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37904 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfEUN4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 09:56:51 -0400
Received: by mail-qt1-f194.google.com with SMTP id l3so9780816qtj.5
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 06:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pYTaum3CP12CnNl2l2SARLRYzz24Z2DkyaBwwLZT8fg=;
        b=bECRBjhM+nKf8JuCDviqApupzpWq6NJIyFTrdmC1wNbpmYahWHhwXGbjupTkKviZ9f
         9WsDrcwMSas0FVModyJ15t+iMz/m35MWYrW+d6wTHf+hue203lJA/JxXav0JqAdOSbUq
         vtSWriFwmA8KRoeTClawlDVZUw2m3oPagFMCBN46lvITve0XQVjUdt81doBh1iE5kmPb
         Cz7v7pj4No1gX3kuYw/7hoT8fNCacGgl+r1qZspqzCf+WWPMxSdYIlv7kote3PfFq8Ha
         GmdPHyUYj9ClJ38TQeku9NpoyOPL0WMrT4aDAAU4FyyurpuZIGr5FZOKKwhoJstQ2JJH
         +axQ==
X-Gm-Message-State: APjAAAWzaMuZpljJkSPb0FhZUxYASAOgjVBEAAFq87bWW6b8AmIyXmHl
        h0eOJtAXc+FF4/XTda/BeOJOnw==
X-Google-Smtp-Source: APXvYqyjROqqBcwmASxlAI9VU7w+aszGFaCH3E/iShso0EmvHY3NlE1r+Z/BxGRgQ8swy30L/IwCBw==
X-Received: by 2002:ac8:1ae2:: with SMTP id h31mr68116988qtk.75.1558447010171;
        Tue, 21 May 2019 06:56:50 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net. [173.76.105.71])
        by smtp.gmail.com with ESMTPSA id l40sm13534232qtc.32.2019.05.21.06.56.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 21 May 2019 06:56:48 -0700 (PDT)
Date:   Tue, 21 May 2019 09:56:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Question about IRQs during the .remove() of virtio-vsock driver
Message-ID: <20190521095206-mutt-send-email-mst@kernel.org>
References: <20190521094407.ltij4ggbd7xw25ge@steredhat>
 <20190521055650-mutt-send-email-mst@kernel.org>
 <20190521134920.pulvy5pqnertbafd@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521134920.pulvy5pqnertbafd@steredhat>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 03:49:20PM +0200, Stefano Garzarella wrote:
> On Tue, May 21, 2019 at 06:05:31AM -0400, Michael S. Tsirkin wrote:
> > On Tue, May 21, 2019 at 11:44:07AM +0200, Stefano Garzarella wrote:
> > > Hi Micheal, Jason,
> > > as suggested by Stefan, I'm checking if we have some races in the
> > > virtio-vsock driver. We found some races in the .probe() and .remove()
> > > with the upper layer (socket) and I'll fix it.
> > > 
> > > Now my attention is on the bottom layer (virtio device) and my question is:
> > > during the .remove() of virtio-vsock driver (virtio_vsock_remove), could happen
> > > that an IRQ comes and one of our callback (e.g. virtio_vsock_rx_done()) is
> > > executed, queueing new works?
> > > 
> > > I tried to follow the code in both cases (device unplugged or module removed)
> > > and maybe it couldn't happen because we remove it from bus's knowledge,
> > > but I'm not sure and your advice would be very helpful.
> > > 
> > > Thanks in advance,
> > > Stefano
> > 
> > 
> > Great question! This should be better documented: patches welcome!
> 
> When I'm clear, I'll be happy to document this.
> 
> > 
> > Here's my understanding:
> > 
> > 
> > A typical removal flow works like this:
> > 
> > - prevent linux from sending new kick requests to device
> >   and flush such outstanding requests if any
> >   (device can still send notifications to linux)
> > 
> > - call
> >           vi->vdev->config->reset(vi->vdev);
> >   this will flush all device writes and interrupts.
> >   device will not use any more buffers.
> >   previously outstanding callbacks might still be active.
> > 
> > - Then call
> >           vdev->config->del_vqs(vdev);
> >   to flush outstanding callbacks if any.
> 
> Thanks for sharing these useful information.
> 
> So, IIUC between step 1 (e.g. in virtio-vsock we flush all work-queues) and
> step 2, new IRQs could happen, and in the virtio-vsock driver new work
> will be queued.
> 
> In order to handle this case, I'm thinking to add a new variable
> 'work_enabled' in the struct virtio_vsock, put it to false at the start
> of the .remove(), then call synchronize_rcu() before to flush all work
> queues
> and use an helper function virtio_transport_queue_work() to queue
> a new work, where the check of work_enabled and the queue_work are in the
> RCU read critical section.
> 
> Here a pseudo code to explain better the idea:
> 
> virtio_vsock_remove() {
>     vsock->work_enabled = false;
> 
>     /* Wait for other CPUs to finish to queue works */
>     synchronize_rcu();
> 
>     flush_works();
> 
>     vdev->config->reset(vdev);
> 
>     ...
> 
>     vdev->config->del_vqs(vdev);
> }
> 
> virtio_vsock_queue_work(vsock, work) {
>     rcu_read_lock();
> 
>     if (!vsock->work_enabled) {
>         goto out;
>     }
> 
>     queue_work(virtio_vsock_workqueue, work);
> 
> out:
>     rcu_read_unlock();
> }
> 
> 
> Do you think can work?
> Please tell me if there is a better way to handle this case.
> 
> Thanks,
> Stefano


instead of rcu tricks I would just have rx_run and tx_run and check it
within the queued work - presumably under tx or rx lock.

then queueing an extra work becomes harmless,
and you flush it after del vqs which flushes everything for you.


