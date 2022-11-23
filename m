Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A331635B96
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 12:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbiKWLYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 06:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiKWLYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 06:24:18 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFCFED70F;
        Wed, 23 Nov 2022 03:23:49 -0800 (PST)
Date:   Wed, 23 Nov 2022 12:23:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669202627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MfZEAblAHd5b9YTYT04Q34en8G//Egc/Y5+6Vq3KWJ0=;
        b=JglsnIcL02nRHEDIyuKm0pcSpaJ1w3wSnat3NTOPSVC8+9DwojbgMmy4msUmVVcKoHreES
        S40jQRvmNv5r0vcatuc1kqYb8SUAsYjZuVbnIqQ0RON2uIbLwbSDFR6xJNTKpI+vkbbwyS
        iG5U1koYmRFNK4gXKAXqFiVe+43AlogRDctfrHUfQbmVB1Qr+XDLNn0fb6eILFFDzOLXH9
        T6wEtpNoNnmryLJaFn8/THG1JbhZVppvMp43HKgqBG10mrZn+APL1QSTgwkdGGAVTdNZmt
        Z4KCjWtdJ3rw1DdEfuB6nOPsEn0UMa1fOxZlLzwy2dhL1iv/S+zygFA1A6pnIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669202627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MfZEAblAHd5b9YTYT04Q34en8G//Egc/Y5+6Vq3KWJ0=;
        b=gtcZVJ0Y1HXJYPoDMweKx851D8lJ4lL2xxwBRV/sjnsFl8ALXlwBDhUAt6mMZWUT3bIGj7
        +uOV7shYD6tXCZDw==
From:   Anna-Maria Behnsen <anna-maria@linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
cc:     LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [patch V2 13/17] timers: Split [try_to_]del_timer[_sync]() to
 prepare for shutdown mode
In-Reply-To: <20221122173648.849454220@linutronix.de>
Message-ID: <905da3b-7c86-8ea2-98b2-e53645e7895b@linutronix.de>
References: <20221122171312.191765396@linutronix.de> <20221122173648.849454220@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Nov 2022, Thomas Gleixner wrote:

> Tearing down timers which have circular dependencies to other
> functionality, e.g. workqueues, where the timer can schedule work and work
> can arm timers is not trivial.

Comma missing (same as in previous commit message)

> In those cases it is desired to shutdown the timer in a way which prevents
> rearming of the timer. The mechanism to do so it to set timer->function to

s/it/is (same as in previous commit message)


Thanks,

	Anna-Maria

