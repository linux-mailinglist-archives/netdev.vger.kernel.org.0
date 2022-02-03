Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA654A8A88
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353036AbiBCRpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbiBCRp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:45:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE858C061714;
        Thu,  3 Feb 2022 09:45:26 -0800 (PST)
Date:   Thu, 3 Feb 2022 18:45:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643910323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LMbK/rkb16pf1pFvu++BiU7C75L+5+l1Z7FWzQOMCJo=;
        b=U7k595SMwbd43+SlszUhj7UdjhaQmx8EEtn59HssmwEKNfTGXLalxRFH0zhAyld1ghBXu8
        eiGYsv5xo2XzZUqtg2eL/yql4LkJ7aANY9gu6wBGFnwvDirftSD1Qk1v1OsOV3avLv4zQX
        uZz7n0lpMEriM4eU4Up8VxIRvRz6xm4X41ds3ReNVeKcoaMlhM8AnS9hYel6bZdIMOE79o
        sf4FKRi7EbEmZPVoPMsguRG9qcAAII0URU/nzvlo6GNIRz9bS0+P/4uLeV/slgLJT7yMrn
        CW+ooMcGxOoSDoL6vheRPbHAuzEOGCgEzXPaLQHIAEnT8uPRmyaQz7Yk76Iksw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643910323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LMbK/rkb16pf1pFvu++BiU7C75L+5+l1Z7FWzQOMCJo=;
        b=shm9yg7XQi7yUNgXid9vOKRIiEFfkic3J4+yjlKOZhVhYwdVV0VWff/aS1j1ftXijtEYVr
        Od046CQCK5HhhXBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <YfwUskgPuOREd9hs@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-4-bigeasy@linutronix.de>
 <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
 <YfvwbsKm4XtTUlsx@linutronix.de>
 <CANn89i+66MvzQVp=eTENzZY6s8+B+jQCoKEO_vXdzaDeHVTH5w@mail.gmail.com>
 <Yfv3c+5XieVR0xAh@linutronix.de>
 <CANn89i+t4TgrryvSBmBMfsY63m6Fhxi+smiKfOwHTRAKxvcPLQ@mail.gmail.com>
 <YfwGcHv6XQytcq68@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfwGcHv6XQytcq68@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-03 17:44:33 [+0100], To Eric Dumazet wrote:
> > I guess the cost of the  local_bh_enable()/local_bh_disable() pair
> > will be roughly the same, please measure it :)
> 
> We would avoid that branch maybe that helps. Will measure.

|  BH OFF/ON     : 722922586
|  BH OFF/ON     : 722931661
|  BH OFF/ON     : 725341486
|  BH OFF/ON     : 725909591
|  BH OFF/ON     : 741705606
|  BH OFF/ON-OPT : 536683873
|  BH OFF/ON-OPT : 536933779
|  BH OFF/ON-OPT : 536967581
|  BH OFF/ON-OPT : 537109700
|  BH OFF/ON-OPT : 537148631

in a tight loop of 100000000 iterations:
BH OFF/ON = local_bh_disable(); local_bh_enable()
BH OFF/ON-OPT = local_bh_disable(); local_bh_enable_opt()
where local_bh_enable_opt() is the proposed function.

725341486 = ~7.3ns for one iteration.
536967581 = ~5.4ns for one iteration.

This is without tracing+lockdep. So I don't need to sell this to peterz
and focus one the previously suggested version.

Sebastian
