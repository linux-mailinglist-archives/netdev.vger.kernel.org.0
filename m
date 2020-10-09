Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BC0287F6F
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 02:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731201AbgJIATl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 20:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725952AbgJIASs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 20:18:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2707D22253;
        Fri,  9 Oct 2020 00:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602202728;
        bh=QHP0V82CfbIX8o7dz0rRle4Ax0kv0c4cLYCcYhOkf7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VCJN9uQdYINwvVBfn9esTIYjg1ypxqp9hxQM6fZs161/3dAktPxA5uBwiE35kuTaw
         wIskjCjIhMVivzeDB2pqJJcLSmDeTQAouwa6BYJ7t8Xuc2Hd4YmUXlQjLIRgOovMJi
         fHuHyQlI1d3pKxStox4/6DAkg8JlQtxrESlHNJ7I=
Date:   Thu, 8 Oct 2020 17:18:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Allen Pais <allen.lkml@gmail.com>
Subject: Re: [PATCH net-next] net/sched: get rid of qdisc->padded
Message-ID: <20201008171846.335b435a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007165111.172419-1-eric.dumazet@gmail.com>
References: <20201007165111.172419-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 09:51:11 -0700 Eric Dumazet wrote:
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index 6c762457122fd0091cb0f2bf41bda73babc4ac12..d8fd8676fc724110630904909f64d7789f3a4b47 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -91,7 +91,7 @@ struct Qdisc {
>  	struct net_rate_estimator __rcu *rate_est;
>  	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
>  	struct gnet_stats_queue	__percpu *cpu_qstats;
> -	int			padded;
> +	int			pad;
>  	refcount_t		refcnt;
>  
>  	/*

Hi Eric!

Why keep the pad field? the member to lines down is
__cacheline_aligned, so we shouldn't have to manually 
push things out?

        struct gnet_stats_queue __percpu *cpu_qstats;                           
        int                     pad;                                            
        refcount_t              refcnt;                                         
                                                                                
        /*                                                                      
         * For performance sake on SMP, we put highly modified fields at the end                                                                               
         */                                                                     
        struct sk_buff_head     gso_skb ____cacheline_aligned_in_smp;  

