Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935EC88C8B
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 19:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfHJRwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 13:52:47 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38964 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfHJRwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 13:52:45 -0400
Received: by mail-qt1-f194.google.com with SMTP id l9so98948889qtu.6
        for <netdev@vger.kernel.org>; Sat, 10 Aug 2019 10:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=66SEGc5TGIf1NyUu+jEpEXEpotUOCLnMVCZU4G+UmoQ=;
        b=LKEFT7f1QeEOKrivVauNgdsZA2S6QsiKyn+FAWRbFmK47/qc7dx/giwkweKTIv0sqY
         rxR/u/tyeovTexXAHM+c4CkSPwGKQZmG8TK/zjFyfAJHmRALBOvcF0fmzS6zAMwbUbaC
         vsAC+ghq/gG2uGJ+z7imE/gDtDGiw3JgetFJZoRDiQmRNlckZB/gTOJgUpHYbsV+El50
         19A/RtF0QR8eF6PJ6lzWMfhWxtey2NHCvXwgIG8Q1ZVkoPU9dWhikTCuwdsiaacZh6HE
         ao22HqJ2rX+ypqXMmPUFwiYjoGBsftiHGPyGO8Gbf77o+p8aYbJI+rkwRf7ag9CYQDCl
         x2hQ==
X-Gm-Message-State: APjAAAV4O+uzYsCS+qKx2sdV2TLfsy/zL2XyUk+tpVrljV7gmkEbHjYO
        6dHrdr99yOHAJwaqGaFnKFHsn1bINY96FTBr
X-Google-Smtp-Source: APXvYqyu+J3eoZAKc/L0K7nzHrnvjWmGtHdW7l8r8vj9yQS0QK9zcmeYBT3jtDeUTZAm2K2OrM0azQ==
X-Received: by 2002:ac8:2fc8:: with SMTP id m8mr23627567qta.269.1565459564445;
        Sat, 10 Aug 2019 10:52:44 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id a135sm45568245qkg.72.2019.08.10.10.52.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 10 Aug 2019 10:52:43 -0700 (PDT)
Date:   Sat, 10 Aug 2019 13:52:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jgg@ziepe.ca
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
Message-ID: <20190810134948-mutt-send-email-mst@kernel.org>
References: <20190809054851.20118-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809054851.20118-1-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 01:48:42AM -0400, Jason Wang wrote:
> Hi all:
> 
> This series try to fix several issues introduced by meta data
> accelreation series. Please review.
> 
> Changes from V4:
> - switch to use spinlock synchronize MMU notifier with accessors
> 
> Changes from V3:
> - remove the unnecessary patch
> 
> Changes from V2:
> - use seqlck helper to synchronize MMU notifier with vhost worker
> 
> Changes from V1:
> - try not use RCU to syncrhonize MMU notifier with vhost worker
> - set dirty pages after no readers
> - return -EAGAIN only when we find the range is overlapped with
>   metadata
> 
> Jason Wang (9):
>   vhost: don't set uaddr for invalid address
>   vhost: validate MMU notifier registration
>   vhost: fix vhost map leak
>   vhost: reset invalidate_count in vhost_set_vring_num_addr()
>   vhost: mark dirty pages during map uninit
>   vhost: don't do synchronize_rcu() in vhost_uninit_vq_maps()
>   vhost: do not use RCU to synchronize MMU notifier with worker
>   vhost: correctly set dirty pages in MMU notifiers callback
>   vhost: do not return -EAGAIN for non blocking invalidation too early
> 
>  drivers/vhost/vhost.c | 202 +++++++++++++++++++++++++-----------------
>  drivers/vhost/vhost.h |   6 +-
>  2 files changed, 122 insertions(+), 86 deletions(-)

This generally looks more solid.

But this amounts to a significant overhaul of the code.

At this point how about we revert 7f466032dc9e5a61217f22ea34b2df932786bbfc
for this release, and then re-apply a corrected version
for the next one?


> -- 
> 2.18.1
