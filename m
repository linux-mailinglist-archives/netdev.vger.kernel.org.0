Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF8039AE66
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFCWyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCWym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 18:54:42 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13254C06174A;
        Thu,  3 Jun 2021 15:52:41 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id h16so4530638pjv.2;
        Thu, 03 Jun 2021 15:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qFrqM5+WxjtGbTpbtf2w4MFDOOBEqwwFq+bBPvXL2oE=;
        b=qte3jPhFf5hcVRYLFK9ul+KSmobwyqJZw5bYZ3DN6GgS8cQbP2BLL1ABa/OXxBnHex
         WNqs9b+xX26sHbYPDUlDGJ/aKjSv1oBYchsO7XfOzcxNWsZfk2uRRbDHW+MtFK11AKUY
         HIqJTq9vtoYLmjZRU02qnCM1JsE/xP2rVU06uWygtjcTNrtAdwEYQy7omyuziicyORC+
         4EN/XKa1cZ0U/G81JhRcw3IEuNXDfJgULyVAsQgKk8Kynz6ukKgUBCKtcdx9WWZknXnF
         /qW4rz9ztTbCd8vWNgX6I9scJLvj8LNIs6jby+mwWFM94oOaZKdK9hIbbAV3dCjZAgR6
         MLtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qFrqM5+WxjtGbTpbtf2w4MFDOOBEqwwFq+bBPvXL2oE=;
        b=WWQA1Q5Qo9XIX2XLQMqyIyoerUnBdLyspqxxfsZxe8vSmZE2ZGP5rS7mOkdspdEV3I
         QEHhj62ne8aRNVkSGHCn1Sx2OjjYt2Nczgc0fpII4QNzdGIFArzdXXhTYr3XI/HbUeB3
         4hLgUN8Uku1yyIWYgYWY4Wfz/+/ZzRDmp7Ut89ZOpx/hAvYH0kOw6ayrEF3raQ6yPUaX
         TI2iX/HNgyrvhaNOJ4dFdqTam+XYFj4smyxmi/LT1RmkHa5wZpixsfwrQUBPLRU4SnRm
         lkx9/S9zxZXjQtMHfpZ4W/7u9QIq/o84oN+XpTGkBHwPKkut2BDFF+1tmOP/R3vpOOx2
         VgbA==
X-Gm-Message-State: AOAM532lpEENfECvlqlfWzwlHji45z8DMsPE9JyzBEdS8j+RxIdvEY8d
        5O0hXi4dIHe85j6XnQtB1Ll+SOiYkn2Y5g9Ycrns5m7H2LjqMg==
X-Google-Smtp-Source: ABdhPJyUs+MYN1Cx+EkDqml0t1Q5qWBEGW/ehcsor/Fiq4Q9YhDgmIHwe1CQIi0hGIfFrasGNm0XSUn9FseypY3taMQ=
X-Received: by 2002:a17:90a:7e92:: with SMTP id j18mr1596536pjl.231.1622760760605;
 Thu, 03 Jun 2021 15:52:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210531153410.93150-1-changbin.du@gmail.com> <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com> <20210602091451.kbdul6nhobilwqvi@wittgenstein>
In-Reply-To: <20210602091451.kbdul6nhobilwqvi@wittgenstein>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 3 Jun 2021 15:52:29 -0700
Message-ID: <CAM_iQpUqgeoY_mA6cazUPCWwMK6yw9SaD6DRg-Ja4r6r_zOmLg@mail.gmail.com>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 2:14 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> But the point is that ns->ops should never be accessed when that
> namespace type is disabled. Or in other words, the bug is that something
> in netns makes use of namespace features when they are disabled. If we
> handle ->ops being NULL we might be tapering over a real bug somewhere.

It is merely a protocol between fs/nsfs.c and other namespace users,
so there is certainly no right or wrong here, the only question is which
one is better.

>
> Jakub's proposal in the other mail makes sense and falls in line with
> how the rest of the netns getters are implemented. For example
> get_net_ns_fd_fd():

It does not make any sense to me. get_net_ns() merely increases
the netns refcount, which is certainly fine for init_net too, no matter
CONFIG_NET_NS is enabled or disabled. Returning EOPNOTSUPP
there is literally saying we do not support increasing init_net refcount,
which is of course false.

> struct net *get_net_ns_by_fd(int fd)
> {
>         return ERR_PTR(-EINVAL);
> }

There is a huge difference between just increasing netns refcount
and retrieving it by fd, right? I have no idea why you bring this up,
calling them getters is missing their difference.

Thanks.
