Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF25C3BF19D
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 23:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhGGVwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhGGVwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 17:52:24 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEEAC061574;
        Wed,  7 Jul 2021 14:49:43 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x12so5407200eds.5;
        Wed, 07 Jul 2021 14:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EC7Oxd/vO2OVP/AyHel/8QwWNlF+f8KQWxcNn5v/QIg=;
        b=bf08DKO7WidCKLhtYEXmq9hkS+bWYFYTaN2cR0BuzAsUE3HZRGnbAvkhBStB/2dEOT
         zFqphAiqGKr1391YXtObX/le70QGoIHxoGX8b6L1oFQLp3DUD8dw2H0q7zPVIDZCxN1o
         0htDi3ynruDbd3ydFFJQOtYUN15LulASv3aOSAQcx5AXZ0oDRfOS03XYWM1lOe2wyjml
         99gPCEvCVPIWymioY9Fn412OkqDyHgc7/KAxtCAdfrG1LuO7NBvk9yU8XDvaAwAqCOoo
         Truv0kgDSX3eTVAv+Tfr34Ax+UHRFXTyNhRXqtpDbSxzwx6P0wgYSQpjmg1KPBhc5CzY
         o3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EC7Oxd/vO2OVP/AyHel/8QwWNlF+f8KQWxcNn5v/QIg=;
        b=tFDZLWN4u4xbUNcFhEf1yG+B8eRIXycujC2gzJJFeHcNttX73dsMcvYFLrf4ZfC8A1
         6L2niVWIPc9TSdzvHWTDdz4E9/qiGleZYEC58zTTHh4RGUcx9NVzLZqGGQdzVB31YtK8
         62uqi0qYoXlczYDnhplwRzCZzXrlYejRMSv0LU7fKAPM7aj/CEVn/0JoJR2Q2346/Ob4
         iZwjRZKhTMIcTdx/7HFzNkwtHS7suRMLgvsB1h4pA1bdyGxi71Be7EtNF+AQy9XVMRcN
         neW9FOJo2Fqp6ECcpL3L9jovTM7gADo3ITEIMt2+4ZaPZ6L3D2SAWKBItZS0Ah1b2EuX
         WiDQ==
X-Gm-Message-State: AOAM533DZTbUfsjnc2vmu0r+QwYAF65PHDqNyACb2XTDbhFppiWrt3aO
        3b7N4svtw0hEkM2e3Hils4EygZGdMXZW/PajoeY=
X-Google-Smtp-Source: ABdhPJz0LiNNZrV+3ai0Fy2+Z6dmL3EBrWrl6GZcDSdTMVXxGtN7BNLXcShNlewnvCgiI1BLrSDRypHGrz6srfGFkJo=
X-Received: by 2002:aa7:d483:: with SMTP id b3mr33423329edr.282.1625694581635;
 Wed, 07 Jul 2021 14:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com> <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <YOX6bPEL0cq8CgPG@enceladus>
In-Reply-To: <YOX6bPEL0cq8CgPG@enceladus>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 7 Jul 2021 14:49:30 -0700
Message-ID: <CAKgT0UfPFbAptXMJ4BQyeAadaxyHfkKRfeiwhrVMwafNEM_0cw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, Marcin Wojtas <mw@semihalf.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        hawk@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, mcroce@microsoft.com,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        cong.wang@bytedance.com, Kevin Hao <haokexin@gmail.com>,
        nogikh@google.com, Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 12:03 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> > > Hi, Alexander
> > >
> > > Thanks for detailed reviewing.
> > >
>
> Likewise!
> I'll have a look on the entire conversation in a few days...
>
> > > >
> > > > So this isn't going to work with the current recycling logic. The
> > > > expectation there is that we can safely unmap the entire page as soon
> > > > as the reference count is greater than 1.
> > >
> > > Yes, the expectation is changed to we can always recycle the page
> > > when the last user has dropped the refcnt that has given to it when
> > > the page is not pfmemalloced.
> > >
> > > The above expectation is based on that the last user will always
> > > call page_pool_put_full_page() in order to do the recycling or do
> > > the resource cleanup(dma unmaping..etc).
> > >
> > > As the skb_free_head() and skb_release_data() have both checked the
> > > skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> > > think we are safe for most case, the one case I am not so sure above
> > > is the rx zero copy, which seems to also bump up the refcnt before
> > > mapping the page to user space, we might need to ensure rx zero copy
> > > is not the last user of the page or if it is the last user, make sure
> > > it calls page_pool_put_full_page() too.
> >
> > Yes, but the skb->pp_recycle value is per skb, not per page. So my
> > concern is that carrying around that value can be problematic as there
> > are a number of possible cases where the pages might be
> > unintentionally recycled. All it would take is for a packet to get
> > cloned a few times and then somebody starts using pskb_expand_head and
> > you would have multiple cases, possibly simultaneously, of entities
> > trying to free the page. I just worry it opens us up to a number of
> > possible races.
>
> Maybe I missde something, but I thought the cloned SKBs would never trigger
> the recycling path, since they are protected by the atomic dataref check in
> skb_release_data(). What am I missing?

Are you talking about the head frag? So normally a clone wouldn't
cause an issue because the head isn't changed. In the case of the
head_frag we should be safe since pskb_expand_head will just kmalloc
the new head and clears head_frag so it won't trigger
page_pool_return_skb_page on the head_frag since the dataref just goes
from 2 to 1.

The problem is that pskb_expand_head memcopies the page frags over and
takes a reference on the pages. At that point you would have two skbs
both pointing to the same set of pages and each one ready to call
page_pool_return_skb_page on the pages at any time and possibly racing
with the other.

I suspect if they both called it at roughly the same time one of them
would trigger a NULL pointer dereference since they would both check
pp_magic first, and then both set pp to NULL. If run on a system where
dma_unmap_page_attrs takes a while it would be very likely to race
since pp_magic doesn't get cleared until after the page is unmapped.
