Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380A91F6445
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 11:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgFKJGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 05:06:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42244 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726697AbgFKJGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 05:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591866407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EMC0E2B827Ia2DQRzxKsWY/OK5Bg//cvAlofONDhk2Q=;
        b=YzptH67dW4oHQlIfgj49adW81ZiLubTWGqoIKOMtNpmeloSVnlDJoIWdLlNGEsfNH8ZzTq
        ZydGrU1yrXGgtWBKRdtxV8l/6ixKEFNyRv8QA/5Z5fTlmZXY9DhKl4OOzjJD8DHWile7f3
        RxH4Q4Eoy+JekbpsBy2oNC40h/9XB7s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-TFnDv4_hP52fa45K9z3I7Q-1; Thu, 11 Jun 2020 05:06:43 -0400
X-MC-Unique: TFnDv4_hP52fa45K9z3I7Q-1
Received: by mail-wr1-f69.google.com with SMTP id x15so939125wru.21
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 02:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EMC0E2B827Ia2DQRzxKsWY/OK5Bg//cvAlofONDhk2Q=;
        b=Teg2v3moUxcYiMMfuzc/GdK4iKDGOe9brMjtwEDaMjUbnVLG7kbaz9jeUIUlKL36Y1
         rg67RzpxSGv+B0qOikKkApCNcxlrnsLIsJaPbK/O5lrykxGF+U7fR9pyM7MIih4TyMbS
         svjkhh02cYmfRUxYmJAlCVgo/KODXOqr6bHo5v731JGknycZsHImIiv9d1MF+QX5PQu0
         tQwG8kkn/oVRAQgAkbBIfD4cw+lQLNA7FDEvzw17pNTPhIUkT3no129ZUpJm7TMzzKA4
         j3p2r4hd6V3W9yxCC4QR19EcH2Vnr1kvBTWpM5x1YCdtLIEwvC3UwWlDbrTUAKAJYiaC
         xvuw==
X-Gm-Message-State: AOAM531GIrulqyOY40aZl8cWn+B+seMYTbcyNUcy7C+YfxAzph/kWWi1
        Lq+Z54K65/8P/L0MvgA/VemKvEd2BLbvcWXKSkNwDIDw+Ino1TL4p9ShRbHHpP1/qJJhjl9B3tt
        XbKSj2mLrj1fBW0RF
X-Received: by 2002:adf:dccc:: with SMTP id x12mr8242100wrm.72.1591866401981;
        Thu, 11 Jun 2020 02:06:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjS282NzyfgjaTUCOeu+TiuTHkZ19eiBXmK6U3BwQgdXs1XxcOHzbjcay7nTvobbz5n62KJQ==
X-Received: by 2002:adf:dccc:: with SMTP id x12mr8242068wrm.72.1591866401733;
        Thu, 11 Jun 2020 02:06:41 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id y80sm3152548wmc.34.2020.06.11.02.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 02:06:40 -0700 (PDT)
Date:   Thu, 11 Jun 2020 05:06:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        eperezma@redhat.com
Subject: Re: [PATCH RFC v6 02/11] vhost: use batched get_vq_desc version
Message-ID: <20200611050416-mutt-send-email-mst@kernel.org>
References: <20200608125238.728563-1-mst@redhat.com>
 <20200608125238.728563-3-mst@redhat.com>
 <81904cc5-b662-028d-3b4a-bdfdbd2deb8c@redhat.com>
 <20200610070259-mutt-send-email-mst@kernel.org>
 <76b14132-407a-48bf-c4d5-9d0b2c700bb0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76b14132-407a-48bf-c4d5-9d0b2c700bb0@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 11:02:57AM +0800, Jason Wang wrote:
> 
> On 2020/6/10 下午7:05, Michael S. Tsirkin wrote:
> > > > +EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> > > >    /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
> > > >    void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
> > > >    {
> > > > +	unfetch_descs(vq);
> > > >    	vq->last_avail_idx -= n;
> > > So unfetch_descs() has decreased last_avail_idx.
> > > Can we fix this by letting unfetch_descs() return the number and then we can
> > > do:
> > > 
> > > int d = unfetch_descs(vq);
> > > vq->last_avail_idx -= (n > d) ? n - d: 0;
> > > 
> > > Thanks
> > That's intentional I think - we need both.
> 
> 
> Yes, but:
> 
> 
> > 
> > Unfetch_descs drops the descriptors in the cache that were
> > *not returned to caller*  through get_vq_desc.
> > 
> > vhost_discard_vq_desc drops the ones that were returned through get_vq_desc.
> > 
> > Did I miss anything?
> 
> We could count some descriptors twice, consider the case e.g we only cache
> on descriptor:
> 
> fetch_descs()
>     fetch_buf()
>         last_avail_idx++;
> 
> Then we want do discard it:
> vhost_discard_avail_buf(1)
>     unfetch_descs()
>         last_avail_idx--;
>     last_avail_idx -= 1;
> 
> Thanks


I don't think that happens. vhost_discard_avail_buf(1) is only called
after get vhost_get_avail_buf. vhost_get_avail_buf increments
first_desc.  unfetch_descs only counts from first_desc to ndescs.

If I'm wrong, could you show values of first_desc and ndescs in this
scenario?

-- 
MST

