Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FCE43412B
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 00:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhJSWLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 18:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhJSWLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 18:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 103566128B;
        Tue, 19 Oct 2021 22:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634681335;
        bh=akfUjC354D7+HPcocLL3jvKnQlkQnZNxiCCtLPxRtyE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aVSewfe6ARuaEHL/S/AIf+GAII6a0HVxtbOAPX0bbsIGC4adJWDjRKy9exT4EPAuU
         TVdsRKfPZoHWoR/VjhG5FEErWRDWoQTMqK9yXfjAkhi9+0FB/G+EZALclZaui2ANR7
         b8uHsw6Da73lQkhC1FtNFhqLvTcHv1X/euXIj4bSgvo7Le+An5pCLlXo/ux4xjX5Za
         WTbUxNtbJKK/LU9DGRKoWWQFTFUPInIqPY+9oT1Ue6tXAiY8E/NB9AcY1Oa8K8s/5Q
         gK3FX1eYOFuiG8Gh6SNWKtvxF8e1pHXluTY/vQ/V6iZXu3HzhpM+3itDGWQlIWtEgD
         Zp05BpcgWkACg==
Date:   Tue, 19 Oct 2021 15:08:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] net: sched: gred: dynamically allocate
 tc_gred_qopt_offload
Message-ID: <20211019150854.2e2de09b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211019191544.3063872-1-arnd@kernel.org>
References: <20211019191544.3063872-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 21:15:29 +0200 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The tc_gred_qopt_offload structure has grown too big to be on the
> stack for 32-bit architectures after recent changes.
> 
> net/sched/sch_gred.c:903:13: error: stack frame size (1180) exceeds limit (1024) in 'gred_destroy' [-Werror,-Wframe-larger-than]
> net/sched/sch_gred.c:310:13: error: stack frame size (1212) exceeds limit (1024) in 'gred_offload' [-Werror,-Wframe-larger-than]
> 
> Use dynamic allocation per qdisc to avoid this.
> 
> Fixes: 50dc9a8572aa ("net: sched: Merge Qdisc::bstats and Qdisc::cpu_bstats data types")
> Fixes: 67c9e6270f30 ("net: sched: Protect Qdisc::bstats with u64_stats")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Hi Jakub,
> 
> Not sure if this is what you had in mind, if not it might be easier
> if you do it yourself. In particular, adding tc_gred_qopt_offload
> to gred_sched directly rather than as a pointer may be easier here,
> but that may have other downsides.

This is exactly what I had in mind, thanks!

Two minor nits if you're willing to respin, if you feel like you've
spent enough time on this already we can marge as is :)

> -		opt.set.qstats = &sch->qstats;
> +		opt->set.qstats = &sch->qstats;
>  	}
>  
> -	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_GRED, &opt);
> +	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_GRED, opt);
> +
> +	return;

return no longer needed

>  }
>  
>  static int gred_offload_dump_stats(struct Qdisc *sch)

> @@ -754,6 +759,10 @@ static int gred_init(struct Qdisc *sch, struct nlattr *opt,
>  		sch->limit = qdisc_dev(sch)->tx_queue_len
>  		             * psched_mtu(qdisc_dev(sch));

The ops should not change, so I think we can do

	if (qdisc_dev(sch)->netdev_ops->ndo_setup_tc) {

> +	table->opt = kzalloc(sizeof(table->opt), GFP_KERNEL);
> +	if (!table->opt)
> +		return -ENOMEM;
> +
>  	return gred_change_table_def(sch, tb[TCA_GRED_DPS], extack);
>  }
>  
