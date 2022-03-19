Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589034DE7C5
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 13:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239774AbiCSMCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 08:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiCSMCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 08:02:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BE727B60D
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 05:01:08 -0700 (PDT)
Date:   Sat, 19 Mar 2022 13:01:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647691266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=89agWUDxMyONMhvbmRB+67ox1kUx/bLkXLhrOsubcxk=;
        b=Ye81CPBnQOKxDYNkTadSa1cq+6YRgkbKsXS8v/Btmduy4EYxUGpLULClH27TrSCLNJFGte
        63rU3MeHiV0GWQ1gCdaI/Pewt19G6QqlcS3DhWDqC3w6uvl2bzVCEw7vJMORdlLXKgMhiB
        kSW+T1NQA5n2zE+u/gRP6YiXUpxSsk4UdrQng3MPh21irZwX3OfNQrqzXhHcdrpwZqpO+G
        gPcmMCOe2GmF2c+dhrfYwybLZxkWYlL4AfOFujoHZ+8ckrM2FPDipDFP5ChhICABk3H+1I
        /QhftKHgImAHP90xm5sL/6ZA/bYy96fnhDfZuX+hFuhYxvLx9uaEeovA2p/SNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647691266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=89agWUDxMyONMhvbmRB+67ox1kUx/bLkXLhrOsubcxk=;
        b=HBvNqIIqd1zYhCLpxj4470xq/EMHVx7lDtey29N64WXJRicPxY/nqk8IW+dWh9PtO1iRzy
        4W792F8Rt4bHLTCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, wireguard@lists.zx2c4.com, kuba@kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] net: remove lockdep asserts from ____napi_schedule()
Message-ID: <YjXGALddYuJeRlDk@linutronix.de>
References: <20220319004738.1068685-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220319004738.1068685-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-18 18:47:38 [-0600], Jason A. Donenfeld wrote:
> This reverts commit fbd9a2ceba5c ("net: Add lockdep asserts to
> ____napi_schedule()."). While good in theory, in practice it causes
> issues with various drivers, and so it can be revisited earlier in the
> cycle where those drivers can be adjusted if needed.

Do you plan to address to address the wireguard warning?

> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4277,9 +4277,6 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>  {
>  	struct task_struct *thread;
>  
> -	lockdep_assert_softirq_will_run();
> -	lockdep_assert_irqs_disabled();

Could you please keep that lockdep_assert_irqs_disabled()? That is
needed regardless of the upper one.

Sebastian
