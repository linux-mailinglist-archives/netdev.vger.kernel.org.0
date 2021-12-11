Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EF147111C
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 04:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244295AbhLKDOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 22:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235308AbhLKDOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 22:14:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFC6C061714
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 19:10:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D85FECE2DDA
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 03:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7183CC341CA;
        Sat, 11 Dec 2021 03:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639192224;
        bh=2ayOkiEJMYCuKeoCNXaHHr9g/B2VPxxz/JOB6o9sLEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FWPYSx6CZl8xIT9pzc1QyPQXo5vAk4eb56Tan4mG17RlTHXwD2VkgSPyra7/WWDF2
         /EmFYSIKWDHkcLutBvcaSDkhPR3f1PBTuVrI2LruXeHcm/3YiHuV7dUE5eE4cr719e
         0HAMpfMbVanq8KnI4HCsK8/CtQVlrWVxR+9qk0/fhi7srurIJOaI3EAUPqem1tQDEG
         v4SwP0/g2kX8TnXhCJe/QeYWgQBFile/l91rwgFnBc+HX0B/TCcBCrJR80wUcxy+PF
         f6QmtDRWvJ6q6VjJgmX81pD/mZFLq17V5qMRvwwxbQADFPXnuwdwfVKYek/JWVJfPt
         8/I/8y0tThlXw==
Date:   Fri, 10 Dec 2021 19:10:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [RFC net-next 1/4] net: napi threaded: remove unnecessary
 locking
Message-ID: <20211210191022.02e07ee6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210193556.1349090-2-yannick.vignon@oss.nxp.com>
References: <20211210193556.1349090-1-yannick.vignon@oss.nxp.com>
        <20211210193556.1349090-2-yannick.vignon@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 20:35:53 +0100 Yannick Vignon wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> NAPI polling is normally protected by local_bh_disable()/local_bh_enable()
> calls, to avoid that code from being executed concurrently due to the
> softirq design. When NAPI instances are assigned their own dedicated kernel
> thread however, that concurrent code execution can no longer happen.

Meaning NAPI will now run in process context? That's not possible, 
lots of things depend on being in BH context. There are per-CPU
cross-NAPI resources, I think we have some expectations that we
don't need to take RCU locks here and there..

> Removing the lock helps lower latencies when handling real-time traffic
> (whose processing could still be delayed because of on-going processing of
> best-effort traffic), and should also have a positive effect on overall
> performance.
> 
> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
> ---
>  net/core/dev.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 15ac064b5562..e35d90e70c75 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -7131,13 +7131,11 @@ static int napi_threaded_poll(void *data)
>  		for (;;) {
>  			bool repoll = false;
>  
> -			local_bh_disable();
>  
>  			have = netpoll_poll_lock(napi);
>  			__napi_poll(napi, &repoll);
>  			netpoll_poll_unlock(have);
>  
> -			local_bh_enable();
>  
>  			if (!repoll)
>  				break;

