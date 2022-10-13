Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E105FDC5B
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJMOWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 10:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJMOWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:22:22 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3C07CE2F
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:22:13 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id i9so1396265qvo.0
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2NGQAGAfwfgj6bQQFri3e7UvpFHJBbG66RlLh3PT3p8=;
        b=SDhA7zbv62PBaHsvPGDAgC+u2bWJOE2OO2P9PQ8O8yhfC3+O+6zOHA0pKrIUoxR0jb
         rdkdaIOIcP0Zm/LwhM9aYOF2nNRGLOCXW6KDvAxTI8GGHfmY59JXXY4vLfnHaGMnBvYm
         KPJqMc1JMbsz+TlNcGzW9lsTFb86rQ8TKR4SJ8rtNt8IG9eK3Gx2mc7rf0D0IzPdj0qj
         q94Q3OnfgWsGiDhsBjJzu33I6+YFoFGIH5067KhLkF04G3vqGwwO3xG4oVW1zsY4yO2E
         yyw4sfe4cfH5bzvYjNCPsf8dOL1soi9uAiw9XtpJ0HfB21bV+G9RFgpzYGiK9R9YarDJ
         hmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2NGQAGAfwfgj6bQQFri3e7UvpFHJBbG66RlLh3PT3p8=;
        b=LCEukuUw8drl/h5EXjznAxSCZKVHCkbQwKKaFHuHEH8sUfCLOYa7ThglN35BU5UlUl
         wkauHE+B8UqZd126QsCpEVMWnTqlR81j+o5nypDv4t6AYmqaBZXurWTgLCTZyQNkoh5M
         8f6mCoQI86cZFeZ6h9+a02w16azfzAr+xlIfL+rGbPJ97wwBZ79WvENu6gbq+PVtuQYt
         O9kD6uaKrU1Ac3I/4S0EzZEpDldM3xSrknbp7XaTRHCIRBuP46kxaiuvGyVzGjOzHuKS
         9FyjBNKocPmfiT0PxXLigkPDDukGD6nl8HkAseuVXD1eObmNcLzR0V2B6AzM7ZquOg6h
         b8mw==
X-Gm-Message-State: ACrzQf3HOYd4ZWRWfpsxxjtWyUT7u52vUs1hM3rjpJKsaXX7YiX4tywr
        P/TNoEz5BsgCXiGGshbJOVupkQ==
X-Google-Smtp-Source: AMsMyM4ejZLk6SAda6oIT4GjMyfCkdv+MKWSXy85/4wqrAIiPeVWI24lZSdclBBimgKybOfcGtq5Dw==
X-Received: by 2002:a05:6214:2a83:b0:4b1:cdc6:821d with SMTP id jr3-20020a0562142a8300b004b1cdc6821dmr160703qvb.36.1665670931825;
        Thu, 13 Oct 2022 07:22:11 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::3a61])
        by smtp.gmail.com with ESMTPSA id q4-20020a05620a2a4400b006ee74cc976esm9007413qkp.70.2022.10.13.07.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 07:22:11 -0700 (PDT)
Date:   Thu, 13 Oct 2022 10:22:10 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     =?utf-8?Q?Gra=C5=BEvydas?= Ignotas <notasas@gmail.com>,
        Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: UDP rx packet loss in a cgroup with a memory limit
Message-ID: <Y0gfEn6487fMalI9@cmpxchg.org>
References: <CANOLnON11vzvVdyJfW+QJ36siWR4-s=HJ2aRKpRy7CP=aRPoSw@mail.gmail.com>
 <CANOLnOPeOi0gxYwd5+ybdv5w=RZEh5JakJPE9xgrSL1cecZHbw@mail.gmail.com>
 <Yv0h1PFxmK7rVWpy@cmpxchg.org>
 <CALvZod5_LVkOkF+gmefnctmx+bRjykSARm2JA9eqKJx85NYBGQ@mail.gmail.com>
 <CAEA6p_BhAh6f_kAHEoEJ38nunY=c=4WqxhJQUjT+dCSAr_rm8g@mail.gmail.com>
 <CANOLnONQaHXOp1z1rNum74N2b=Ub7t5NsGHqPdHUQL4+4YYEQg@mail.gmail.com>
 <CALvZod6VaQXrs1x7ff=RRWWP+CgD0hQkTROfZ9XowQ_Zo3SO3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALvZod6VaQXrs1x7ff=RRWWP+CgD0hQkTROfZ9XowQ_Zo3SO3Q@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 09:36:34PM -0700, Shakeel Butt wrote:
