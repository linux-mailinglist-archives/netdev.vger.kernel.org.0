Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC673C1E0A
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 06:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhGIETN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 00:19:13 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33314 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhGIETM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 00:19:12 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by linux.microsoft.com (Postfix) with ESMTPSA id 334F320B7178;
        Thu,  8 Jul 2021 21:16:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 334F320B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1625804189;
        bh=7YN2MB1o16HhRHqHTGbU97I3iPMBzy7xhI6gkzcCu0w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qjAIcxU35cVdxuaBVKYVcDcj1mBtSyY9zOlFCNabzWRdVFAza31D36kjyq2xN0asx
         BLbk7kKINgI/ODL8EoYCUSiwhRcqx2eF/gZ84xHnTmbUt02zvzR+uhR3vt70KUWDo3
         1fyMoeXWCtnY16YtCDLpgiQk4TrtcsQSxIJocTrQ=
Received: by mail-pg1-f175.google.com with SMTP id y4so6188455pgl.10;
        Thu, 08 Jul 2021 21:16:29 -0700 (PDT)
X-Gm-Message-State: AOAM530bq5emnfh5NK0tUDHTJsGKy6X6rSEWLxme/9fDVaAS8EaPelVK
        xARTDDnS2eeXfFBnig+jEFtbK0r0bcK4coBjY8U=
X-Google-Smtp-Source: ABdhPJxEqRVJU+XVeFuT1F5iksrgNMytcQvQQ+sMscueXp2JkOS8ADs6kJbwyH7yOpVW8c9rUjptMqZr60ii4FYX/k8=
X-Received: by 2002:a63:fe41:: with SMTP id x1mr4010513pgj.272.1625804178026;
 Thu, 08 Jul 2021 21:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <20210702153947.7b44acdf@linux.microsoft.com> <20210706155131.GS22278@shell.armlinux.org.uk>
 <CAFnufp1hM6WRDigAsSfM94yneRhkmxBoGG7NxRUkbfTR2WQvyA@mail.gmail.com> <CAPv3WKdQ5jYtMyZuiKshXhLjcf9b+7Dm2Lt2cjE=ATDe+n9A5g@mail.gmail.com>
In-Reply-To: <CAPv3WKdQ5jYtMyZuiKshXhLjcf9b+7Dm2Lt2cjE=ATDe+n9A5g@mail.gmail.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Fri, 9 Jul 2021 06:15:42 +0200
X-Gmail-Original-Message-ID: <CAFnufp0NaPSkMQC-3ne49FL3Ak+UV0a7QoXELvVuMzBR4+GZ_g@mail.gmail.com>
Message-ID: <CAFnufp0NaPSkMQC-3ne49FL3Ak+UV0a7QoXELvVuMzBR4+GZ_g@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 0/2] add elevated refcnt support for page pool
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        feng.tang@intel.com, Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        wenxu <wenxu@ucloud.cn>, Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 6:50 PM Marcin Wojtas <mw@semihalf.com> wrote:
>
> Hi,
>
>
> =C5=9Br., 7 lip 2021 o 01:20 Matteo Croce <mcroce@linux.microsoft.com> na=
pisa=C5=82(a):
> >
> > On Tue, Jul 6, 2021 at 5:51 PM Russell King (Oracle)
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Fri, Jul 02, 2021 at 03:39:47PM +0200, Matteo Croce wrote:
> > > > On Wed, 30 Jun 2021 17:17:54 +0800
> > > > Yunsheng Lin <linyunsheng@huawei.com> wrote:
> > > >
> > > > > This patchset adds elevated refcnt support for page pool
> > > > > and enable skb's page frag recycling based on page pool
> > > > > in hns3 drvier.
> > > > >
> > > > > Yunsheng Lin (2):
> > > > >   page_pool: add page recycling support based on elevated refcnt
> > > > >   net: hns3: support skb's frag page recycling based on page pool
> > > > >
> > > > >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  79 +++++++=
-
> > > > >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   3 +
> > > > >  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   1 +
> > > > >  drivers/net/ethernet/marvell/mvneta.c              |   6 +-
> > > > >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
> > > > >  include/linux/mm_types.h                           |   2 +-
> > > > >  include/linux/skbuff.h                             |   4 +-
> > > > >  include/net/page_pool.h                            |  30 ++-
> > > > >  net/core/page_pool.c                               | 215
> > > > > +++++++++++++++++---- 9 files changed, 285 insertions(+), 57
> > > > > deletions(-)
> > > > >
> > > >
> > > > Interesting!
> > > > Unfortunately I'll not have access to my macchiatobin anytime soon,=
 can
> > > > someone test the impact, if any, on mvpp2?
> > >
> > > I'll try to test. Please let me know what kind of testing you're
> > > looking for (I haven't been following these patches, sorry.)
> > >
> >
> > A drop test or L2 routing will be enough.
> > BTW I should have the macchiatobin back on friday.
>
> I have a 10G packet generator connected to 10G ports of CN913x-DB - I
> will stress mvpp2 in l2 forwarding early next week (I'm mostly AFK
> this until Monday).
>

I managed to to a drop test on mvpp2. Maybe there is a slowdown but
it's below the measurement uncertainty.

Perf top before:

Overhead  Shared O  Symbol
   8.48%  [kernel]  [k] page_pool_put_page
   2.57%  [kernel]  [k] page_pool_refill_alloc_cache
   1.58%  [kernel]  [k] page_pool_alloc_pages
   0.75%  [kernel]  [k] page_pool_return_skb_page

after:

Overhead  Shared O  Symbol
   8.34%  [kernel]  [k] page_pool_put_page
   4.52%  [kernel]  [k] page_pool_return_skb_page
   4.42%  [kernel]  [k] page_pool_sub_bias
   3.16%  [kernel]  [k] page_pool_alloc_pages
   2.43%  [kernel]  [k] page_pool_refill_alloc_cache

Regards,
--=20
per aspera ad upstream
