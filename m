Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0A3618DD7
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 02:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiKDB52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 21:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiKDB51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 21:57:27 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569C024096
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 18:57:25 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id r3so4313553yba.5
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 18:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dkv9TmpYzRXxCdw8qjnv2btS0v4b+E/OUJk1nZvMH7U=;
        b=FhstQWOA5IKUavuOVMM3fySx92HRbLkmJt71VxxfTzOa8jtE7NqMfyvEQGq8Shzn7j
         vE2AdeYUoaQU+1Rukp4DR7Z46NgQC+mAVJPQ/4qryVezyTI6KSsz06SAs1ZW6f95Sx0p
         3UI6nlz5H/2WUqAvVFsdtBUKySmr3NSnSOIHSGKYFqsCF6ChYSuNSCb+yzzTryNVVJEy
         4NmRyZMoxl/zdUY+2D0415X9tvhIL7pBiJWsspFeoO1FIolNIw8gtGctHEU7aGp+Xv30
         kvQdnPgym7B/L85x5MIRz6npVKlfEUrmtKpZNjleSYkGEHQkNyoozPvN2X+RiKtjqGY3
         Z68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dkv9TmpYzRXxCdw8qjnv2btS0v4b+E/OUJk1nZvMH7U=;
        b=ulNgqGnUZyFPkfcafi4DymOrYGSlxYYCkoijT6919OcBR8Ds685QYWUayLO99UYVY3
         louvH1dR6L/rZMff8ErcZeh62uwLy4mjP3oOU/dSeBN4o5Qn11yUnIU+nJVVtRdVNG9S
         wZ/+PSMvC4RvIiI/gr1sz8zwlgGq+V17EFz26teSD9o5AhTS7W+xMwqtRIcAFMUItUdz
         l7+R3ITvMoqccvM21UicfUECLtsibOBVv2yEl0cA4U4cSaJMWwWnua6SXiGOUjDLLVht
         +9Hf0TQ4UnYu8EhfyCu/V+EjBpuvEcStwlxYJzA159mBSS6xO5HsuRC0n/SP/StIyTQQ
         8osQ==
X-Gm-Message-State: ACrzQf1GSpi281CVL5+NP5xNmnlLJzByANJzjBbXSrsw+Pznq/hQW3eE
        o2rD0j+Q5vHQ3ctbr6OJGpLpeuEQgoD/cCbWXRbhYqCIp/Q=
X-Google-Smtp-Source: AMsMyM7Zx9xsIOp5yGeGB8JhRKXt8DMUaLY8u34dlvgQ9IZWbc0rA/D9l2Z2y/hk+YSYz2EOiVRa00y2IEKZc5xsy7c=
X-Received: by 2002:a25:d64e:0:b0:6cb:7faa:af94 with SMTP id
 n75-20020a25d64e000000b006cb7faaaf94mr32690560ybg.36.1667527044265; Thu, 03
 Nov 2022 18:57:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221103090345.187989-1-chenzhongjin@huawei.com>
 <20221103165827.19428-1-kuniyu@amazon.com> <5b05c7d9-a7e3-8b32-4aa6-cd94df2858e5@huawei.com>
In-Reply-To: <5b05c7d9-a7e3-8b32-4aa6-cd94df2858e5@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Nov 2022 18:57:12 -0700
Message-ID: <CANn89iKW9JFYdZNa5VtHBSLFP0Xe9-1kw+3=Cn0hMe_YqNbfmw@mail.gmail.com>
Subject: Re: [PATCH net] net: ping6: Fix possible leaked pernet namespace in pingv6_init()
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net,
        dsahern@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lorenzo@google.com, netdev@vger.kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 6:36 PM Chen Zhongjin <chenzhongjin@huawei.com> wrote:
>
> Hi,
>
> On 2022/11/4 0:58, Kuniyuki Iwashima wrote:
> > From:   Chen Zhongjin <chenzhongjin@huawei.com>
> > Date:   Thu, 3 Nov 2022 17:03:45 +0800
> >> When IPv6 module initializing in pingv6_init(), inet6_register_protosw()
> >> is possible to fail but returns without any error cleanup.
> > The change itself looks sane, but how does it fail ?
> > It seems inet6_register_protosw() never fails for pingv6_protosw.
> > Am I missing something ?
>
> Thanks for reminding! I only injected error return value for functions
> but didn't notice the inner logic.
>
> Rechecked and find you are right that inet6_register_protosw() is safe
> for this case.
>
> Sorry for bothering, please reject this. Will check carefully next time.

This is silly and a waste of time for many of us.

If you want to send fixes for real bugs, I suggest you grab reports
from syzbot queues,
instead of 'injecting error values' from arbitrary functions.

Thanks.
