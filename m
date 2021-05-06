Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5048F3759B0
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 19:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbhEFRus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 13:50:48 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:42923 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbhEFRuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 13:50:46 -0400
Received: by mail-wr1-f47.google.com with SMTP id l2so6514715wrm.9;
        Thu, 06 May 2021 10:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jZ25V5gFIEZP6ukMOMeThXYzSrrigmzcHYTAxDcrK/U=;
        b=I1EK5mDmaGnPJvraVOO4uFF9dQq9tIL8q4OVfm0aAaFGRa4tmDA6HnVwZlUAYdWy/6
         WcL7+2luZAQrYOCOsABrqJUYRZcwg720obSCly2ENPdJ8rsFT9cCOR3yYiXJ7EF2xN5R
         jrlJqOLFK3Eo7D9lymwXWX+HnXrXZaf6GmpiY0jpQb4cl8OCEnKcxCglCyXSBaH+4p8h
         +NMYwfM6m+fc3FFFN9E4VhXmk9sC2zXfpx9ez1QUcbTbMHYjayrYJcbfTqNkKwQqLKtQ
         WSozBJQuXnxkkAmGnzPl0pQrT9dxG8Z+8q/n5JY4JNQpHjPfN/sj8Jl3NFRKYgHsmvuV
         s4Lw==
X-Gm-Message-State: AOAM531qzRlFDwlYmSAlqmQutJaWOz8hbn8UR6ika7rt5Aaqih3oNd31
        Hh2giWhFGgBfzqJeubiAAus=
X-Google-Smtp-Source: ABdhPJzBkXQU5DP6oTLnvIh+SGwU7/JXq8VhmyBRi8o090ybLqDZ2Blt2FLC/CgcT/I/qdZgf9IDcQ==
X-Received: by 2002:adf:d0cd:: with SMTP id z13mr6883154wrh.373.1620323387206;
        Thu, 06 May 2021 10:49:47 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id u2sm5530127wmm.5.2021.05.06.10.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 10:49:46 -0700 (PDT)
Date:   Thu, 6 May 2021 17:49:45 +0000
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
Message-ID: <20210506174945.5vp72zn44uu7xkd5@liuwe-devbox-debian-v2>
References: <20210408161439.341988-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408161439.341988-1-parri.andrea@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 06:14:39PM +0200, Andrea Parri (Microsoft) wrote:
> From: Andres Beltran <lkmlabelt@gmail.com>
> 
> Pointers to ring-buffer packets sent by Hyper-V are used within the
> guest VM. Hyper-V can send packets with erroneous values or modify
> packet fields after they are processed by the guest. To defend
> against these scenarios, return a copy of the incoming VMBus packet
> after validating its length and offset fields in hv_pkt_iter_first().
> In this way, the packet can no longer be modified by the host.
> 
> Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
> Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
>  drivers/hv/channel.c              |  9 ++--
>  drivers/hv/hv_fcopy.c             |  1 +
>  drivers/hv/hv_kvp.c               |  1 +
>  drivers/hv/hyperv_vmbus.h         |  2 +-
>  drivers/hv/ring_buffer.c          | 82 ++++++++++++++++++++++++++-----
>  drivers/net/hyperv/hyperv_net.h   |  7 +++
>  drivers/net/hyperv/netvsc.c       |  2 +
>  drivers/net/hyperv/rndis_filter.c |  2 +
>  drivers/scsi/storvsc_drv.c        | 10 ++++
>  include/linux/hyperv.h            | 48 +++++++++++++++---
>  net/vmw_vsock/hyperv_transport.c  |  4 +-
>  11 files changed, 143 insertions(+), 25 deletions(-)

In theory this patch needs acks from network and scsi maintainers, but
the changes are so small and specific to Hyper-V drivers. In the
interest of making progress, I will be picking up this patch shortly
unless I hear objections.


Wei.
