Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F4162A042
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiKOR02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiKOR0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:26:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0607B27CDE
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 09:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668533116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4AF5wlPWBdv2FqTXmRD8z1A6As043p69QbUfc2aOxsk=;
        b=Ap6DXvzDatlBXAqeY062XGzonYiUmHVa/wcK8qIgGsZjOUMWlLmmL6EYdDvJn0yFPA7zZS
        R/xBo0V4ZKJtmkBjBmPAtDkMDlPKliMl1Ed4llueDCx18kH4/B7EHmdEaP1JqZBAj+0lID
        flavjaN6z8+61wxnWeGYKyUjisvX6ZQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-671-x-506YfNNVq0MFm4L0Zw9Q-1; Tue, 15 Nov 2022 12:25:14 -0500
X-MC-Unique: x-506YfNNVq0MFm4L0Zw9Q-1
Received: by mail-qt1-f197.google.com with SMTP id s14-20020a05622a1a8e00b00397eacd9c1aso10839935qtc.21
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 09:25:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4AF5wlPWBdv2FqTXmRD8z1A6As043p69QbUfc2aOxsk=;
        b=zy2eWG7qlS60CuUE5Z4pcNc+Dhz+Jc6nGI7WEz1y9Heorh9r8DoZ6sPGMTJEDcs0aa
         J8udo6U7S/eo2zQ8po+S85Ze+zM2TgdXqGmcKMdXKk4d5CGIrxWLryQ9yg9Z9yOx10zO
         ARGklGrZlgNiEWdXaUdfg/AffQcVClND436FSedRq2riU+zAhGwm0IRBxUpfwP0lj7kb
         6fteqovyJFEhP2NzjOdeurVR5A8UsyxbIu2lpS1lScEaendQ+hpoKWNxg9IgE7jCVjJZ
         8/31qJeNs0K2qolm/RGOffC12bUB6p5DvnqDMEkR9uFkBG4I0Y/8HrMMokmPfa/XqwZ6
         gXCw==
X-Gm-Message-State: ANoB5pnD01xee+qiFg7Odu9mz+XVRTi3tXC728+ph32LeH9td+rELAZ/
        vul7e5eCB3MD9zqJQluUnTirLRPabpV27on1bkgeokHz7L1pOL/jgPvBxgbWFENnLzLvUisVddG
        HvyfXr2Eig3gzmmV7
X-Received: by 2002:a05:622a:248c:b0:3a5:6005:7db6 with SMTP id cn12-20020a05622a248c00b003a560057db6mr17429580qtb.131.1668533114160;
        Tue, 15 Nov 2022 09:25:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7zZKeX/NTHK2U+NGI2HOpzkibwEC02BCDSKCXnFiWM2TzRBw3qp/HS9r1HUB4lPxzefKfbhw==
X-Received: by 2002:a05:622a:248c:b0:3a5:6005:7db6 with SMTP id cn12-20020a05622a248c00b003a560057db6mr17429531qtb.131.1668533113947;
        Tue, 15 Nov 2022 09:25:13 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id g10-20020a05620a40ca00b006faf76e7c9asm8680773qko.115.2022.11.15.09.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 09:25:13 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 3/4] sched: add sched_numa_find_nth_cpu()
In-Reply-To: <20221112190946.728270-4-yury.norov@gmail.com>
References: <20221112190946.728270-1-yury.norov@gmail.com>
 <20221112190946.728270-4-yury.norov@gmail.com>
Date:   Tue, 15 Nov 2022 17:25:06 +0000
Message-ID: <xhsmh5yfgyvt9.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/22 11:09, Yury Norov wrote:
> The function finds Nth set CPU in a given cpumask starting from a given
> node.
>
> Leveraging the fact that each hop in sched_domains_numa_masks includes the
> same or greater number of CPUs than the previous one, we can use binary
> search on hops instead of linear walk, which makes the overall complexity
> of O(log n) in terms of number of cpumask_weight() calls.
>

So one thing regarding the bsearch and NUMA levels; until not so long ago
we couldn't even support 3 hops [1], and this only got detected when such
machines started showing up.

Your bsearch here operates on NUMA levels, which represent hops, and so far
we know of systems that have up to 4 levels. I'd be surprised (and also
appalled) if we even doubled that in the next decade, so with that in mind,
a linear walk might not be so horrible.

[1]: https://lore.kernel.org/all/20210224030944.15232-1-song.bao.hua@hisilicon.com/


> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
> +int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
> +{
> +	struct __cmp_key k = { cpus, NULL, node, cpu, 0 };
> +	int hop, ret = nr_cpu_ids;
> +
> +	rcu_read_lock();
> +	k.masks = rcu_dereference(sched_domains_numa_masks);
> +	if (!k.masks)
> +		goto unlock;
> +
> +	hop = (struct cpumask ***)
> +		bsearch(&k, k.masks, sched_domains_numa_levels, sizeof(k.masks[0]), cmp) - k.masks;
> +
> +	ret = hop ?
> +		cpumask_nth_and_andnot(cpu - k.w, cpus, k.masks[hop][node], k.masks[hop-1][node]) :
> +		cpumask_nth_and(cpu - k.w, cpus, k.masks[0][node]);
                                      ^^^
                  wouldn't this always be 0 here?

> +unlock:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sched_numa_find_nth_cpu);
>  #endif /* CONFIG_NUMA */
>
>  static int __sdt_alloc(const struct cpumask *cpu_map)
> --
> 2.34.1

