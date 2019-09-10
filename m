Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF684AE3FC
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 08:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390960AbfIJGtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 02:49:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbfIJGtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 02:49:02 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D1819C01B7E2
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 06:49:01 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id k68so19537892qkb.19
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 23:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dfiQALXz5+7KOgf5kpTvYt6Xu5cXYJTwms28arJUb+Y=;
        b=lhHr8wiuU5FMYBRlPWWQx6dAYEZjRomvUzDx4b+Yj7P6eN1Yp0hFHyQwRuHjL2E1+Q
         iEJF0cIvmy9k2M8m9PhMcRJkC9jXFAVFgmxzEGpiyj5GNh5nFuQTWobCfMqn76oOJDg/
         gch3Bl7YQM0+FTYEQMeBrlVtxgyC2t2oS4ScNCgBsKKXLq1DT02QEr6ivSgRUmUJabK/
         eH7HZBhK3pCW9uj1nUDtwbTJdKfW9dWu752eRIHvTeFy2k5z9d6QhzLWlfQA3bSB7de9
         zVjs6e01ZbocnzxRMcNU69g/xi51moirx1Lofl5odm2T/9TxJZhTw8jBflWLDwO47Ap7
         UO8Q==
X-Gm-Message-State: APjAAAUK/aKJL9LbdiweRGc2XfTG2sZ84Hxqyq2MMdwDPvpNhZ6EH0RL
        BqNVVLf5uvcbDAuzbS6uhrSa0/GydZbnFKwo/PhV/9/ldtc1aehLUgnmLOLJqDy+xKiku9VDGHD
        tjPjB7/TO/I1EXie6
X-Received: by 2002:ac8:718c:: with SMTP id w12mr27618509qto.235.1568098141169;
        Mon, 09 Sep 2019 23:49:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzv6IYVdd0f5WQVUeM0vPrOJIlCYkZC8iTVcIPS0hC3pXejSbPr3ajEFZbHAbLF59dsjfyt7g==
X-Received: by 2002:ac8:718c:: with SMTP id w12mr27618495qto.235.1568098141014;
        Mon, 09 Sep 2019 23:49:01 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id l7sm8266259qke.67.2019.09.09.23.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 23:49:00 -0700 (PDT)
Date:   Tue, 10 Sep 2019 02:48:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH untested] vhost: block speculation of translated
 descriptors
Message-ID: <20190910024814-mutt-send-email-mst@kernel.org>
References: <20190908110521.4031-1-mst@redhat.com>
 <db4d77d7-c467-935d-b4ae-1da7635e9b6b@redhat.com>
 <20190909104355-mutt-send-email-mst@kernel.org>
 <9ab48e0f-50a9-bed4-1801-73c37a7da27c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ab48e0f-50a9-bed4-1801-73c37a7da27c@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 09:52:10AM +0800, Jason Wang wrote:
> 
> On 2019/9/9 下午10:45, Michael S. Tsirkin wrote:
> > On Mon, Sep 09, 2019 at 03:19:55PM +0800, Jason Wang wrote:
> > > On 2019/9/8 下午7:05, Michael S. Tsirkin wrote:
> > > > iovec addresses coming from vhost are assumed to be
> > > > pre-validated, but in fact can be speculated to a value
> > > > out of range.
> > > > 
> > > > Userspace address are later validated with array_index_nospec so we can
> > > > be sure kernel info does not leak through these addresses, but vhost
> > > > must also not leak userspace info outside the allowed memory table to
> > > > guests.
> > > > 
> > > > Following the defence in depth principle, make sure
> > > > the address is not validated out of node range.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > >    drivers/vhost/vhost.c | 4 +++-
> > > >    1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index 5dc174ac8cac..0ee375fb7145 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -2072,7 +2072,9 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
> > > >    		size = node->size - addr + node->start;
> > > >    		_iov->iov_len = min((u64)len - s, size);
> > > >    		_iov->iov_base = (void __user *)(unsigned long)
> > > > -			(node->userspace_addr + addr - node->start);
> > > > +			(node->userspace_addr +
> > > > +			 array_index_nospec(addr - node->start,
> > > > +					    node->size));
> > > >    		s += size;
> > > >    		addr += size;
> > > >    		++ret;
> > > 
> > > I've tried this on Kaby Lake smap off metadata acceleration off using
> > > testpmd (virtio-user) + vhost_net. I don't see obvious performance
> > > difference with TX PPS.
> > > 
> > > Thanks
> > Should I push this to Linus right now then? It's a security thing so
> > maybe we better do it ASAP ... what's your opinion?
> 
> 
> Yes, you can.
> 
> Acked-by: Jason Wang <jasowang@redhat.com>


And should I include

Tested-by: Jason Wang <jasowang@redhat.com>

?

> 
> 
> > 
