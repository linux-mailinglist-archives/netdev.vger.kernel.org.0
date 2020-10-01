Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E05F27FAA2
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbgJAHw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgJAHw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:52:58 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9689C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:52:57 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y74so5578603iof.12
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 00:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xB3ncbmkLkwfOcYMz5MYO6FEU0eVky921Z6MbEUUiuc=;
        b=j7WrSo5778UsqLWXi+R+oIFVq+nD2SqJbkD6tYZl8pQyNO5RfXd12e6Opm0ReFf7k0
         Ie8FLsP7SiLUBAYqQ3WS+Yb9ukyp1srzmnpDlbbdO7CG4ZTcrQOC74y5nE8pYQnYORL/
         NscuBVyFnzgDpAUnxa3r0hKjP3lOYdBI/tsSCqDNcZe1CUN+7jJzw8pdaG6Yy7rqBtxj
         QaAfqLrYaJr85fcW15xakRnvOdCaQIhBVJmrAD6oxK4LiXOj4FxbD8U8fWLWWCw1305O
         24BQNb4hLXlptlDezo7mD8UkN7YrawBrOZVUMZTNGO4gJL9YSczGMaKAjrHgEJkKNviZ
         K2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xB3ncbmkLkwfOcYMz5MYO6FEU0eVky921Z6MbEUUiuc=;
        b=po+3f1SYmca3VKdWGRHBIqTf0zw1OyDwy2maNS+MTE1qOBGeXg+sQhsnDQFW8EkSN4
         0dTNMwWWNIa5ZAtBgiidpQF+9YpOe16VaGlD8Hfbp8BzsjWjn9Kq2/YB1Nh8p/7Pj3tE
         WBlvwra3vSivUCvlpbm7s0ION7XWKU8i4vkufNB49npRWSyRcoTq8dVlhcj0qP9Dmt2Y
         qoyd5hn0aaGq279c3rGRmAgkIxbv5cW25bsQLXLDUIdxGU9xX3BLdYFsoS8zTQIvI0bX
         32ChZuf6bD0xctu+LfCpWLqVtDym7acRH9mQPDa5DzwQXmbbPXbnJmrjmXermKsae2we
         rQhQ==
X-Gm-Message-State: AOAM533Ncdv3IZM8cS/WoUby8gyTMVLqoXQrrignG70cAj+EbESyvLMF
        QxqETCmnv8vuXJJrJG4LP863dI+MsQPUcw/QEoK6dg==
X-Google-Smtp-Source: ABdhPJz7QnVhZYM9+rXDso3ASYy4U/R/lAHee6yOP6NzfD/yqkOBQIQXuNtxaRFy9CmyxXnNVVQp7jf6C/IvgXTr+nU=
X-Received: by 2002:a6b:3bd3:: with SMTP id i202mr4524922ioa.145.1601538776918;
 Thu, 01 Oct 2020 00:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com> <20200930130839.427eafa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200930130839.427eafa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Oct 2020 09:52:45 +0200
Message-ID: <CANn89iK2-Wu8HMkWiD8U3pdRbwj2tjng-4-fJ81zVw_a3R6OqQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 30 Sep 2020 12:21:35 -0700 Wei Wang wrote:
> > With napi poll moved to kthread, scheduler is in charge of scheduling both
> > the kthreads handling network load, and the user threads, and is able to
> > make better decisions. In the previous benchmark, if we do this and we
> > pin the kthreads processing napi poll to specific CPUs, scheduler is
> > able to schedule user threads away from these CPUs automatically.
> >
> > And the reason we prefer 1 kthread per napi, instead of 1 workqueue
> > entity per host, is that kthread is more configurable than workqueue,
> > and we could leverage existing tuning tools for threads, like taskset,
> > chrt, etc to tune scheduling class and cpu set, etc. Another reason is
> > if we eventually want to provide busy poll feature using kernel threads
> > for napi poll, kthread seems to be more suitable than workqueue.
>
> As I said in my reply to the RFC I see better performance with the
> workqueue implementation, so I would hold off until we have more
> conclusive results there, as this set adds fairly strong uAPI that
> we'll have to support for ever.


We can make incremental changes, the kthread implementation looks much
nicer to us.

The unique work queue is a problem on server class platforms, with
NUMA placement.
We now have servers with NIC on different NUMA nodes.

We can not introduce a new model that will make all workload better
without any tuning.
If you really think you can do that, think again.

Even the old ' fix'  (commit 4cd13c21b207e80ddb1144c576500098f2d5f882
"softirq: Let ksoftirqd do its job" )
had severe issues for latency sensitive jobs.

We need to be able to opt-in to threads, and let process scheduler
take decisions.
If we believe the process scheduler takes bad decision, it should be
reported to scheduler experts.

I fully support this implementation, I do not want to wait for yet
another 'work queue' model or scheduler classes.
