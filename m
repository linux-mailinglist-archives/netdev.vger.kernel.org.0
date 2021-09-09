Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA4E40591C
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244974AbhIIOf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237928AbhIIOfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:35:13 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D8AC14D5B1
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 06:41:25 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id w17so1392443qta.9
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 06:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3/Ce6lFtyRmn2ji1Q8BwWOl/gOJcVd/BpgqxuQ7rvKA=;
        b=TivxSsiLhEvtKtA2AAj1jwDFPCKDKrqB1v55qs1/RD+Dw1rvE+vj0QzA5ynrmjGqia
         sIWv2aJTbe2H8ASLddvSJ+hs/SWhECBkJRqHddbaf6m7Z2HOKNiIKRFVNHedhALxz1hh
         xdr6thNLdUA3En6gobMtYKQ5gElpSNDGn7ltoxnc58ukif97iF/b92kYNFnAmZnU2f/Z
         sVOFCMvnucSv45M2cZsKHDMX18o0xy68XuBdOedB19jYzXrTlBg9Fj5/8D0TLqslVdvz
         JnokpIWLYfUj/yNdYG244F8vtMogFg11uXGZ9YNrtrCXT6VNw1bIxa9PZnBoCqcz04IY
         qHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3/Ce6lFtyRmn2ji1Q8BwWOl/gOJcVd/BpgqxuQ7rvKA=;
        b=JjS5DXKkm44dQteuUz404fxCefRWBGuUPTw7efRRvugxttrKcz666rSawHgamC//sl
         C6xLp31l5KKcU74r/gF1QQE0LzwbvyQ5GWnX3snwuPjJOs+fOa8De0sgz4Ujon0f3sBo
         Kas3qXPN9hO6wrvgWq2h8Vk6MrYRHjDr3mNIw5udKjRXAWVjVLxLQv0GcwHkTi611Gcn
         zR2+Xm6HBAskj0hkAu0eKMXR2vhJI7RrNE32IyYrtB0P+hd1vuI0FMqaTjUEXDU7+36l
         KFI9Ch8Fe5x0fq4IdcZjXBolbaH9GtEWEycbivX5YhxOFVs+l1NHLkq+dvwZG6GDH2d2
         +ebw==
X-Gm-Message-State: AOAM531K9NgUyhB58363nA0BzHxXHRfXez42lg+TCHSKBXuktOZpWQVZ
        I860Vt12Ab8h9gtjFn7lCf4NB5vq3Rdx+XRUk8SKrA==
X-Google-Smtp-Source: ABdhPJwxSoP3ny0xPCIt8PII7r8xrpmTJVxhFfpj7mUmRgiz/Hdq6IgyOXwaV+a6SKN3JxXj2HAFVwY0FIE97C7aa+8=
X-Received: by 2002:a05:622a:c1:: with SMTP id p1mr2840408qtw.365.1631194884386;
 Thu, 09 Sep 2021 06:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <1630238373-12912-1-git-send-email-zhenggy@chinatelecom.cn> <CADVnQykZvz3qSEm3c16cHOG66nwXnRVq5FhBT05h6Dj4dnxyiQ@mail.gmail.com>
In-Reply-To: <CADVnQykZvz3qSEm3c16cHOG66nwXnRVq5FhBT05h6Dj4dnxyiQ@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 9 Sep 2021 09:41:07 -0400
Message-ID: <CADVnQyn=5HXGwEOrXJJEq-NAxXq1HiaSUr0=bzYj+p74xOLutA@mail.gmail.com>
Subject: Re: [PATCH] net: fix tp->undo_retrans accounting in tcp_sacktag_one()
To:     zhenggy <zhenggy@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 9, 2021 at 9:38 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Thu, Sep 9, 2021 at 6:34 AM zhenggy <zhenggy@chinatelecom.cn> wrote:
> >
> > Commit a71d77e6be1e ("tcp: fix segment accounting when DSACK range covers
> > multiple segments") fix some DSACK accounting for multiple segments.
> > In tcp_sacktag_one(), we should also use the actual DSACK rang(pcount)
> > for tp->undo_retrans accounting.
> >
> > Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>

Another nit: in the commit title, rather than "net":

  net: fix tp->undo_retrans accounting in tcp_sacktag_one()

...I would suggest the more specific "tcp", which is more typical for
commits fixing tcp*.c files:

  tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

thanks,
neal
