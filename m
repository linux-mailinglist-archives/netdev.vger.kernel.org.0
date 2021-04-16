Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AB03627B6
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244851AbhDPS3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244969AbhDPS3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 14:29:17 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D647C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 11:28:52 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id n12so31115980ybf.8
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 11:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BFWYqFUm7Sz7Cjn9PN9sg28n7Pzx0VMcw0b/FIWF6Oo=;
        b=vz5TNzwG/5g3/MRXdvNDI1yaO0WwV/GBfAJP8khzAr6/oa5Tk8ms2NI2aeinbXjpaM
         a4rYPcfeAery98FIWH8e6b3xkT7HN3xxXtuv+u7g9Aa4JjnnJT2mlFrRkDFyMZh2BlGx
         iZABB13+pbqWS6nzjQ24dP5ynhoLcCLv7TFeRY1N4R5zt//KrXlif1iwFK0g6DunjWlP
         BIwkcJy8WiqZhGS5EoYhKX80yw4GHKNLqQGbQ94wq1rr8CWKCSF6fPDtrl78KS5wroQW
         UNcBPvqJPjj/HBhvYFvMl5hrJwoAb4J2DxAJFv3c1s/VJGFnGUx27uOJX3yBNzl3A357
         N/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BFWYqFUm7Sz7Cjn9PN9sg28n7Pzx0VMcw0b/FIWF6Oo=;
        b=AEbAMjF5qMVR14pzWB7VHOoK9/U6ZOdvybXWVZ1aXN4GzkxBGJqb0YJItgQg/0aIqT
         loNG+ZLUkgQcNLVjmvryLn2nMvZJJMEZtXWgc9Nvn5hg+Ub5jB4SvNIHwN70sI3dmjNU
         oBiEULdM4r1R48aij9iGUKVVbDNykweVYBLwPTYNnF/9+vhG5CjsG6UcizIrKMESAk4T
         Zc8IYZikb2MWsurmpLtnQdp6iuO6XQ+x7dzNzXRd7zYDNWureEXah5Ve/Ot3jk8bVvLO
         zgiB039t2cQAXQKZ++NKO0sooSSm4z4jxJUKVBofWq5sVzWrw5XIGuf0Tr5Cs5Lea3X/
         Ti3g==
X-Gm-Message-State: AOAM531ZPdqQSiezfDWYXX6WwzdMVjQxutgzEmKQ8g/8dZF+AhqYVuEF
        /p6+eSZjanCOznMqhk1WzRUgvb3ykMsKrBEJGfdESw==
X-Google-Smtp-Source: ABdhPJyuy1gBcS1iwsQToCLbKEK4rxINeRB7eqhXTsU+WCTBqdjMGpu2A0Xl1kiKaDYlDNRfk97L4WPRTrmCahZU4TM=
X-Received: by 2002:a5b:e90:: with SMTP id z16mr596757ybr.303.1618597731343;
 Fri, 16 Apr 2021 11:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210415173753.3404237-1-eric.dumazet@gmail.com> <20210416105735.073466b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416105735.073466b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 16 Apr 2021 20:28:40 +0200
Message-ID: <CANn89iK0QOCDyEZS2z4Z_VZSqkDWO6kcFZ+b3ah+CVyyK-5x6A@mail.gmail.com>
Subject: Re: [PATCH net-next] scm: optimize put_cmsg()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 7:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 15 Apr 2021 10:37:53 -0700 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Calling two copy_to_user() for very small regions has very high overhead.
> >
> > Switch to inlined unsafe_put_user() to save one stac/clac sequence,
> > and avoid copy_to_user().
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Soheil Hassas Yeganeh <soheil@google.com>
>
> Hi Eric!
>
> This appears to break boot on my systems.
>
> IDK how exactly, looks like systemd gets stuck waiting for nondescript
> services to start in initramfs. I have lots of debug enabled and didn't
> spot anything of note in kernel logs.
>
> I'll try to poke at this more, but LMK if you have any ideas. The
> commit looks "obviously correct" :S

Oops, my rebase went wong, sorry for that

Can you check this  patch (on top of the buggy one) ?

If that works, I'll submit a v2

diff --git a/net/core/scm.c b/net/core/scm.c
index bd96c922041d22a2f3b7ee73e4b3183316f9b616..ae3085d9aae8adb81d3bb42c8a915a205476a0ee
100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -232,7 +232,7 @@ int put_cmsg(struct msghdr * msg, int level, int
type, int len, void *data)
                if (!user_write_access_begin(cm, cmlen))
                        goto efault;

-               unsafe_put_user(len, &cm->cmsg_len, efault_end);
+               unsafe_put_user(cmlen, &cm->cmsg_len, efault_end);
                unsafe_put_user(level, &cm->cmsg_level, efault_end);
                unsafe_put_user(type, &cm->cmsg_type, efault_end);
                unsafe_copy_to_user(CMSG_USER_DATA(cm), data,
