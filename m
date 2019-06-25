Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79749556CB
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbfFYSHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:07:41 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39507 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfFYSHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:07:41 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so9881125pfe.6
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2SCahMmUfmE322selZyfgRFKgsG0o0VArNmdDLXtukE=;
        b=BiUmPIdUbd9kXQ5uaP10wlsF762W42O+KjhHcv5qynskXCZZfgxikqfgZ87Fs+bD/z
         DUAmXOKgsiwkVfTNwoPNlTMMWHdLsf0FrYf+bblELobkJkJS61xub/bPAIUuqL0LLNjm
         ZCxiuk4U/+nwuvqrKSMuJAkDMzs0XI0bXHfdB+0EqfCNccyPydGJcOR2m7ECkyg3/jFF
         UjvUVtGsQnKW3PHUtXHP+eaFZa9NXSHERQqobAhi9qpjRrz/s1Ns4np7yJaMW9Ebm3F8
         tHjigC8Mmdsd3y6NJklvgk/fl7o88lWfpbqL6mfLbnH5kbw1G8tuxgtY+F4CHkfCxuO+
         23Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2SCahMmUfmE322selZyfgRFKgsG0o0VArNmdDLXtukE=;
        b=aAJOlMqPMGdKDZ8rToVXGPqxRU3JRZkFq1nUGSMUh3ICicPITdQ4maZxmYs3ieuQ3l
         BAmoPWRBKSu6mA6bT+K4Edtog32ABZmwQtOM6TWvBwU+7mFn+XZqiEnjryGE34i6/M8p
         wYu2EIzFxd6TCxv7CokcVnzFpV+RLKpVcOYZivuQbaEm8MG7S23AlKNxNmojwcfBHUMZ
         Qmw2RHFauRLcgxh5LHM8D0DGs/qFxCKBpSi86UsCzIcztvyBbfhprSTAf2+bmQ5UzLK/
         dHWYWZ5luhAQfz+4k4MHnNV6abzrd6yhXIt4Kq1azCDoUOvBLXIarf57PRpgo5M9AwFu
         LzLw==
X-Gm-Message-State: APjAAAUMB3mY8fwNcaqL/S11swGAN0uZwqRjaFMfPr7PhlZIZu5fu3u2
        hplzQIFS3EQ+ORzH2GB3JyvKFIvH7FxLz3IvZck=
X-Google-Smtp-Source: APXvYqwumNRdio6g/Pjozm1Ndjs1gGBkke8JFqsYB789jYAt6z9lOs4yJCtnJXtjedCMpa1/E6XBK3DLoyUv4q7zb60=
X-Received: by 2002:a63:fa4e:: with SMTP id g14mr40096265pgk.237.1561486060511;
 Tue, 25 Jun 2019 11:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
 <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com>
 <53b8c3118900b31536594e98952640c03a4456e0.camel@redhat.com>
 <CAM_iQpVVMBUdhv3o=doLhpWxee91zUPKjAOtUwryUEj0pfowdg@mail.gmail.com> <6650f0da68982ffa5bb71a773c5a3d588bd972c4.camel@redhat.com>
In-Reply-To: <6650f0da68982ffa5bb71a773c5a3d588bd972c4.camel@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 25 Jun 2019 11:07:28 -0700
Message-ID: <CAM_iQpW_-e+duPqKVXSDn7fp3WOKfs+RgVkFkfeQJQUTP_0x1Q@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Jun 25, 2019 at 8:47 AM Davide Caratti <dcaratti@redhat.com> wrote:
> hello Cong,
>
> I tested the above patch, but I still see the infinite loop on kernel
> 5.2.0-0.rc5.git0.1.fc31.i686 .
>
> idr_get_next_ul() returns the entry in the radix tree which is greater or
> equal to '*nextid' (which has the same value as 'id' in the above hunk).
> So, when the radix tree contains one slot with index equal to ULONG_MAX,
> whatever can be the value of 'id', the condition in that if() will always
> be false (and the function will keep  returning non-NULL, hence the
> infinite loop).
>
> I also tried this:
>
> if (iter.index == id && id == ULONG_MAX) {
>         return NULL;
> }
>
> it fixes the infinite loop, but it clearly breaks the function semantic
> (and anyway, it's not sufficient to fix my test, at least with cls_flower
> it still dumps the entry with id 0xffffffff several times).  I'm for
> fixing the callers of idr_get_next_ul(), and in details:

It now becomes more interesting.

On one hand, its callers should not need to worry about details
like overflow. On the other hand, in fact it does exactly what its
callers tell it to do, the problematic part is actually the
incremented id. On 64bit, it is fairly easy, we can just simply
know 'long' is longer than 32bit and leverage this to detect overflow,
but on 32bit this clearly doesn't work.

Let me think about it.

Thanks.
