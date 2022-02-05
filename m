Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7345D4AA669
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379185AbiBEERw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:17:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41002 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiBEERv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:17:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C87B460C09;
        Sat,  5 Feb 2022 04:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF567C340E8;
        Sat,  5 Feb 2022 04:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644034670;
        bh=2akhDseEzFt+NqVu8nQ9Kcv+ZbPtiE+4mb8CRHgc1ls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kPgMtLuvI56qp86MrDxks41liBOwMhJ66fkMSQ7GW4omJFq0M+6iIuSbcMwmXhQVk
         69QVacksb6JYA++qfpMyl4hSpZ1YPywfZA82W/b8jSPlRS2OpxirnOVN5vTD4PivLC
         x/cX8Y6fuAUkhW87+nsx1uCt4u4Kzbco8xc4mPRDGPwzhRLqInl8ssjOqHrd24E2s5
         KeVnBARik5togHg7BFXHL0R9krVyNvSeqpsM0i8EGg6Lvnqde35rTqmPpYpTv7Bx+f
         uu7GXjK9WWt7NgMQKErNjcrNBSQ4qgOl21WK63E4f1U7QYKTJm6YoKSo11UGj1GqkU
         ykaiQs6g3xl9w==
Date:   Fri, 4 Feb 2022 20:17:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@toke.dk>
Subject: Re: [PATCH net-next v2 3/3] net: dev: Make rps_lock() disable
 interrupts.
Message-ID: <20220204201748.4af2857c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204201259.1095226-4-bigeasy@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
        <20220204201259.1095226-4-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Feb 2022 21:12:59 +0100 Sebastian Andrzej Siewior wrote:
> Disabling interrupts and in the RPS case locking input_pkt_queue is
> split into local_irq_disable() and optional spin_lock().
> 
> This breaks on PREEMPT_RT because the spinlock_t typed lock can not be
> acquired with disabled interrupts.
> The sections in which the lock is acquired is usually short in a sense that it
> is not causing long und unbounded latiencies. One exception is the
> skb_flow_limit() invocation which may invoke a BPF program (and may
> require sleeping locks).
> 
> By moving local_irq_disable() + spin_lock() into rps_lock(), we can keep
> interrupts disabled on !PREEMPT_RT and enabled on PREEMPT_RT kernels.
> Without RPS on a PREEMPT_RT kernel, the needed synchronisation happens
> as part of local_bh_disable() on the local CPU.
> ____napi_schedule() is only invoked if sd is from the local CPU. Replace
> it with __napi_schedule_irqoff() which already disables interrupts on
> PREEMPT_RT as needed. Move this call to rps_ipi_queued() and rename the
> function to napi_schedule_rps as suggested by Jakub.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
