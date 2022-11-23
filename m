Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C01F636682
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbiKWRFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237966AbiKWRFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:05:33 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423489A248;
        Wed, 23 Nov 2022 09:05:31 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669223129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PgTWXneFnRsaQL5l6FFuRIiOLzxe0QUbUHjo5FawPdA=;
        b=fObtseNro5mWffM0T0jcbNZso48gwULpGcWrN2f+WryYNTx1jd/eZZjqG+eVmwhFUBU06o
        t/iknouVlvMyS4fiDuC+1vFBMwwSObGdYJkyBTy41y88PtU47dMuSBSsPL0H5aKuprG5hU
        l+JcK3nhz5jWFbSdTIUnvH/XRwX1ugFCPQIUL2dAdGWiDOc+y7zIF32gj8lFcjamlUAJsQ
        AcHIOAJ3RNufAKN/4Chca1p1vAcLmEkn6LcyHOQtfUOtJ4FUw+AOdSnXzTAhCxR0OB7eQ6
        dv0UlmS3fwKc/i8fVpPN7Z/2rQ4HRN/WSEAEvpJb7GGPLKOxF5MtKOvPZCXdZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669223129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PgTWXneFnRsaQL5l6FFuRIiOLzxe0QUbUHjo5FawPdA=;
        b=WTXkGIx/5p9xTP5fplTXmKHFCaCwwqD7NPh0QPEc1ilTHJLUJo12hxO98fg48Q0bA8Gjyk
        lrcNlmfSLqUFIPCg==
To:     Jacob Keller <jacob.e.keller@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [patch V2 13/17] timers: Split [try_to_]del_timer[_sync]() to
 prepare for shutdown mode
In-Reply-To: <74922e6d-73d5-62cc-3679-96ea447a1cb4@intel.com>
References: <20221122171312.191765396@linutronix.de>
 <20221122173648.849454220@linutronix.de>
 <74922e6d-73d5-62cc-3679-96ea447a1cb4@intel.com>
Date:   Wed, 23 Nov 2022 18:05:28 +0100
Message-ID: <87k03leh47.ffs@tglx>
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

On Tue, Nov 22 2022 at 15:04, Jacob Keller wrote:
> On 11/22/2022 9:45 AM, Thomas Gleixner wrote:
>> +int try_to_del_timer_sync(struct timer_list *timer)
>> +{
>> +	return __try_to_del_timer_sync(timer);
>> +}
>>   EXPORT_SYMBOL(try_to_del_timer_sync);
>>   
>
>
> Its a bit odd to me that some patches refactor and replace functions 
> with new variants all under timer_* namespace, but then we've left some 
> of them available without that.
>
> Any reasoning behind this? I guess "try_*" is pretty clear and unlikely 
> to get stolen by other code..?

Kinda. I renamed del_timer*() because that's the ones which we want to
substitute with timer_shutdown*() where possible and reasonable.

A larger timer namespace cleanup is subject to a follow up series.

Thanks,

        tglx
