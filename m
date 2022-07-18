Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398DD578D21
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiGRV5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiGRV5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:57:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF222E9FE;
        Mon, 18 Jul 2022 14:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EBC260C38;
        Mon, 18 Jul 2022 21:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF732C341C0;
        Mon, 18 Jul 2022 21:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658181442;
        bh=YwbotHMfbuxrSbS+K1OjmqsDpBUf1RB689gnIn+U8ck=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LVuchH6+Yae3CHyWf7MKhWHG8rjKFTfYb/7M6dAzH+3gWxyMuOcmtvikTSZbLoocS
         eS1R60VC84RcEgSQQSw68cdLP+cLq0kVtlmelmPXPZqjc44P3UX5yPi50m+sTUoovI
         QYMvv30U+q+xYkZLLctJIokbWaRRpQA+CHBjyvNGg4KmX4OpcdoJ+26sGFNEkiI2U8
         FyM1QrXbNYJqF63JdIh5UhhVJTN7UC4ebekfIuWtvNyHBlhqMm6fT2nv2x6NLkGhR0
         6ecyxF/LqkqMXOm01V2ZUl7NPzaYtOwpmKBxQBfrX7NL8SrD/gTvRKfBykWbud318c
         yoXCfwcT6lGZA==
Date:   Mon, 18 Jul 2022 14:57:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V2 2/2] net/mlx5e: Improve remote NUMA
 preferences used for the IRQ affinity hints
Message-ID: <20220718145717.27c2db1b@kernel.org>
In-Reply-To: <2fc99d26-f804-ad34-1fd7-90cfb123b426@gmail.com>
References: <20220718124315.16648-1-tariqt@nvidia.com>
        <20220718124315.16648-3-tariqt@nvidia.com>
        <YtVlDiLTPxm312u+@worktop.programming.kicks-ass.net>
        <2fc99d26-f804-ad34-1fd7-90cfb123b426@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 22:49:21 +0300 Tariq Toukan wrote:
> >> @@ -830,8 +887,7 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
> >>   		ret = -ENOMEM;
> >>   		goto free_irqs;
> >>   	}
> >> -	for (i = 0; i < ncomp_eqs; i++)
> >> -		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
> >> +	mlx5_set_eqs_cpus(dev, cpus, ncomp_eqs);  
> > 
> > So you change this for mlx5, what about the other users of
> > cpumask_local_spread() ?  
> 
> I took a look at the different netdev users.
> While some users have similar use case to ours (affinity hints), many 
> others use cpumask_local_spread in other flows (XPS setting, ring 
> allocations, etc..).
> 
> Moving them to use the newly exposed API needs some deeper dive into 
> their code, especially due to the possible undesired side-effects.
> 
> I prefer not to include these changes in my series for now, but probably 
> contribute it in a followup work.

I'd be great if you could pick any other driver and start creating 
the right APIs for it and mlx5. "Probably contribute followup work"
does not inspire confidence. And yes, I am being picky, I'm holding 
a grudge against mlx5 for not using netif_get_num_default_rss_queues().
