Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADA827AA1B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgI1I76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:59:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50929 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgI1I75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 04:59:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id e17so255581wme.0;
        Mon, 28 Sep 2020 01:59:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z1pXiZu8/lbpcC5OOR1HHt+WJc9Zi03GtYctvtdplD4=;
        b=QtJN08lBetwcbva9VVuCfbu/bYexVNzn/WRCo/mDHqd/XFSGOh/vFGwOB+aNSKW98q
         uAHe6hqAfbgXL2UzxNc++8KQdBFzMrsl1FPmCZ9exIoHyyRvwwTAHeXhw/QzkoPzXcE5
         l7cK+9kX5DMup3/SBTby2HuKPm6qji0Q+NAwKCPhyNefi1Vm7HI5y2d3Zp0H3d3O5d58
         iqMXpbLN0ZQjHrpdhRY+o1TP4xGrqVEGtkOU3AY/iNne0wVWH+J4pPI+G7zsSNzjfL20
         B+w6QBy9O6z/pf7HlRjD8t+ZTRK4Suwis9iZTwHG4WaKLlP4kinhMBCvzCJ4LVfdeOFz
         I8Jw==
X-Gm-Message-State: AOAM532o6whpm+lqnLPdqZe8ILKqe2o1IvGCekdIlq7Gscf7GSN6FuHq
        J314nIfhVL4DRhAZQAzJe7o=
X-Google-Smtp-Source: ABdhPJwTUznMg4qU1PpK1jW4iQ8NBXUE7lDRIOJNIqN9idOI7XE143sfOo/KuA6ckcfJJXr8isESDg==
X-Received: by 2002:a1c:7e15:: with SMTP id z21mr528843wmc.21.1601283594850;
        Mon, 28 Sep 2020 01:59:54 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id i3sm548308wrs.4.2020.09.28.01.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 01:59:54 -0700 (PDT)
Date:   Mon, 28 Sep 2020 08:59:52 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>, will@kernel.org,
        ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org
Subject: Re: [PATCH v4 00/11] Hyper-V: Support PAGE_SIZE larger than 4K
Message-ID: <20200928085952.t5ji5rjl3h6g7zks@liuwe-devbox-debian-v2>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 11:48:06AM +0800, Boqun Feng wrote:
> This patchset add the necessary changes to support guests whose page
> size is larger than 4K. And the main architecture which we develop this
> for is ARM64 (also it's the architecture that I use to test this
> feature).
> 
> Previous version:
> v1: https://lore.kernel.org/lkml/20200721014135.84140-1-boqun.feng@gmail.com/
> v2: https://lore.kernel.org/lkml/20200902030107.33380-1-boqun.feng@gmail.com
> v3: https://lore.kernel.org/lkml/20200910143455.109293-1-boqun.feng@gmail.com/
> 
> Changes since v3:
> 
> *	Fix a bug that ringbuffer sizes are not page-aligned when
> 	PAGE_SIZE = 16k. Drop the Acked-by and Reviewed-by tags for
> 	those patches accordingly.
> 
> *	Code improvement as per suggestion from Michael Kelley.
> 
> I've done some tests with PAGE_SIZE=64k and PAGE_SIZE=16k configurations
> on ARM64 guests (with Michael's patchset[1] for ARM64 Hyper-V guest
> support), everything worked fine ;-)
> 
> Looking forwards to comments and suggestions!
> 
> Regards,
> Boqun
> 
> [1]: https://lore.kernel.org/lkml/1598287583-71762-1-git-send-email-mikelley@microsoft.com/
> 
> Boqun Feng (11):
>   Drivers: hv: vmbus: Always use HV_HYP_PAGE_SIZE for gpadl
>   Drivers: hv: vmbus: Move __vmbus_open()
>   Drivers: hv: vmbus: Introduce types of GPADL
>   Drivers: hv: Use HV_HYP_PAGE in hv_synic_enable_regs()
>   Drivers: hv: vmbus: Move virt_to_hvpfn() to hyperv header
>   hv: hyperv.h: Introduce some hvpfn helper functions
>   hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V communication
>   Input: hyperv-keyboard: Use VMBUS_RING_SIZE() for ringbuffer sizes
>   HID: hyperv: Use VMBUS_RING_SIZE() for ringbuffer sizes
>   Driver: hv: util: Use VMBUS_RING_SIZE() for ringbuffer sizes
>   scsi: storvsc: Support PAGE_SIZE larger than 4K

Series applied to hyperv-next.

I also replaced the tabs with spaces in the commit messages of patch 8
through patch 10.

Wei.
