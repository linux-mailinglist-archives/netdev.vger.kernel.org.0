Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDC3280091
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 15:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732339AbgJAN4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 09:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732018AbgJAN4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 09:56:43 -0400
Received: from localhost (fla63-h02-176-172-189-251.dsl.sta.abo.bbox.fr [176.172.189.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5A720872;
        Thu,  1 Oct 2020 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601560602;
        bh=o6qC8bC+K4scG1XPUArlJlnEglhhA7NyUzceP6nkYdI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MXeH6FmIoCrfau0W+WEVxQ2VRPiAykZjm2GMGlUsh12yFePp1P8OfDU9y4YF/flEM
         MSbl46cqF3QyJirMrdBjRZAVUJJcW7N6F4JPKxVSba6zbSRfU/L6n5//FXQ6rFK+vI
         RnXQMZb6DOSyo1ig6sI67GlpHT7Y41BHNna95WqI=
Date:   Thu, 1 Oct 2020 15:56:40 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Alex Belits <abelits@marvell.com>
Cc:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 03/13] task_isolation: userspace hard isolation from
 kernel
Message-ID: <20201001135640.GA1748@lothringen>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 02:49:49PM +0000, Alex Belits wrote:
> +/*
> + * Description of the last two tasks that ran isolated on a given CPU.
> + * This is intended only for messages about isolation breaking. We
> + * don't want any references to actual task while accessing this from
> + * CPU that caused isolation breaking -- we know nothing about timing
> + * and don't want to use locking or RCU.
> + */
> +struct isol_task_desc {
> +	atomic_t curr_index;
> +	atomic_t curr_index_wr;
> +	bool	warned[2];
> +	pid_t	pid[2];
> +	pid_t	tgid[2];
> +	char	comm[2][TASK_COMM_LEN];
> +};
> +static DEFINE_PER_CPU(struct isol_task_desc, isol_task_descs);

So that's quite a huge patch that would have needed to be split up.
Especially this tracing engine.

Speaking of which, I agree with Thomas that it's unnecessary. It's too much
code and complexity. We can use the existing trace events and perform the
analysis from userspace to find the source of the disturbance.

Thanks.

