Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC154A762D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 17:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346014AbiBBQrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 11:47:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59038 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346013AbiBBQri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 11:47:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEA3A61763;
        Wed,  2 Feb 2022 16:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90676C340EC;
        Wed,  2 Feb 2022 16:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643820457;
        bh=ze8E3yQ1FF2NJOx3ZouFGw3DDWqI+XQwfKKZzK6gJaA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z0rlm+ivd6vA/nxTPxc4gNXEpkBjy+EVK2QBL59hg3p6ID/rIhx94xv/miSu4kFpo
         JuD6F7ZFefDqHo5vJV3tkjVBCgdgEtlqCiq9iY/ze0n1pyer4gB5+YUOHb/yvuHThe
         YKKYJaFmeSqTRW1LMpaDDAmZNRN/02eXBzfGWqE+WAexk4YH3zUgZIvsunHJhATy1T
         ZdzkyW1v5NW+oAHG++pmg1UTmEiM1R5j41ct2e1yUqKePoyVEl6AJnG6pobRJHhBXs
         0uy1kiKUO8yJGCKHc1uGqtNUucQNQRdo1nf1hIpQsKoPmio0qQBhYiHVhC11VqkEKf
         /aGKkbONl9rpg==
Date:   Wed, 2 Feb 2022 08:47:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 4/4] net: dev: Make rps_lock() disable
 interrupts.
Message-ID: <20220202084735.126397eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220202122848.647635-5-bigeasy@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
        <20220202122848.647635-5-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Feb 2022 13:28:48 +0100 Sebastian Andrzej Siewior wrote:
>  		/* Schedule NAPI for backlog device
>  		 * We can use non atomic operation since we own the queue lock
> +		 * PREEMPT_RT needs to disable interrupts here for
> +		 * synchronisation needed in napi_schedule.
>  		 */
> +		if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +			local_irq_disable();
> +
>  		if (!__test_and_set_bit(NAPI_STATE_SCHED, &sd->backlog.state)) {
>  			if (!rps_ipi_queued(sd))
>  				____napi_schedule(sd, &sd->backlog);
>  		}
> +		if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +			local_irq_enable();
>  		goto enqueue;

I think you can re-jig this a little more - rps_ipi_queued() only return
0 if sd is "local" so maybe we can call __napi_schedule_irqoff()
instead which already has the if () for PREEMPT_RT?

Maybe moving the ____napi_schedule() into rps_ipi_queued() and
renaming it to napi_schedule_backlog() or napi_schedule_rps() 
would make the code easier to follow in that case?
