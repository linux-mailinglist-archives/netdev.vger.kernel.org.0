Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB1C634B83
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 01:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbiKWAI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 19:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235105AbiKWAI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 19:08:56 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F17AD3296;
        Tue, 22 Nov 2022 16:08:55 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669162133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NpMA+zNMaAXKIzVLL87sVBSomMTYSA48949Ug9zbik0=;
        b=PedtZGT9Dk+OywLP6kXQoRWO3w2k7HoKQulLCsfhsw9eJ+XJcLChqVpeJZBHmxV6I8UKEZ
        u3EVtCZkGoXNmF5YiXwp7MlGOaQ5ZTsEonFPLVyBooEmSSGLUPPO3QfRlQOULhc5sZblOL
        eCt1bAgOrX5Bp9TGRMVGBB0TG9luK0L4hfVpGi54FxsF4rA75PQQdt2GmFBl9lOzd2TJIa
        yGpaZxKiGL51AyoaPd05okMlmPk0rouMfhkmaLQJ1BdAHGyBvSKlp4l1EDAwkpZ2VZy6++
        tN/8O2Q4UKyoo89k+c/kOY53qBeF5bpcGJMSOrt3nhGWE1fCzhbYhfy5l1aQ0g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669162133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NpMA+zNMaAXKIzVLL87sVBSomMTYSA48949Ug9zbik0=;
        b=HCBUurIsJ4SfqL+JiymV2ToAmK8U2oV837dGO/655yZJUzSJosq/YgYNs17OvR5B44NGeV
        2Ax9DuPyI+3LuODg==
To:     Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>
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
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [patch V2 09/17] timers: Rename del_timer_sync() to
 timer_delete_sync()
In-Reply-To: <20221122174506.08ce49bd@gandalf.local.home>
References: <20221122171312.191765396@linutronix.de>
 <20221122173648.619071341@linutronix.de>
 <2c42cb1fe1fa4b11ba3c0263d7886b68@AcuMS.aculab.com>
 <20221122174506.08ce49bd@gandalf.local.home>
Date:   Wed, 23 Nov 2022 01:08:53 +0100
Message-ID: <87fseafs6i.ffs@tglx>
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

On Tue, Nov 22 2022 at 17:45, Steven Rostedt wrote:
> On Tue, 22 Nov 2022 22:23:11 +0000
> David Laight <David.Laight@ACULAB.COM> wrote:
>
>> > Rename del_timer_sync() to timer_delete_sync() and provide del_timer_sync()
>> > as a wrapper. Document that del_timer_sync() is not for new code.  
>> 
>> To change the colo[u]r of the bikeshed, would it be better to
>> name the functions timer_start() and timer_stop[_sync]().
>
> I kinda like this color. ;-)

Feel free to repaint the series with this new color. My spare cycles are
exhausted by now.

Thanks,

        tglx

