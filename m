Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D5A3DE99D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhHCJST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbhHCJSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:18:18 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349F8C061796
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 02:18:07 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hs10so26679656ejc.0
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 02:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bNa7n1tZtuJcEEYiLTNeGKslKTEJs+rtFT0YV9yNlew=;
        b=Jd+UZ5AGs0Ooq/66KM+jA4m9HwVi+MRm7XqkaGbn4V3hh5RUeGnjXO4FB7ez9GAPYi
         tgsVUEl0qxA7yF00ZHW+ZQiwCQ+LlBhQO7XW9c8IihoDB7j2kIzgHGgN0wPJWzhpaSye
         JNwP1w89B3rYkEiXk/GkfLl0DR/lZ5VVGVH+IgILe+GxDSLM0KE2pbBO9vokfAg1Y2DJ
         4RPjt/85Mviy7n69snrUtKkUS9Z6/N8O0sY0KgvcM19Hi4Hbb6ldZkvVVYKFbXNgIOAM
         fo/TUivWwXaMC+0AFsFKUL9/T5bEBtf2ZUMRUza95oSJ9q2/NCozwY/+6bIvFMxUfevT
         EO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bNa7n1tZtuJcEEYiLTNeGKslKTEJs+rtFT0YV9yNlew=;
        b=pKz0KpvvbVL9weiBozph25NDTr7koaDuQ1LRgT8xBOXrnvP6AxY4n7aArbMnC8bn/e
         d+OOrmVIXUFQfJUaU+somIzZ35Iw3gtltgGq78YIJzjIxVI+7B8apjuWXzETzlG/xV5n
         bLgUhl6ZUPCym7b7iYj8npSwKwlrBMPVbNHqxX3v/wke4jzkE8eIQU1ttroQ9VpfwMUm
         OukuZjXAe4mvlr3GRF5POggyLO1p/NHz6cYpADnDCPLH0RvhBapExupDb3F5Fn/ZqnhX
         UhMP8WPqE5T2njkD9f8N+XhzSrsqKKizBS8Nm6TV6U3zfpThhRYDsTR+JrJyNX3uo55L
         jjRA==
X-Gm-Message-State: AOAM533wpXfHnButpt0mAsk+RKsrsLfJzGdoQAp572D8nEcMnjURFP/e
        S7BQBxk6GW3ilJeIMjsVjmYlH6TWGxYpir1amEJR
X-Google-Smtp-Source: ABdhPJz+l/RWTi/cEp9hIjcvn9xzMhjrwXVoQzQni85Wf2XRf3qnbCHSQTs5k/IZl5rLuZZ4G+B/tk85r0HL53eNKZg=
X-Received: by 2002:a17:906:af77:: with SMTP id os23mr19120305ejb.427.1627982285614;
 Tue, 03 Aug 2021 02:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-8-xieyongji@bytedance.com>
 <487ed840-f417-e1b6-edb3-15f19969de51@redhat.com>
In-Reply-To: <487ed840-f417-e1b6-edb3-15f19969de51@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 3 Aug 2021 17:17:54 +0800
Message-ID: <CACycT3ujOQ84mNMEjE-H93cgVvrWeKaDcAabg7GPvMzU-rSPYw@mail.gmail.com>
Subject: Re: [PATCH v10 07/17] virtio: Don't set FAILED status bit on device
 index allocation failure
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 4:03 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/29 =E4=B8=8B=E5=8D=883:34, Xie Yongji =E5=86=99=E9=81=93=
:
> > We don't need to set FAILED status bit on device index allocation
> > failure since the device initialization hasn't been started yet.
> > This doesn't affect runtime, found in code review.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>
>
> Does it really harm?
>

Actually not. I think I can remove this patch if we don't need it.

Thanks,
Yongji
