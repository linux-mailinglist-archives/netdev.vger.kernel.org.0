Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E26E34B490
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 06:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhC0Fv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 01:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhC0Fuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 01:50:46 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1713C0613AA;
        Fri, 26 Mar 2021 22:50:46 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso3456632pjb.3;
        Fri, 26 Mar 2021 22:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j1YVF0L/sT8C7kUir3CTd5LEHGyeZEH5Pw39tlq7L5c=;
        b=pEI0qqIc1+rcyYKmCl+0Rb3Mm6GVFy3j4RW1h3oyKMht+DgRHtVcWEz3Xq0UkrjbVR
         FfNfHti48J046ucks+xjh9OeYTBRhhiz64f+MpbHgs2dZkzueH/HZbLthHTXrbav0yOe
         R3000vNQTH89cIn4BS3s5gUAGAfRYl9eRBkUh6FxQpeYwbeWxCqXD6foripu6ckKc+Qa
         UIA9cxz7kPdhIbh5GTSV4wy3RySmPjFBqMu6y8xRyXOvMrB92U28gWiUspq3OP3PoYB5
         Tpuq4Iocbl/PvJkW7OPGF0oztvBY8w7wBeHUJv7pEAOXYb9uGQm6NHUez8SkwBIN3BRe
         vyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j1YVF0L/sT8C7kUir3CTd5LEHGyeZEH5Pw39tlq7L5c=;
        b=HnKqEDqf50wXoE7GCHoDqoK/mjGrp7R+XfuEyBqo14BQg9CndRwkDJbyko6w+sAvVW
         XsoLkdw+k77e2fhG4HAOxKRCE6PrtHrQ8WhBLKQFz7/IN1L8zBpcgfZ5q8/iNCtgRq5u
         7cxm6G34jauDOigXpZrnEDBM7qjkpl4UooGh9732OHqxm4lLQp1f5z3n5OC0n4Jjjrda
         /StJ4FL4JuNHItGlQnmvOsV+xA+1XXsPQMAdtrYeqe4FQEYpAOkS70MPfIs2IIgsc3xo
         tOwE1L0NcRo/eAmXgdHox66BsOr93kAC5P+6sgKFvpKhjuE+28YHp6ugY7Fc30V7rvoj
         4xEA==
X-Gm-Message-State: AOAM532bioQ9UTKkn8VxNC4ycmg749ArVVaORS2/AtvfVycarPTsUuaN
        ysYmboUK6VLj8E5Ah+X1Bp2Tlokt/AtMV9TJU88=
X-Google-Smtp-Source: ABdhPJyAezjKUF6WKiomtHCEOmRPTYoFAlB5aai9DXbohU0o66MJXqbDlYUnlw1B9Ioj9nVrVWL9dZqVOptBHE7qXCw=
X-Received: by 2002:a17:902:c407:b029:e7:3568:9604 with SMTP id
 k7-20020a170902c407b02900e735689604mr3424013plk.31.1616824246123; Fri, 26 Mar
 2021 22:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
 <20210323003808.16074-5-xiyou.wangcong@gmail.com> <605d428fa91cd_9529c20842@john-XPS-13-9370.notmuch>
In-Reply-To: <605d428fa91cd_9529c20842@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 26 Mar 2021 22:50:35 -0700
Message-ID: <CAM_iQpUGxpmJFJGh-OXugZ6gXdvNxH8m9wUNvWLD4FCDrL-eJA@mail.gmail.com>
Subject: Re: [Patch bpf-next v6 04/12] skmsg: avoid lock_sock() in sk_psock_backlog()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 7:10 PM John Fastabend <john.fastabend@gmail.com> wrote:
> Hi Cong,
>
> I'm trying to understand if the workqueue logic will somehow prevent the
> following,
>
>   CPU0                         CPU1
>
>  work dequeue
>  sk_psock_backlog()
>     ... do backlog
>     ... also maybe sleep
>
>                                schedule_work()
>                                work_dequeue
>                                sk_psock_backlog()
>
>           <----- multiple runners -------->
>
>  work_complete
>
> It seems we could get multiple instances of sk_psock_backlog(), unless
> the max_active is set to 1 in __queue_work() which would push us through
> the WORK_STRUCT_DELAYED state. At least thats my initial read. Before
> it didn't matter because we had the sock_lock to ensure we have only a
> single runner here.
>
> I need to study the workqueue code here to be sure, but I'm thinking
> this might a problem unless we set up the workqueue correctly.
>
> Do you have any extra details on why above can't happen thanks.

Very good question!

I thought a same work callback is never executed concurrently, but
after reading the workqueue code, actually I agree with you on this, that
is, a same work callback can be executed concurrently on different CPU's.

Limiting max_active to 1 is not a solution here, as we still want to keep
different items running concurrently. Therefore, we still need a mutex here,
just to protect this scenario. I will add a psock->work_mutex inside
sk_psock_backlog().

Thanks!
