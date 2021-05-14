Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1E33810FE
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 21:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhENTjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 15:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229981AbhENTjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 15:39:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99B06613D3;
        Fri, 14 May 2021 19:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621021119;
        bh=fuYo85BNBgn72d2joQno1yx5YvBZPSJbiqSuQwDGkbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ACF0+c9v4hCk2SgoUwoLzSwrQSegfqp+Y/0FlJldSVrHzGFKO4DEVxwdXVWPnUMJY
         2wjtNHq7+3b1BPj18mCPrsX9FXTkYlKvq3FbTIFAUwsC3lC6duQvWPHEQud0bqpZdJ
         /5nHiasWDfb0E1ULYuS99dp3KMvlyzv/LEJYbRdyX5X1hKG/Ws6Sech3Mi2neLMYpP
         2VynBEFAgDk9SVQa9tXG3CEMnPeZ5tplxjgH9j6OQbzsaeuDlUO44yJ6anHabXJw7G
         m4sHn/LQLZxYyUCuAqWLtN+aiMLf4fi8YmCs4hQNlNUTZeHt/4MVhcd8BKlXLY1rIi
         fCoaPMXgK8iIA==
Date:   Fri, 14 May 2021 12:38:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Michal Svec <msvec@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Thierry Reding <treding@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH RFC] r8152: Ensure that napi_schedule() is handled
Message-ID: <20210514123838.10d78c35@kicinski-fedora-PC1C0HJN>
In-Reply-To: <877dk162mo.ffs@nanos.tec.linutronix.de>
References: <877dk162mo.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 May 2021 12:17:19 +0200 Thomas Gleixner wrote:
> The driver invokes napi_schedule() in several places from task
> context. napi_schedule() raises the NET_RX softirq bit and relies on the
> calling context to ensure that the softirq is handled. That's usually on
> return from interrupt or on the outermost local_bh_enable().
> 
> But that's not the case here which causes the soft interrupt handling to be
> delayed to the next interrupt or local_bh_enable(). If the task in which
> context this is invoked is the last runnable task on a CPU and the CPU goes
> idle before an interrupt arrives or a local_bh_disable/enable() pair
> handles the pending soft interrupt then the NOHZ idle code emits the
> following warning.
> 
>   NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
> 
> Prevent this by wrapping the napi_schedule() invocation from task context
> into a local_bh_disable/enable() pair.

I should have read through my inbox before replying :)

I'd go for switching to raise_softirq_irqoff() in ____napi_schedule()...
why not?
