Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A5AFC7B
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 14:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfIKMZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 08:25:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3143 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfIKMZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 08:25:10 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2C8223C92D
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 12:25:10 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id h9so22512011qtq.11
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 05:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hxqdd7sLD0IIJEG1yv3oLsELLYkxr9dTgSFMh9qjyAM=;
        b=Ng51dCcFA56iSS84BiA8NpjR7IZg5PqklktwZ1erf5OiVti7tAG0WfRKrfOKnxLzat
         4xcssMHu1FnPaK4tVcpWIDoZVEVrSeeh18kNP8a5m76wdfdI7jB2g2kdALr+nDVjBAiz
         xwIC9G4npsQtMqByD/iTiQAYI5j2Z267t/BPIfzNIorpawAz3gZhFgk5Oumj2WWKDiui
         AduNHwHg5confrl3WB/9fcocMpJDuZ1beBbZsymaiC5gHHXR/pqmT/EBeuzpJbjO4F/E
         /qEH2hHhv8N4g6HblLARDeHwPes5d0g4i1xUjjwT/X/d/0teqtvxIbwZA1Nzg2g2JfpN
         nL/w==
X-Gm-Message-State: APjAAAUqg61BePE13neoJTlui8RqTzNCXLdF9l4jITl9R01/iThmGvbU
        BRJOeG40FhqzIUyh4g4e58MFmI8RrUP3QppXTkCGEH8+oFXlQMNa4E0Chnv3IXh8FWwTVP7KDAl
        cx5nppnI1GpdbcHdj
X-Received: by 2002:a37:a858:: with SMTP id r85mr20448441qke.394.1568204709488;
        Wed, 11 Sep 2019 05:25:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqydIpMhvodySW7CTJrCuCWEytvXXGQbmEf5VStZ8nkcJ6t3BKc9d/kPejtfhSjav5sm2yl2eg==
X-Received: by 2002:a37:a858:: with SMTP id r85mr20448417qke.394.1568204709315;
        Wed, 11 Sep 2019 05:25:09 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id w126sm9508107qkd.68.2019.09.11.05.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 05:25:08 -0700 (PDT)
Date:   Wed, 11 Sep 2019 08:25:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] vhost: block speculation of translated descriptors
Message-ID: <20190911082236-mutt-send-email-mst@kernel.org>
References: <20190911120908.28410-1-mst@redhat.com>
 <20190911121628.GT4023@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911121628.GT4023@dhcp22.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 02:16:28PM +0200, Michal Hocko wrote:
> On Wed 11-09-19 08:10:00, Michael S. Tsirkin wrote:
> > iovec addresses coming from vhost are assumed to be
> > pre-validated, but in fact can be speculated to a value
> > out of range.
> > 
> > Userspace address are later validated with array_index_nospec so we can
> > be sure kernel info does not leak through these addresses, but vhost
> > must also not leak userspace info outside the allowed memory table to
> > guests.
> > 
> > Following the defence in depth principle, make sure
> > the address is not validated out of node range.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > Tested-by: Jason Wang <jasowang@redhat.com>
> 
> no need to mark fo stable? Other spectre fixes tend to be backported
> even when the security implications are not really clear. The risk
> should be low and better to be covered in case.

This is not really a fix - more a defence in depth thing,
quite similar to e.g.  commit b3bbfb3fb5d25776b8e3f361d2eedaabb0b496cd
x86: Introduce __uaccess_begin_nospec() and uaccess_try_nospec
in scope.

That one doesn't seem to be tagged for stable. Was it queued
there in practice?

> > ---
> > 
> > changes from v1: fix build on 32 bit
> > 
> >  drivers/vhost/vhost.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 5dc174ac8cac..34ea219936e3 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -2071,8 +2071,10 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
> >  		_iov = iov + ret;
> >  		size = node->size - addr + node->start;
> >  		_iov->iov_len = min((u64)len - s, size);
> > -		_iov->iov_base = (void __user *)(unsigned long)
> > -			(node->userspace_addr + addr - node->start);
> > +		_iov->iov_base = (void __user *)
> > +			((unsigned long)node->userspace_addr +
> > +			 array_index_nospec((unsigned long)(addr - node->start),
> > +					    node->size));
> >  		s += size;
> >  		addr += size;
> >  		++ret;
> > -- 
> > MST
> 
> -- 
> Michal Hocko
> SUSE Labs
