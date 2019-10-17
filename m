Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86274DB795
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390034AbfJQTdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:33:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41060 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfJQTdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:33:42 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E736140505D9;
        Thu, 17 Oct 2019 12:33:41 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:33:40 -0400 (EDT)
Message-Id: <20191017.153340.1998610553660604312.davem@davemloft.net>
To:     bigeasy@linutronix.de
Cc:     sergei.shtylyov@cogentembedded.com, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        edumazet@google.com, tglx@linutronix.de, mkl@pengutronix.de,
        peterz@infradead.org
Subject: Re: [PATCH net-next v2] net: sched: Avoid using yield() in a busy
 waiting loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016082833.u4jxbiqg3oo6lyue@linutronix.de>
References: <20191011171526.fon5npsxnarpn3qp@linutronix.de>
        <8c3fad79-369a-403d-89fd-e54ab1b03643@cogentembedded.com>
        <20191016082833.u4jxbiqg3oo6lyue@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 12:33:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Wed, 16 Oct 2019 10:28:33 +0200

> From: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> With threaded interrupts enabled, the interrupt thread runs as SCHED_RR
> with priority 50. If a user application with a higher priority preempts
> the interrupt thread and tries to shutdown the network interface then it
> will loop forever. The kernel will spin in the loop waiting for the
> device to become idle and the scheduler will never consider the
> interrupt thread because its priority is lower.
> 
> Avoid the problem by sleeping for a jiffy giving other tasks,
> including the interrupt thread, a chance to run and make progress.
> 
> In the original thread it has been suggested to use wait_event() and
> properly waiting for the state to occur. DaveM explained that this would
> require to add expensive checks in the fast paths of packet processing.
> 
> Link: https://lkml.kernel.org/r/1393976987-23555-1-git-send-email-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> [bigeasy: Rewrite commit message, add comment, use
>           schedule_timeout_uninterruptible()]
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v1…v2: Typo fixes, noticed by Sergei Shtylyov.

Applied, thank you.
