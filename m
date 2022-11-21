Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5838F632F38
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiKUVq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiKUVqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:46:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D34B2BB;
        Mon, 21 Nov 2022 13:46:53 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669067210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=25pWSq2e0C2TXCLukHvs6vCqh5MLBCLUpnDn0otJ9KE=;
        b=FbtH5+u9waXGg9CZo4ZHjniJ+8r8at+QGoIS9BThWJMRaXfGgvvM57EI7jHICnZDFiZ+93
        z4sIAaNaYH6eRqntVRHdnFbu+k2UsZCKlWimu1/FMl5+EFEv0o7rcHMknAZ+oHya6Pl3Nx
        crh4wRoHufoVeNE4dSSz5vnSwesd8dTlYfXXCej09nm4sxp0kFSi87M1nin4mfyTgxUY2J
        wuneBMYMIil+AcGf9nMKqQeoNAjDVgz2d0sjdO5c3osq7Z0p4eZRoVvHmGT0B6raYC6Too
        subJz0SN+eC6CPAdF2zQjg74jxJ360v5Z+SiO93w7LkDEWHfMm/NuTQfCcGRnw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669067210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=25pWSq2e0C2TXCLukHvs6vCqh5MLBCLUpnDn0otJ9KE=;
        b=NbrOnvoe5zioV94Av3uKut/LcoD7xKzjrW2JK0zqV8FVPlBu19Fbk5a/pccUiDpb8PeGpq
        bx1QQ/5PLS7Ei7CA==
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
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
Subject: Re: [patch 10/15] timers: Silently ignore timers with a NULL function
In-Reply-To: <20221121163522.5eedbfe9@gandalf.local.home>
References: <20221115195802.415956561@linutronix.de>
 <20221115202117.560506554@linutronix.de>
 <20221121163522.5eedbfe9@gandalf.local.home>
Date:   Mon, 21 Nov 2022 22:46:49 +0100
Message-ID: <87wn7ogeuu.ffs@tglx>
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

On Mon, Nov 21 2022 at 16:35, Steven Rostedt wrote:
> On Tue, 15 Nov 2022 21:28:49 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
>> @@ -1532,6 +1573,12 @@ static void expire_timers(struct timer_b
>>  
>>  		fn = timer->function;
>>  
>> +		if (WARN_ON_ONCE(!fn)) {
>> +			/* Should never happen. Emphasis on should! */
>> +			base->running_timer = NULL;
>> +			return;
>
> Why return and not continue?
>
> Wont this drop the other timers in the queue?

Duh. Yes. Thanks for catching that!
