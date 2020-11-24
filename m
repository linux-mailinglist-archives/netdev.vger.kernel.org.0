Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6F12C303D
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404330AbgKXSyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:54:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729281AbgKXSyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 13:54:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81CD920757;
        Tue, 24 Nov 2020 18:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606244054;
        bh=MQTdgzF68zcvyjf0yTt1ZEi6+KpPEmNIDrI4AfS4Co0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cRnI12Ajweg3bl/1tadioS6dqIsnystPR6jqy2VUzV2hDd1eYxnYg4FQP5fpdKzQ9
         dJrjZbxN738vHiLhpDCIM+7g1s9M8Kb9byPKZac5VD/MoJGzGKsf7Hm/JLyV9NIEyN
         elS8bFxAJzArO+0DnOMRdcRZ6/Ny5xXn5v741PPI=
Date:   Tue, 24 Nov 2020 10:54:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/3] net: remove napi_hash_del() from
 driver-facing API
Message-ID: <20201124105413.0406e879@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8735d11e-e734-2ba9-7ced-d047682f9f3e@gmail.com>
References: <20200909173753.229124-1-kuba@kernel.org>
        <20200909173753.229124-2-kuba@kernel.org>
        <8735d11e-e734-2ba9-7ced-d047682f9f3e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 19:00:50 +0100 Eric Dumazet wrote:
> On 9/9/20 7:37 PM, Jakub Kicinski wrote:
> > We allow drivers to call napi_hash_del() before calling
> > netif_napi_del() to batch RCU grace periods. This makes
> > the API asymmetric and leaks internal implementation details.
> > Soon we will want the grace period to protect more than just
> > the NAPI hash table.
> > 
> > Restructure the API and have drivers call a new function -
> > __netif_napi_del() if they want to take care of RCU waits.
> > 
> > Note that only core was checking the return status from
> > napi_hash_del() so the new helper does not report if the
> > NAPI was actually deleted.
> > 
> > Some notes on driver oddness:
> >  - veth observed the grace period before calling netif_napi_del()
> >    but that should not matter
> >  - myri10ge observed normal RCU flavor
> >  - bnx2x and enic did not actually observe the grace period
> >    (unless they did so implicitly)
> >  - virtio_net and enic only unhashed Rx NAPIs
> > 
> > The last two points seem to indicate that the calls to
> > napi_hash_del() were a left over rather than an optimization.
> > Regardless, it's easy enough to correct them.
> > 
> > This patch may introduce extra synchronize_net() calls for
> > interfaces which set NAPI_STATE_NO_BUSY_POLL and depend on
> > free_netdev() to call netif_napi_del(). This seems inevitable
> > since we want to use RCU for netpoll dev->napi_list traversal,
> > and almost no drivers set IFF_DISABLE_NETPOLL.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> After this patch, gro_cells_destroy() became damn slow
> on hosts with a lot of cores.
> 
> After your change, we have one additional synchronize_net() per cpu as
> you stated in your changelog.

Sorry :S  I hope it didn't waste too much of your time..

> gro_cells_init() is setting NAPI_STATE_NO_BUSY_POLL, and this was enough
> to not have one synchronize_net() call per netif_napi_del()
> 
> I will test something like :
> I am not yet convinced the synchronize_net() is needed, since these
> NAPI structs are not involved in busy polling.

IDK how this squares against netpoll, though?

> diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
> index e095fb871d9120787bfdf62149f4d82e0e3b0a51..8cfa6ce0738977290cc9f76a3f5daa617308e107 100644
> --- a/net/core/gro_cells.c
> +++ b/net/core/gro_cells.c
> @@ -99,9 +99,10 @@ void gro_cells_destroy(struct gro_cells *gcells)
>                 struct gro_cell *cell = per_cpu_ptr(gcells->cells, i);
>  
>                 napi_disable(&cell->napi);
> -               netif_napi_del(&cell->napi);
> +               __netif_napi_del(&cell->napi);
>                 __skb_queue_purge(&cell->napi_skbs);
>         }
> +       synchronize_net();
>         free_percpu(gcells->cells);
>         gcells->cells = NULL;
>  }
> 
> 

