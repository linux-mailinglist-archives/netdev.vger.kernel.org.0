Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262BE6662AE
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbjAKSVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbjAKSVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:21:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126082AD6;
        Wed, 11 Jan 2023 10:21:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B93D4B81C9B;
        Wed, 11 Jan 2023 18:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1993C433EF;
        Wed, 11 Jan 2023 18:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673461260;
        bh=/wTogX2viLmB/IEtgzmEq7Q4gKdHD+IAnZ0d3M+fwF4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zzlyb485t3eNQIUZVNkc6lIjskHzek4FXswGVkuO5DXOCY9jW2zSsIIr/7JiTVDUk
         78+cCyS5Yt08ro5SBNqK6dSfnQtTFyag8le6wJ3Sriwfb2RL+uouRkfC4Ymwa5pExd
         6ru0rblnjKHUN1VKR2mccJwaYXEhah6go1LXEP5dTpttyGHzby+EkisldLDTJEHNzs
         4rCi1upvvLa2WNiUZ0I+FrGrIuTynxVnLlyHVaZ1J971Vzhkx/kyKQzyt0eJu2jZZr
         uavYdm7MKwy3WSmAhsqFNuLRyYVhVqrtPanYf7C9xelg+thrQo8nMBz5YCN95wsJQQ
         lsgW3qETYFZjw==
Date:   Wed, 11 Jan 2023 10:20:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?5p2O5ZOy?= <sensor1010@163.com>, davem@davemloft.net,
        pabeni@redhat.com, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net/dev.c : Remove redundant state settings after
 waking up
Message-ID: <20230111102058.144dbb11@kernel.org>
In-Reply-To: <Y75mGsoe5XUVtqqa@linutronix.de>
References: <20230110091409.2962-1-sensor1010@163.com>
        <CANn89iL0EYuGASWaXPwKN+E6mZvFicbDKOoZVA8N+BXFQV7e2A@mail.gmail.com>
        <20230110163043.069c9aa4@kernel.org>
        <CAEA6p_AdUL-NgX-C9j0DRNbwnc+nKPnwKRY8dXNCEZ4_pnTOXQ@mail.gmail.com>
        <Y75mGsoe5XUVtqqa@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 08:32:42 +0100 Sebastian Andrzej Siewior wrote:
> It made sense in the beginning but now the suggested patch is a clean
> up. First the `woken' parameter was added in commit
>    cb038357937ee ("net: fix race between napi kthread mode and busy poll")
> 
> and then the `napi_disable_pending' check was removed in commit
>    27f0ad71699de ("net: fix hangup on napi_disable for threaded napi")
> 
> which renders the code to:
> |         while (!kthread_should_stop()) {
> |                 if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
> |                         WARN_ON(!list_empty(&napi->poll_list));
> |                         __set_current_state(TASK_RUNNING);
> |                         return 0;
> |                 }
> | 
> |                 schedule();
> |                 /* woken being true indicates this thread owns this napi. */
> |                 woken = true;
> |                 set_current_state(TASK_INTERRUPTIBLE);
> |         }
> |         __set_current_state(TASK_RUNNING);
> 
> so when you get out of schedule() woken is set and even if
> NAPI_STATE_SCHED_THREADED is not set, the while() loop is left due to
> `woken = true'. So changing state to TASK_INTERRUPTIBLE makes no sense
> since it will be set back to TASK_RUNNING cycles later.

Ah, fair point, forgot about the woken optimization.
