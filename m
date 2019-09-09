Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18145ADB64
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 16:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbfIIOpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 10:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730029AbfIIOpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 10:45:15 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EFC19C057F2C
        for <netdev@vger.kernel.org>; Mon,  9 Sep 2019 14:45:14 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id k67so4565429wmf.3
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 07:45:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TIU8l9uNtqi5N363chjsQODAD8NExttwuYVEnSx0c3k=;
        b=Cygx1nlsJV8Pd0R2XqyzmUOWXDDlg1cqccoPBdXW90ceYTVzyzU9wCrfLC75J7qk/8
         0LaD1ZJEEXeIaJgyRl8EysBnhh9lyD+hvUWdQBkLWv5249Ogy8PEVQHaOwmM/gPbgJbH
         JAfEUFP//Mv89vIKu/O3n1gFmCZs8eMCbqUCmCwycA2J6dL0PFYbnmTC5c7IsQaD7Cl/
         upiovpeb5WSyYPp8lM6Uz7/YsWzPItIAQFYsCVc/6SIC4HM+Bh20+C/3BeiPpbrB/D02
         2U5XCqSFJXPLZ9k3bHzN+CTWXGqNZ6/03WRXjUKeLM2PKaXRWL2nF0BSo9pGWtfhng6I
         7Zfw==
X-Gm-Message-State: APjAAAUbtv8LwrKFEUuTR+7W9PKLwcpEG6HcHM0vqFTXLH8sip1KIOoM
        Y0q1MP89ezczVRSb6MV+VmrBCREv2sIv/s9H5KVk8cD/0T94Cv5rwx1sydXlM4Aoj6L6wT3cWX3
        PHnswY7ve9UrsVp/S
X-Received: by 2002:adf:eb4b:: with SMTP id u11mr12031964wrn.121.1568040313765;
        Mon, 09 Sep 2019 07:45:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzcqag+ERBvSjIm6CpVOwAwyVlX8Vd50VjCvuAgwQi1q8tVVx/gSm4B5gLVsG6xNkiMwg2Qkg==
X-Received: by 2002:adf:eb4b:: with SMTP id u11mr12031946wrn.121.1568040313584;
        Mon, 09 Sep 2019 07:45:13 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id y14sm26560796wrd.84.2019.09.09.07.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 07:45:12 -0700 (PDT)
Date:   Mon, 9 Sep 2019 10:45:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH untested] vhost: block speculation of translated
 descriptors
Message-ID: <20190909104355-mutt-send-email-mst@kernel.org>
References: <20190908110521.4031-1-mst@redhat.com>
 <db4d77d7-c467-935d-b4ae-1da7635e9b6b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db4d77d7-c467-935d-b4ae-1da7635e9b6b@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 03:19:55PM +0800, Jason Wang wrote:
> 
> On 2019/9/8 下午7:05, Michael S. Tsirkin wrote:
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
> > ---
> >   drivers/vhost/vhost.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 5dc174ac8cac..0ee375fb7145 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -2072,7 +2072,9 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
> >   		size = node->size - addr + node->start;
> >   		_iov->iov_len = min((u64)len - s, size);
> >   		_iov->iov_base = (void __user *)(unsigned long)
> > -			(node->userspace_addr + addr - node->start);
> > +			(node->userspace_addr +
> > +			 array_index_nospec(addr - node->start,
> > +					    node->size));
> >   		s += size;
> >   		addr += size;
> >   		++ret;
> 
> 
> I've tried this on Kaby Lake smap off metadata acceleration off using
> testpmd (virtio-user) + vhost_net. I don't see obvious performance
> difference with TX PPS.
> 
> Thanks

Should I push this to Linus right now then? It's a security thing so
maybe we better do it ASAP ... what's your opinion?

-- 
MST
