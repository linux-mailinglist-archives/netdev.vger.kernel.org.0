Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299D35E68C7
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 18:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiIVQpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 12:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiIVQpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 12:45:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3237F9E2DF;
        Thu, 22 Sep 2022 09:45:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A16636A9;
        Thu, 22 Sep 2022 16:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEAEC433D6;
        Thu, 22 Sep 2022 16:45:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="YjmEGxm6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663865141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qIiaOcRx5bVWqVXMbg0MBYV+EUTIZZiWQtV5u1WQL3o=;
        b=YjmEGxm6RKC5i9AQrfoyJ0hN1/XDCaEwRrPALAuC7Ey3+yrMCDZ3/tr7d3vFpIWQWRX/JX
        N7nIAyTKXE+Gg716h73kX62/i1/byltX7kxqwSuBywsqVgvQKlktCRdB5UXnBX0Bf2vCPn
        4pCPLAOZDyo63fKEJ6RDljseavSWs7c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 536c23f5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 22 Sep 2022 16:45:41 +0000 (UTC)
Date:   Thu, 22 Sep 2022 18:45:37 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Sherry Yang <sherry.yang@oracle.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Jack Vogel <jack.vogel@oracle.com>,
        Tariq Toukan <tariqt@nvidia.com>, sultan@kerneltoast.com
Subject: Re: 10% regression in qperf tcp latency after introducing commit
 "4a61bf7f9b18 random: defer fast pool mixing to worker"
Message-ID: <YyyRMam6Eu8nmeCd@zx2c4.com>
References: <B1BC4DB8-8F40-4975-B8E7-9ED9BFF1D50E@oracle.com>
 <CAHmME9rUn0b5FKNFYkxyrn5cLiuW_nOxUZi3mRpPaBkUo9JWEQ@mail.gmail.com>
 <04044E39-B150-4147-A090-3D942AF643DF@oracle.com>
 <CAHmME9oKcqceoFpKkooCp5wriLLptpN=+WrrG0KcDWjBahM0bQ@mail.gmail.com>
 <BD03BFF6-C369-4D34-A38B-49653F1CBC53@oracle.com>
 <YyuREcGAXV9828w5@zx2c4.com>
 <YyukQ/oU/jkp0OXA@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YyukQ/oU/jkp0OXA@slm.duckdns.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tejun,

On Wed, Sep 21, 2022 at 01:54:43PM -1000, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 22, 2022 at 12:32:49AM +0200, Jason A. Donenfeld wrote:
> > What are our options? Investigate queue_work_on() bottlenecks? Move back
> > to the original pattern, but use raw spinlocks? Some thing else?
> 
> I doubt it's queue_work_on() itself if it's called at very high frequency as
> the duplicate calls would just fail to claim the PENDING bit and return but
> if it's being called at a high frequency, it'd be waking up a kthread over
> and over again, which can get pretty expensive. Maybe that ends competing
> with softirqd which is handling net rx or sth?

Huh, yea, interesting theory. Orrr, the one time that it _does_ pass the
test_and_set_bit check, the extra overhead here is enough to screw up
the latency? Both theories sound at least plausible.

> So, yeah, I'd try something which doesn't always involve scheduling and a
> context switch whether that's softirq, tasklet, or irq work.

Alright, I'll do that. I posted a diff for Sherry to try, and I'll make
that into a real patch and wait for her test.

> I probably am
> mistaken but I thought RT kernel pushes irq handling to threads so that
> these things can be handled sanely. Is this some special case?

It does mostly. But there's still a hard IRQ handler, somewhere, because
IRQs gotta IRQ, and the RNG benefits from getting a timestamp exactly
when that happens. So here we are.

Jason
