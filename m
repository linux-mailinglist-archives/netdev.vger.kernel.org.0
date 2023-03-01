Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7846A6AF1
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 11:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCAKk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 05:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCAKk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 05:40:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565A5366AE;
        Wed,  1 Mar 2023 02:40:13 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677667211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L8EFrO2smvO54m4OlFPf+7U0da0HeQG774RYmh30c3o=;
        b=M7SlDUYsit/VCp2jlJC1/KqExpU/rj+CFSY0PS48Cxwejvif+sKZnZVVuukjK0QrfiMtsB
        YgbpdvXAm1EPL3z6R3og/8tjUvUtMtbOclgD43I67m06wCSey6DKcpQjxH2zcyLXpMS75B
        DM3AhSr49OHBVsqIhntyQWjm8PnzJJEsrXSdlKHvN2+6ynB8dQoyOXU8ozB8+rPA61VQoW
        iUT03UAyhAWuc8F6eYP1eY0fFrOHmEV6TfhW7r87t1gnj/gAWUebc9DqOyDyfQt/L42nyn
        pjvBKz0OKgNqDCHu+R6NTvHwBnYfC9UOTdZNxCQdyx+vAIbvY1zgres7hV79EA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677667211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L8EFrO2smvO54m4OlFPf+7U0da0HeQG774RYmh30c3o=;
        b=VOLoWAGOtoPHyDNtDmdYKJB/i3SbPFZw92rCbug2tlts34N2qiQzsvtU6QV8OFRmJfgSUp
        WwgbnRT/CFFw0VCA==
To:     Jakub Kicinski <kuba@kernel.org>
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
In-Reply-To: <20230228191705.3bc8bed6@kernel.org>
References: <20230228132118.978145284@linutronix.de>
 <CANn89iL2pYt2QA2sS4KkXrCSjprz9byE_p+Geom3MTNPMzfFDw@mail.gmail.com>
 <87h6v5n3su.ffs@tglx>
 <CANn89iL_ey=S=FjkhJ+mk7gabOdVag6ENKnu9GnZkcF31qOaZA@mail.gmail.com>
 <871qm9mgkb.ffs@tglx> <20230228191705.3bc8bed6@kernel.org>
Date:   Wed, 01 Mar 2023 11:40:11 +0100
Message-ID: <87sfeolppw.ffs@tglx>
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

On Tue, Feb 28 2023 at 19:17, Jakub Kicinski wrote:
> FWIW looks good to me, especially the refcount part.
> We do see 10% of jitter in microbenchmarks due to random cache
> effects, so forgive the questioning.

Yes, those things are hard to measure. 

> But again, the refcount seems like an obvious win to my noob eyes.
>
> While I have you it would be remiss of me not to mention my ksoftirq
> change which makes a large difference in production workloads:
> https://lore.kernel.org/all/20221222221244.1290833-3-kuba@kernel.org/

Let me find this again.

> Is Peter's "rework" of softirq going in for 6.3?

Not that I'm aware of. That had a few loose ends and got lost in space
AFAICT.

Thanks,

        tglx
