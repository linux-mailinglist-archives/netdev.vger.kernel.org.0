Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AB8578CA9
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiGRVZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbiGRVZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:25:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3A32A24D;
        Mon, 18 Jul 2022 14:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l8uo0guaOVRQ3ALjLP6lZE7PWqqqke5+PStc6yRq+YM=; b=pRBtMIStMfZUuUH0onfRkGgdRy
        skpq8m+P+0Y/POkkU/7naWbxeZBNp+ogGn9XQIYqZrQOx/Ca5LSOkIeoBJTlWej/r7ekBgrL5Em20
        ru4wKhBJeEmNeMLywFKK1rGqFeNuvIzRgO+rHLzDbCH8wWSMXgm5yT+fHDBlqN5RghEs+UiSGCFX6
        ZYKZKjTPlpVvsn9m0IAwaFehk8akGxI9uGe3jYURUzZRbUyjX0TYN+NZKkFGjQ2evRzAoXhEpNiAD
        /LdGou7Frnmy5gfjs/Us9sB2W831kMwl7omfl3RQF9FZJSQFaLpM4uT+rQKCA76Y/1W4w1iOzYBwV
        ZleDXyqQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDYEc-00D2rz-Fk; Mon, 18 Jul 2022 21:24:58 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 191139802A7; Mon, 18 Jul 2022 23:24:58 +0200 (CEST)
Date:   Mon, 18 Jul 2022 23:24:57 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V2 2/2] net/mlx5e: Improve remote NUMA
 preferences used for the IRQ affinity hints
Message-ID: <YtXPqTM2fH+MUKH7@worktop.programming.kicks-ass.net>
References: <20220718124315.16648-1-tariqt@nvidia.com>
 <20220718124315.16648-3-tariqt@nvidia.com>
 <YtVlDiLTPxm312u+@worktop.programming.kicks-ass.net>
 <2fc99d26-f804-ad34-1fd7-90cfb123b426@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fc99d26-f804-ad34-1fd7-90cfb123b426@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 10:49:21PM +0300, Tariq Toukan wrote:

> > > +	first = cpumask_local_spread(0, dev->priv.numa_node);
> > 
> > Arguably you want something like:
> > 
> > 	first = cpumask_any(cpumask_of_node(dev->priv.numa_node));
> 
> Any doesn't sound like what I'm looking for, I'm looking for first.
> I do care about the order within the node, so it's more like
> cpumask_first(cpumask_of_node(dev->priv.numa_node));
> 
> Do you think this has any advantage over cpumask_local_spread, if used only
> during the setup phase of the driver?

Only for the poor sod trying to read this code ;-) That is, I had no
idea what cpumask_local_spread() does, while cpumask_first() is fairly
obvious.

> > > @@ -830,8 +887,7 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
> > >   		ret = -ENOMEM;
> > >   		goto free_irqs;
> > >   	}
> > > -	for (i = 0; i < ncomp_eqs; i++)
> > > -		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
> > > +	mlx5_set_eqs_cpus(dev, cpus, ncomp_eqs);
> > 
> > So you change this for mlx5, what about the other users of
> > cpumask_local_spread() ?
> 
> I took a look at the different netdev users.
> While some users have similar use case to ours (affinity hints), many others
> use cpumask_local_spread in other flows (XPS setting, ring allocations,
> etc..).
> 
> Moving them to use the newly exposed API needs some deeper dive into their
> code, especially due to the possible undesired side-effects.
> 
> I prefer not to include these changes in my series for now, but probably
> contribute it in a followup work.

Fair enough.
