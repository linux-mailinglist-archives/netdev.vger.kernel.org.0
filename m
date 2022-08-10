Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F36A58F1B0
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiHJRmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiHJRmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:42:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B28832FE;
        Wed, 10 Aug 2022 10:42:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D87613F8;
        Wed, 10 Aug 2022 17:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED0CC433C1;
        Wed, 10 Aug 2022 17:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660153330;
        bh=UKjX/HIVJYtoMT63FsvLicnyqSItCHIDZerhD09rc9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aJ/Lpebw9EYhgUQMsaCG/pinULvjGLYsSR2sJ6EmdW/T1+ahDniIsoUEUnpD8Kmk7
         GZgP0nAaNL/tU/4zYp8briPMQFCzmdWICG2Vl8xvRTM/nJxhfQhcwR6M20KBPp224q
         F6+2PVMpNe7+BSby/uvyjsRKoOiIhr9KA4xDNt0IdpbryQdOVfgX8jQ0hjPscztsBV
         VKPD/2Jvm5o5sriEWGATbng/zaSO44nIuqtL/X+ZtNVQvXKGaKJ0w5VoG6JFiA/a/R
         Tcc9OZthEkIRD8B0hMTJDMyZc5xou6GBpi101OmxfYF7HtZstCrBoJcEYOke5rU/se
         77aaHvUOJuWYA==
Date:   Wed, 10 Aug 2022 10:42:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Valentin Schneider <vschneid@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH 2/2] net/mlx5e: Leverage sched_numa_hop_mask()
Message-ID: <20220810104209.36961cc1@kernel.org>
In-Reply-To: <8448dade-a64a-0b6b-1ed0-dd164917eedf@gmail.com>
References: <xhsmhtu6kbckc.mognet@vschneid.remote.csb>
        <20220810105119.2684079-1-vschneid@redhat.com>
        <20220810105119.2684079-2-vschneid@redhat.com>
        <8448dade-a64a-0b6b-1ed0-dd164917eedf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 15:57:33 +0300 Tariq Toukan wrote:
> > +		for_each_cpu(cpu, mask) {
> > +			cpus[i] = cpu;
> > +			if (++i == ncomp_eqs)
> > +				goto spread_done;
> > +		}
> > +	}
> > +spread_done:
> > +	rcu_read_unlock();
> >   	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
> >   	kfree(cpus);
> >   	if (ret < 0)  
> 
> This logic is typical. Other drivers would also want to use it.
> It must be introduced as a service/API function, if not by the sched 
> topology, then at least by the networking subsystem.
> Jakub, WDYT?

Agreed, no preference where the helper would live tho.
