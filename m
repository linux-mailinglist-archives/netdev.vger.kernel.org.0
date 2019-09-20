Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359FFB9605
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 18:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391285AbfITQxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 12:53:43 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33144 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390491AbfITQxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 12:53:43 -0400
Received: by mail-pl1-f193.google.com with SMTP id d22so2150449pls.0
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 09:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UMLYgH8/Y7t1j5nDhWGsqeK4ExfpndFIxYT+t+d6WyM=;
        b=iReR/FkvMUze2jAQeINxzqxCOcUEjRvLqZRv3WmiceKqAvhdsaLaC+WAp9dt9GKWOz
         cCzsP3TXH+7HKprhXmxdOHgqEtCWNUNj7nl5Ol/MlugPYFxaq0T8md4dg0mEsxfdaVWG
         hKSeUGXG1ePEy4RORCm5ctPqys69qlCE4EtvFhPH8kuSDS2tmA+yBTtOuX8O7pX1cv50
         vwU+laAfsL8NfeaGCvZup3ir4VgfpddcvFebNzQQ+QhgkEPiOacOyS3VZck6xXhGx9rl
         RRSNddrKm1qIS9pIZw6lHjZT+wZcJGfSqNVKigT8ieqh15H5J2UGEJdlS53SbrihzIF8
         nMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UMLYgH8/Y7t1j5nDhWGsqeK4ExfpndFIxYT+t+d6WyM=;
        b=KikPVbG0fOY3P+rUbPPsGXCDxYP5/th/2RlecQo0JUEunBhkCU1bYmmEmmQd0vUr5x
         0oJ6qxXCNAMZH36x0+t4mN6UoRMaacSHEE3dek67j/IFUzv9ipE3fQFTz7rCJJPHGAxi
         bB0u4/Jt4fwkMggdvj1sjx3uVhGniux+IXf+HPmuvr7gpnbstW9JRPqjV8A2sgCgcRP3
         jctYWfof/C54rXFOjMOEmZeuWWAoLYb5LfD6GpCv1p+LUbdZIRENLVn7W/iRybuXLmWB
         2C3QkoFa/o/bFCA0Wxc1jmLWswfJtcQ59T4jKr1xlV+Lfn0iHBsZN0kiSsXHDK3cEuJW
         oVyg==
X-Gm-Message-State: APjAAAVg4F5JTDcEPJHZJvM4+zjHwypnFlsilVQicggO9lq6oeKgMhlR
        02o7kVruvc+y32n568pzsr8zJ02SjbCSGAqvZNmUsg==
X-Google-Smtp-Source: APXvYqxjuOsuUlyYV3ahkokCpwPH1P/hD/hp1rLyVedmkQnuOyM/fvGK5PjWsaxsEQvj0X+amXeWrAt5e0uh8xcuiNM=
X-Received: by 2002:a17:902:a586:: with SMTP id az6mr18272678plb.12.1568998421287;
 Fri, 20 Sep 2019 09:53:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190919201438.2383-1-vladbu@mellanox.com> <20190919201438.2383-2-vladbu@mellanox.com>
 <CAM_iQpWREfLQX6VSqLw_xTm8WkNBZ8_adGWE5PpTnVQVDBWPvw@mail.gmail.com> <vbfv9tnzdnb.fsf@mellanox.com>
In-Reply-To: <vbfv9tnzdnb.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 20 Sep 2019 09:53:30 -0700
Message-ID: <CAM_iQpVqcjDuGvecZL56fQRQWXJrH5tUfKCUw1yuz8LFBh8+xw@mail.gmail.com>
Subject: Re: [PATCH net v2 1/3] net: sched: sch_htb: don't call qdisc_put()
 while holding tree lock
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 11:27 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Fri 20 Sep 2019 at 04:05, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > On Thu, Sep 19, 2019 at 1:14 PM Vlad Buslov <vladbu@mellanox.com> wrote:
> >> Notes:
> >>     Changes V1 -> V2:
> >>
> >>     - Extend sch API with new qdisc_put_empty() function that has same
> >>       implementation as regular qdisc_put() but skips parts that reset qdisc
> >>       and free all packet buffers from gso_skb and skb_bad_txq queues.
> >
> > I don't understand why you need a new API here, as long as qdisc_reset()
> > gets called before releasing sch tree lock, the ->reset() inside qdisc_put(),
> > after releasing sch tree lock, should be a nop, right?
>
> Yes, but I wanted to make it explicit, so anyone else looking at the
> code of those Qdiscs would know that manual reset with appropriate
> locking is required. And it didn't require much new code because
> qdisc_put() and qidsc_put_empty() just reuse same __qdisc_put(). I'll
> revert it back, if you suggest that original approach is better.

It is unnecessary for -net/-stable. And you can always add a comment
to explain this if it is not clear.

Thanks.
