Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414306BDE9B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjCQC1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCQC1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:27:50 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE6057D05;
        Thu, 16 Mar 2023 19:27:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id er8so3367010edb.0;
        Thu, 16 Mar 2023 19:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kkvhtLRyj3BAbvkoDEbMjYCXIZuq7CtMnGSynMvalKU=;
        b=WPRaiuMTPMr3eEAMQyt6P2lRnteV++AAhaLm4Na7nGIzRSviZMUTe50i5Txkd7MVdp
         bvZMhbnxNhhJDDqa1tRo8g/iI+xLC/TO4onjjxHJ1W5JWjKK7pWVG9Gj6PzCIQswOOVV
         NdR3sAn4IbPZa84oUGxljsd2tKgD20xoWrqkfWrZ5zxq0UMC18dlC467NkKdJUcuBKGh
         sVgZrgAMjeTv8+wjpA5hvO6KWafPUFyx0sTAynHDBR4XhRsGzW3cAiR82u4U6vEaZuUD
         pz/w1qv1ESCdLCAbNyCUMmOGWfXp2K1K3ZECvR16oMWLJ8GSVBo/P7ubXpF3gmcHY5PQ
         fEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkvhtLRyj3BAbvkoDEbMjYCXIZuq7CtMnGSynMvalKU=;
        b=0izS4r3AFrHqmkE+Qy+nn81v5uqV9l7C273DuFOPcUloKqjvnyZuX8mXo9XKkNcr37
         1EIeqiqNv5wcEr+eHOVkh+2ACjhPSYMPhDNV7Sc2hCbkR4f11jcogwzw4NSlUZ3OPdUT
         fcXCCsFdw9DRk9OZ/vIun2scrx65DLcjLuS4us98dstYbKRSljzqSXGFWcrU7BUK4IRG
         aLZEs7JvoY44/FPvNDywEbyaQRMg7P0SHNNSw8lriCZnIwdDsOUyvnkzuUoKj1lzF19d
         ge1fInOHSVPeoQaAetWQ16tGtT1UmzVhANKeBkuadGYKHze+jriuoy6lRmroqdnfRMiI
         9nIQ==
X-Gm-Message-State: AO0yUKX+lptefbhmPgxVSnMBEsprFRnkIWkbXXHU2bR5OP8+myM9uzMA
        46hxojUOHE47jNRxI24FOwukS5wjvRrHUnloAPk=
X-Google-Smtp-Source: AK7set+lNfSiCxCZdcJM+0m9dhr3FSuq+wzE7Zk8rKWtUElWalIXslzpCrDYYg2452mzl/QdEkWR+4EX1Pi4D4fBnfs=
X-Received: by 2002:a05:6402:4497:b0:4bf:5981:e5a9 with SMTP id
 er23-20020a056402449700b004bf5981e5a9mr960092edb.3.1679020067514; Thu, 16 Mar
 2023 19:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
 <20230315092041.35482-3-kerneljasonxing@gmail.com> <20230316172020.5af40fe8@kernel.org>
In-Reply-To: <20230316172020.5af40fe8@kernel.org>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 17 Mar 2023 10:27:11 +0800
Message-ID: <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 8:20=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 15 Mar 2023 17:20:41 +0800 Jason Xing wrote:
> > In our production environment, there're hundreds of machines hitting th=
e
> > old time_squeeze limit often from which we cannot tell what exactly cau=
ses
> > such issues. Hitting limits aranged from 400 to 2000 times per second,
> > Especially, when users are running on the guest OS with veth policy
> > configured, it is relatively easier to hit the limit. After several tri=
es
> > without this patch, I found it is only real time_squeeze not including
> > budget_squeeze that hinders the receive process.
>
[...]
> That is the common case, and can be understood from the napi trace

Thanks for your reply. It is commonly happening every day on many servers.

> point and probing the kernel with bpftrace. We should only add

We probably can deduce (or guess) which one causes the latency because
trace_napi_poll() only counts the budget consumed per poll.

Besides, tracing napi poll is totally ok with the testbed but not ok
with those servers with heavy load which bpftrace related tools
capturing the data from the hot path may cause some bad impact,
especially with special cards equipped, say, 100G nic card. Resorting
to legacy file softnet_stat is relatively feasible based on my limited
knowledge.

Paolo also added backlog queues into this file in 2020 (see commit:
7d58e6555870d). I believe that after this patch, there are few or no
more new data that is needed to print for the next few years.

> uAPI for statistics which must be maintained contiguously. For

In this patch, I didn't touch the old data as suggested in the
previous emails and only separated the old way of counting
@time_squeeze into two parts (time_squeeze and budget_squeeze). Using
budget_squeeze can help us profile the server and tune it more
usefully.

> investigations tracing will always be orders of magnitude more
> powerful :(


>
> On the time squeeze BTW, have you found out what the problem was?
> In workloads I've seen the time problems are often because of noise
> in how jiffies are accounted (cgroup code disables interrupts
> for long periods of time, for example, making jiffies increment
> by 2, 3 or 4 rather than by 1).

Yes ! The issue of jiffies increment troubles those servers more often
than not. For a small group of servers, budget limit is also a
problem. Sometimes we might treat guest OS differently.

Thanks,
Jason

>
> > So when we encounter some related performance issue and then get lost o=
n
> > how to tune the budget limit and time limit in net_rx_action() function=
,
> > we can separately counting both of them to avoid the confusion.
