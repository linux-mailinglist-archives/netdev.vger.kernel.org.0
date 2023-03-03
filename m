Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B0D6A9A7B
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 16:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjCCPSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 10:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjCCPS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 10:18:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A40279B3;
        Fri,  3 Mar 2023 07:18:06 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677856683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CcU93JcaAtKAHOD6IVdoeZ1f2RKzGn1KKcruphnvp7w=;
        b=g7BqBpCB+716hxEeILJaGZaDxBnhnAsabRrNHRlbBaUfp0KKIYo+92/oJ489iRtaOtOgJr
        iS3zkiieJ+2vUguEiZhgPUXE51zuos9PDudxp6LetGVaT8bzjpSNVg9ytMvWAMb0PpjbAh
        pPe+Ru4rxct5C2NuMLRuXHZvMAwR0HzTq75FgaEbnKOltpS6iN7ND72FDSMCIy8RHHqxqH
        xjFBFinifHFF4am9y02wSm0R1Ltc3WncOTTYN8Xs5DSYOhF8+I6XTQQfaNmcP98uUjw7zX
        jsHm4iZ368VM7jKiR9wJYAAS8r6OqECxabTS9M2+JJ28Uu6N1yv3c2SkLf9AuA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677856683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CcU93JcaAtKAHOD6IVdoeZ1f2RKzGn1KKcruphnvp7w=;
        b=NxPe2Ga3oUAyzc3/eVCPdoXu428DOEchTkwa0IGGXt+9UsxKOAoRor5p99PiIZ6KDj2Xkc
        Ds/2Tm1EL1tJiCBg==
To:     Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org
Cc:     jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
In-Reply-To: <87r0u6j721.ffs@tglx>
References: <20221222221244.1290833-1-kuba@kernel.org>
 <20221222221244.1290833-3-kuba@kernel.org> <87r0u6j721.ffs@tglx>
Date:   Fri, 03 Mar 2023 16:18:03 +0100
Message-ID: <87jzzxkgno.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub!

On Fri, Mar 03 2023 at 14:30, Thomas Gleixner wrote:
> On Thu, Dec 22 2022 at 14:12, Jakub Kicinski wrote:
> But without the sched_clock() changes the actual defer time depends on
> HZ and the point in time where limit is set. That means it ranges from 0
> to 1/HZ, i.e. the 2ms defer time ends up with close to 10ms on HZ=100 in
> the worst case, which perhaps explains the 8ms+ stalls you are still
> observing. Can you test with that sched_clock change applied, i.e. the
> first two commits from
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core/softirq
>
> 59be25c466d9 ("softirq: Use sched_clock() based timeout")
> bd5a5bd77009 ("softirq: Rewrite softirq processing loop")
>
> whether that makes a difference? Those two can be applied with some
> minor polishing. The rest of that series is broken by f10020c97f4c
> ("softirq: Allow early break").

WHile staring I noticed that the current jiffies based time limit
handling has the exact same problem. For HZ=100 and HZ=250
MAX_SOFTIRQ_TIME resolves to 1 jiffy. So the window is between 0 and
1/HZ. Not really useful.

Thanks,

        tglx


