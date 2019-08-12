Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B8789A62
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfHLJtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:49:16 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37597 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbfHLJtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:49:15 -0400
Received: by mail-qk1-f196.google.com with SMTP id s14so6036956qkm.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 02:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TeG3wutKuFLwVY8GXTa6M+xMk4IsoY0IuBgfuWlKI8w=;
        b=KI2ianMZVMb4YKXV5zb0ULXgjnEEWgLLHPgKJdrr5EZdtiNft6ZqEYCEL3KrFabZK1
         w5IiQnzhK4sptepE8XZT0W3RPDob+UZPAWxKa1IGVSbdQ5JbXOXP08cAy48hlqFVFWi0
         8mS/sdkdFH5yn4vQSevi/G42V4FskcapxKJDLT4J05WNo0PR2chHVWpf+pBakeXfI+Bx
         G+ZNWp3o1a8EpsVoToYmGZucpMOggYPMYrbgzORGAc2FfnEM16gwzDbxmn2sdxkhNPnr
         QBjPSX8i0O9WDkGseJ6kFVXW2nUsJ+xNTlzjpku2RkbOXnuWdtmD6TmBqbZ5kl8SgQrQ
         Mggw==
X-Gm-Message-State: APjAAAXbmF4iJp+XPpsYpa7PsM4Y1NJxfQEkkHUmH+hK0FID4N52AhHd
        ZzMFnuFyp/KEJHY0pPQblexQrA==
X-Google-Smtp-Source: APXvYqxP0GkCXonLtypbly8kLbgJ4TN28n5gWEUnHayGxRExqWLocZL6kaOvmE9QUvNpukx30J3PxA==
X-Received: by 2002:a37:79c7:: with SMTP id u190mr3917170qkc.26.1565603354162;
        Mon, 12 Aug 2019 02:49:14 -0700 (PDT)
Received: from redhat.com ([147.234.38.29])
        by smtp.gmail.com with ESMTPSA id m27sm52517604qtu.31.2019.08.12.02.49.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 02:49:13 -0700 (PDT)
Date:   Mon, 12 Aug 2019 05:49:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jgg@ziepe.ca
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
Message-ID: <20190812054429-mutt-send-email-mst@kernel.org>
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
 <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 10:44:51AM +0800, Jason Wang wrote:
> 
> On 2019/8/11 上午1:52, Michael S. Tsirkin wrote:
> > On Fri, Aug 09, 2019 at 01:48:42AM -0400, Jason Wang wrote:
> > > Hi all:
> > > 
> > > This series try to fix several issues introduced by meta data
> > > accelreation series. Please review.
> > > 
> > > Changes from V4:
> > > - switch to use spinlock synchronize MMU notifier with accessors
> > > 
> > > Changes from V3:
> > > - remove the unnecessary patch
> > > 
> > > Changes from V2:
> > > - use seqlck helper to synchronize MMU notifier with vhost worker
> > > 
> > > Changes from V1:
> > > - try not use RCU to syncrhonize MMU notifier with vhost worker
> > > - set dirty pages after no readers
> > > - return -EAGAIN only when we find the range is overlapped with
> > >    metadata
> > > 
> > > Jason Wang (9):
> > >    vhost: don't set uaddr for invalid address
> > >    vhost: validate MMU notifier registration
> > >    vhost: fix vhost map leak
> > >    vhost: reset invalidate_count in vhost_set_vring_num_addr()
> > >    vhost: mark dirty pages during map uninit
> > >    vhost: don't do synchronize_rcu() in vhost_uninit_vq_maps()
> > >    vhost: do not use RCU to synchronize MMU notifier with worker
> > >    vhost: correctly set dirty pages in MMU notifiers callback
> > >    vhost: do not return -EAGAIN for non blocking invalidation too early
> > > 
> > >   drivers/vhost/vhost.c | 202 +++++++++++++++++++++++++-----------------
> > >   drivers/vhost/vhost.h |   6 +-
> > >   2 files changed, 122 insertions(+), 86 deletions(-)
> > This generally looks more solid.
> > 
> > But this amounts to a significant overhaul of the code.
> > 
> > At this point how about we revert 7f466032dc9e5a61217f22ea34b2df932786bbfc
> > for this release, and then re-apply a corrected version
> > for the next one?
> 
> 
> If possible, consider we've actually disabled the feature. How about just
> queued those patches for next release?
> 
> Thanks

Sorry if I was unclear. My idea is that
1. I revert the disabled code
2. You send a patch readding it with all the fixes squashed
3. Maybe optimizations on top right away?
4. We queue *that* for next and see what happens.

And the advantage over the patchy approach is that the current patches
are hard to review. E.g.  it's not reasonable to ask RCU guys to review
the whole of vhost for RCU usage but it's much more reasonable to ask
about a specific patch.


-- 
MST
