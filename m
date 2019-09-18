Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F2DB6F7F
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 00:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbfIRW4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 18:56:48 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44328 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730834AbfIRW4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 18:56:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id q15so633640pll.11
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 15:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/KORqi9MvJK5DTujojrSlj9Cp7b9QjX7+k5d7WSJIeU=;
        b=NIXNsubd0M4/YmMZ4nLzujQswJVgCxwYEstBspiVVX0rkTNwUh6s0xinc+pBxdruf5
         P/0Gx7ky8PD9m3vuIVPYqNF2quPFLuGEAmjUNzkikKPKR058FZLRVBiPIobPap+iFtQw
         2vvG1oA6KwfLEUt3VRyImxG3N1reZ/2wH8veya7I1D3fQsIZCLPiWU5ZG39VnsKEf8pE
         7RTDD6Y/YpiAlNQA0M7XoBQiRMCn83tHhUCFDC6Xy/9JDUP83ie6ghuVpik9Z37KKrtg
         xpRJyBZEWTvhs8BUvpH+hZWb+BZoXENXBb9ANwMQ3poVfnmVW3U6ZTsyvF06AIjf3n1m
         njCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/KORqi9MvJK5DTujojrSlj9Cp7b9QjX7+k5d7WSJIeU=;
        b=T743l6ERU+vvNQaXrgfEkAm4R2p9hQfyuPNVsJ7tFRdHBO1d7CxPO3S+w7gLrGSvpu
         XHHJIaieVRzQpfRotSK1xRT4pxuEGLK/A5OniWVqMOtkpMROlXFPORE24wmbdmqPlMHq
         s3RKmU4Z3WOUFEQlCQTFkPabWXkCziwj117b2rkoUdPC2gDh/6VrgGLM70xN5qEjjW4/
         vpcpE9YoaASsIaRjrkFoO/tra3v7LKtQVZVBKQeqUV+zEkqL1DyvGBN46orLhArCzoc0
         8l6bDU6y8sdJMmRZn/jk0t4b3QvJhxsvwQIGn7kRSP1IGx3urFKov5D8ppEHBwxdyqbI
         Oaog==
X-Gm-Message-State: APjAAAXUMPkMFmah7H1aDN0nwUjZUFB2TjdsB52ZZ20Ps9VP9jA6w+6Y
        zj/rLnCPWbnaSG6k9PsZAFWjMNuYIhMPE1hvCYc=
X-Google-Smtp-Source: APXvYqwVQvhd9nUiMO6RxsXX/NSbDXJYGrg9Zyst/UAZRzw+IWfKlRIlBcxl4iAkD1nOoj+M1wtP9shZWYBJ/1guFHc=
X-Received: by 2002:a17:902:a5c5:: with SMTP id t5mr6426253plq.316.1568847407898;
 Wed, 18 Sep 2019 15:56:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190918073201.2320-1-vladbu@mellanox.com> <20190918073201.2320-3-vladbu@mellanox.com>
In-Reply-To: <20190918073201.2320-3-vladbu@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 18 Sep 2019 15:56:36 -0700
Message-ID: <CAM_iQpV75h9npv2TbBMoRAMf+riPqJhAY2LaiVX-mrVGaUN-Kw@mail.gmail.com>
Subject: Re: [PATCH net 2/3] net: sched: multiq: don't call qdisc_put() while
 holding tree lock
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

On Wed, Sep 18, 2019 at 12:32 AM Vlad Buslov <vladbu@mellanox.com> wrote:
> diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
> index e1087746f6a2..4cfa9a7bd29e 100644
> --- a/net/sched/sch_multiq.c
> +++ b/net/sched/sch_multiq.c
> @@ -187,18 +187,21 @@ static int multiq_tune(struct Qdisc *sch, struct nlattr *opt,
>
>         sch_tree_lock(sch);
>         q->bands = qopt->bands;
> +       sch_tree_unlock(sch);
> +
>         for (i = q->bands; i < q->max_bands; i++) {
>                 if (q->queues[i] != &noop_qdisc) {
>                         struct Qdisc *child = q->queues[i];
>
> +                       sch_tree_lock(sch);
>                         q->queues[i] = &noop_qdisc;
>                         qdisc_tree_flush_backlog(child);
> +                       sch_tree_unlock(sch);
> +
>                         qdisc_put(child);
>                 }
>         }

Repeatedly acquiring and releasing a spinlock in a loop
does not seem to be a good idea. Is it possible to save
those qdisc pointers to an array or something similar?

Thanks.
