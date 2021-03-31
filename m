Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87E034FFFA
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 14:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhCaMJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 08:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbhCaMIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 08:08:47 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFA1C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 05:08:46 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id a143so20921351ybg.7
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 05:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C8nug5VsyKNZg83ZSmyv9nPJjmblHCXHSQ1Tit6blzA=;
        b=c0PHl1HBwqp71CQXgrPYwnVZBpDJLk0XhXXOceFSGxJ3Y9LdvN4yQz+ZlRp+qxMinB
         SapfV8bwDtZHxz0cAbuQJSH/ROpJ+5sIWMy7YrueAFQ8UsUG65f+TuPNNQKf8LEMsbYZ
         Rcz4KlQvtm7LMpH9pFHw4J6rtmSqw/JA82zmGbvKJNK9fFRZeShj3VeqXzcFpugLl1HR
         NEXyq4rt8G35y5f2W1LhertgElFdhzzC8hNgzePaeX+MwZsVC0VcG91GZdJH1qNRMHxS
         Ia132v5FTZDDXVsBap9c7nL/dvkV8C4DxpoyCY4orfiqk1Tlo1qf03zb6D3C8CPnUZrT
         JZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C8nug5VsyKNZg83ZSmyv9nPJjmblHCXHSQ1Tit6blzA=;
        b=jy6p7EOY0j2UbuGkjmgZplJm/XgnPb8eCZe9KKJ7n9OASudSNpPU4BHaV+oZJiYUve
         6xQzvv/NkkMnnsifFjii//T17BJ/QKOGyvzM4lilwHtNj+LDvj1g649GY6rgaIJpyvMP
         R2sMNZP7q2bA7RtP79JFU3DYZYx1J1hZcspO1n8+2TEB304pcQ+L/tsP/nNtVTW7fWy5
         Io+VNP/NGmMvcUp5HUZv6PkEvnuaeBmNb7nkgUVCi2KQl4pp3IqyTq0YTeF2w3Pc2mGK
         H7mGSz0rUpp+bq1iUcn0PhErwhWTJReaJU0pHWXwp/yDgbuao1n9MXDB8QLu1Fhhdu2R
         Cq5Q==
X-Gm-Message-State: AOAM531E+BARRY9/hSKVouTMapaFGDCM47jrJEY27wdIFKn/vtu5p2ee
        hruFhXvrDAGTYdvzmA6dTDP4yzdP9LVPNBQB1sEJgw==
X-Google-Smtp-Source: ABdhPJywHNXj3DxtCtUhs2pVRd0xTIo1bequBVa+Z2pak60AJPjQSVXmj7nnjzlRMPRk5jdhDSEfyiQy1utOl2nssV8=
X-Received: by 2002:a25:6a88:: with SMTP id f130mr4194043ybc.234.1617192525548;
 Wed, 31 Mar 2021 05:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210331040405-mutt-send-email-mst@kernel.org> <1617190239.1035674-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1617190239.1035674-1-xuanzhuo@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 31 Mar 2021 14:08:34 +0200
Message-ID: <CANn89iKHdMWOFtX5om_g6SHW_tC0V_G94rGvOLPdtoLxEVH19w@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, su-lifan@linux.alibaba.com,
        "dust.li" <dust.li@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 1:34 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Wed, 31 Mar 2021 04:11:12 -0400, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Mon, Mar 29, 2021 at 11:06:09AM +0200, Eric Dumazet wrote:
> > > On Mon, Mar 29, 2021 at 10:52 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > > >
> > > > On Wed, 13 Jan 2021 08:18:19 -0800, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > > > From: Eric Dumazet <edumazet@google.com>
> > > > >
> > > > > Both virtio net and napi_get_frags() allocate skbs
> > > > > with a very small skb->head
> > > > >
> > > > > While using page fragments instead of a kmalloc backed skb->head might give
> > > > > a small performance improvement in some cases, there is a huge risk of
> > > > > under estimating memory usage.
> > > > >
> > > > > For both GOOD_COPY_LEN and GRO_MAX_HEAD, we can fit at least 32 allocations
> > > > > per page (order-3 page in x86), or even 64 on PowerPC
> > > > >
> > > > > We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
> > > > > but consuming far more memory for TCP buffers than instructed in tcp_mem[2]
> > > > >
> > > > > Even if we force napi_alloc_skb() to only use order-0 pages, the issue
> > > > > would still be there on arches with PAGE_SIZE >= 32768
> > > > >
> > > > > This patch makes sure that small skb head are kmalloc backed, so that
> > > > > other objects in the slab page can be reused instead of being held as long
> > > > > as skbs are sitting in socket queues.
> > > > >
> > > > > Note that we might in the future use the sk_buff napi cache,
> > > > > instead of going through a more expensive __alloc_skb()
> > > > >
> > > > > Another idea would be to use separate page sizes depending
> > > > > on the allocated length (to never have more than 4 frags per page)
> > > > >
> > > > > I would like to thank Greg Thelen for his precious help on this matter,
> > > > > analysing crash dumps is always a time consuming task.
> > > >
> > > >
> > > > This patch causes a performance degradation of about 10% in the scenario of
> > > > virtio-net + GRO.
> > > >
> > > > For GRO, there is no way to merge skbs based on frags with this patch, only
> > > > frag_list can be used to link skbs. The problem that this cause are that compared
> > > > to the GRO package merged into the frags way, the current skb needs to call
> > > > kfree_skb_list to release each skb, resulting in performance degradation.
> > > >
> > > > virtio-net will store some data onto the linear space after receiving it. In
> > > > addition to the header, there are also some payloads, so "headlen <= offset"
> > > > fails. And skb->head_frag is failing when use kmalloc() for skb->head allocation.
> > > >
> > >
> > > Thanks for the report.
> > >
> > > There is no way we can make things both fast for existing strategies
> > > used by _insert_your_driver
> > > and malicious usages of data that can sit for seconds/minutes in socket queues.
> > >
> > > I think that if you want to gain this 10% back, you have to change
> > > virtio_net to meet optimal behavior.
> > >
> > > Normal drivers make sure to not pull payload in skb->head, only headers.
> >
> > Hmm we do have hdr_len field, but seem to ignore it on RX.
> > Jason do you see any issues with using it for the head len?
> >
>
> Why not add a struct skb_shared_info space when adding merge/big buffer?
> So that we can use build_skb to create skb. For skb with little data, we can
> copy directly to save pages.
>

This does not matter. build_skb() is a distraction here.

Ultimately, you want to receive fat GRO packets with 17 MSS per sk_buff

The patch I gave earlier will combine :

1) Advantage of having skb->head being backed by slab allocations,
   to solve the OOM issue my patch already coped with.

2)  Up to 17 page frags attached to the sk_buff, storing 17 MSS.

In the past, virtio_net had to use 2 slots in shared_info per MSS
  -One slot for the first ~200 bytes of payload
 - One slot for the last part of the MSS.

Please try my patch, so that we confirm the issue is really in page_to_skb()

Thanks
