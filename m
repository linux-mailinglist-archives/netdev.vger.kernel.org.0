Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FC65C1B0
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbfGARED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:04:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33824 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbfGAREC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:04:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so487097wmd.1
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 10:04:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ld/S+VVZs8pmZedqdnP/S9bHBpKYWy8WRk/m3Q5+2LI=;
        b=ukmYuniVHx5w29mIpq+0Myt6O7GEZsjHP4QQ1uzT/A7yPr+wCIbtBngJwLYP7WpzvL
         NFqzBC5Xd+tZMyhnPPEVX4S0WvmzyrrKc6pqCDRtniF+aohKmyxUgTYH2SsttNeGcFqf
         +PHZK+sSUSbgCXMdXnwC2w3WoP63AhE8obr4TBWnjpPRB+takZIf2CKUs7Jb/r6iodQ3
         nR/DW3j7QHqKInv0VxsMxip5RZbnsOHhIhpkH1lqnyvZAJHp0QRebZXRsOnlUoolgC/i
         HD+M31O5QABB7kO38KLDXVdYmjLZMTzFyj4hx8UfIrCLGAzvPQNC1CjOI//kXmIX5q9E
         ToGQ==
X-Gm-Message-State: APjAAAWOs5T2ZE6y+Zpym6IZKkfygp2vL936Cdb4d02aBmAScHSTyrRe
        adjxxPgVFIl0QabO8b6KPFKHyQ==
X-Google-Smtp-Source: APXvYqwBOYSxwelsum2oddoo+4pw1dZnLt7m1hYtVtolWxEgwL2beWLJsaejVTIBg02GC95ss28lWA==
X-Received: by 2002:a1c:7503:: with SMTP id o3mr183987wmc.170.1562000640687;
        Mon, 01 Jul 2019 10:04:00 -0700 (PDT)
Received: from steredhat (host21-207-dynamic.52-79-r.retail.telecomitalia.it. [79.52.207.21])
        by smtp.gmail.com with ESMTPSA id q18sm9950224wrj.65.2019.07.01.10.03.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 10:04:00 -0700 (PDT)
Date:   Mon, 1 Jul 2019 19:03:57 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 0/3] vsock/virtio: several fixes in the .probe() and
 .remove()
Message-ID: <20190701170357.jtuhy3ank7mv6izb@steredhat>
References: <20190628123659.139576-1-sgarzare@redhat.com>
 <20190701151113.GE11900@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701151113.GE11900@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 04:11:13PM +0100, Stefan Hajnoczi wrote:
> On Fri, Jun 28, 2019 at 02:36:56PM +0200, Stefano Garzarella wrote:
> > During the review of "[PATCH] vsock/virtio: Initialize core virtio vsock
> > before registering the driver", Stefan pointed out some possible issues
> > in the .probe() and .remove() callbacks of the virtio-vsock driver.
> > 
> > This series tries to solve these issues:
> > - Patch 1 adds RCU critical sections to avoid use-after-free of
> >   'the_virtio_vsock' pointer.
> > - Patch 2 stops workers before to call vdev->config->reset(vdev) to
> >   be sure that no one is accessing the device.
> > - Patch 3 moves the works flush at the end of the .remove() to avoid
> >   use-after-free of 'vsock' object.
> > 
> > v2:
> > - Patch 1: use RCU to protect 'the_virtio_vsock' pointer
> > - Patch 2: no changes
> > - Patch 3: flush works only at the end of .remove()
> > - Removed patch 4 because virtqueue_detach_unused_buf() returns all the buffers
> >   allocated.
> > 
> > v1: https://patchwork.kernel.org/cover/10964733/
> 
> This looks good to me.

Thanks for the review!

> 
> Did you run any stress tests?  For example an SMP guest constantly
> connecting and sending packets together with a script that
> hotplug/unplugs vhost-vsock-pci from the host side.

Yes, I started an SMP guest (-smp 4 -monitor tcp:127.0.0.1:1234,server,nowait)
and I run these scripts to stress the .probe()/.remove() path:

- guest
  while true; do
      cat /dev/urandom | nc-vsock -l 4321 > /dev/null &
      cat /dev/urandom | nc-vsock -l 5321 > /dev/null &
      cat /dev/urandom | nc-vsock -l 6321 > /dev/null &
      cat /dev/urandom | nc-vsock -l 7321 > /dev/null &
      wait
  done

- host
  while true; do
      cat /dev/urandom | nc-vsock 3 4321 > /dev/null &
      cat /dev/urandom | nc-vsock 3 5321 > /dev/null &
      cat /dev/urandom | nc-vsock 3 6321 > /dev/null &
      cat /dev/urandom | nc-vsock 3 7321 > /dev/null &
      sleep 2
      echo "device_del v1" | nc 127.0.0.1 1234
      sleep 1
      echo "device_add vhost-vsock-pci,id=v1,guest-cid=3" | nc 127.0.0.1 1234
      sleep 1
  done

Do you think is enough or is better to have a test more accurate?

Thanks,
Stefano
