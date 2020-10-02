Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789AF280E56
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 09:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgJBH4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 03:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgJBH4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 03:56:44 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0E4C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 00:56:44 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y13so624950iow.4
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 00:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jDwFpEIvfdUGt6crCvIdEg+JF7XiM7T2tgmieF2Kyx8=;
        b=sitpXb3pv3MEvAhrTgVD8MersSwJcwaTBdDPlFy5vQs+fJ/bhInL4fpC0BYHrW1+pe
         RtaJ+a6zK4NxidkuLgofvmB3sBhHS9IgTCnDZ1B4pOofywZBIPeJnidr2p/zRsIFcg4X
         pUoGDlauNKXL6Bvvuz2SUhvxO29X5qGunZS74J50bR/CVTurNQyxq3NFbJflS7eyCk9Y
         LeEYD5WdSBtDO+h90nNS96yZablwYHsH4RJhF0Kcf3868YS6P5uqTJXHXMk1kXCkNogC
         l2nqyhYR8MfhoBot7N/8CCsOiX0oSvzbl+AvB4q60lPywdSYshOP1DnJV1rr0xkZ05kr
         UiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jDwFpEIvfdUGt6crCvIdEg+JF7XiM7T2tgmieF2Kyx8=;
        b=eJFuzfpJ1YlIniQULPs4ExHZ+L70og6NU3E2LH4+44LDfVEH9er6R+tIiyy224EASi
         J6puy9M6hqFAtI1EVEzFeC+6FoM2B5TFXuuei36p7qMamdhocN3OtTyAFL9iNVR8yXg5
         5jlwCUC0u0eTPzQWOC+niiphBK2GRiLWrfXjAjli+jtJk7dfzRsso9hyhsyzqAgdKC0p
         rVcLrYcGlt9S9T2VrgMRFiuf0g3A2FMz8C/wkJUp2jPNbFIPFes7JkPL/99cr5Jw+Jua
         2xPx/2XDIotRireyezr2L7vxC8zEQM4X+BzO7+o8MUFHGBNZ8aIdmEtEu+9oG5w3igoI
         neow==
X-Gm-Message-State: AOAM5302FHdKr6Q3aPL5bKpN2EBFO5JTP3qx8jAR1+4453cWf5KEox9w
        8sIOjpOlctbxTMwJ/LHIxMZz+NgSGSyi+9tGwLUf/w==
X-Google-Smtp-Source: ABdhPJxXui6z8+ytKiIIAE/TEIQDen2il7yv8DKof/QfSml9A7culWGJXRaH8obnpbJZsVFDn/7VPJNSZGKAgY8+R2Y=
X-Received: by 2002:a6b:3bd3:: with SMTP id i202mr1091413ioa.145.1601625403220;
 Fri, 02 Oct 2020 00:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com> <20200930130839.427eafa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iK2-Wu8HMkWiD8U3pdRbwj2tjng-4-fJ81zVw_a3R6OqQ@mail.gmail.com> <20201001132607.21bcaa17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201001132607.21bcaa17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Oct 2020 09:56:31 +0200
Message-ID: <CANn89iK30VVUggQn6-ULOhKnLxz4Ogjw8fMZxbqWiOztURdccA@mail.gmail.com>
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

On Thu, Oct 1, 2020 at 10:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 1 Oct 2020 09:52:45 +0200 Eric Dumazet wrote:

> > The unique work queue is a problem on server class platforms, with
> > NUMA placement.
> > We now have servers with NIC on different NUMA nodes.
>
> Are you saying that the wq code is less NUMA friendly than unpinned
> threads?

Yes this is what I am saying.

Using a single and shared wq wont allow you to make sure :
- work for NIC0 attached on NUMA node#0 will be using CPUS belonging to node#0
- work for NIC1 attached on NUMA node#1 will be using CPUS belonging to node#1


The only way you can tune things with a single wq is tweaking a single cpumask,
that we can change with /sys/devices/virtual/workqueue/{wqname}/cpumask
The same for the nice value with  /sys/devices/virtual/workqueue/{wqname}/nice.

In contrast, having kthreads let you tune things independently, if needed.

Even with a single NIC, you can still need isolation between queues.
We have queues dedicated to a certain kind of traffic/application.

The work queue approach would need to be able to create/delete
independent workqueues.
But we tested the workqueue with a single NIC and our results gave to
kthreads a win over the work queue.

Really, wq concept might be a nice abstraction when each work can be
running for arbitrary durations,
and arbitrary numbers of cpus, but with the NAPI model of up to 64
packets at a time, and a fixed number of queues,
we should not add the work queue overhead.
