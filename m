Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564376A6664
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 04:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCADRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 22:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCADRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 22:17:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474ED37B41;
        Tue, 28 Feb 2023 19:17:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6DC56122D;
        Wed,  1 Mar 2023 03:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D35C433D2;
        Wed,  1 Mar 2023 03:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677640627;
        bh=Kd9ZzTP/IT+UqzT+MbMRvYxxm/pwIusoqLP0tgakQKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tZfW86w7zoAjyXJGoiYfQC3Q0t/s9Z/MZFdzSG6ClI8GcYhudD8GZx7SWVOVdQiIf
         GYgJuc58B09UZU6w6IvNM0VCPoq2ttQ4GpUzrsczcU3g82vtHA7mqQJ8P+z6P7IOJj
         tCG4rGRXSlLQYYVguiV0hKb6cq7G6UmXnmvmhBPaYiUv1i00xL5GfzFcb/ziZk0UWH
         tFl/OXZpo4RGTNHg5fWkmE899la+Wll92zHVCKXWd1KgxhRbPybnTA6FkJFkuSc43F
         FLy0wUs/wcje07NvxAcfzp/nZuaGgvYnpPQrQP4H+MI4DcFFieA2GXhoNKcLHNDDbb
         VKcda8gsUuUrg==
Date:   Tue, 28 Feb 2023 19:17:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [patch 0/3] net, refcount: Address dst_entry reference count
 scalability issues
Message-ID: <20230228191705.3bc8bed6@kernel.org>
In-Reply-To: <871qm9mgkb.ffs@tglx>
References: <20230228132118.978145284@linutronix.de>
        <CANn89iL2pYt2QA2sS4KkXrCSjprz9byE_p+Geom3MTNPMzfFDw@mail.gmail.com>
        <87h6v5n3su.ffs@tglx>
        <CANn89iL_ey=S=FjkhJ+mk7gabOdVag6ENKnu9GnZkcF31qOaZA@mail.gmail.com>
        <871qm9mgkb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FWIW looks good to me, especially the refcount part.
We do see 10% of jitter in microbenchmarks due to random cache
effects, so forgive the questioning. But again, the refcount seems 
like an obvious win to my noob eyes.

While I have you it would be remiss of me not to mention my ksoftirq
change which makes a large difference in production workloads:
https://lore.kernel.org/all/20221222221244.1290833-3-kuba@kernel.org/
Is Peter's "rework" of softirq going in for 6.3?

On Wed, 01 Mar 2023 02:00:20 +0100 Thomas Gleixner wrote:
> >> We looked at this because the reference count operations stood out in
> >> perf top and we analyzed it down to the false sharing _and_ the
> >> non-scalability of atomic_inc_not_zero().
> >
> > Please share your recipe and perf results.  
> 
> Sorry for being not explicit enough about this, but I was under the
> impression that explicitely mentioning memcached and memtier would be
> enough of a hint for people famiiar with this matter.

I think the disconnect may be that we are indeed familiar with 
the workloads, but these exact workloads don't hit the issue
in production (I don't work at Google but a similarly large corp).
My initial reaction was also to see if I can find the issue in prod.
Not to question but in hope that I can indeed find a repro, and make
this series an easy sell.

> Run memcached with -t $N and memtier_benchmark with -t $M and
> --ratio=1:100 on the same machine. localhost connections obviously
> amplify the problem,
> 
> Start with the defaults for $N and $M and increase them. Depending on
> your machine this will tank at some point. But even in reasonably small
> $N, $M scenarios the refcount operations and the resulting false sharing
> fallout becomes visible in perf top. At some point it becomes the
> dominating issue while the machine still has capacity...
> 
> > We must have been very lucky to not see this at Google.  
> 
> There _is_ a world outside of Google? :)
> 
> Seriously. The point is that even if you @google cannot obverse this as
> a major issue and it just gives your usecase a minimal 0.X gain, it
> still is contributing to the overall performance, no?
