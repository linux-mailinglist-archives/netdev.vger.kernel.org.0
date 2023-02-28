Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF2D6A6143
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 22:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjB1Vbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 16:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjB1Vbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 16:31:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D240D31E17;
        Tue, 28 Feb 2023 13:31:42 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677619901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XULtfbjBIz1FOvEFn9iDb0SfXe5T/4fLkxxvSGAFW0M=;
        b=tic/nKZ149irgSP9iKVwHFJbfKbDi1D3UVaBOOE5QP9GTFjHwjR4I22PZtg+dMHF+LxcSf
        OIfzB61ntCyQoFy8Y70esCCND+3tmhntLmjFkaaNjUq7i2a4MuMwT/6QnOoxQ1lgGiqcZv
        Z4LZQDIRaskUEC6ttIFYLr6sP0TXdCN5RAqKN10kDbeLODrGk6S9hesy/dMfYrOimHJet1
        8Am2Bf3MCx7A9c4X9lFep+YfNU3O/a33UbnXEF7T4m69hPvWglbMVCF0RWJza2kew5APOS
        XHZp5rQ+vlsCINlAofqxvD6ZD0fmwTSGaFY2dK8MYz8PUZIR2Jc4wk4CSmkIuA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677619901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XULtfbjBIz1FOvEFn9iDb0SfXe5T/4fLkxxvSGAFW0M=;
        b=FM2gRf0I7HrFgzvT8zYbO5Zsn1H8mTbWPNmrKRvIQhH6Id5COoNLHZ8v/28GX5CW0M3aRQ
        bcbZ7I26FKTlodBw==
To:     Eric Dumazet <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [patch 1/3] net: dst: Prevent false sharing vs.
 dst_entry::__refcnt
In-Reply-To: <CANn89iKM6yMP2Doy0MuCrfX1LASPFt_OnpPY-aNg+hu=F3W7AA@mail.gmail.com>
References: <20230228132118.978145284@linutronix.de>
 <20230228132910.934296889@linutronix.de>
 <CANn89iKM6yMP2Doy0MuCrfX1LASPFt_OnpPY-aNg+hu=F3W7AA@mail.gmail.com>
Date:   Tue, 28 Feb 2023 22:31:40 +0100
Message-ID: <875yblmq83.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric!

On Tue, Feb 28 2023 at 16:17, Eric Dumazet wrote:
> On Tue, Feb 28, 2023 at 3:33=E2=80=AFPM Thomas Gleixner <tglx@linutronix.=
de> wrote:
>> perf top identified two affected read accesses. dst_entry::lwtstate and
>> rtable::rt_genid.
>>
>> dst_entry:__refcnt is located at offset 64 of dst_entry, which puts it i=
nto
>> a seperate cacheline vs. the read mostly members located at the beginning
>> of the struct.
>
> This will probably increase struct rt6_info past the 4 cache line
> size, right ?

pahole says: /* size: 256, cachelines: 4, members: 11 */

> It would be nice to allow sharing the 'hot' cache line with seldom
> used fields.

Sure.

> Instead of mere pads, add some unions, and let rt6i_uncached/rt6i_uncache=
d_list
> use them.

If I understand correctly, you suggest to move

   rt6_info::rt6i_uncached[_list], rtable::rt_uncached[_list]
=20=20=20
into struct dst_entry and fixup the usage sites, right?

I don't see why that would need a union. dst_entry::rt_uncached[_list]
would work for both, no?

Thanks,

        tglx
