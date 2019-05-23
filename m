Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630C827EE5
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfEWN4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:56:40 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37910 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730323AbfEWN4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 09:56:40 -0400
Received: by mail-wm1-f66.google.com with SMTP id t5so5898549wmh.3
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 06:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=4zyOmc3w83OZjNl1gz2hff5TDZIfn6vMP8k+ViPMpNw=;
        b=OUeiqgLfsR6n0O/ADGCdziEKh/zSFE47vYaAoCVaMg31T7QT7s9DDiUGUQw3yOYnXk
         afy2AxmUvRd0XTygOe176LkV92ag91g+Th7s5Yo/jvNLzOdv0B9WEm+n9kH2cAbXYyhV
         5HP4pSD4u2ps2xrBsjcc16u5jiNRXIVJnStj0hHBgFPQw8KGKaTHdEFgF4zpbpzpXq69
         3+C11EnJB6Wye1EU1T9UUF0JAPjvQIYnUa407nTWJ/WlnvbLHMi+cy0CXi7OeSEA+VBg
         U6JlCPdzl73Z+4JM8scmxZWapfN+ufH/WPSKQ09lX9MXUvLMOyI7lm3RG4j4gsn2a+RW
         x6cQ==
X-Gm-Message-State: APjAAAX7t//VdXE7bM4labv5bbgm2hDg44Bz3D/Y6mgUHV0N8SkCG7wd
        hXwgDPmzPpzD1IzyUDjHBeRUtA==
X-Google-Smtp-Source: APXvYqztZcHI0xZmDKFQnfruxXXNMb3/j4YG4j9kP6ksNGl8MO3TiVCyDFJPq3t3VUrWQzc6peKArA==
X-Received: by 2002:a1c:eb0c:: with SMTP id j12mr11417383wmh.55.1558619797231;
        Thu, 23 May 2019 06:56:37 -0700 (PDT)
Received: from steredhat (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id y8sm7696956wmi.8.2019.05.23.06.56.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 06:56:36 -0700 (PDT)
Date:   Thu, 23 May 2019 15:56:34 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Question about IRQs during the .remove() of virtio-vsock driver
Message-ID: <20190523135634.wdy674m4iptjycav@steredhat>
References: <20190521094407.ltij4ggbd7xw25ge@steredhat>
 <20190521055650-mutt-send-email-mst@kernel.org>
 <20190521134920.pulvy5pqnertbafd@steredhat>
 <20190521095206-mutt-send-email-mst@kernel.org>
 <d58c5a2e-6bb2-aae6-4765-a6205e156ae4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d58c5a2e-6bb2-aae6-4765-a6205e156ae4@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 11:44:26AM +0800, Jason Wang wrote:
> 
> On 2019/5/21 下午9:56, Michael S. Tsirkin wrote:
> > On Tue, May 21, 2019 at 03:49:20PM +0200, Stefano Garzarella wrote:
> > > On Tue, May 21, 2019 at 06:05:31AM -0400, Michael S. Tsirkin wrote:
> > > > On Tue, May 21, 2019 at 11:44:07AM +0200, Stefano Garzarella wrote:
> > > > > Hi Micheal, Jason,
> > > > > as suggested by Stefan, I'm checking if we have some races in the
> > > > > virtio-vsock driver. We found some races in the .probe() and .remove()
> > > > > with the upper layer (socket) and I'll fix it.
> > > > > 
> > > > > Now my attention is on the bottom layer (virtio device) and my question is:
> > > > > during the .remove() of virtio-vsock driver (virtio_vsock_remove), could happen
> > > > > that an IRQ comes and one of our callback (e.g. virtio_vsock_rx_done()) is
> > > > > executed, queueing new works?
> > > > > 
> > > > > I tried to follow the code in both cases (device unplugged or module removed)
> > > > > and maybe it couldn't happen because we remove it from bus's knowledge,
> > > > > but I'm not sure and your advice would be very helpful.
> > > > > 
> > > > > Thanks in advance,
> > > > > Stefano
> > > > 
> > > > Great question! This should be better documented: patches welcome!
> > > When I'm clear, I'll be happy to document this.
> > > 
> > > > Here's my understanding:
> > > > 
> > > > 
> > > > A typical removal flow works like this:
> > > > 
> > > > - prevent linux from sending new kick requests to device
> > > >    and flush such outstanding requests if any
> > > >    (device can still send notifications to linux)
> > > > 
> > > > - call
> > > >            vi->vdev->config->reset(vi->vdev);
> > > >    this will flush all device writes and interrupts.
> > > >    device will not use any more buffers.
> > > >    previously outstanding callbacks might still be active.
> > > > 
> > > > - Then call
> > > >            vdev->config->del_vqs(vdev);
> > > >    to flush outstanding callbacks if any.
> > > Thanks for sharing these useful information.
> > > 
> > > So, IIUC between step 1 (e.g. in virtio-vsock we flush all work-queues) and
> > > step 2, new IRQs could happen, and in the virtio-vsock driver new work
> > > will be queued.
> > > 
> > > In order to handle this case, I'm thinking to add a new variable
> > > 'work_enabled' in the struct virtio_vsock, put it to false at the start
> > > of the .remove(), then call synchronize_rcu() before to flush all work
> > > queues
> > > and use an helper function virtio_transport_queue_work() to queue
> > > a new work, where the check of work_enabled and the queue_work are in the
> > > RCU read critical section.
> > > 
> > > Here a pseudo code to explain better the idea:
> > > 
> > > virtio_vsock_remove() {
> > >      vsock->work_enabled = false;
> > > 
> > >      /* Wait for other CPUs to finish to queue works */
> > >      synchronize_rcu();
> > > 
> > >      flush_works();
> > > 
> > >      vdev->config->reset(vdev);
> > > 
> > >      ...
> > > 
> > >      vdev->config->del_vqs(vdev);
> > > }
> > > 
> > > virtio_vsock_queue_work(vsock, work) {
> > >      rcu_read_lock();
> > > 
> > >      if (!vsock->work_enabled) {
> > >          goto out;
> > >      }
> > > 
> > >      queue_work(virtio_vsock_workqueue, work);
> > > 
> > > out:
> > >      rcu_read_unlock();
> > > }
> > > 
> > > 
> > > Do you think can work?
> > > Please tell me if there is a better way to handle this case.
> > > 
> > > Thanks,
> > > Stefano
> > 
> > instead of rcu tricks I would just have rx_run and tx_run and check it
> > within the queued work - presumably under tx or rx lock.
> > 
> > then queueing an extra work becomes harmless,
> > and you flush it after del vqs which flushes everything for you.
> > 
> > 
> 
> It looks to me that we need guarantee no work queued or scheduled before
> del_vqs. Otherwise it may lead use after free? (E.g net disable NAPI before
> del_vqs).
> 

I'm disabling works before del_vqs (setting tx_run or rx_run to false under the
tx or rx lock), this means that work can still be queued, but the worker
function will exit just after tx or rx lock is acquired, where I'm
checking the tx_run or rx_run, so no workers should use the virtqueues.

Then I'll call del_vqs and I'll flush all works before to free the
'vsock' object (struct virtio_vsock) to be sure that no workers will run.

I hope this will match your advice.

Thanks,
Stefano
