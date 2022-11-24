Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2E9637AA6
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 14:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiKXN5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 08:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiKXN44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 08:56:56 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BB7116589;
        Thu, 24 Nov 2022 05:56:38 -0800 (PST)
Date:   Thu, 24 Nov 2022 14:56:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669298196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L38wN5RSHd5FCEARF7VhEM6L+ZXyHvAmeQENCVMiFLY=;
        b=hc9zgftn9z12KNvF8vJKaZZVk8vf1B4vcVAismXLpbvgf2eck3Q6kvc8ETKIZqg4OAEXGY
        tbz0eq5xH9edMm9Rqgba2HaJAH5dK87MhCH2RnlcAdmjwheMFpuy4tA51Ij9frOoKN0lyd
        TyYdAIplmL/hFOvdRVD+aqEMTelik6YxRT3bOwjFOeI23LYGPHaxOXpu4ia/MQetNSwM2c
        V56Wp+MJPkPSoVTpZaBzj3oYlpdqGG/1LI8+JmKnmyPOJF1tl7Et4cEPkOvfV9QbOO+W57
        51v21CqNNg/KONJ6bm/hneK8GvjFATO64OlwqNko3N+7X0UV6ixGwD3z8z4q3g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669298196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L38wN5RSHd5FCEARF7VhEM6L+ZXyHvAmeQENCVMiFLY=;
        b=Z5KNNOk+gsBVb3LEJODz/5FwbcRsWDNMomH9vIslRMdYdscg1beV7gcH9Z+xhUcp4eZOEM
        I1PIcSOufCO9sgBA==
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [patch V3 17/17] Bluetooth: hci_qca: Fix the teardown problem
 for real
In-Reply-To: <20221123201625.435907114@linutronix.de>
Message-ID: <21108e77-f67d-528-dd61-249c5ebe217f@linutronix.de>
References: <20221123201306.823305113@linutronix.de> <20221123201625.435907114@linutronix.de>
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

On Wed, 23 Nov 2022, Thomas Gleixner wrote:

> While discussing solutions for the teardown problem which results from
> circular dependencies between timers and workqueues, where timers schedule
> work from their timer callback and workqueues arm the timers from work
> items, it was discovered that the recent fix to the QCA code is incorrect.
> 
> That commit fixes the obvious problem of using del_timer() instead of
> del_timer_sync() and reorders the teardown calls to
> 
>    destroy_workqueue(wq);
>    del_timer_sync(t);
> 
> This makes it less likely to explode, but it's still broken:
> 
>    destroy_workqueue(wq);
>    /* After this point @wq cannot be touched anymore */
> 
>    ---> timer expires
>          queue_work(wq) <---- Results in a NULl pointer dereference

The last NIT (for now...): s/NULl/NULL

Thanks,

	Anna-Maria

