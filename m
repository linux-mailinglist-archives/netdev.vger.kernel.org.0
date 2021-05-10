Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC36C379603
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 19:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhEJRer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 13:34:47 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:43739 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbhEJRdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 13:33:21 -0400
Received: by mail-wm1-f41.google.com with SMTP id b19-20020a05600c06d3b029014258a636e8so9360287wmn.2;
        Mon, 10 May 2021 10:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sDZ3tRbv031oHbGpV+N1z1YYOM2AxFL8Zr1XzgZEaF0=;
        b=fdJhkhlOVr5XZgKnbKXYwsLmCQeUmuphsnogdjxXdLqtpeYBfEDoQCdXpsU4cAm+dD
         /z9mrFe7inl2avZU6L1JZvrXMx85EG3nFhpXUDexRLhJQ6R6e7T3BWIhWUfZNzU/UVIa
         RHmq7kBjGpolq0uCfROjDnXeXe1Yw3oNZhESIj9tlJbROCyqKW1dnuH5FxJspO8UFBcE
         j3JzF2WHNk0qdVHLEBFfwtgNL+q8AB1g/s5BsOmL70+ZAGhzitMylMW4XAJqd5UTNIab
         ZSW0jbHLExnZUWX2tY4znuoZJqmOJxPO1VFublL7dPX1gl4ZFJc60vJzrLAnKwiFHL3r
         xnIA==
X-Gm-Message-State: AOAM5308cB0+8GMbm+P90e9qGWkaniVzmuIlgaIEvkhB7Ermu5moudiF
        3Gg9YxyiOajiBfI0km4bJ6c=
X-Google-Smtp-Source: ABdhPJxFu3gDS5lcv8nrvtaynxqZvrYXf7iEezNiL+0bqck50k0BRsC1MnwXfrUO3ST+fBOmt4FefA==
X-Received: by 2002:a1c:7e82:: with SMTP id z124mr252113wmc.51.1620667934808;
        Mon, 10 May 2021 10:32:14 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id a126sm175639wmh.37.2021.05.10.10.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 10:32:14 -0700 (PDT)
Date:   Mon, 10 May 2021 17:32:12 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        mikelley@microsoft.com, Andres Beltran <lkmlabelt@gmail.com>
Subject: Re: [PATCH hyperv-next] Drivers: hv: vmbus: Copy packets sent by
 Hyper-V out of the ring buffer
Message-ID: <20210510173212.3atq5bihfcfb2spp@liuwe-devbox-debian-v2>
References: <20210408161439.341988-1-parri.andrea@gmail.com>
 <20210506174945.5vp72zn44uu7xkd5@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506174945.5vp72zn44uu7xkd5@liuwe-devbox-debian-v2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 05:49:45PM +0000, Wei Liu wrote:
> On Thu, Apr 08, 2021 at 06:14:39PM +0200, Andrea Parri (Microsoft) wrote:
> > From: Andres Beltran <lkmlabelt@gmail.com>
> > 
> > Pointers to ring-buffer packets sent by Hyper-V are used within the
> > guest VM. Hyper-V can send packets with erroneous values or modify
> > packet fields after they are processed by the guest. To defend
> > against these scenarios, return a copy of the incoming VMBus packet
> > after validating its length and offset fields in hv_pkt_iter_first().
> > In this way, the packet can no longer be modified by the host.
> > 
> > Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
> > Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > ---
> >  drivers/hv/channel.c              |  9 ++--
> >  drivers/hv/hv_fcopy.c             |  1 +
> >  drivers/hv/hv_kvp.c               |  1 +
> >  drivers/hv/hyperv_vmbus.h         |  2 +-
> >  drivers/hv/ring_buffer.c          | 82 ++++++++++++++++++++++++++-----
> >  drivers/net/hyperv/hyperv_net.h   |  7 +++
> >  drivers/net/hyperv/netvsc.c       |  2 +
> >  drivers/net/hyperv/rndis_filter.c |  2 +
> >  drivers/scsi/storvsc_drv.c        | 10 ++++
> >  include/linux/hyperv.h            | 48 +++++++++++++++---
> >  net/vmw_vsock/hyperv_transport.c  |  4 +-
> >  11 files changed, 143 insertions(+), 25 deletions(-)
> 
> In theory this patch needs acks from network and scsi maintainers, but
> the changes are so small and specific to Hyper-V drivers. In the
> interest of making progress, I will be picking up this patch shortly
> unless I hear objections.

Applied to hyperv-next.

Wei.
