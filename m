Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60D527B62E
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 22:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgI1UZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 16:25:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41050 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgI1UZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 16:25:00 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601324697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bFCfMeJz3k7KgJV/g5+JO0vuUvcWHhiaBBsDnTpUBlY=;
        b=TP+PHTQylOshKfHId3EGDSY+kpXmrrQb8H3PwNUb84fyOn4v5ZeeI8H0JxN/b8gF8adktB
        W7OG2fyaY3Sih3/menetx7cVg5D3lteYcAucOb6MbOoeyyuCW47eANUHyiPTvul0+No5wz
        vtqtHjO+0efFNqmBef7hEjs9QzEFBcXj97JYGvKomBDBDXFghK+TvTeZQurFKynWXlEDYT
        +h1dti1KMXdySYSTvj448S1p/9MD+aU3UXWBmsRYm5DQSLkEufICQL1A3mrIYQBvEQubGF
        QgHfc4AeIYB44xI9JHCSwintZ0/I92YCAZ+XxvoSz55bsYFHMkubqvEbk+aFTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601324697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bFCfMeJz3k7KgJV/g5+JO0vuUvcWHhiaBBsDnTpUBlY=;
        b=nIpAK+TLxTnYokpLYa33bQYSZ6zKFYxNxEexVmJUR3hXUJBCTfLAqtcMtiFO92LiSBBuJY
        dGDq3BCWHqF3KDBw==
To:     Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] sfc: replace in_interrupt() usage
In-Reply-To: <e45d9556-2759-6f33-01a0-d1739ce5760d@solarflare.com>
References: <168a1f9e-cba4-69a8-9b29-5c121295e960@solarflare.com> <e45d9556-2759-6f33-01a0-d1739ce5760d@solarflare.com>
Date:   Mon, 28 Sep 2020 22:24:57 +0200
Message-ID: <87k0wdk5t2.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28 2020 at 21:05, Edward Cree wrote:
> efx_ef10_try_update_nic_stats_vf() used in_interrupt() to figure out
>  whether it is safe to sleep (for MCDI) or not.
> The only caller from which it was not is efx_net_stats(), which can be
>  invoked under dev_base_lock from net-sysfs::netstat_show().
> So add a new update_stats_atomic() method to struct efx_nic_type, and
>  call it from efx_net_stats(), removing the need for
>  efx_ef10_try_update_nic_stats_vf() to behave differently for this case
>  (which it wasn't doing correctly anyway).
> For all nic_types other than EF10 VF, this method is NULL and so we
>  call the regular update_stats() methods, which are happy with being
>  called from atomic contexts.
>
> Fixes: f00bf2305cab ("sfc: don't update stats on VF when called in atomic context")
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Edward Cree <ecree@solarflare.com>

That's much nicer.

> ---
> Only compile-tested so far, because I'm waiting for my kernel to
>  finish rebuilding with CONFIG_DEBUG_ATOMIC_SLEEP which I'm hoping
>  is the right thing to detect the bug in the existing code.
> I also wasn't quite sure how to give credit to the thorough analysis
>  in the commit message of Sebastian's patch.  I don't think we have
>  a Whatever-by: tag to cover that, do we?

Sebastian did the analysis and I did some word polishing, but the credit
surely goes to him.

Thanks,

        tglx
