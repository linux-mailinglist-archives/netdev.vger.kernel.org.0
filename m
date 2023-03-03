Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D216A969C
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjCCLly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjCCLlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:41:49 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9601F5F236;
        Fri,  3 Mar 2023 03:41:29 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677843688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YQtG99BnykW9iCa6kuywr/Rk0RXA0HmLsf2+3nUNFrg=;
        b=4poJpPDdkY2CDLtaNmtbA1b+2HquVPKLdUOaxhGJiY/1aoHgUs0Dx5ShghLvhyewwGngyB
        ciK+L5K62FrWbdl5YNwTilpkDphiwxeRGP4UQR5PBbjHbK3yHtXoM2Q7FtlOke8XVH0XCv
        euJ4fFKoa31xAUN4MqaCsI9aqzo3MI0M6lwH1Izkae25OXOPI327wHN6MBZFhGXoyONV9k
        nDXdjZQ/HQK/36Bhekul2RBGOZyBeAww7oJGiLEg8i9op4MO6IW503SakLutvRSdAz/L5w
        2kFS6EnoNCWzYgNZ6mj2VnOfQcxCrRBgBaFgkBRJM1iSfUA+k8gNjD3YXeTnpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677843688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YQtG99BnykW9iCa6kuywr/Rk0RXA0HmLsf2+3nUNFrg=;
        b=pZBY12nwPzMQFplLjiag1O1lM3EBId+egbydanO8tqkOnGfzTz+D3PdE9hKH6rFFY0ZbKV
        NQ6hM6CKMo9FJjAA==
To:     Peter Zijlstra <peterz@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] softirq: don't yield if only expedited handlers are
 pending
In-Reply-To: <Y7viEa4BC3yJRXIS@hirez.programming.kicks-ass.net>
References: <20221222221244.1290833-1-kuba@kernel.org>
 <20221222221244.1290833-4-kuba@kernel.org>
 <Y7viEa4BC3yJRXIS@hirez.programming.kicks-ass.net>
Date:   Fri, 03 Mar 2023 12:41:27 +0100
Message-ID: <87sfemjc48.ffs@tglx>
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

On Mon, Jan 09 2023 at 10:44, Peter Zijlstra wrote:
> On Thu, Dec 22, 2022 at 02:12:44PM -0800, Jakub Kicinski wrote:
>> Tweak the need_resched() condition to be ignored if all pending
>> softIRQs are "non-deferred". The tasklet would run relatively
>> soon, anyway, but once ksoftirqd is woken we're risking stalls.
>> 
>> I did not see any negative impact on the latency in an RR test
>> on a loaded machine with this change applied.
>
> Ignoring need_resched() will get you in trouble with RT people real
> fast.

In this case not really. softirq processing is preemptible in RT, but
it's still a major pain ...

Thanks,

        tglx

