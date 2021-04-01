Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4DA350C0B
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 03:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhDABmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 21:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhDABlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 21:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB6866105A;
        Thu,  1 Apr 2021 01:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617241298;
        bh=hCwITlRNYLUd47vFnerKl+19CDdmIGMIz2b1PBAuEC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q5m3XocNRV+/uuZ7bZhPYGdVq9gOd0SIhQvfE0Wr7r6wco3ZNbHkf1V7jFH0ILICa
         oEXrl/z1kycrvExU4ep0N1wPM1wwn8PikvvKBxCAwwa+T/xyNEo8wqVSNNRBMnN8wE
         L2S94G+XI6KIColX1ulkZf3SH949Rj/mflElBbyCFyUQqv0Js9RmYgnODoRSxFJBji
         Rwq86UnBKrjtUd22WIrgUY9qd/xGmamGDNxOB5VbJ3Qfyvqc0glPuJM8+c2ujtDRwT
         /eqvuyDmDUg+XSCusEv1j1y89e2WtSi5cJ6yppGoNP/C70fUVve1GBILGjODTby697
         pddmx1Yo5IR0g==
Date:   Wed, 31 Mar 2021 18:41:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net: fix hangup on napi_disable for threaded napi
Message-ID: <20210331184137.129fc965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <996c4bb33166b5cf8d881871ea8b61e54ad4da24.1617230551.git.pabeni@redhat.com>
References: <996c4bb33166b5cf8d881871ea8b61e54ad4da24.1617230551.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Apr 2021 00:46:18 +0200 Paolo Abeni wrote:
> I hit an hangup on napi_disable(), when the threaded
> mode is enabled and the napi is under heavy traffic.
> 
> If the relevant napi has been scheduled and the napi_disable()
> kicks in before the next napi_threaded_wait() completes - so
> that the latter quits due to the napi_disable_pending() condition,
> the existing code leaves the NAPI_STATE_SCHED bit set and the
> napi_disable() loop waiting for such bit will hang.
> 
> Address the issue explicitly clearing the SCHED_BIT on napi_thread
> termination, if the thread is owns the napi.
> 
> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/core/dev.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b4c67a5be606d..e2e716ba027b8 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -7059,6 +7059,14 @@ static int napi_thread_wait(struct napi_struct *napi)
>  		set_current_state(TASK_INTERRUPTIBLE);
>  	}
>  	__set_current_state(TASK_RUNNING);
> +
> +	/* if the thread owns this napi, and the napi itself has been disabled
> +	 * in-between napi_schedule() and the above napi_disable_pending()
> +	 * check, we need to clear the SCHED bit here, or napi_disable
> +	 * will hang waiting for such bit being cleared
> +	 */
> +	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken)
> +		clear_bit(NAPI_STATE_SCHED, &napi->state);

Not sure this covers 100% of the cases. We depend on the ability to go
through schedule() "unnecessarily" when the napi gets scheduled after
we go into TASK_INTERRUPTIBLE.

If we just check woken outside of the loop it may be false even though
we got a "wake event".


Looking closer now I don't really understand where we ended up with
disable handling :S  Seems like the thread exits on napi_disable(),
but is reaped by netif_napi_del(). Some drivers (*cough* nfp) will
go napi_disable() -> napi_enable()... and that will break. 

Am I missing something?

Should we not stay in the wait loop on napi_disable()?
