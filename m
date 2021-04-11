Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1F935B1D4
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 07:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbhDKFgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 01:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhDKFgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 01:36:46 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DC3C06138B
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 22:36:30 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g17so10394684edm.6
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 22:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0lwDd82fgpJThgZMHhLJnQgV6W4vkNqis2PraEjVIBw=;
        b=c4Db3epPQ7BtwNnPr8IaEN1uoC8TT4Cseg9TW2LOXl0mLgoowQzuMu0HEjnfJhWU6l
         xzrGM8hjOF8f1AvXob4ziQXk/mFjMtQD4xc7CI3foTZ4jSrKSitPBEtZsx+YmJQKz4CL
         2rxWFLJRkkr9xhYHKoO4FyXyLmIyEuT02doObAUnu5ZdTsK4/1fJ6fOIBnRyM4XwdAaO
         rwNDIsTqSR3SbA4yx+T/jvt8ShIArPdnAFni2G29Ac44P6VGKd0xcSl8weOqDXSEKsKn
         Jb+YUau5RFx4C7t8XsuqOke36WQB/kNHw24Ej3LTxaI+V9cPhxvKZv988v7Mr4mS8Nse
         hw+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0lwDd82fgpJThgZMHhLJnQgV6W4vkNqis2PraEjVIBw=;
        b=hUnpi64npxsKhQWSDV0ZSST/1xCvEAB+agnzFSoBQbEe8irLZEgtwkKs5ETBjOxv+q
         jFOI2MyCT6SXgADeBU3vZHp9KshCJpKJne+IoUCGmZyuPZNZhYbK8rGh1UA2oxbf6kkN
         VTF6ogngshvtKFgXQsQx+nVoBLuXrykEk5EUsL4CujRzvCIJqJkCtBdB9JGCwpdPtyTp
         h+TYfjX6S9nFBkrDnWxivFIkyiwzALVoNOWKqcFMQYhAy3KAlkQzm2EMpgGtvaB9yt+f
         9nPprOWpceTuvrEx58Zg5aJKim5sum25kD62g1tfQB1ygbdrla9AXCVTrSf2Q541VP+z
         4O5g==
X-Gm-Message-State: AOAM5331ne9qCHTKOXM3Oj222Y60gHWMgNb7XThv9XCXGdQBNN+xWwwL
        WL3hAQ1PU1bbeLC3GzyC+DjW2sA0N34VUY5Kbcfe
X-Google-Smtp-Source: ABdhPJz0uxSIdyrEwimFA/W6SiCsgNrH3yatdgdl47Lv/XrisxjYBLMuDcXpWpcG+4MirvvkrrYIKqyH/L4ndSeY1QQ=
X-Received: by 2002:a05:6402:6ca:: with SMTP id n10mr24284861edy.312.1618119389097;
 Sat, 10 Apr 2021 22:36:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-4-xieyongji@bytedance.com>
 <20210409121512-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210409121512-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Sun, 11 Apr 2021 13:36:18 +0800
Message-ID: <CACycT3tPWwpGBNEqiL4NPrwGZhmUtAVHUZMOdbSHzjhN-ytg_A@mail.gmail.com>
Subject: Re: Re: [PATCH v6 03/10] vhost-vdpa: protect concurrent access to
 vhost device iotlb
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 10, 2021 at 12:16 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Mar 31, 2021 at 04:05:12PM +0800, Xie Yongji wrote:
> > Use vhost_dev->mutex to protect vhost device iotlb from
> > concurrent access.
> >
> > Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>
> I could not figure out whether there's a bug there now.
> If yes when is the concurrent access triggered?
>

When userspace sends the VHOST_IOTLB_MSG_V2 message concurrently?

vhost_vdpa_chr_write_iter -> vhost_chr_write_iter ->
vhost_vdpa_process_iotlb_msg()

Thanks,
Yongji
