Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BCE303084
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732075AbhAYVJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 16:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732305AbhAYVH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:07:59 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1854CC061573
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:07:18 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 30so9784260pgr.6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LA+NuW/W/4RbqTliN8bqJ8l+gil5XZP6d0C5mjRf1oU=;
        b=V0vVKXPHETMtjByibD66iqDO10LP8NsmoDG2Rg5g7py7yafNzq688Vvql46HHTDPFB
         q2RacvHexVwO2QY/7vwPgwPP/XAzpAeicj7C9Kqkm6hIBRusXc83FUCF4HKSUHVrXjVV
         Rb5EIOnSGkBmxvJmWocLtGiHJcmEJbYgNHpafmDczUSbGokp+yXqdUTwUHsGzlgiSdtn
         lcx1Tc8xFirr9W34xlKzj2PR/LqnFLl/2LLuR+DhCBZYguUjTrNczi7Ak6xT99zas4Yf
         UeSZtS7pXDdgn62/wYPFjHbI9lnkH0GLdtWOdH99dRxCtF7mU8ncOZF9+TwmMTaVxOXw
         dofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LA+NuW/W/4RbqTliN8bqJ8l+gil5XZP6d0C5mjRf1oU=;
        b=FUBdgg29ZRYZXYb7UaDsuvV3i1wnyVVzyhLDOsIChNwwDIIALZbKi0E6YSgXDE4yHp
         9RK0FzkDaJcMLnTAo24O3hQwlgP09QJ4Wd7EiHVqlQEsbZIbTfd46oBD2Bqyy+jjzkh5
         BJWwVpPltFb1CbwRiV8CXqZwNCJmkMylSqRvLZffDckIJ8xgKVqq6GzL6SUcIu8xLg/h
         qRrJdFRfVNLbRJOG6jtkzOShSrbjJaHyRqQPE14FIw+g1KapPjZ68qHMIAhy3yDiGggy
         dYG4dLV9xfjHzRIlqe/WAExjdX4/dbuf49+ubnT7TgiPfyc8sQyk2FKfbC8E3pPf6KKc
         M+Fw==
X-Gm-Message-State: AOAM530UcOasmlkhnxuXVOUXug5VdvpeWd2phC6x9PQfCG0u3luGiEFM
        4PSXGno6MuA88mABa6TBLzN9xB1zBnUDnz4u1CAa6x0H9xnEoQ==
X-Google-Smtp-Source: ABdhPJyX+RXt+OsJjOu+hdU0L48qfSosyDCr+523tQVda5WzhKyBBinPF5hcTDYqpyUAcuEQRFcnF4wytq+pkeIe8eM=
X-Received: by 2002:a63:1707:: with SMTP id x7mr2338320pgl.266.1611608837358;
 Mon, 25 Jan 2021 13:07:17 -0800 (PST)
MIME-Version: 1.0
References: <20210125195927.GA26972@chinagar-linux.qualcomm.com>
In-Reply-To: <20210125195927.GA26972@chinagar-linux.qualcomm.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 25 Jan 2021 13:07:06 -0800
Message-ID: <CAM_iQpXx=iHqSxqYwL33iozBpy6R9_ET_5j8-upPzYzP0hNVQA@mail.gmail.com>
Subject: Re: [PATCH] neighbour: Prevent a dead entry from updating gc_list
To:     Chinmay Agarwal <chinagar@codeaurora.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        sharathv@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 11:59 AM Chinmay Agarwal
<chinagar@codeaurora.org> wrote:
>
> Following race condition was detected:
> <CPU A, t0> - neigh_flush_dev() is under execution and calls neigh_mark_dead(n),
> marking the neighbour entry 'n' as dead.
>
> <CPU B, t1> - Executing: __netif_receive_skb() -> __netif_receive_skb_core()
> -> arp_rcv() -> arp_process().arp_process() calls __neigh_lookup() which takes
> a reference on neighbour entry 'n'.
>
> <CPU A, t2> - Moves further along neigh_flush_dev() and calls
> neigh_cleanup_and_release(n), but since reference count increased in t2,
> 'n' couldn't be destroyed.
>
> <CPU B, t3> - Moves further along, arp_process() and calls
> neigh_update()-> __neigh_update() -> neigh_update_gc_list(), which adds
> the neighbour entry back in gc_list(neigh_mark_dead(), removed it
> earlier in t0 from gc_list)
>
> <CPU B, t4> - arp_process() finally calls neigh_release(n), destroying
> the neighbour entry.
>
> This leads to 'n' still being part of gc_list, but the actual
> neighbour structure has been freed.
>
> The situation can be prevented from happening if we disallow a dead
> entry to have any possibility of updating gc_list. This is what the
> patch intends to achieve.
>
> Signed-off-by: Chinmay Agarwal <chinagar@codeaurora.org>

Please add a Fixes tag for bug fixes, in this case it is probably:

Fixes: 9c29a2f55ec0 ("neighbor: Fix locking order for gc_list changes")

And, make sure you run checkpatch.pl before sending out. For your
patch, it will definitely complain about the missing spaces around the
assignment "new=old;".

Thanks.
