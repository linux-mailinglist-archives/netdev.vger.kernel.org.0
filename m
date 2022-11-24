Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EC46373C1
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiKXITU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiKXITF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:19:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C76E24BC9;
        Thu, 24 Nov 2022 00:18:48 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669277926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBNp84cE9rns7J7UgaJIbhZ4vtMYMawfokeJnqIV8yU=;
        b=3j0Ccw1/zby95sNNg0TIWuyYXsfO/PBhjK2DzrVReplJ9Clf5ntgfXo73fot1qffrB9bbz
        XSaUGU++P6qnOe2i6cLW+xAV++1Y71qnCmp1PxyVGUSobJAFAURI5N7K4oJ3WEqcYkrT0+
        1Vll+nrLUDmXBtXJk+d8Wt4+LzKpKMFXf6XgJBVjTG45Xk0AzAmtrlXBTej0SIc1Vy1RhA
        +/xLZK3MFtgCf/rE9+Q4Gs4k2nLHU3L03wTGn5OsHzrhhNfVYqNuoC7tXCSiMBofdSC9gI
        Fi68qHxG1/SH4xB4dbdBL8iWXl0c4TU/ji58H1qSntb1UNTQ8xcuIFBFY/JESw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669277926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBNp84cE9rns7J7UgaJIbhZ4vtMYMawfokeJnqIV8yU=;
        b=0NTusCg3KEMlk8MtBj5SWLGIW0kvCMsvAVEt6DpLMhgzsNf+gHGM7ZsiP+hbA1w9EqUUUi
        TBLn+ePExWkhYYBg==
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [patch V3 12/17] timers: Silently ignore timers with a NULL
 function
In-Reply-To: <644695b9-f343-7fb7-ed8e-763e5fe3d158@linutronix.de>
References: <20221123201306.823305113@linutronix.de>
 <20221123201625.135055320@linutronix.de>
 <644695b9-f343-7fb7-ed8e-763e5fe3d158@linutronix.de>
Date:   Thu, 24 Nov 2022 09:18:46 +0100
Message-ID: <87zgcgdau1.ffs@tglx>
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

On Thu, Nov 24 2022 at 08:37, Anna-Maria Behnsen wrote:

> On Wed, 23 Nov 2022, Thomas Gleixner wrote:
>
>> Tearing down timers which have circular dependencies to other
>> functionality, e.g. workqueues, where the timer can schedule work and work
>> can arm timers, is not trivial.
>> 
>> In those cases it is desired to shutdown the timer in a way which prevents
>> rearming of the timer. The mechanism to do so is to set timer->function to
>> NULL and use this as an indicator for the timer arming functions to ignore
>> the (re)arm request.
>> 
>> In preparation for that replace the warnings in the relevant code paths
>> with checks for timer->function == NULL. If the pointer is NULLL, then
>
> s/NULLL/NULL

Bah. I should have went to the bar instead of trying to fix this.

