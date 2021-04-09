Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C2135A1CC
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbhDIPQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233878AbhDIPQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 11:16:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 934BD610CA;
        Fri,  9 Apr 2021 15:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617981354;
        bh=7477cM5TtPJKkLrFW9qvkh0h3s4Kw7OT4a753h4HCuU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PJKas0qWKPK5SV4485cDxzlkuv31nl4LQjcnp29Us9tnf0x1qe6TULgzxrIgXQCob
         VldXvjPw3KHu63Boxn5Eo0qKa5Lm1sMwZdF37A/k42JSbsh3Sv/jLWYylqNYXwiR9/
         VVCz+NXEiigZ2IsErO9fcJWErzGYAnGSxgPxGsiiwymUJiHh5dvc31Pjb/v8WV2F9g
         CLGPVshR90Gmr/wbqn9T/wwYNxFxtQ3wh5fVcSyUkcyFQAUlJWIAsAT5vxFQ9CzX8Q
         WPmXAAmeYuG0lBfBoiggLP1+oFSlHtKxu116r5IMCOUnD3PEqEVPfIrQFAENfTN0eu
         SRM2WwJx69vSQ==
Date:   Fri, 9 Apr 2021 08:15:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net: fix hangup on napi_disable for threaded napi
Message-ID: <20210409081553.03b60e0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7ff0f0e6027c3b84b0d0e1d58096392bfc0fe806.camel@redhat.com>
References: <996c4bb33166b5cf8d881871ea8b61e54ad4da24.1617230551.git.pabeni@redhat.com>
        <20210331184137.129fc965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9f6c5d92f1bd2e480e762a7c724d7b583988f0de.camel@redhat.com>
        <20210401164415.6426d19c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2254885d747833eaf2b4461cd1233551140f644a.camel@redhat.com>
        <20210407111318.39c2374d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7ff0f0e6027c3b84b0d0e1d58096392bfc0fe806.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 09 Apr 2021 11:24:07 +0200 Paolo Abeni wrote:
> I think it can be simplified as the following - if NAPIF_STATE_DISABLE
> is set, napi_threaded_poll()/__napi_poll() will return clearing the
> SCHEDS bits after trying to poll the device:

Indeed!

> diff --git a/net/core/dev.c b/net/core/dev.c
> index d9db02d4e044..5cb6f411043d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6985,7 +6985,7 @@ static int napi_thread_wait(struct napi_struct *napi)
>  
>         set_current_state(TASK_INTERRUPTIBLE);
>  
> -       while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> +       while (!kthread_should_stop()) {
>                 /* Testing SCHED_THREADED bit here to make sure the current
>                  * kthread owns this napi and could poll on this napi.
>                  * Testing SCHED bit is not enough because SCHED bit might be
> 
> ---
> 
> And works as intended here. I'll submit that formally, unless there are
> objection.

Please and thank you!
