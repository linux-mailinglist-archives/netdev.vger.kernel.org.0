Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC241AB4A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 10:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239778AbhI1JAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239716AbhI1JAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 05:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 688006113E;
        Tue, 28 Sep 2021 08:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632819511;
        bh=/LGa6ol03F+gR8eOJlhzdRh431oy2qqGn62TyLrNt4o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XmMzcsw8b72SmPUyhRK65YCZ/97MG+nocrjNEEgf/A3gRa+cNudoDirffGR1pjuX4
         O+ufgxoA+7fe9PtZMGhr1KTOr7b00jc+F45hgM4lfGtgsJ1h3NXYrjHHi5P5BjOsLH
         wPNqSVKqaXpO5+PTRC+IbBjfjjgI1eOk6tqh8xybZpCu7suJFQD8o1a1noqWee89yu
         ogEXhgxxBqe5HWGi3YznACbZutfvp2CDAgyEKejH3Hxc+tjXjBAGbGXcbKxiLi9yeN
         LyG1OBYCaO9X3prvvKC0NK4Xhles1YcJST4gFf9hIiVfIjXJQqQB2G5pJuiXVYIf4B
         m5u6DWYHpbS1w==
Received: by mail-wm1-f50.google.com with SMTP id r83-20020a1c4456000000b0030cfc00ca5fso1550109wma.2;
        Tue, 28 Sep 2021 01:58:31 -0700 (PDT)
X-Gm-Message-State: AOAM533Y5m5d0mT20QAlJWeUuKGB24yAFqROwnC71P0DkWctuiPxe4/f
        sDwDoRWeW8Ofp0cEiSRBrbTTMKLcHfkPCNRVYd8=
X-Google-Smtp-Source: ABdhPJwHL7ma7ruvWe4f8FDLT+xzDkJx2IKDXRF4dh9UuUVKdUU7m0I+UeX6VB0SdiIH8EQ1osGeh6QBupnZtyRQS7Q=
X-Received: by 2002:a1c:4b0c:: with SMTP id y12mr3483320wma.35.1632819509973;
 Tue, 28 Sep 2021 01:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210927095006.868305-1-arnd@kernel.org> <bd4871e4-62e6-2cb2-26be-34bda8dcb7dd@huawei.com>
In-Reply-To: <bd4871e4-62e6-2cb2-26be-34bda8dcb7dd@huawei.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 28 Sep 2021 10:58:14 +0200
X-Gmail-Original-Message-ID: <CAK8P3a22NhkuWLvFh2+UYEcvzVOf_9m_GdLREqfCCK-+=Q9tug@mail.gmail.com>
Message-ID: <CAK8P3a22NhkuWLvFh2+UYEcvzVOf_9m_GdLREqfCCK-+=Q9tug@mail.gmail.com>
Subject: Re: [PATCH] net: hns3: fix hclge_dbg_dump_tm_pg() stack usage
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 10:34 AM huangguangbin (A)
<huangguangbin2@huawei.com> wrote:
> On 2021/9/27 17:49, Arnd Bergmann wrote: From: Arnd Bergmann <arnd@arndb.de>

> > +static int hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *buf, int len)
> > +{
> > +     int ret;
> > +     char *data_str = kcalloc(ARRAY_SIZE(tm_pg_items),
> > +                              HCLGE_DBG_DATA_STR_LEN, GFP_KERNEL);
> > +
> Hi Arnd, thanks your modification, according to linux code style, should the code be written as follow?
>
>         char *data_str;
>         int ret;
>
>         data_str = kcalloc(ARRAY_SIZE(tm_pg_items),
>                            HCLGE_DBG_DATA_STR_LEN, GFP_KERNEL);

That's actually one of the versions I tried, but I didn't really like
any of them, so
I went with the shorter version.

Sending a v2 now with that changed black.

        Arnd
