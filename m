Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F237158D8F0
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 14:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243239AbiHIMwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 08:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243220AbiHIMwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 08:52:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04E156384
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 05:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660049538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rN2wh+nxvchYpu9hQV2LMnguLQFknovVkUYSriHC3N4=;
        b=RUmn36G9GXEI7F0qksKWe2Sdj7I1E5G3bvbAj9xJVGGBM3ViDEba5tYFQFKHysXpUnWr7s
        FyoaA/d1+ABY8+6vi/U9fJI2CCucrymMUWHMkYxPASdH85mDSF1McCxlzOAx9DWekVIan0
        nQGIL8zjsGTu5Nf4kMWDP5XZpVRapEw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-41-6IGpjnfQNW--vNvueQVTRA-1; Tue, 09 Aug 2022 08:52:16 -0400
X-MC-Unique: 6IGpjnfQNW--vNvueQVTRA-1
Received: by mail-wm1-f70.google.com with SMTP id y3-20020a1c4b03000000b003a537ef75c7so1361764wma.3
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 05:52:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=rN2wh+nxvchYpu9hQV2LMnguLQFknovVkUYSriHC3N4=;
        b=SlGyY/buWryElDOFN0woLQw9TFuqBs+2LZiGlamVsoOEWBIltknekMQIZmrVD7z0v2
         7eCEjzCpoTGTMiCWGZCTy87nQRdhAsUg7yaVGM7iUQDVxJKAtVtM2u71QbLoMgkXF8vz
         HPbV5bgTjkLJ+ulBwbm4vl//4h3+FvVbo5btR4VnP4Jp6nHUEZNQu7+5Ih2yBwQZeBAf
         rplESA+WMMlaNCfNCubYX3fjn/P1YEzFLmtlAM+5bNkeddzCOO3NjhbQzP5seMSFrHCY
         iv52zHRY1pf3PJlNCHRfGnRgERXfN4QS5UOsLP5RsTkQkNxOO4YyzKA2WUdmOUzvIEhC
         U4Gw==
X-Gm-Message-State: ACgBeo1biiNa5mnSS/ld2lC0xBl+GaWL2UU5sw66mW9tyNxytmA5G000
        tONgyksGpXPzBOo0TXgJa6DvYzbcKP0RB7fLLm61EgsJwCnNRR4QYSw6tj+HCWuozdBls2dZYk4
        ylxQUV4D6BHtNcrQn
X-Received: by 2002:a05:600c:4f95:b0:3a3:4612:6884 with SMTP id n21-20020a05600c4f9500b003a346126884mr20920881wmq.39.1660049535793;
        Tue, 09 Aug 2022 05:52:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ihYNMk3wUnk1Vjz3SciAXplfGwbOx1Fhv5ZIEp5DgY1Xxn8KAvJ/8UDHh4rGZ5kHX1j1UGg==
X-Received: by 2002:a05:600c:4f95:b0:3a3:4612:6884 with SMTP id n21-20020a05600c4f9500b003a346126884mr20920870wmq.39.1660049535620;
        Tue, 09 Aug 2022 05:52:15 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id 6-20020a1c1906000000b003a511e92abcsm17149747wmz.34.2022.08.09.05.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 05:52:14 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V4 1/3] sched/topology: Add NUMA-based CPUs
 spread API
In-Reply-To: <12fd25f9-96fb-d0e0-14ec-3f08c01a5a4b@gmail.com>
References: <20220728191203.4055-1-tariqt@nvidia.com>
 <20220728191203.4055-2-tariqt@nvidia.com>
 <xhsmhedxvdikz.mognet@vschneid.remote.csb>
 <df8b684d-ede6-7412-423d-51d57365e065@gmail.com>
 <xhsmh35e5d9b4.mognet@vschneid.remote.csb>
 <12fd25f9-96fb-d0e0-14ec-3f08c01a5a4b@gmail.com>
Date:   Tue, 09 Aug 2022 13:52:13 +0100
Message-ID: <xhsmhzggdbmv6.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/22 13:18, Tariq Toukan wrote:
> On 8/9/2022 1:02 PM, Valentin Schneider wrote:
>>
>> Are there cases where we can't figure this out in advance? From what I grok
>> out of the two callsites you patched, all vectors will be used unless some
>> error happens, so compressing the CPUs in a single cpumask seemed
>> sufficient.
>>
>
> All vectors will be initialized to support the maximum number of traffic
> rings. However, the actual number of traffic rings can be controlled and
> set to a lower number N_actual < N. In this case, we'll be using only
> N_actual instances and we want them to be the first/closest.

Ok, that makes sense, thank you.

In that case I wonder if we'd want a public-facing iterator for
sched_domains_numa_masks[%i][node], rather than copy a portion of
it. Something like the below (naming and implementation haven't been
thought about too much).

  const struct cpumask *sched_numa_level_mask(int node, int level)
  {
          struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);

          if (node >= nr_node_ids || level >= sched_domains_numa_levels)
                  return NULL;

          if (!masks)
                  return NULL;

          return masks[level][node];
  }
  EXPORT_SYMBOL_GPL(sched_numa_level_mask);

  #define for_each_numa_level_mask(node, lvl, mask)	    \
          for (mask = sched_numa_level_mask(node, lvl); mask;	\
               mask = sched_numa_level_mask(node, ++lvl))

  void foo(int node, int cpus[], int ncpus)
  {
          const struct cpumask *mask;
          int lvl = 0;
          int i = 0;
          int cpu;

          rcu_read_lock();
          for_each_numa_level_mask(node, lvl, mask) {
                  for_each_cpu(cpu, mask) {
                          cpus[i] = cpu;
                          if (++i == ncpus)
                                  goto done;
                  }
          }
  done:
          rcu_read_unlock();
  }