> On Wed, Aug 17, 2022 at 1:12 PM Gražvydas Ignotas <notasas@gmail.com> wrote:
> >
> > On Wed, Aug 17, 2022 at 9:16 PM Wei Wang <weiwan@google.com> wrote:
> > >
> > > On Wed, Aug 17, 2022 at 10:37 AM Shakeel Butt <shakeelb@google.com> wrote:
> > > >
> > > > + Eric and netdev
> > > >
> > > > On Wed, Aug 17, 2022 at 10:13 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > > >
> > > > > This is most likely a regression caused by this patch:
> > > > >
> > > > > commit 4b1327be9fe57443295ae86fe0fcf24a18469e9f
> > > > > Author: Wei Wang <weiwan@google.com>
> > > > > Date:   Tue Aug 17 12:40:03 2021 -0700
> > > > >
> > > > >     net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
> > > > >
> > > > >     Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem(),
> > > > >     to give more control to the networking stack and enable it to change
> > > > >     memcg charging behavior. In the future, the networking stack may decide
> > > > >     to avoid oom-kills when fallbacks are more appropriate.
> > > > >
> > > > >     One behavior change in mem_cgroup_charge_skmem() by this patch is to
> > > > >     avoid force charging by default and let the caller decide when and if
> > > > >     force charging is needed through the presence or absence of
> > > > >     __GFP_NOFAIL.
> > > > >
> > > > >     Signed-off-by: Wei Wang <weiwan@google.com>
> > > > >     Reviewed-by: Shakeel Butt <shakeelb@google.com>
> > > > >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > > > >
> > > > > We never used to fail these allocations. Cgroups don't have a
> > > > > kswapd-style watermark reclaimer, so the network relied on
> > > > > force-charging and leaving reclaim to allocations that can block.
> > > > > Now it seems network packets could just fail indefinitely.
> > > > >
> > > > > The changelog is a bit terse given how drastic the behavior change
> > > > > is. Wei, Shakeel, can you fill in why this was changed? Can we revert
> > > > > this for the time being?
> > > >
> > > > Does reverting the patch fix the issue? However I don't think it will.
> > > >
> > > > Please note that we still have the force charging as before this
> > > > patch. Previously when mem_cgroup_charge_skmem() force charges, it
> > > > returns false and __sk_mem_raise_allocated takes suppress_allocation
> > > > code path. Based on some heuristics, it may allow it or it may
> > > > uncharge and return failure.
> > >
> > > The force charging logic in __sk_mem_raise_allocated only gets
> > > considered on tx path for STREAM socket. So it probably does not take
> > > effect on UDP path. And, that logic is NOT being altered in the above
> > > patch.
> > > So specifically for UDP receive path, what happens in
> > > __sk_mem_raise_allocated() BEFORE the above patch is:
> > > - mem_cgroup_charge_skmem() gets called:
> > >     - try_charge() with GFP_NOWAIT gets called and  failed
> > >     - try_charge() with __GFP_NOFAIL
> > >     - return false
> > > - goto suppress_allocation:
> > >     - mem_cgroup_uncharge_skmem() gets called
> > > - return 0 (which means failure)
> > >
> > > AFTER the above patch, what happens in __sk_mem_raise_allocated() is:
> > > - mem_cgroup_charge_skmem() gets called:
> > >     - try_charge() with GFP_NOWAIT gets called and failed
> > >     - return false
> > > - goto suppress_allocation:
> > >     - We no longer calls mem_cgroup_uncharge_skmem()
> > > - return 0
> > >
> > > So I agree with Shakeel, that this change shouldn't alter the behavior
> > > of the above call path in such a situation.
> > > But do let us know if reverting this change has any effect on your test.
> >
> > The problem is still there (the kernel wasn't compiling after revert,
> > had to adjust another seemingly unrelated callsite). It's hard to tell
> > if it's better or worse since it happens so randomly.
> >
> 
> Hello everyone, we have a better understanding why the patch pointed
> out by Johannes might have exposed this issue. See
> https://lore.kernel.org/all/20221013041833.rhifxw4gqwk4ofi2@google.com/.

Wow, that's super subtle! Nice sleuthing.

> To summarize, the old code was depending on a subtle interaction of
> force-charge and percpu charge caches which this patch removed. The
> fix I am proposing is for the network stack to be explicit of its need
> (i.e. use GFP_ATOMIC) instead of depending on a subtle behavior.

That sounds good to me.
