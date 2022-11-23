Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B77363669D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239245AbiKWRJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239268AbiKWRJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:09:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687E12BFA;
        Wed, 23 Nov 2022 09:08:30 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669223308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fuw8Yu7j4q7omEaozhm8BruvfO/pl6W6sJNGVh6Std4=;
        b=cxW8I6tuErDfif3SfF+LW0dtjhdd+ekiTmScSO/lZhTTiIByQeysTYR90qk75POobXE7+7
        f9jRamN+kwx6S3vO35jekHbHVWlH2bPu/fN6KaH67z/hMURqrRM0Y3czAV6RXfNCsf7msl
        U5ZIj8lcJYDngwCgoV/t2sSJr6eDHxVOuelZK5Oe/x+jIa3tQFA6g2z2N8nwGtFJm2m6T/
        PuDDSgWAnq5QP2uQ6aWhvxhpjm0PGGHgg12D50tLvJwvZAXp/btkDrTTqLbB3r+yauzgsu
        KRlvvW2RtzpfX2DM8rEXWFrW/VMLx63aJKPkhAORRNGkFUd89XcJxat47dMcUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669223308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fuw8Yu7j4q7omEaozhm8BruvfO/pl6W6sJNGVh6Std4=;
        b=PrEYnilOru4c8b+aa1alij9EoHzcVjswvQtTSyBconK07eaaIxvhoXiODoSSmZcXrqiICC
        0wkdsqA6rTXBH3Bg==
To:     Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch V2 12/17] timers: Silently ignore timers with a NULL
 function
In-Reply-To: <165dcea1-2713-218b-fecf-5bf80452229@linutronix.de>
References: <20221122171312.191765396@linutronix.de>
 <20221122173648.793640919@linutronix.de>
 <165dcea1-2713-218b-fecf-5bf80452229@linutronix.de>
Date:   Wed, 23 Nov 2022 18:08:27 +0100
Message-ID: <87edttegz8.ffs@tglx>
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

On Wed, Nov 23 2022 at 12:06, Anna-Maria Behnsen wrote:
> On Tue, 22 Nov 2022, Thomas Gleixner wrote:
>> Add debug_assert_init() instead of the WARN_ON_ONCE(!timer->function)
>> checks so that debug objects can warn about non-initialized timers.
>
> Could you expand this paragraph, so that is is not missleading when a
> reader is not aware of the details of debug objects? Otherwise it seems to
> the reader that debug objects will warn when timer->function == NULL.
>
>   The warning of debug objects does not cover the original
>   WARN_ON_ONCE(!timer->function). It warns when timer was not initialized
>   using timer_setup[_on_stack]() or via DEFINE_TIMER().

Good point.
