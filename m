Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42ADE24C36
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 12:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfEUKFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 06:05:35 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39564 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfEUKFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 06:05:35 -0400
Received: by mail-qt1-f193.google.com with SMTP id y42so19750237qtk.6
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 03:05:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z7qgAEipoJrrDBwx15qY8meLZixvE2IB+wvZftGohQA=;
        b=l31IMnOPCSBlBd6PFPhc67y4iIsEDB/EJDU4qQ/XTwJHIxW3R2HkfYxPMrLLNXWwhH
         6mwVd8N4gtOTqn8C11zab7/5nerUQUYAWGgoz3++EoYkTtS8q5P5ZLTY/sA6pKzPP15B
         1fwwbe/VgcboAAkOzOAN1z/C7SQrD2jEc4gwrRkhWrmDZixJejOCi4tXMiyG+uGdlqgw
         Qb+oNV/9PrzuP9rBAgJ9UTdG2PgfQ/52ghK9QcFpmybiUbpOgIKKWKtTLm+pdeEVu89t
         I1ztLp2b/DMPyPaZN4bgLhPS5ca0g0qJwtbNEwPaWaGps8hm2VyJcEmXha+ReV79b+wi
         L8NA==
X-Gm-Message-State: APjAAAXkMHhmsGjsHEC6ZZdhvpvMDr/e1LC1XCe594MYdKAmc2av2SoN
        pWCgXsB32zl05yZb2t1cbxGUkw==
X-Google-Smtp-Source: APXvYqxhw2pKUAxdbWZkgFPeBFcnr+Q2DKys+vYhH7Q3g4kz280LK8KEPNj3LcHryY+PFGUyu77RhA==
X-Received: by 2002:ac8:36cc:: with SMTP id b12mr65886400qtc.193.1558433134611;
        Tue, 21 May 2019 03:05:34 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net. [173.76.105.71])
        by smtp.gmail.com with ESMTPSA id s12sm9862956qkm.38.2019.05.21.03.05.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 21 May 2019 03:05:33 -0700 (PDT)
Date:   Tue, 21 May 2019 06:05:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Question about IRQs during the .remove() of virtio-vsock driver
Message-ID: <20190521055650-mutt-send-email-mst@kernel.org>
References: <20190521094407.ltij4ggbd7xw25ge@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521094407.ltij4ggbd7xw25ge@steredhat>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 11:44:07AM +0200, Stefano Garzarella wrote:
> Hi Micheal, Jason,
> as suggested by Stefan, I'm checking if we have some races in the
> virtio-vsock driver. We found some races in the .probe() and .remove()
> with the upper layer (socket) and I'll fix it.
> 
> Now my attention is on the bottom layer (virtio device) and my question is:
> during the .remove() of virtio-vsock driver (virtio_vsock_remove), could happen
> that an IRQ comes and one of our callback (e.g. virtio_vsock_rx_done()) is
> executed, queueing new works?
> 
> I tried to follow the code in both cases (device unplugged or module removed)
> and maybe it couldn't happen because we remove it from bus's knowledge,
> but I'm not sure and your advice would be very helpful.
> 
> Thanks in advance,
> Stefano


Great question! This should be better documented: patches welcome!

Here's my understanding:


A typical removal flow works like this:

- prevent linux from sending new kick requests to device
  and flush such outstanding requests if any
  (device can still send notifications to linux)

- call
          vi->vdev->config->reset(vi->vdev);
  this will flush all device writes and interrupts.
  device will not use any more buffers.
  previously outstanding callbacks might still be active.

- Then call
          vdev->config->del_vqs(vdev);
  to flush outstanding callbacks if any.

-- 
MST
