Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCFC665533
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 08:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbjAKHdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 02:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjAKHdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 02:33:23 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FABEE1C;
        Tue, 10 Jan 2023 23:32:46 -0800 (PST)
Date:   Wed, 11 Jan 2023 08:32:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1673422364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gnoU21dfZfsK7C0/T0w43z6dHTJwm4LjhRe84LVnovc=;
        b=C4/Q8vhFsvczuz3F7lCwXRE7Kax3e3/iOgNv2TBHeSnt2osUnM7/gJEy4he4Eyuu5FAg9X
        MynEv4LQhsgTO6tMFsJaEuK1Y65xA1bA4BwVXgOZ0aQTjB0psCpPub0J0QEvhzw0aQiXhi
        4NamsFOPdVRXFLpKBvyTvVW5vE6Whyf7oWuQja5kVXSFR/gh7ReCgqEtO4R2EMzQcJEG7z
        ofvsxZ3kwTU7KGgCpSLm+0OYk6dHfaLWCsQ3YXyPVzPqkGldJy0kdDfOzROKQbT8bQPN4T
        fEYEZc0SGwOHhugoYdEZkz/NCvDh8QPv8H9Mpvvg6hXHw47HPgB5EPaXI7A7nA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1673422364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gnoU21dfZfsK7C0/T0w43z6dHTJwm4LjhRe84LVnovc=;
        b=pONzYW/ACL5x1qcAUiz659Mc3zO7GWVpAkVHf4xw784apW4P8rAK5s973yfO3e9kk/8G3a
        q6w3wPXEBvBV95Ag==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Wei Wang <weiwan@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        =?utf-8?B?5p2O5ZOy?= <sensor1010@163.com>, davem@davemloft.net,
        pabeni@redhat.com, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net/dev.c : Remove redundant state settings after
 waking up
Message-ID: <Y75mGsoe5XUVtqqa@linutronix.de>
References: <20230110091409.2962-1-sensor1010@163.com>
 <CANn89iL0EYuGASWaXPwKN+E6mZvFicbDKOoZVA8N+BXFQV7e2A@mail.gmail.com>
 <20230110163043.069c9aa4@kernel.org>
 <CAEA6p_AdUL-NgX-C9j0DRNbwnc+nKPnwKRY8dXNCEZ4_pnTOXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEA6p_AdUL-NgX-C9j0DRNbwnc+nKPnwKRY8dXNCEZ4_pnTOXQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-01-10 16:42:56 [-0800], Wei Wang wrote:
> I was not able to see the entire changelog, but I don't think
> > -               set_current_state(TASK_INTERRUPTIBLE);
> is redundant.
> 
> It makes sure that if the previous if statement:
>     if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken)
> is false, this napi thread yields the CPU to other threads waiting to
> be run by calling schedule().

It made sense in the beginning but now the suggested patch is a clean
up. First the `woken' parameter was added in commit
   cb038357937ee ("net: fix race between napi kthread mode and busy poll")

and then the `napi_disable_pending' check was removed in commit
   27f0ad71699de ("net: fix hangup on napi_disable for threaded napi")

which renders the code to:
|         while (!kthread_should_stop()) {
|                 if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
|                         WARN_ON(!list_empty(&napi->poll_list));
|                         __set_current_state(TASK_RUNNING);
|                         return 0;
|                 }
| 
|                 schedule();
|                 /* woken being true indicates this thread owns this napi. */
|                 woken = true;
|                 set_current_state(TASK_INTERRUPTIBLE);
|         }
|         __set_current_state(TASK_RUNNING);

so when you get out of schedule() woken is set and even if
NAPI_STATE_SCHED_THREADED is not set, the while() loop is left due to
`woken = true'. So changing state to TASK_INTERRUPTIBLE makes no sense
since it will be set back to TASK_RUNNING cycles later.

Sebastian
