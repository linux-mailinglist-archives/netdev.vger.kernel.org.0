Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E345326B02
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 02:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhB0BXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 20:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhB0BXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 20:23:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0382F64EDB;
        Sat, 27 Feb 2021 01:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614388961;
        bh=ulC9P1g+vkQi5V8xfr+C06lVK1lroMmUBuDqgRIXCLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aB5kdn45MtsG/OLiZ0Hc46iz5sJELOrK2tWr+LVxXk7r5AAFJ1ADRsFR5uRPWS+PI
         1z9lRX3O0j6n/h6dCIg1tl7GvH07o3tUeaPuToinb+ntBEQe2ahSI9was72IL4MTZJ
         9g1j8KuG5mZUquuLQE0BPIJYeu8w3RfWEeEgx++9Si1s+OzpRQP4v+0kPbP6ZFHzx6
         //78cdmoUZ0YW9zL/KU9dt9PoKihpH2y7aGzsJPje3yXzou7sJhMmdvRH2tZ0/EF6g
         GsWoW+eC8c1OGriybDfflngI4jidp0x9H+Blbf8yI6rCAXEpb95C9GMbPkBr04tDIZ
         eY1CwnL67I2dg==
Date:   Fri, 26 Feb 2021 17:22:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH net v2] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210226172240.24d626e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_CJx7K1Fab1C0Qkw=1VNnDaV9qwB_UUtikPMoqNUUWJuA@mail.gmail.com>
References: <20210227003047.1051347-1-weiwan@google.com>
        <20210226164803.4413571f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_CJx7K1Fab1C0Qkw=1VNnDaV9qwB_UUtikPMoqNUUWJuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 17:02:17 -0800 Wei Wang wrote:
>  static int napi_thread_wait(struct napi_struct *napi)
>  {
> +       bool woken = false;
> +
>         set_current_state(TASK_INTERRUPTIBLE);
> 
>         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> +               unsigned long state = READ_ONCE(napi->state);
> +
> +               if ((state & NAPIF_STATE_SCHED) &&
> +                   ((state & NAPIF_STATE_SCHED_THREAD) || woken)) {
>                         WARN_ON(!list_empty(&napi->poll_list));
>                         __set_current_state(TASK_RUNNING);
>                         return 0;
> +               } else {
> +                       WARN_ON(woken);
>                 }
> 
>                 schedule();
> +               woken = true;
>                 set_current_state(TASK_INTERRUPTIBLE);
>         }
>         __set_current_state(TASK_RUNNING);
> 
> I don't think it is sufficient to only set SCHED_THREADED bit when the
> thread is in RUNNING state.
> In fact, the thread is most likely NOT in RUNNING mode before we call
> wake_up_process() in ____napi_schedule(), because it has finished the
> previous round of napi->poll() and SCHED bit was cleared, so
> napi_thread_wait() sets the state to INTERRUPTIBLE and schedule() call
> should already put it in sleep.

That's why the check says "|| woken":

	((state & NAPIF_STATE_SCHED_THREAD) ||	woken))

thread knows it owns the NAPI if:

  (a) the NAPI has the explicit flag set
or
  (b) it was just worken up and !kthread_should_stop(), since only
      someone who just claimed the normal SCHED on thread's behalf 
      will wake it up
